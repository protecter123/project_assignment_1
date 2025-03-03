// lib/data/models/user_model.dart

class UserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'] ?? '',
     
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      
    };
  }

  // Create a copy with updated fields
  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
     
    );
  }
}

