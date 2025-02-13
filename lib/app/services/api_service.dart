import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class ApiService {
  final String apiUrl = "http://192.168.31.247:3000/employees";

  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      List<User> result = data.map((json) => User.fromJson(json)).toList();

      return result;
    } else {
      print('LOG * ERROR API: ${response.statusCode}');
      throw Exception('Erro ao carregar os dados');
    }
  }
}
