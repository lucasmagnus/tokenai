import { AI_MODEL } from "api/chat/utils/constants"
import * as fs from 'fs'
import OpenAI from "openai"

const OPEN_AI = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY ?? 'asd',
})

export async function sendToAI(chatHistory: any[]) {
  try {
    if (chatHistory && chatHistory.length < 2) {
      chatHistory.push({
        role: 'system',
        content: `You are an English assistant that helps the user to perform blockchain operations. Its purpose is to ask the user questions to get data and return a structured json at the end to help the app process it. `,
      })
    }

    const response = await OPEN_AI.chat.completions.create({
      model: AI_MODEL,
      messages: chatHistory,
    })

    const rawResponse = response.choices[0].message.content
    const cleanResponse = rawResponse?.replace(/```json|```/g, '')
    let parsedCommand
    try {
      parsedCommand = JSON.parse(cleanResponse || '{}')
    } catch (error) {
      parsedCommand = cleanResponse
    }

    chatHistory.push({
      role: 'assistant',
      content: rawResponse,
    })

    return { parsedCommand, chatHistory }
  } catch (error) {
    console.error('Error IA', error)
    throw error
  }
}

export async function uploadTrainingData() {
  const fileResponse = await OPEN_AI.files.create({
    file: fs.createReadStream('data/fine_tuning_data.jsonl'),
    purpose: 'fine-tune',
  })

  return fileResponse.id
}

export async function fineTuneModel(trainingFileId: string) {
  const fineTuneResponse = await OPEN_AI.fineTuning.jobs.create({
    training_file: trainingFileId,
    model: 'ft:gpt-4o-mini-2024-07-18:personal::BL7zjgQJ',
  })

  return fineTuneResponse.id
}

export async function fineTuneStatus(fineTuneId : string) {
  const statusResponse = await OPEN_AI.fineTuning.jobs.retrieve(fineTuneId)

  console.log(statusResponse.status)
}