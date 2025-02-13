import 'package:be_talent_test/app/widgets/user_card_widget.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/api_service.dart';
import '../utils/format_util.dart';
import '../widgets/user_detail_dialog_widget.dart';
import '../widgets/user_filter_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<User>> users;
  List<User> filteredUsers = [];
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
        title: Text("Be Talent"),
      ),
      body: FutureBuilder<List<User>>(
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

          List<User> usersList = snapshot.data!;

          return Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                Text(
                  "Funcionários",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                UserFilterWidget(
                  users: users,
                  onFiltered: (filtered) {
                    setState(() => filteredUsers = filtered);
                  },
                ),
                if (filteredUsers.isNotEmpty)
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 70,
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
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
                  ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Container(
                          color: Colors.grey[200],
                          padding: EdgeInsets.all(8),
                          child: Row(
                            children: [
                              SizedBox(width: 10),
                              Text(
                                "Foto",
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              SizedBox(width: 25),
                              Text(
                                "Nome",
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: usersList.length,
                            itemBuilder: (context, index) {
                              final user = usersList[index];
                              return ExpansionTile(
                                leading: ClipOval(
                                  child: Image.network(
                                    user.image,
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(user.name),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Nome: ${user.name}"),
                                        Text("Cargo: ${user.job}"),
                                        Text(
                                            "Data de Admissão: ${FormatUtil.formatDate(user.admissionDate)}"),
                                        Text(
                                            "Telefone: ${FormatUtil.formatPhone(user.phone)}"),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
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
