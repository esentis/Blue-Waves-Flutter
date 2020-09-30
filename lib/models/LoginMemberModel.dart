class LoginMemberModel {
  LoginMemberModel({
    this.password,
    this.userName,
    this.rememberMe,
  });

  final String userName;
  final String password;
  final bool rememberMe;
}
