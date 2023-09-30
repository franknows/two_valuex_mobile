import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:two_value/screens/home/company_home_page.dart';

import '../../src/fcm.dart';
import 'journalist_home_page.dart';

class HomePage extends StatefulWidget {
  final String userId;
  const HomePage({super.key, required this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StreamController<List<DocumentSnapshot>> _streamController =
      StreamController<List<DocumentSnapshot>>();
  DocumentSnapshot? _userData;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    _getUserData(widget.userId);
    checkForUpdate();
    FCMService().initialize(context);
  }

  ///check for update
  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        InAppUpdate.performImmediateUpdate().catchError((e) {
          if (kDebugMode) {
            print(e.toString());
          }
        });
      } else {
        if (kDebugMode) {
          print('No update');
        }
      }
    }).catchError((e) {
      if (kDebugMode) {
        print('Error checking for update: $e');
      }
    });
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  void _getUserData(String userId) {
    FirebaseFirestore.instance
        .collection('XUsers')
        .doc(userId)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      setState(() {
        _userData = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_userData == null) {
      return Container();
    } else if (_userData!['account_type'] == 'Company') {
      return CompanyHomePage(
        userId: widget.userId,
        userData: _userData!,
      );
    } else if (_userData!['account_type'] == 'Journalist') {
      return JournalistHomePage(
        userId: widget.userId,
        userData: _userData!,
      );
    } else {
      return Container();
    }
  }
}
