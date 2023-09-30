import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:two_value/src/helper_widgets.dart';

class CompanyHomeView extends StatefulWidget {
  final String userId;
  final DocumentSnapshot userData;
  const CompanyHomeView(
      {super.key, required this.userId, required this.userData});

  @override
  State<CompanyHomeView> createState() => _CompanyHomeViewState();
}

class _CompanyHomeViewState extends State<CompanyHomeView> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Articles')
          .doc('Presses')
          .collection('Dominant')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.data!.docs.length == 0) {
            return Center(
              child: Text('No Articles Found'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot doc = snapshot.data!.docs[index];
                // Replace with your article widget, and provide the required data from 'doc'.
                return ListTile(
                  title: Text(doc[
                      'press_title']), // Replace 'title' with the field key of your Article title.
                  subtitle: Text(doc[
                      'press_title']), // Replace 'subtitle' with the field key of your Article subtitle.
                  // You can add more properties like Image, onTap etc. according to your design needs.
                );
              },
            );
          }
        }
      },
    );
    return Container(
      child: Column(
        children: [
          addVerticalSpace(40),
          InkWell(
              onTap: () async {
                final firestore = FirebaseFirestore.instance;

                const sourceCollectionPath = 'Articles/Interviews/Dominant';
                const destCollectionPath = 'XArticles/Interviews/Dominant';

                // Retrieve all documents from 'Articles/Presses/Dominant'.
                final dominantSnapshot =
                    await firestore.collection(sourceCollectionPath).get();

                // Copy each document to 'XArticles/Presses/Dominant'.
                for (final doc in dominantSnapshot.docs) {
                  await firestore
                      .collection(destCollectionPath)
                      .doc(doc.id)
                      .set(doc.data() as Map<String, dynamic>);
                }

                // Inform the user that the operation is complete.
                print('moved Dominant');
              },
              child: simpleRoundedButton('Move presses')),
        ],
      ),
    );
  }
}
