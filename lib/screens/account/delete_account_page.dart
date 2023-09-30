import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../src/helper_widgets.dart';
import '../auth/login_screen.dart';

class DeleteAccountPage extends StatefulWidget {
  final String userId;
  final DocumentSnapshot myUserInfo;
  const DeleteAccountPage(
      {super.key, required this.userId, required this.myUserInfo});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String language = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      language = widget.myUserInfo['user_language'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff184a45),
        elevation: 4,
        title: appBarWhiteText('Delete Account'),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            advancedProfileTiles(
              language == 'sw'
                  ? 'Una uhakika unataka kufuta akaunti yako? Akaunti yako na data yote itafutwa kabisa.'
                  : 'Are you sure you want to delete your account? Your account and all of its data will be permanently deleted.',
              language == 'sw'
                  ? 'Tunapendekeza uzime akaunti yako badala yake. Akaunti iliyozimwa haitaonekana na inaweza kurejeshwa wakati wowote.'
                  : 'We recommend deactivating your account instead. A deactivated account will not be visible and can be reactivated anytime.',
            ),
            const SizedBox(height: 16.0),
            InkWell(
              onTap: () {
                deactivateAccountDialog(widget.myUserInfo['user_language']);
              },
              child: laterButton(
                  language == 'sw' ? 'Zima akaunti' : 'Deactivate account'),
            ),
            const SizedBox(height: 16.0),
            InkWell(
              onTap: () {
                deleteAccountDialog(widget.myUserInfo['user_language']);
              },
              child: dangerButton(
                  language == 'sw' ? 'Futa akaunti' : 'Delete account'),
            ),
          ],
        ),
      ),
    );
  }

  deleteAccountDialog(String language) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ), //this right here
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      language == 'sw' ? 'Una uhakika?' : 'Are you sure?',
                      style: GoogleFonts.quicksand(
                        textStyle: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          letterSpacing: .5,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      language == 'sw'
                          ? 'Kukamilisha uamuzi wako bonyeza kitufe husika hapa chini.'
                          : 'To finalize your action click the respective button below.',
                      style: GoogleFonts.quicksand(
                        textStyle: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                          letterSpacing: .5,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: laterButton(
                              language == 'sw' ? 'Sitisha' : 'Cancel',
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              _deleteAccount();
                            },
                            child: dangerButton(
                              language == 'sw' ? 'Futa' : 'Delete',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  deactivateAccountDialog(String language) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ), //this right here
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      language == 'sw' ? 'Una uhakika?' : 'Are you sure?',
                      style: GoogleFonts.quicksand(
                        textStyle: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          letterSpacing: .5,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      language == 'sw'
                          ? 'Kukamilisha uamuzi wako bonyeza kitufe husika hapa chini.'
                          : 'To finalize your action click the respective button below.',
                      style: GoogleFonts.quicksand(
                        textStyle: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                          letterSpacing: .5,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: laterButton(
                              language == 'sw' ? 'Sitisha' : 'Cancel',
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              _deleteAccount();
                            },
                            child: dangerButton(
                              language == 'sw' ? 'Funga sasa' : 'Deactivate',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _deleteAccount() async {
    DocumentReference swipeRef =
        FirebaseFirestore.instance.collection('XUsers').doc(widget.userId);
    Map<String, dynamic> swipeTask = {
      'user_visibility': false,
    };
    swipeRef.update(swipeTask);

    try {
      await _googleSignIn.signOut();
      await auth.signOut();
      if (mounted) {
        Navigator.of(context).pop();
        Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(
              builder: (context) => const LoginScreen(),
            ),
            (r) => false);
      }
      // MyApp.restartApp(context);
    } catch (e) {
      snackError('An error occured try again', context);
      return null;
    }
  }
}
