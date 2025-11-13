class UserModel{
  final String username;
  final String email;
  final String password;
  final String? confirmPassword;
  final Role role;

  UserModel({
    required this.username,
    required this.email,
    required this.password,
    this.confirmPassword,
    required this.role,
  });

  factory UserModel.fromJson(Map <String, dynamic> json){
    return UserModel(
      username: json['username'],
      email: json['email'],
      password: json['password'],
      confirmPassword: json['confirmPassword'],
      role: json['role'] == 'admin' ? Role.admin : Role.user,
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'username': username,
      'email': email, 
      'password': password,
      'confirmPassword': confirmPassword,
      'role': role == Role.admin ? 'admin' : 'user',
    };
  }

}

enum Role { admin, user }