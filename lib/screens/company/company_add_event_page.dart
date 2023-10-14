import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';

import '../../src/helper_widgets.dart';
import '../../src/theme.dart';

class CompanyAddEventPage extends StatefulWidget {
  final String userId;
  final DocumentSnapshot userData;
  const CompanyAddEventPage(
      {super.key, required this.userId, required this.userData});

  @override
  State<CompanyAddEventPage> createState() => _CompanyAddEventPageState();
}

class _CompanyAddEventPageState extends State<CompanyAddEventPage> {
  final _formKey = GlobalKey<FormState>();
  String eventDescription = '';
  String eventTitle = '';
  String eventLink = '';
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
    DocumentReference ds =
        FirebaseFirestore.instance.collection('XEvents').doc();

    Map<String, dynamic> tasks = {
      'event_title': eventTitle,
      'event_image': url,
      'event_link': eventLink,
      'event_description': eventDescription,
      'event_id': ds.id,
      'event_poster': widget.userId,
      'event_clicks_count': 0,
      'event_date': Timestamp.fromDate(eventDate),
      'event_author': widget.userData['user_name'],
      'event_visibility': false,
      'event_visible_areas': FieldValue.arrayUnion(['-']),
      'event_interested_users': FieldValue.arrayUnion([widget.userId]),
      'event_posted_time': FieldValue.serverTimestamp(),
      'event_posted_mills': DateTime.now().millisecondsSinceEpoch,
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
              language == 'ro' ? 'Postează un eveniment' : 'Post an event',
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
                      decoration: inputDecoration(language == 'ro'
                          ? 'Titlul evenimentului'
                          : 'Event title'),
                      onChanged: (val) {
                        setState(() => eventTitle = val.trim());
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
                          ? 'Descrierea evenimentului'
                          : 'Event description'),
                      onChanged: (val) {
                        setState(() => eventDescription = val.trim());
                      },
                      validator: (value) => value!.length < 30
                          ? (language == 'ro'
                              ? 'Descrierea prea scurtă'
                              : 'Description too short')
                          : null,
                    ),
                    addVerticalSpace(20),
                    TextFormField(
                      controller: dateController,
                      decoration: inputDecorationWithIcon(
                        language == 'ro' ? 'Data evenimentului' : 'Event date',
                        CupertinoIcons.calendar,
                      ),
                      style: textFieldStyle(),
                      readOnly: true, // when true user cannot edit text
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2025),
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                primaryColor: TAppTheme
                                    .darkBlue, // Header background color
                                // accentColor: Colors.blue, // Selection color
                                buttonTheme: ButtonThemeData(
                                    textTheme: ButtonTextTheme
                                        .primary // OK/Cancel button text color
                                    ),
                                colorScheme: ColorScheme.light(
                                  primary: TAppTheme
                                      .darkBlue, // Used for the header background
                                  onPrimary: Colors.white, // Header text color
                                  surface: Colors.blue, // Calendar day color
                                  onSurface:
                                      Colors.black87, // Calendar text color
                                ),
                                dialogBackgroundColor: Colors
                                    .white, // Background color of the dialog
                              ),
                              child: child!,
                            );
                          },
                        );
                        // DateTime? pickedDate = await showDatePicker(
                        //     context: context,
                        //     initialDate: DateTime.now(),
                        //     firstDate: DateTime.now(),
                        //     lastDate: DateTime(2101));

                        if (pickedDate != null) {
                          String formattedDate =
                              DateFormat('dd MMM, yyyy').format(pickedDate);

                          setState(() {
                            dateController.text = formattedDate;
                            eventDate = pickedDate;
                          });
                        } else {
                          if (kDebugMode) {
                            print("Date is not selected.");
                          }
                        }
                      },
                      validator: (val) => val!.isNotEmpty
                          ? null
                          : (language == 'ro'
                              ? 'Introdu o dată validă'
                              : 'Enter a valid date'),
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
                      decoration: inputDecoration(
                          language == 'ro' ? 'Link eveniment' : 'Event link'),
                      onChanged: (val) {
                        setState(() => eventLink = val.trim());
                      },
                      validator: (value) => !Uri.parse(value!).isAbsolute
                          ? language == 'ro'
                              ? 'Introduceți un link valid'
                              : 'Enter a valid link'
                          : null,
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
        language == 'ro'
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
