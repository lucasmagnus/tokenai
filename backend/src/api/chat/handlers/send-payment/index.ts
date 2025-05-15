import { OPEN_AI, AI_MODEL } from 'api/ai/utils/constants'
import { AI_COMMAND } from 'api/ai/v1/ai/usecase/send-message/types'
import { Beneficiary } from 'api/core/entities/beneficiary'
import StellarTransactions from 'interfaces/stellar'
import { formatWallet } from 'utils/formatters'

export async function processPayment(command: AI_COMMAND, user) {
  const payload = command.payload
  const { amount, currency, recipient } = payload

  console.log(`Processing payment: ${amount} ${currency} to ${recipient}`)

  if (!recipient) {
    const beneficiaries = await Beneficiary.find({
      where: { legalName: recipient as any, user: { id: user.id } as any },
    })

    if (beneficiaries && beneficiaries.length > 0) {
      return { ...command, list: beneficiaries }
    }
  }

  if (!amount || !currency || !recipient) {
    return command
  }

  let beneficiary = await Beneficiary.findOne({
    where: { legalName: recipient as any, user: { id: user.id } as any },
  })
  const stellarTransactions = new StellarTransactions()

  const issuers = stellarTransactions.getIssuers()
  const formattedCurrency = (currency as string).toUpperCase()
  const selectedIssuer = formattedCurrency === 'EURC' ? issuers.EURC : formattedCurrency === 'USDC' ? issuers.USDC : ''

  if (!beneficiary || !beneficiary?.legalName) {
    const beneficiaries = await Beneficiary.find({
      where: { user: { id: user.id } as any },
    })

    const mappedBeneficieries = beneficiaries?.map((beneficiary) => {
      return {
        id: beneficiary.id,
        legalName: beneficiary.legalName,
        walletAddress: beneficiary.walletAddress,
        email: beneficiary.email,
        phoneNumber: beneficiary.phoneNumber,
      }
    })

    const response = await OPEN_AI.chat.completions.create({
      model: AI_MODEL,
      messages: [
        { role: 'system', content: 'You are a helpful assistant' },
        {
          role: 'user',
          content: `Return the just the id that you think might be what the user is looking for with the following search data: ${recipient}. The list is: ${JSON.stringify(
            mappedBeneficieries
          )}}`,
        },
      ],
    })

    const rawResponse = response.choices[0].message.content

    const foundBeneficiary = beneficiaries.find((beneficiary) => beneficiary.id === Number(rawResponse))

    if (foundBeneficiary) {
      beneficiary = foundBeneficiary
    } else {
      return {
        message: 'Beneficiary not found',
      }
    }
  }

  return {
    action: 'review_payment',
    message: `Do you want to make this payment?
    \nTo: ${beneficiary.legalName}
    \nAddress: ${formatWallet(beneficiary.walletAddress)}
    \nAmount: ${amount} ${formattedCurrency}`,
    payload: {
      from_user_id: user.id,
      amount: amount,
      asset_issuer: selectedIssuer,
      memo: '',
      currency: formattedCurrency,
      to: beneficiary.legalName,
      destination_pk: beneficiary.walletAddress,
    },
  }
}
