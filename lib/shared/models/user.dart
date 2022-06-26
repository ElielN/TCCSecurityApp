class CurrentUser{
  String name;
  String email;
  String? avatar;
  String? number;
  bool showNumber = false;
  String? cpf;
  String? registration;

  CurrentUser(this.name, this.email, {this.avatar, this.number, this.showNumber = false, this.cpf, this.registration});

}

