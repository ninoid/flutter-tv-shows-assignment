import 'dart:convert';


class CurrentUserCredientalsModel {
  
  // we will not encrypt login credientals in this demo... :)
  String email;
  String password;  

  CurrentUserCredientalsModel({
    required this.email,
    required this.password
  });


  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }

  factory CurrentUserCredientalsModel.fromMap(Map<String, dynamic> map) {
    return CurrentUserCredientalsModel(
      email: map['email'],
      password: map['password'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CurrentUserCredientalsModel.fromJson(String source) => CurrentUserCredientalsModel.fromMap(json.decode(source));

  
}
