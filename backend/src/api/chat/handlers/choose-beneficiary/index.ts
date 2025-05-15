import { AI_COMMAND } from 'api/ai/v1/ai/usecase/send-message/types'
import { Beneficiary } from 'api/core/entities/beneficiary'
import { parseCommandWithGPT } from 'api/core/services/ai'

export async function chooseBeneficiary(command : AI_COMMAND, user, chatHistory) {
  const {recipient} = command.payload
  const beneficiaries = await Beneficiary.find({
    where: { legalName: recipient as any, user: { id: user.id } as any },
  })

  if (beneficiaries && beneficiaries.length > 0) {
    const message = {
      list: beneficiaries,
      message: 'Please select a recipient from the list to complete the transaction.',
      action: 'choose_recipient',
    }

    chatHistory.push({
      role: 'assistant',
      content: JSON.stringify(message),
    })
    return {
      ...message,
      chatHistory: chatHistory,
    }
  }

  return {
    message: 'You do not have any registered beneficiaries, please register one.',
  }
}
