
bool isValidPassword(String password) {
  final passwordRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$');
  return passwordRegExp.hasMatch(password);
}
