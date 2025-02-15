import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/employee_model.dart';

class ApiService {
  final String apiUrl = "http://192.168.31.247:3000/employees";

  Future<List<EmployeeModel>> fetchUsers() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      List<EmployeeModel> result =
          data.map((json) => EmployeeModel.fromJson(json)).toList();

      return result;
    } else {
      print('LOG * ERROR API: ${response.statusCode}');
      throw Exception('Erro ao carregar os dados');
    }
  }
}
