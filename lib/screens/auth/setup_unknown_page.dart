import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SetupUnknownPage extends StatefulWidget {
  final String userId;
  final DocumentSnapshot userData;
  const SetupUnknownPage(
      {super.key, required this.userId, required this.userData});

  @override
  State<SetupUnknownPage> createState() => _SetupUnknownPageState();
}

class _SetupUnknownPageState extends State<SetupUnknownPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
