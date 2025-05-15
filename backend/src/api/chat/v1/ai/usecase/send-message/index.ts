import { Request, Response } from 'express'

import { UseCaseBase } from 'api/core/framework/use-case/base'
import { IUseCaseHttp } from 'api/core/framework/use-case/http'
import { HttpStatusCodes } from 'api/core/utils/http/status-code'
import { UnauthorizedException } from 'errors/exceptions/unauthorized'
import { BadRequestException } from 'errors/exceptions/bad-request'

import { MessageRequest, MessageResponse } from './types'
import { messages } from '../../utils/contants'
import { sendToAI } from 'api/core/services/ai'
import { AIActionFactory } from '../../actions/factory'

const endpoint = 'send-message'

export class SendMessageUseCase
  extends UseCaseBase<MessageResponse>
  implements IUseCaseHttp<MessageResponse>
{
  async executeHttp(
    request: Request,
    response: Response<MessageResponse>
  ): Promise<Response<MessageResponse>> {
    try {
      const result = await this.handle(request.body)
      return response.status(HttpStatusCodes.OK).json(result)
    } catch (error) {
      if (
        error instanceof UnauthorizedException ||
        error instanceof BadRequestException
      ) {
        return response.status(HttpStatusCodes.BAD_REQUEST).json({
          message: 'Error processing request',
          data: {
            message: error.message,
            success: false,
          },
        })
      }
      return response.status(HttpStatusCodes.INTERNAL_SERVER_ERROR).json({
        message: 'Error processing request',
        data: {
          message: 'An unexpected error occurred',
          success: false,
        },
      })
    }
  }

  private async processAIResponse(
    parsedCommand: any,
    chatHistory: any[],
    wallet?: string
  ): Promise<MessageResponse> {
    let responseData: any = null
    let message = parsedCommand?.message || ''

    console.log('parsedCommand:: ', parsedCommand)
    if (parsedCommand?.action) {
      try {
        if (parsedCommand.action === 'send_payment') {
          parsedCommand.wallet = wallet
        }

        responseData = await AIActionFactory.handle(parsedCommand)
        if (responseData.message) {
          message = responseData.message
        }
      } catch (error) {
        console.error('Error processing AI action:', error)
        if (
          error instanceof Error &&
          error.message.includes('No handler found for action')
        ) {
          return {
            message: 'Success',
            data: {
              message: parsedCommand?.payload?.message || message,
              success: true,
              data: null,
              chatHistory,
            },
          }
        }
        throw new BadRequestException('Failed to process AI action')
      }
    }

    return {
      message: 'Success',
      data: {
        message:
          message ?? (typeof parsedCommand === 'string' ? parsedCommand : ''),
        success: true,
        data: responseData,
        chatHistory,
      },
    }
  }

  async handle(data: MessageRequest): Promise<MessageResponse> {
    try {
      const validatedData = this.validate(data, MessageRequest)
      if (!validatedData) {
        throw new UnauthorizedException(messages.invalidCredentials)
      }

      const { parsedCommand, chatHistory } = await sendToAI(
        validatedData.chatHistory || []
      )

      return this.processAIResponse(
        parsedCommand,
        chatHistory,
        validatedData?.wallet
      )
    } catch (error) {
      console.error('Error processing message:', error)
      throw error
    }
  }
}

export { endpoint }
