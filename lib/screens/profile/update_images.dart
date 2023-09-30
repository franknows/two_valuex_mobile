import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';

import '../../src/helper_widgets.dart';
import '../../src/theme.dart';

class UpdateImages extends StatefulWidget {
  final String userId;

  const UpdateImages({super.key, required this.userId});

  @override
  State<UpdateImages> createState() => _UpdateImagesState();
}

class _UpdateImagesState extends State<UpdateImages> {
  final ImagePicker _picker = ImagePicker();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: TAppTheme.primaryColor,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('XUsers')
            .where('user_id', isEqualTo: widget.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            DocumentSnapshot myRealtimeInfo = snapshot.data!.docs[0];
            return OverlayLoaderWithAppIcon(
              isLoading: loading,
              overlayBackgroundColor: TAppTheme.primaryColor,
              circularProgressColor: TAppTheme.accentColor,
              borderRadius: 15,
              appIcon: Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    color: TAppTheme.primaryColor,
                    border: Border.all(
                      color: TAppTheme.primaryColor,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(6.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/images/no_bg_logo.png',
                    ),
                  ),
                ),
              ),
              appIconSize: 50,
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: TAppTheme.primaryColor,
                  elevation: 4,
                  centerTitle: true,
                  title: appBarWhiteText(myRealtimeInfo['user_language'] == 'sw'
                      ? 'Weka picha zako'
                      : 'Add your images'),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 240,
                        decoration: const BoxDecoration(
                          color: Color(0xff184f54),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(40),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(
                                'https://picsum.photos/200/300/?blur=5'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(
                          children: <Widget>[
                            Center(
                              child: Center(
                                child: InkWell(
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white38,
                                    radius: 84,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.blue,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                              myRealtimeInfo['user_image']),
                                      foregroundColor: Colors.white,
                                      radius: 80,
                                    ),
                                  ),
                                  onTap: () {
                                    getProfileImage(
                                        myRealtimeInfo['user_language'],
                                        context);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                blueBodyTextLarge(myRealtimeInfo[
                                            'user_language'] ==
                                        'sw'
                                    ? 'Changua picha\ntatu (3) zinazo kuonesha wewe.'
                                    : 'Select three (3) \npictures that we will display.'),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width:
                                          (MediaQuery.of(context).size.width /
                                                  3) -
                                              20,
                                      child: InkWell(
                                        child: AspectRatio(
                                          aspectRatio: 9 / 16,
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 2,
                                                color:
                                                    Colors.grey.withOpacity(.5),
                                              ),
                                            ),
                                            child: CachedNetworkImage(
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              imageUrl: myRealtimeInfo[
                                                  'user_slide_one'],
                                              placeholder: (context, url) =>
                                                  const Image(
                                                image: AssetImage(
                                                  'assets/images/vertical_placeholder.png',
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Image(
                                                image: AssetImage(
                                                  'assets/images/vertical_placeholder.png',
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          getSlideImage1(
                                              myRealtimeInfo, context);
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width:
                                          (MediaQuery.of(context).size.width /
                                                  3) -
                                              20,
                                      child: InkWell(
                                        child: AspectRatio(
                                          aspectRatio: 9 / 16,
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 2,
                                                color:
                                                    Colors.grey.withOpacity(.5),
                                              ),
                                            ),
                                            child: CachedNetworkImage(
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              imageUrl: myRealtimeInfo[
                                                  'user_slide_two'],
                                              placeholder: (context, url) =>
                                                  const Image(
                                                image: AssetImage(
                                                  'assets/images/vertical_placeholder.png',
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Image(
                                                image: AssetImage(
                                                  'assets/images/vertical_placeholder.png',
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          getSlideImage2(
                                              myRealtimeInfo, context);
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width:
                                          (MediaQuery.of(context).size.width /
                                                  3) -
                                              20,
                                      child: InkWell(
                                        child: AspectRatio(
                                          aspectRatio: 9 / 16,
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 2,
                                                color:
                                                    Colors.grey.withOpacity(.5),
                                              ),
                                            ),
                                            child: CachedNetworkImage(
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              imageUrl: myRealtimeInfo[
                                                  'user_slide_three'],
                                              placeholder: (context, url) =>
                                                  const Image(
                                                image: AssetImage(
                                                  'assets/images/vertical_placeholder.png',
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Image(
                                                image: AssetImage(
                                                  'assets/images/vertical_placeholder.png',
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          getSlideImage3(
                                              myRealtimeInfo, context);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  myRealtimeInfo['user_language'] == 'sw'
                                      ? '✍️ Kumbuka, ili kupata tiki ya bluu kwenye akaunti yako, utahitaji kuthibitisha picha tatu ulizoweka ni picha zinazokuonesha wewe.'
                                      : '✍️ Remember, in order to get a blue badge on your profile, you will have to verify the three images you uploaded really represents you.',
                                  style: GoogleFonts.quicksand(
                                    textStyle: const TextStyle(
                                      color: Color(0xff2a0000),
                                      fontSize: 14.0,
                                      letterSpacing: .5,
                                    ),
                                  ),
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
            );
          } else {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: const Color(0xff184a45),
                elevation: 0,
                centerTitle: true,
                title: Text(
                  '',
                  style: GoogleFonts.quicksand(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      letterSpacing: .5,
                    ),
                  ),
                ),
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
              body: Container(),
            );
          }
        },
      ),
    );
  }

  Future<void> getProfileImage(String language, BuildContext context) async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

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
            toolbarColor: const Color(0xff184f54),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
        IOSUiSettings(
          title: 'Crop image',
        ),
      ],
    );

    if (croppedFile == null) return;

    final file = File(croppedFile.path);
    if (!mounted) return;
    await uploadProfileImage(file, language, context);
  }

  Future<void> uploadProfileImage(
      File file, String language, BuildContext context) async {
    setState(() {
      loading = true;
    });

    try {
      final now = DateTime.now();
      final year = DateFormat('yyyy').format(now);

      final pressStorageReference = FirebaseStorage.instance
          .ref()
          .child('Profiles/$year/${widget.userId}.jpg');
      final uploadTask = pressStorageReference.putFile(file);
      await uploadTask;

      final url = await pressStorageReference.getDownloadURL();
      final ds =
          FirebaseFirestore.instance.collection('XUsers').doc(widget.userId);
      final updateTasks = {
        'user_image': url,
        'images_verification_status': 'Updated',
        'notification_count': FieldValue.increment(1),
      };
      await ds.update(updateTasks);
      sendNotification();
      sendNotificationToAdmin();
      if (mounted) {
        snackSuccess(
          language == 'sw'
              ? 'Imefanikiwa kupandisha'
              : 'Profile picture uploaded',
          context,
        );
      }
    } on FirebaseException catch (_) {
      snackError(
        language == 'sw'
            ? 'Imefeli, Tafadhari jaribu tena'
            : 'An error occurred, try again',
        context,
      );
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> getSlideImage1(
      DocumentSnapshot myRealtimeInfo, BuildContext context) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatio: const CropAspectRatio(
        ratioX: 9,
        ratioY: 16,
      ),
      maxHeight: 1920,
      maxWidth: 1080,
      compressQuality: 70,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop image',
          toolbarColor: const Color(0xff184f54),
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Crop image',
        ),
      ],
    );

    if (croppedFile == null) return;

    setState(() {
      final file = File(croppedFile.path);
      _uploadSlide1(myRealtimeInfo['user_language'], file, context);
    });
  }

  Future<void> getSlideImage2(
    DocumentSnapshot myRealtimeInfo,
    BuildContext context,
  ) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image!.path,
      aspectRatio: const CropAspectRatio(
        ratioX: 9,
        ratioY: 16,
      ),
      maxHeight: 1920,
      maxWidth: 1080,
      compressQuality: 70,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop image',
          toolbarColor: const Color(0xff184f54),
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Crop image',
        ),
      ],
    );

    if (croppedFile != null) {
      if (!mounted) return;
      setState(() {
        final File file = File(croppedFile.path);
        _uploadSlide2(myRealtimeInfo['user_language'], file, context);
      });
    }
  }

  Future<void> getSlideImage3(
      DocumentSnapshot myRealtimeInfo, BuildContext context) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image!.path,
      aspectRatio: const CropAspectRatio(
        ratioX: 9,
        ratioY: 16,
      ),
      maxHeight: 1920,
      maxWidth: 1080,
      compressQuality: 70,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop image',
          toolbarColor: const Color(0xff184f54),
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Crop image',
        ),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        final File file = File(croppedFile.path);
        if (mounted) {
          _uploadSlide3(myRealtimeInfo['user_language'], file, context);
        }
      });
    }
  }

  Future<void> _uploadSlide1(
      String language, File file, BuildContext context) async {
    setState(() {
      loading = true;
    });

    try {
      final now = DateTime.now();
      final year = DateFormat('yyyy').format(now);

      final pressStorageReference = FirebaseStorage.instance
          .ref()
          .child('Slides/$year/${widget.userId}/1.jpg');
      final uploadTask = pressStorageReference.putFile(file);
      await uploadTask;

      final url = await pressStorageReference.getDownloadURL();

      final ds =
          FirebaseFirestore.instance.collection('XUsers').doc(widget.userId);
      final updateTasks = {
        'user_slide_one': url,
        'images_verification_status': 'Updated',
        'notification_count': FieldValue.increment(1),
      };
      await ds.update(updateTasks);

      sendNotification();
      sendNotificationToAdmin();

      setState(() {
        loading = false;
      });

      if (mounted) {
        snackSuccess(
            (language == 'sw'
                ? 'Imefanikiwa kupandisha picha'
                : 'Image uploaded successfully'),
            context);
      }
    } on FirebaseException catch (e) {
      setState(() {
        loading = false;
      });

      if (mounted) {
        snackError(
            (language == 'sw'
                ? 'Imefeli, Tafadhari jaribu tena'
                : 'An error occurred, try again'),
            context);
      }
    }
  }

  Future<void> _uploadSlide2(
      String language, File file, BuildContext context) async {
    final now = DateTime.now();
    final year = DateFormat('yyyy').format(now);

    setState(() {
      loading = true;
    });

    try {
      final pressStorageReference = FirebaseStorage.instance
          .ref()
          .child('Slides/$year/${widget.userId}/2.jpg');
      final uploadTask = pressStorageReference.putFile(file);

      await uploadTask.whenComplete(() async {
        final url = await pressStorageReference.getDownloadURL();

        final ds =
            FirebaseFirestore.instance.collection('XUsers').doc(widget.userId);
        final updateTasks = {
          'user_slide_two': url,
          'images_verification_status': 'Updated',
          'notification_count': FieldValue.increment(1),
        };
        await ds.update(updateTasks);

        sendNotification();
        sendNotificationToAdmin();

        setState(() {
          loading = false;
        });

        if (mounted) {
          snackSuccess(
            language == 'sw'
                ? 'Imefanikiwa kupandisha picha'
                : 'Image uploaded successfully',
            context,
          );
        }
      });
    } on FirebaseException catch (e) {
      setState(() {
        loading = false;
      });

      if (mounted) {
        snackError(
          language == 'sw'
              ? 'Imefeli, Tafadhari jaribu tena'
              : 'An error occurred, try again',
          context,
        );
      }
    }
  }

  Future<void> _uploadSlide3(
      String language, File file, BuildContext context) async {
    final DateTime now = DateTime.now();
    final String year = DateFormat('yyyy').format(now);

    setState(() {
      loading = true;
    });

    try {
      Reference pressStorageReference = FirebaseStorage.instance
          .ref()
          .child('Slides/$year/${widget.userId}/3.jpg');
      TaskSnapshot snapshot = await pressStorageReference.putFile(file);

      String url = await snapshot.ref.getDownloadURL();

      DocumentReference ds =
          FirebaseFirestore.instance.collection('XUsers').doc(widget.userId);
      await ds.update({
        'user_slide_three': url,
        'images_completed': true,
        'images_verification_status': 'Updated',
        'notification_count': FieldValue.increment(1),
      });

      sendNotification();
      sendNotificationToAdmin();
      setState(() {
        loading = false;
      });

      if (mounted) {
        snackSuccess(
            (language == 'sw'
                ? 'Imefanikiwa kupandisha picha'
                : 'Image uploaded successfully'),
            context);
      }
    } catch (e) {
      setState(() {
        loading = false;
      });

      if (mounted) {
        snackError(
            (language == 'sw'
                ? 'Imefeli, Tafadhari jaribu tena'
                : 'An error occurred, try again'),
            context);
      }
    }
  }

  void sendNotification() {
    final notificationRef = FirebaseFirestore.instance
        .collection('Notifications')
        .doc('system')
        .collection(widget.userId)
        .doc('${widget.userId}_prfUpdate');

    final notificationData = {
      'notification_tittle_eng': 'Profile update!',
      'notification_tittle_sw': 'Marekebisho katika ukurasa!',
      'notification_body_eng':
          'You have successfully updated the images on your profile, our tools will do a quick scan and you will gain full access shortly.',
      'notification_body_sw':
          'Umefanikiwa kufanya marekebisho ya picha katika wasifu wako, mitambo yetu itapitia maudhui kisha akaunti yako itakuwa huru kwa faragha.',
      'notification_time': FieldValue.serverTimestamp(),
      'notification_sender': 'My wangu',
      'action_title': '-',
      'action_destination': '-',
      'notification_read': true,
      'action_destination_id': '-',
      'notification_id': notificationRef.id,
    };
    notificationRef.set(notificationData);
  }

  void sendNotificationToAdmin() async {
    try {
      final adminDocs = await FirebaseFirestore.instance
          .collection('XUsers')
          .where('account_type', isEqualTo: 'Admin')
          .get();

      for (final doc in adminDocs.docs) {
        // Update notification count for admin user
        final userRef =
            FirebaseFirestore.instance.collection('XUsers').doc(doc['user_id']);
        final countTasks = {'notification_count': FieldValue.increment(1)};
        await userRef.update(countTasks);

        // Send notification to admin user
        final notificationRef = FirebaseFirestore.instance
            .collection('Notifications')
            .doc('system')
            .collection(doc['user_id'])
            .doc('${widget.userId}_prfUpdate');
        final notificationTasks = {
          'notification_tittle_eng': 'A user updated their profile!',
          'notification_tittle_sw': 'Mtumiaji kaboresha picha zake!',
          'notification_body_eng':
              'A user has successfully updated the images on their profile, please visit the profiles to do a review.',
          'notification_body_sw':
              'Mtumiaji amefanikiwa kubadili picha katika wasifu wake, tafadhari tembelea wasifu ili kupitia maudhui.',
          'notification_time': FieldValue.serverTimestamp(),
          'notification_sender': 'My wangu',
          'action_title': 'profile-update',
          'action_destination': 'Notifications',
          'notification_read': true,
          'action_destination_id': widget.userId,
          'notification_id': notificationRef.id,
        };
        await notificationRef.set(notificationTasks);
      }
    } catch (e) {
      // print('Error sending notification to admin: $e');
    }
  }
}
