class AuthException {
  static const Map<String, String> errors = {
    'EMAIL_EXISTS': 'The provided E-mail exists',
    'OPERATION_NOT_ALLOWED': 'The operation is not allowed',
    'TOO_MANY_ATTEMPTS_TRY_LATER': 'Try again later',
    'EMAIL_NOT_FOUND': 'The provided E-mail is not found!',
    'INVALID_PASSWORD': 'The provided password is not valid!',
    'USER_DISABLED': 'This user was disabled',
  };
  final String key;

  const AuthException(this.key);

  @override
  String toString() {
    if (errors.containsKey(key))
      return errors[key];
    else
      return 'Ocurred some error during authentication';
  }
}
