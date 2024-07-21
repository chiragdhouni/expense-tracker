// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';

// class UserModel {
//   final String id;
//   final String name;
//   final String email;

//   UserModel({required this.id, required this.name, required this.email});

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'id': id,
//       'name': name,
//       'email': email,
//     };
//   }

//   factory UserModel.fromMap(Map<String, dynamic> map) {
//     return UserModel(
//       id: map['id'] as String,
//       name: map['name'] as String,
//       email: map['email'] as String,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory UserModel.fromJson(String source) =>
//       UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
// }
