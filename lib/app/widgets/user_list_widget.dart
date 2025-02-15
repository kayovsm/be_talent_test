import 'package:flutter/material.dart';

import '../models/employee_model.dart';
import '../utils/format_util.dart';
import 'app/text/description_text_app.dart';
import 'app/text/subtitle_text_app.dart';

class UserListWidget extends StatefulWidget {
  final List<EmployeeModel> usersList;

  const UserListWidget({super.key, required this.usersList});

  @override
  _UserListWidgetState createState() => _UserListWidgetState();
}

class _UserListWidgetState extends State<UserListWidget> {
  List<bool> isExpandedList = [];

  @override
  void initState() {
    super.initState();
    isExpandedList = List.generate(widget.usersList.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.usersList.length,
        itemBuilder: (context, index) {
          final user = widget.usersList[index];

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: isExpandedList[index] ? Colors.grey[100] : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading: ClipOval(
                  child: Image.network(
                    user.image,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                title: DescriptionTextApp(text: user.name),
                backgroundColor:
                    isExpandedList[index] ? Colors.grey[100] : Colors.white,
                onExpansionChanged: (bool expanded) {
                  setState(() => isExpandedList[index] = expanded);
                },
                tilePadding: EdgeInsets.zero,
                childrenPadding: EdgeInsets.zero,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildExpansionDetail("Cargo: ", user.job),
                        _buildExpansionDetail(
                          "Data de Admissão: ",
                          FormatUtil.formatDate(user.admissionDate),
                        ),
                        _buildExpansionDetail(
                          "Telefone: ",
                          FormatUtil.formatPhone(user.phone),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildExpansionDetail(String title, String detail) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SubTitleTextApp(text: title),
        DescriptionTextApp(text: detail),
      ],
    );
  }
}
