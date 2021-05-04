enum AuthResultStatus {
  successful,
  emailAlreadyExists,
  weakPassword,
  wrongPassword,
  invalidEmail,
  userNotFound,
  userDisabled,
  operationNotAllowed,
  tooManyRequests,
  undefined,
}

class AuthExceptionHandler {
  static handleException(e) {
    var status;
    switch (e.code) {
      case "ERROR_INVALID_EMAIL":
        status = AuthResultStatus.invalidEmail;
        break;
      case "ERROR_WEAK_PASSWORD":
        status = AuthResultStatus.weakPassword;
        break;
      case "ERROR_WRONG_PASSWORD":
        status = AuthResultStatus.wrongPassword;
        break;
      case "ERROR_USER_NOT_FOUND":
        status = AuthResultStatus.userNotFound;
        break;
      case "ERROR_USER_DISABLED":
        status = AuthResultStatus.userDisabled;
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        status = AuthResultStatus.tooManyRequests;
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
        status = AuthResultStatus.operationNotAllowed;
        break;
      case "ERROR_EMAIL_ALREADY_IN_USE":
        status = AuthResultStatus.emailAlreadyExists;
        break;
      default:
        status = AuthResultStatus.undefined;
    }
    return status;
  }

  static generateExceptionMessage(exceptionCode) {
    String exceptionMessage;
    switch (exceptionCode) {
      case AuthResultStatus.invalidEmail:
        exceptionMessage = "Is this a valid email address?  Please try again.";
        break;
      case AuthResultStatus.weakPassword:
        exceptionMessage =
            "The password provided is too weak. Please try again.";
        break;
      case AuthResultStatus.wrongPassword:
        exceptionMessage = "Sorry, that password is wrong. Please try again.";
        break;
      case AuthResultStatus.userNotFound:
        exceptionMessage = "A User with this email doesn't exist.";
        break;
      case AuthResultStatus.userDisabled:
        exceptionMessage = "Sorry, this account has been disabled.";
        break;
      case AuthResultStatus.tooManyRequests:
        exceptionMessage = "Too many requests. Try again later.";
        break;
      case AuthResultStatus.operationNotAllowed:
        exceptionMessage = "Signing in with Email and Password is not enabled.";
        break;
      case AuthResultStatus.emailAlreadyExists:
        exceptionMessage = "An account already exists for that email.";
        break;
      default:
        exceptionMessage = "An undefined Error happened. Oh no!";
    }

    return exceptionMessage;
  }
}
