import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:two_value/src/helper_widgets.dart';

import 'admin_companies_view.dart';
import 'admin_contacts_view.dart';
import 'admin_journalists_view.dart';

class AdminManageView extends StatefulWidget {
  final String userId;
  final DocumentSnapshot userData;
  const AdminManageView(
      {super.key, required this.userId, required this.userData});

  @override
  State<AdminManageView> createState() => _AdminManageViewState();
}

class _AdminManageViewState extends State<AdminManageView> {
  String language = '';
  String category = 'COMPANIES';
  final Map<String, Map<String, String>> categoryLabels = {
    'ro': {
      'COMPANIES': 'FIRME',
      'JOURNALISTS': 'JURNALIŞTII',
      'CONTACTS': 'CONTACTE ',
    },
    'eng': {
      'COMPANIES': 'COMPANIES',
      'JOURNALISTS': 'JOURNALISTS',
      'CONTACTS': 'CONTACTS',
    },
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      language = widget.userData['user_language'];
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      color: Colors.grey.withOpacity(.1),
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white, // Background color of the container
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2), // Shadow color
                  spreadRadius: 1, // Spread radius
                  blurRadius: 3, // Blur radius
                  offset: Offset(0, 3), // Changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 6.0,
              ),
              child: ChipsChoice<String>.single(
                value: category,
                onChanged: (val) {
                  setState(() {
                    category = val;
                  });
                },
                choiceItems: C2Choice.listFrom<String, String>(
                  source: categoryLabels[language]!.keys.toList(),
                  value: (i, v) => v,
                  label: (i, v) => categoryLabels[language]![v]!,
                ),
                choiceBuilder: (item, index) {
                  return ChoiceChip(
                    label: category == item.value
                        ? whiteChipText(item.label)
                        : blackChipText(item.label),
                    selected: category == item.value,
                    onSelected: (selected) {
                      setState(() {
                        category = item.value;
                      });
                    },
                    selectedColor: Colors
                        .blueGrey, // The background color for selected items
                    backgroundColor: Colors.grey[
                        300], // The background color for non-selected items
                    padding: EdgeInsets.symmetric(horizontal: 10),
                  );
                },
                wrapped: true,
                wrapCrossAlignment: WrapCrossAlignment.start,
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.start,
                padding: EdgeInsets.zero,
                spacing: 10,
                runSpacing: 0,
              ),
            ),
          ),
          // decideView(),
          decideView()
        ],
      ),
    );
  }

  Widget decideView() {
    if (category == 'COMPANIES') {
      return AdminCompaniesView(
        userId: widget.userId,
        userData: widget.userData,
      );
    } else if (category == 'JOURNALISTS') {
      return AdminJournalistsView(
        userId: widget.userId,
        userData: widget.userData,
      );
    } else if (category == 'CONTACTS') {
      return AdminContactsView(
        userId: widget.userId,
        userData: widget.userData,
      );
    } else {
      return AdminCompaniesView(
        userId: widget.userId,
        userData: widget.userData,
      );
    }
  }
}
