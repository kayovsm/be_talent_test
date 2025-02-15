import 'package:be_talent_test/app/widgets/app/text/description_text_app.dart';
import 'package:flutter/material.dart';

import '../models/employee_model.dart';

class UserCardWidget extends StatelessWidget {
  final EmployeeModel user;
  final VoidCallback onTap;

  const UserCardWidget({
    super.key,
    required this.user,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipOval(
        child: Image.network(
          user.image,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
        ),
      ),
      title: DescriptionTextApp(text: user.name),
      onTap: onTap,
    );
  }
}
