import 'package:be_talent_test/app/widgets/app/text/subtitle_text_app.dart';
import 'package:be_talent_test/app/widgets/app/text/title_text_app.dart';
import 'package:be_talent_test/app/widgets/user_card_widget.dart';
import 'package:be_talent_test/app/widgets/user_list_widget.dart';
import 'package:flutter/material.dart';

import '../models/employee_model.dart';
import '../services/api_service.dart';
import '../widgets/user_detail_dialog_widget.dart';
import '../widgets/user_filter_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<EmployeeModel>> users;
  List<EmployeeModel> filteredUsers = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    users = ApiService().fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: TitleTextApp(
          text: "Be Talent",
          color: Colors.white,
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<EmployeeModel>>(
        future: users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Erro ao carregar dados"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Nenhum usuário encontrado"));
          }

          List<EmployeeModel> usersList = snapshot.data!;

          return Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                const SubTitleTextApp(text: "Funcionários"),
                const Divider(color: Colors.black),
                UserFilterWidget(
                  users: users,
                  onFiltered: (filtered) {
                    setState(() => filteredUsers = filtered);
                  },
                ),
                if (filteredUsers.isNotEmpty)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
                    ),
                    constraints: BoxConstraints(maxHeight: 300),
                    child: Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredUsers.length,
                        itemBuilder: (context, index) {
                          final user = filteredUsers[index];

                          return UserCardWidget(
                            user: user,
                            onTap: () {
                              searchController.clear();
                              setState(() => filteredUsers.clear());

                              showDialog(
                                context: context,
                                builder: (context) {
                                  return UserDetailsDialogWidget(user: user);
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      spacing: 16,
                      children: [
                        Container(
                          padding: EdgeInsets.all(16),
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Row(
                            children: [
                              SizedBox(width: 5),
                              SubTitleTextApp(text: "Foto"),
                              SizedBox(width: 20),
                              SubTitleTextApp(text: "Nome"),
                            ],
                          ),
                        ),
                        UserListWidget(usersList: usersList),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
