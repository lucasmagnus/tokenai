/*
  Password Strength Validation
  ^                         Start anchor
  (?=.*[A-Z])               Ensure the string has at least one uppercase letter.
  (?=.*[ !"#$%&'()*+,-./:;<=>?@[\]^_`{|}~])            Ensure string has one special case letter.
  (?=.*[0-9])               Ensure string has one digits.
  (?=.*[a-z])               Ensure string has one lowercase letters.
  .{8,64}                   Ensure string is between the length 8 and 64.
  $                         End anchor
*/
export const password = /^(?=.*[A-Z])(?=.*[ !"#$%&'()*+,-./:;<=>?@[\]^_`{|}~])(?=.*[0-9])(?=.*[a-z]).{8,64}$/
