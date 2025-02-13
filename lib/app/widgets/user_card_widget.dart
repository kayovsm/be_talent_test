import 'package:flutter/material.dart';
import '../models/user.dart';

class UserCardWidget extends StatelessWidget {
  final User user;
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
      title: Text(user.name),
      onTap: onTap,
    );
  }
}
