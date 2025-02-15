import 'dart:convert';

class EmployeeModel {
  final String id;
  final String name;
  final String job;
  final String admissionDate;
  final String phone;
  final String image;

  EmployeeModel({
    required this.id,
    required this.name,
    required this.job,
    required this.admissionDate,
    required this.phone,
    required this.image,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'],
      name: utf8.decode(json['name'].toString().codeUnits),
      job: utf8.decode(json['job'].toString().codeUnits),
      admissionDate: json['admission_date'],
      phone: json['phone'],
      image: json['image'],
    );
  }
}
