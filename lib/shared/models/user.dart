class CurrentUser{
  late final String name;
  late final String email;
  String avatar;
  String? number;
  bool showNumber;
  String? cpf;
  String? registration;
  bool loginByGoogle;

  CurrentUser(this.name, this.email, {this.avatar = "assets/images/random_person.jpg", this.number, this.showNumber = false, this.cpf, this.registration, this.loginByGoogle = false});

}

