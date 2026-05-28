class Login {
  final String username;
  final String password;

  Login({required this.username, required this.password});

  //  reçoit la réponse de l'API → crée un objet Login
  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(username: json['username'], password: json['password']);
  }

  //  envoie les données à l'API
  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password};
  }
}
