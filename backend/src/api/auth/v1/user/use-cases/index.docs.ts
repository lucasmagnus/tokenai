import ForgotPasswordRequestCodeDocs from 'api/auth/v1/user/use-cases/forgot-password/request-code/index.docs'
import ForgotPasswordValidateCodeDocs from 'api/auth/v1/user/use-cases/forgot-password/validate-code/index.docs'
import ResetPasswordDocs from 'api/auth/v1/user/use-cases/reset-password/index.docs'
import SignInDocs from 'api/auth/v1/user/use-cases/signin/index.docs'
import SignUpDocs from 'api/auth/v1/user/use-cases/signup/index.docs'

export default {
  '/api/v1/auth/signin': {
    ...SignInDocs,
  },
  '/api/v1/auth/signup': {
    ...SignUpDocs,
  },
  '/api/v1/auth/forgot-password/request-code': {
    ...ForgotPasswordRequestCodeDocs,
  },
  '/api/v1/auth/forgot-password/validate-code': {
    ...ForgotPasswordValidateCodeDocs,
  },
  '/api/v1/auth/reset-password': {
    ...ResetPasswordDocs,
  },
}
