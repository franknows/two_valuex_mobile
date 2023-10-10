import 'dart:io';

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

class CompanyAddAdPage extends StatefulWidget {
  final String userId;
  final DocumentSnapshot userData;
  const CompanyAddAdPage(
      {super.key, required this.userId, required this.userData});

  @override
  State<CompanyAddAdPage> createState() => _CompanyAddAdPageState();
}

class _CompanyAddAdPageState extends State<CompanyAddAdPage> {
  final _formKey = GlobalKey<FormState>();
  String description = '';
  String link = '';
  bool loading = false;
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  String selectedCta = 'Book Now';
  List<String> ctaList = [
    'Book Now',
    'Buy Now',
    'Contact Us',
    'Discover More',
    'Download Now',
    'Get Started',
    'Get the App',
    'Get Yours',
    'Join Now',
    'Learn More',
    'Register Now',
    'Request Quote',
    'Send Message',
    'Shop Now',
    'Sign Up',
    'Start Trial',
    'Subscribe Now',
    'Try For Free',
  ];

  void saveData(String url) {
    DocumentReference ds = FirebaseFirestore.instance.collection('XAds').doc();

    Map<String, dynamic> tasks = {
      'ad_image': url,
      'ad_link': link,
      'ad_description': description,
      'ad_id': ds.id,
      'ad_poster': widget.userId,
      'ad_clicks_count': 0,
      'ad_visibility': true,
      'ad_cta': selectedCta,
      'ad_visible_areas': FieldValue.arrayUnion(['-']),
      'ad_posted_time': FieldValue.serverTimestamp(),
      'ad_posted_mills': DateTime.now().millisecondsSinceEpoch,
    };

    ds.set(tasks).whenComplete(() {
      Navigator.pop(context);
    });
  }

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
            title: Text(
              widget.userData['user_language'] == 'ro'
                  ? 'Postați un anunț'
                  : 'Post an Ad',
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
                      decoration: inputDecoration(
                          widget.userData['user_language'] == 'ro'
                              ? 'Link de destinație'
                              : 'Destination link'),
                      onChanged: (val) {
                        setState(() => link = val.trim());
                      },
                      validator: (value) => !Uri.parse(value!).isAbsolute
                          ? 'Enter a valid link'
                          : null,
                    ),
                    addVerticalSpace(20),
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.text,
                      maxLength: 120,
                      maxLines: null,
                      style: GoogleFonts.quicksand(
                        textStyle: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          letterSpacing: .5,
                        ),
                      ),
                      decoration: inputDecoration(
                          widget.userData['user_language'] == 'ro'
                              ? 'Descriere'
                              : 'Description'),
                      onChanged: (val) {
                        setState(() => description = val.trim());
                      },
                      validator: (value) =>
                          value!.length < 30 ? ('Description too short') : null,
                    ),
                    addVerticalSpace(20),
                    DropdownButtonFormField(
                      isDense: true,
                      isExpanded: true,
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      dropdownColor: Colors.white,
                      value: selectedCta,
                      items: ctaList.map((region) {
                        return DropdownMenuItem(
                          value: region,
                          child: Text(
                            region,
                            style: GoogleFonts.quicksand(
                              textStyle: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                letterSpacing: .5,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCta = value!;
                        });
                      },
                      decoration: inputDecoration(
                        widget.userData['user_language'] == 'ro'
                            ? 'Selectați CTA'
                            : 'Select CTA',
                      ),
                    ),
                    addVerticalSpace(20),
                    const SizedBox(
                      height: 30.0,
                    ),
                    InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        buttonPressed(context);
                      },
                      child: simpleDarkRoundedButton(
                          widget.userData['user_language'] == 'ro'
                              ? 'Trimite'
                              : 'Submit'),
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
        widget.userData['user_language'] == 'ro'
            ? 'Vă rugăm să adăugați poza!'
            : 'Please add the picture!',
        context,
      );
      return;
    }
    if (!_formKey.currentState!.validate()) {
      setState(() {
        loading = false;
      });
      snackError(
        widget.userData['user_language'] == 'ro'
            ? 'Vă rugăm să completați totul!'
            : 'Please fill in everything!',
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
    final DateTime now = DateTime.now();
    final String year = DateFormat('yyyy').format(now);

    try {
      Reference pressStorageReference = FirebaseStorage.instance
          .ref()
          .child('Ads/$year/${now.millisecondsSinceEpoch.toString()}.jpg');
      UploadTask uploadTask = pressStorageReference.putFile(_imageFile!);

      uploadTask.whenComplete(() async {
        String url = await pressStorageReference.getDownloadURL();

        if (mounted) {
          saveData(url);
        }
      }).catchError((onError) {
        setState(() {
          loading = false;
        });
        snackError(
          widget.userData['user_language'] == 'ro'
              ? 'A apărut o eroare, încercați din nou!'
              : 'An error occurred, try again!',
          context,
        );
      });
    } on FirebaseException catch (e) {
      setState(() {
        loading = false;
      });
      snackError(
        widget.userData['user_language'] == 'ro'
            ? 'A apărut o eroare, încercați din nou!'
            : 'An error occurred, try again!',
        context,
      );
    }
  }
}
