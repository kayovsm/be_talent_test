import 'package:flutter/material.dart';

import '../models/employee_model.dart';
import '../utils/format_util.dart';

class UserDetailsDialogWidget extends StatelessWidget {
  final EmployeeModel user;

  const UserDetailsDialogWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(
        child: Text(
          "Dados do Funcionário",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ClipOval(
              child: Image.network(
                user.image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text("Nome: ${user.name}"),
          Text("Cargo: ${user.job}"),
          Text(
              "Data de Admissão: ${FormatUtil.formatDate(user.admissionDate)}"),
          Text("Telefone: ${FormatUtil.formatPhone(user.phone)}"),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Fechar"),
        ),
      ],
    );
  }
}
