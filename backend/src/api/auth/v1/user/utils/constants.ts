export const messages = {
  invalidUserNamePassword: 'Invalid username/password',
  validUserNamePassword: 'User credentials validated successfully and token generated',
  invalidCode: 'Invalid code',
  validCode: 'Code validated successfully and exchanged for token',
  tooManyTriesShortTime: (seconds: number): string =>
    `Too many tries with incorrect code. Try again in ${seconds} seconds`,
  invalidJwtType: 'Invalid token type',
  invalidJwtUser: 'Token is for an nonexistent user',
  resetTokenInvalidUser: "Token is not for this user's password",
  passwordResetCodeSent: 'If the provided email address exists in our database, a reset code will be sent',
  passwordResetSuccess: 'Your password has been reset successfully',
  userNotFound: 'The user was not found in the database',
  userAlreadyExists: 'The user already exists in the database',
  signUpSuccess: 'The user has been created successfully',
  profileImageSuccess: 'Profile image updated successfully',
  invalidImage: 'Invalid image field',
}

export const ACCOUNT_TAG = 'Account'
