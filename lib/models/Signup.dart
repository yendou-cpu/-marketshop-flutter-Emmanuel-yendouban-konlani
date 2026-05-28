class Signup {
  final String username;
  final String email; 
  final String password;

  Signup({required this.username, required this.email, required this.password});

  factory Signup.fromJson(Map<String, dynamic> json) {
    return Signup(
      username: json['username'],
      email: json['email'] ?? '',
      password: json['password'],
    );
  }

  //  envoie les données à l'API lors de l'inscription
  Map<String, dynamic> toJson() {
    return {'username': username, 'email': email, 'password': password};
  }
}
