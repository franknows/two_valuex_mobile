import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../src/helper_widgets.dart';
import 'add_stories_page.dart';
import 'approve_images.dart';
import 'approve_updated_images.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xff184a45),
          elevation: 4,
          title: appBarWhiteText('Admin page'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 16 / 9,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => const ApproveImages(),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        CupertinoIcons.person_2_alt,
                        size: 20.0,
                        color: Colors.black87,
                      ),
                      const SizedBox(height: 6.0),
                      blackBoldText('New users'),
                      blackNormalText('2 to approve'),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => const ApproveUpdatedImages(),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        CupertinoIcons.person_2_fill,
                        size: 20.0,
                        color: Colors.black87,
                      ),
                      const SizedBox(height: 6.0),
                      blackBoldText('Updated profiles'),
                      blackNormalText('2 to approve'),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => const AddStoriesPage(),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        CupertinoIcons.chat_bubble_text_fill,
                        size: 20.0,
                        color: Colors.black87,
                      ),
                      const SizedBox(height: 6.0),
                      blackBoldText('Add Stories'),
                      blackNormalText('2 to approve'),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  migrateUsersToMembers();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        CupertinoIcons.chat_bubble_text_fill,
                        size: 20.0,
                        color: Colors.black87,
                      ),
                      const SizedBox(height: 6.0),
                      blackBoldText('Move users'),
                      blackNormalText('2 to approve'),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.grey),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      CupertinoIcons.person_2_alt,
                      size: 20.0,
                      color: Colors.black87,
                    ),
                    const SizedBox(height: 6.0),
                    blackBoldText('New users'),
                    blackNormalText('2 to approve'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> migrateUsersToMembers() async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('Accounts');
    CollectionReference members =
        FirebaseFirestore.instance.collection('XUsers');

    // Fetch all documents from 'XUsers' collection
    QuerySnapshot usersSnapshot = await users.get();

    // Loop through each document and add it to 'XUsers' collection
    for (DocumentSnapshot document in usersSnapshot.docs) {
      await members.doc(document.id).set(document.data()!);
    }

    // Optionally, you can also delete all documents from 'XUsers' collection after migration
    // for (DocumentSnapshot document in usersSnapshot.docs) {
    //   await document.reference.delete();
    // }

    print("Migration from Accounts to Members complete!");
  }
}
