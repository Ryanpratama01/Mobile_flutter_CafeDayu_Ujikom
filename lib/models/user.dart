class User {
  final int? id;
  final String nama;
  final String email;
  final String password;
  final String role; // "user" atau "admin"
  final String? fotoProfil;

  User({
    this.id,
    required this.nama,
    required this.email,
    required this.password,
    this.role = "user", // default-nya user biasa
    this.fotoProfil,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'password': password,
      'role': role,
      'fotoProfil': fotoProfil,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      nama: map['nama'],
      email: map['email'],
      password: map['password'],
      role: map['role'],
      fotoProfil: map['fotoProfil'],
    );
  }
}