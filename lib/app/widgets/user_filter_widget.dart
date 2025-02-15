import 'package:be_talent_test/app/widgets/app/text/title_text_app.dart';
import 'package:flutter/material.dart';

import '../models/employee_model.dart';
import '../utils/filter_option_util.dart';
import '../utils/format_util.dart';

class UserFilterWidget extends StatefulWidget {
  final Future<List<EmployeeModel>> users;
  final Function(List<EmployeeModel>) onFiltered;

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
  List<EmployeeModel> filteredUsers = [];
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

  List<EmployeeModel> _filterUsers(String query, List<EmployeeModel> users) {
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
          title: const Center(child: TitleTextApp(text: 'Filtrar por')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(color: Colors.black),
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
              child: Text("Salvar"),
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
            Container(
              margin: const EdgeInsets.only(left: 16),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: IconButton(
                icon: Icon(Icons.filter_list),
                color: Colors.white,
                onPressed: _openFilterDialog,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
