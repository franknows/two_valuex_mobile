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

class AdminAddJobPage extends StatefulWidget {
  final String userId;
  final DocumentSnapshot userData;
  const AdminAddJobPage(
      {super.key, required this.userId, required this.userData});

  @override
  State<AdminAddJobPage> createState() => _AdminAddJobPageState();
}

class _AdminAddJobPageState extends State<AdminAddJobPage> {
  final _formKey = GlobalKey<FormState>();
  String jobDescription = '';
  String employerName = '';
  String jobTitle = '';
  String jobLink = '';
  bool loading = false;
  final ImagePicker _picker = ImagePicker();
  TextEditingController dateController = TextEditingController();
  DateTime eventDate = DateTime.now();
  File? _imageFile;
  String language = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      language = widget.userData['user_language'];
    });
  }

  void saveData(String url) {
    DocumentReference ds = FirebaseFirestore.instance.collection('XJobs').doc();

    Map<String, dynamic> tasks = {
      'job_title': jobTitle.trim(),
      'job_employer_logo': url,
      'job_employer_name': employerName.trim(),
      'job_application_link': jobLink.trim(),
      'job_description': jobDescription.trim(),
      'job_id': ds.id,
      'job_poster': widget.userId,
      'job_clicks_count': 0,
      'job_poster_name': widget.userData['user_name'],
      'job_visibility': true,
      'job_visible_areas': FieldValue.arrayUnion(['-']),
      'job_interested_users': FieldValue.arrayUnion([widget.userId]),
      'job_posted_time': FieldValue.serverTimestamp(),
      'job_posted_mills': DateTime.now().millisecondsSinceEpoch,
      'job_extra': '-',
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
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                CupertinoIcons.hourglass,
                color: Colors.white,
                size: 14,
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
              language == 'ro' ? 'Posteaza un loc de munca' : 'Post a job',
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    addVerticalSpace(20),
                    GestureDetector(
                        onTap: () {
                          getImage();
                        },
                        child: ClipOval(
                          child: Image(
                            width: 200,
                            height: 200,
                            image: _imageFile == null
                                ? const AssetImage(
                                    'assets/images/logo_placeholder.png',
                                  )
                                : FileImage(_imageFile!) as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        )),
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
                      decoration: inputDecoration(language == 'ro'
                          ? 'Numele angajatorului'
                          : 'Employer name'),
                      onChanged: (val) {
                        setState(() => employerName = val.trim());
                      },
                      validator: (value) => value!.isEmpty
                          ? language == 'ro'
                              ? 'Introduceți un nume valid'
                              : 'Enter a valid name'
                          : null,
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
                      decoration: inputDecoration(language == 'ro'
                          ? 'Denumirea funcției'
                          : 'Job title'),
                      onChanged: (val) {
                        setState(() => jobTitle = val.trim());
                      },
                      validator: (value) => value!.isEmpty
                          ? language == 'ro'
                              ? 'Introduceți un titlu valid'
                              : 'Enter a valid title'
                          : null,
                    ),
                    addVerticalSpace(20),
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.text,
                      // maxLength: 120,
                      maxLines: null,
                      style: GoogleFonts.quicksand(
                        textStyle: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          letterSpacing: .5,
                        ),
                      ),
                      decoration: inputDecoration(language == 'ro'
                          ? 'Descrierea postului'
                          : 'Job description'),
                      onChanged: (val) {
                        setState(() => jobDescription = val.trim());
                      },
                      validator: (value) => value!.length < 30
                          ? (language == 'ro'
                              ? 'Descrierea prea scurtă'
                              : 'Description too short')
                          : null,
                    ),
                    addVerticalSpace(20),
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.text,
                      // maxLength: 120,
                      maxLines: null,
                      style: GoogleFonts.quicksand(
                        textStyle: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          letterSpacing: .5,
                        ),
                      ),
                      decoration: inputDecoration(language == 'ro'
                          ? 'Link pentru a aplica'
                          : 'Link to apply'),
                      onChanged: (val) {
                        setState(() => jobLink = val.trim());
                      },
                      validator: (value) => !Uri.parse(value!).isAbsolute
                          ? language == 'ro'
                              ? 'Introduceți un link valid'
                              : 'Enter a valid link'
                          : null,
                    ),
                    addVerticalSpace(20),
                    addVerticalSpace(30),
                    InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        buttonPressed(context);
                      },
                      child: simpleDarkRoundedButton(
                          language == 'ro' ? 'Trimite' : 'Submit'),
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
          ratioX: 1,
          ratioY: 1,
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
        language == 'ro'
            ? 'Vă rugăm să adăugați sigla!'
            : 'Please add the logo!',
        context,
      );
      return;
    }
    if (!_formKey.currentState!.validate()) {
      setState(() {
        loading = false;
      });
      snackError(
        language == 'ro'
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
          .child('XJobs/$year/${now.millisecondsSinceEpoch.toString()}.jpg');
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
          language == 'ro'
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
        language == 'ro'
            ? 'A apărut o eroare, încercați din nou!'
            : 'An error occurred, try again!',
        context,
      );
    }
  }
}
