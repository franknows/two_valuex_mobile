import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';

import '../../src/helper_widgets.dart';
import '../../src/theme.dart';

class AddStoriesPage extends StatefulWidget {
  const AddStoriesPage({super.key});

  @override
  State<AddStoriesPage> createState() => _AddStoriesPageState();
}

class _AddStoriesPageState extends State<AddStoriesPage> {
  final _formKey = GlobalKey<FormState>();
  final DateTime now = DateTime.now();
  File? _imageFile;

  void saveStory(String thumbUrl) {
    DocumentReference ds =
        FirebaseFirestore.instance.collection('TheStories').doc();

    Map<String, dynamic> tasks = {
      'story_video_url': '-',
      'story_thumbnail_url': thumbUrl,
      'story_title_sw': storyTitle,
      'story_title_en': storyTitle,
      'story_summary_sw': storySummary,
      'story_summary_en': storySummary,
      'story_body_sw': storyBody,
      'story_body_en': storyBody,
      'story_id': ds.id,
      'story_gender': '-',
      'story_tags': FieldValue.arrayUnion([]),
      'story_users': FieldValue.arrayUnion([]),
      'story_usage_count': 0,
      'story_view_count': 0,
      'story_name': now.millisecondsSinceEpoch.toString(),
      'story_visibility': true,
      'story_visible_areas': FieldValue.arrayUnion(['-']),
      'story_posted_time': FieldValue.serverTimestamp(),
      'story_posted_mills': DateTime.now().millisecondsSinceEpoch,
    };
    ds.set(tasks).whenComplete(() {
      snackSuccess('Uploaded successfully!', context);
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String storySummary = '';
  String storyBody = '';
  String storyTitle = '';
  bool loading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarDividerColor: Colors.grey.shade200),
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
            title: Text(
              'Write a story',
              style: GoogleFonts.quicksand(
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  letterSpacing: .5,
                ),
              ),
            ),
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
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    addVerticalSpace(20),
                    InkWell(
                      onTap: () {
                        getImage();
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image(
                          width: MediaQuery.of(context).size.width - 32,
                          height:
                              (MediaQuery.of(context).size.width - 32) * 9 / 16,
                          image: _imageFile == null
                              ? const AssetImage(
                                  'assets/images/vertical_placeholder.png',
                                )
                              : FileImage(_imageFile!) as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    addVerticalSpace(20),
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.text,
                      maxLines: null,
                      style: GoogleFonts.quicksand(
                        textStyle: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          letterSpacing: .5,
                        ),
                      ),
                      decoration: inputDecoration('Story title'),
                      onChanged: (val) {
                        setState(() => storyTitle = val.trim());
                      },
                      validator: (value) =>
                          value!.length < 3 ? 'Enter a valid tile' : null,
                    ),
                    addVerticalSpace(20),
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.text,
                      maxLength: 500,
                      maxLines: null,
                      style: GoogleFonts.quicksand(
                        textStyle: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          letterSpacing: .5,
                        ),
                      ),
                      decoration: inputDecoration('Story summary'),
                      onChanged: (val) {
                        setState(() => storySummary = val.trim());
                      },
                      validator: (value) =>
                          value!.length < 30 ? ('Summary too short') : null,
                    ),
                    addVerticalSpace(20),
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.multiline,
                      maxLength: 30000,
                      maxLines: null,
                      style: GoogleFonts.quicksand(
                        textStyle: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          letterSpacing: .5,
                        ),
                      ),
                      decoration: inputDecoration('Story body'),
                      onChanged: (val) {
                        setState(() => storyBody = val.trim());
                      },
                      validator: (value) =>
                          value!.length < 500 ? ('Body too short') : null,
                    ),
                    addVerticalSpace(20),
                    InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        buttonPressed(context);
                      },
                      child: simpleButton('Submit'),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      return;
    }

    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(
          ratioX: 16,
          ratioY: 9,
        ),
        maxHeight: 1080,
        maxWidth: 1920,
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
          _imageFile = file;
        });
      }
    } catch (e) {
      // Handle any errors that occurred during image cropping.
    }
  }

  void buttonPressed(BuildContext context) async {
    if (_imageFile == null) {
      snackError(
        'Please pick an image!',
        context,
      );
      return;
    }
    if (!_formKey.currentState!.validate()) {
      setState(() {
        loading = false;
      });
      snackError(
        'Please fill in everything!',
        context,
      );
      return;
    }

    _uploadImage(context);
    setState(() {
      loading = true;
    });
  }

  Future<void> _uploadImage(BuildContext context) async {
    final String year = DateFormat('yyyy').format(now);

    try {
      Reference pressStorageReference = FirebaseStorage.instance.ref().child(
          'Stories/$year/${now.millisecondsSinceEpoch.toString()}.${_imageFile!.path.split('.').last}');
      UploadTask uploadTask = pressStorageReference.putFile(_imageFile!);

      uploadTask.whenComplete(() async {
        String url = await pressStorageReference.getDownloadURL();

        if (mounted) {
          saveStory(url);
        }
      }).catchError((onError) {
        setState(() {
          loading = false;
        });
        snackError(
          'An error occurred, try again',
          context,
        );
      });
    } on FirebaseException catch (e) {
      setState(() {
        loading = false;
      });
      snackError(
        'An error occurred, try again',
        context,
      );
    }
  }
}
