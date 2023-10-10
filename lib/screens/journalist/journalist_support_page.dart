import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:two_value/screens/company/company_support_engage_page.dart';

import '../../src/helper_widgets.dart';

class JournalistSupportPage extends StatefulWidget {
  final String userId;
  final DocumentSnapshot userData;
  const JournalistSupportPage(
      {super.key, required this.userId, required this.userData});

  @override
  State<JournalistSupportPage> createState() => _JournalistSupportPageState();
}

class _JournalistSupportPageState extends State<JournalistSupportPage> {
  String language = '';
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                addVerticalSpace(30),
                Center(
                  child: Image(
                    height: size.width / 1.5,
                    width: size.width / 1.5,
                    image: const AssetImage(
                      'assets/images/support_male.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            addVerticalSpace(20),
            blackBoldTextWithSize(
              language == 'ro' ? 'Vești incitante!' : 'Exciting News!',
              20,
            ),
            addVerticalSpace(10),
            blackNormalText(
              language == 'ro'
                  ? 'Am îmbunătățit pagina noastră de asistență cu ajutorul inteligenței artificiale. Acum poți discuta instant cu asistentul nostru AI pentru răspunsuri rapide și îndrumare. Cu toate acestea, dacă preferi interacțiunea umană sau ai nevoie de asistență suplimentară, echipa noastră dedicată este de asemenea disponibilă să te ajute. Pur și simplu anunță-ne preferința ta. Suntem aici pentru a te ajuta în orice mod putem.\nApasă butonul de mai jos pentru a începe.'
                  : 'We\'ve enhanced our support page with the power of AI. Now, you can chat instantly with our AI assistant for quick answers and guidance. However, if you prefer human touch or need further assistance, our dedicated team is also available to help. Simply let us know your preference. We\'re here to help in every way we can.\nClick the button below to get started.',
            ),
            addVerticalSpace(40),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => CompanySupportEngagePage(
                      userId: widget.userId,
                      userData: widget.userData,
                    ),
                  ),
                );
              },
              child: simpleRoundedButtonWithIcon(
                language == 'ro' ? 'Vești incitante!' : 'Start Chat',
                CupertinoIcons.chat_bubble_2_fill,
              ),
            )
          ],
        ),
      ),
    );
  }
}
