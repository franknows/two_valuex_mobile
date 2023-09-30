import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';

import '../../src/helper_widgets.dart';
import '../../src/theme.dart';
import '../auth/login_screen.dart';
import 'set_location_page.dart';

class SetupImages extends StatefulWidget {
  final String userId;

  const SetupImages({super.key, required this.userId});

  @override
  State<SetupImages> createState() => _SetupImagesState();
}

class _SetupImagesState extends State<SetupImages> {
  File? _imageProfileFile, _imageSlide1, _imageSlide2, _imageSlide3;
  String language = 'sw';
  bool loading = false;

  final ImagePicker _picker = ImagePicker();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: OverlayLoaderWithAppIcon(
        isLoading: loading,
        overlayBackgroundColor: TAppTheme.primaryColor,
        circularProgressColor: TAppTheme.accentColor,
        borderRadius: 15,
        appIcon: const Padding(
          padding: EdgeInsets.all(10),
          child: Icon(
            CupertinoIcons.hourglass,
            size: 28,
            color: TAppTheme.primaryColor,
          ),
        ),
        appIconSize: 50,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: TAppTheme.primaryColor,
            elevation: 4,
            title:
                appBarWhiteText(language == 'sw' ? 'Weka picha' : 'Add image'),
            actions: [
              Center(
                  child: InkWell(
                onTap: () {
                  if (language == 'sw') {
                    setState(() {
                      language = 'eng';
                    });
                  } else {
                    setState(() {
                      language = 'sw';
                    });
                  }
                },
                child: miniToggleBox(language),
              )),
              IconButton(
                onPressed: () {
                  // openDialog();
                  openLogoutDialog(language);
                },
                icon: const Icon(
                  CupertinoIcons.arrow_left_square,
                  color: Colors.white54,
                  size: 28,
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 240,
                  decoration: const BoxDecoration(
                    color: Color(0xff184f54),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(40),
                    ),
                    image: DecorationImage(
                      image:
                          NetworkImage('https://picsum.photos/200/300/?blur=5'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Center(
                          child: SizedBox(
                            height: 168.0,
                            width: 168.0,
                            child: InkWell(
                              child: _imageProfileFile == null
                                  ? CircleAvatar(
                                      backgroundColor:
                                          Colors.white.withOpacity(.3),
                                      radius: 84,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 80,
                                        child: Icon(
                                          CupertinoIcons.person_fill,
                                          color:
                                              Colors.blueGrey.withOpacity(.6),
                                          size: 80,
                                        ),
                                      ),
                                    )
                                  : CircleAvatar(
                                      backgroundColor:
                                          Colors.white.withOpacity(.3),
                                      radius: 84,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        backgroundImage:
                                            FileImage(_imageProfileFile!),
                                        foregroundColor: Colors.white,
                                        radius: 80,
                                      ),
                                    ),
                              onTap: () {
                                getProfileImage();
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          InkWell(
                            onTap: () {
                              buttonPressed(context);
                            },
                            child: simpleButton(
                                language == 'sw' ? 'Ingia ndani' : 'Finalize'),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void buttonPressed(BuildContext context) async {
    if (_imageProfileFile == null) {
      snackError(
        language == 'sw' ? 'Tafadhari weka picha!' : 'Please add a picture!',
        context,
      );
      return;
    }

    _uploadProfile(context);
    setState(() {
      loading = true;
    });
  }

  Future<void> getProfileImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      return;
    }

    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(
          ratioX: 1,
          ratioY: 1,
        ),
        maxHeight: 1000,
        maxWidth: 1000,
        compressQuality: 70,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Crop image',
              toolbarColor: TAppTheme.primaryColor,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: true),
          IOSUiSettings(
            title: 'Crop image',
          ),
        ],
      );

      if (croppedFile != null) {
        setState(() {
          final file = File(croppedFile.path);
          _imageProfileFile = file;
        });
      }
    } catch (e) {
      // Handle any errors that occurred during image cropping.
    }
  }

  Future<void> _uploadProfile(BuildContext context) async {
    final DateTime now = DateTime.now();
    final String year = DateFormat('yyyy').format(now);

    try {
      Reference pressStorageReference = FirebaseStorage.instance
          .ref()
          .child('Profiles/$year/${widget.userId}.jpg');
      UploadTask uploadTask = pressStorageReference.putFile(_imageProfileFile!);

      uploadTask.whenComplete(() async {
        String url = await pressStorageReference.getDownloadURL();

        // Update image
        DocumentReference ds =
            FirebaseFirestore.instance.collection('XUsers').doc(widget.userId);
        Map<String, dynamic> updateTasks = {
          'user_image': url,
          'images_completed': true,
        };
        ds.update(updateTasks);

        if (mounted) {
          sendNotificationToAdmin();
        }
      }).catchError((onError) {
        setState(() {
          loading = false;
        });
        snackError(
          language == 'sw'
              ? 'Imefeli, Tafadhari jaribu tena'
              : 'An error occurred, try again',
          context,
        );
      });
    } on FirebaseException catch (e) {
      setState(() {
        loading = false;
      });
      snackError(
        language == 'sw'
            ? 'Imefeli, Tafadhari jaribu tena'
            : 'An error occurred, try again',
        context,
      );
    }
  }

  void sendNotificationToAdmin() {
    if (kDebugMode) {
      print('writing notification to admins');
    }
    FirebaseFirestore.instance
        .collection('XUsers')
        .where('account_type', isEqualTo: 'Admin')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        // Increment notification count
        DocumentReference userRef =
            FirebaseFirestore.instance.collection('XUsers').doc(doc['user_id']);
        userRef.update({'notification_count': FieldValue.increment(1)});

        // Create notification document
        DocumentReference ds = FirebaseFirestore.instance
            .collection('Notifications')
            .doc('system')
            .collection(doc['user_id'])
            .doc();
        Map<String, dynamic> tasks = {
          'notification_tittle_eng': 'New user!',
          'notification_tittle_sw': 'Mtumiaji mpya!',
          'notification_body_eng':
              'A new user has just signed up on My wangu. Please visit their profile to review their information.',
          'notification_body_sw':
              'Mtumiaji mpya amejiunga na My wangu hivi punde. Tafadhari tazama ukurasa wao kuthibitisha taarifa zao.',
          'notification_time': FieldValue.serverTimestamp(),
          'notification_sender': 'My wangu',
          'action_title': 'new-user',
          'action_destination': 'XUsers',
          'notification_read': true,
          'action_destination_id': widget.userId,
          'notification_id': ds.id,
        };
        ds.set(tasks);
      }
    }).then((value) => sendNotification());
  }

  void sendNotification() async {
    if (kDebugMode) {
      print('writing notification to online user');
    }

    final notificationRef = FirebaseFirestore.instance
        .collection('Notifications')
        .doc('system')
        .collection(widget.userId)
        .doc();

    final notificationData = {
      'notification_tittle_eng': 'Welcome to My wangu App!',
      'notification_tittle_sw': 'Karibu kwenye programu ya My wangu!',
      'notification_body_eng':
          'Welcome to MY WANGU! Your account is ready, let\'s find out who are your new friends.',
      'notification_body_sw':
          'Karibu katika programu ya MY WANGU! Akaunti yako iko tayari kukutana na marafiki wapya.',
      'notification_time': FieldValue.serverTimestamp(),
      'notification_sender': 'My wangu',
      'action_title': 'new-me',
      'action_destination': '-',
      'notification_read': true,
      'action_destination_id': '-',
      'notification_id': notificationRef.id,
    };

    try {
      await notificationRef.set(notificationData);
      setState(() {
        loading = false;
      });
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(
            builder: (context) => SetLocationPage(userId: widget.userId),
          ),
          (r) => false,
        );
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      snackError(
        language == 'sw'
            ? 'Imefeli, Tafadhari jaribu tena'
            : 'An error occurred, try again',
        context,
      );
    }
  }

  openLogoutDialog(String language) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
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
                      language == 'sw' ? 'Ondoka' : 'Log out!',
                      style: GoogleFonts.quicksand(
                        textStyle: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          letterSpacing: .5,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      language == 'sw'
                          ? 'Hutapokea taarifa za akaunti yako kwa kipindi ambacho hutakuwepo.'
                          : 'You will not receive in-app notifications when you are out.',
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
                              _logOut();
                            },
                            child: dangerButton(
                              language == 'sw' ? 'Ondoka' : 'Logout',
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

  Future<void> _logOut() async {
    try {
      await _googleSignIn.signOut();
      await auth.signOut();
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(builder: (context) => const LoginScreen()),
        (r) => false,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}
