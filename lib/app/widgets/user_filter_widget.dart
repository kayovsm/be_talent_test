import 'package:flutter/material.dart';

import '../models/user.dart';
import '../utils/filter_option_util.dart';
import '../utils/format_util.dart';

class UserFilterWidget extends StatefulWidget {
  final Future<List<User>> users;
  final Function(List<User>) onFiltered;

  const UserFilterWidget({
    super.key,
    required this.users,
    required this.onFiltered,
  });

  @override
  _UserFilterWidgetState createState() => _UserFilterWidgetState();
}

class _UserFilterWidgetState extends State<UserFilterWidget> {
  TextEditingController searchController = TextEditingController();
  List<User> filteredUsers = [];
  List<bool> filterSelections = [true, true, true]; // name, job, phone

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      filterUsers(searchController.text);
    });
  }

  void filterUsers(String query) {
    widget.users.then((userList) {
      setState(() {
        filteredUsers = _filterUsers(query, userList);
        widget.onFiltered(filteredUsers);
      });
    });
  }

  List<User> _filterUsers(String query, List<User> users) {
    if (query.isEmpty) {
      return [];
    } else {
      return users.where((user) {
        final nameLower = user.name.toLowerCase();
        final jobLower = user.job.toLowerCase();
        final phoneFormatted = FormatUtil.formatPhone(user.phone);
        final searchLower = query.toLowerCase();

        bool match = false;

        if (filterSelections[0]) {
          match = match || nameLower.contains(searchLower);
        }

        if (filterSelections[1]) {
          match = match || jobLower.contains(searchLower);
        }

        if (filterSelections[2]) {
          match = match || phoneFormatted.contains(searchLower);
        }

        return match;
      }).toList();
    }
  }

  void _openFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              "Filtros",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FilterOptionUtil(
                label: 'Nome',
                value: filterSelections[0],
                onChanged: (bool? value) {
                  setState(() {
                    filterSelections[0] = value ?? true;
                  });
                  filterUsers(searchController.text);
                },
              ),
              FilterOptionUtil(
                label: 'Cargo',
                value: filterSelections[1],
                onChanged: (bool? value) {
                  setState(() {
                    filterSelections[1] = value ?? true;
                  });
                  filterUsers(searchController.text);
                },
              ),
              FilterOptionUtil(
                label: 'Telefone',
                value: filterSelections[2],
                onChanged: (bool? value) {
                  setState(() {
                    filterSelections[2] = value ?? true;
                  });
                  filterUsers(searchController.text);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Fechar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Pesquisar',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.filter_list),
              hoverColor: Colors.red,
              onPressed: _openFilterDialog,
            ),
          ],
        ),
      ],
    );
  }
}
