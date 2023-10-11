import 'dart:io';

import 'package:chips_choice/chips_choice.dart';
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
import 'package:two_value/src/theme.dart';

import '../../src/helper_widgets.dart';

class AdminAddInterviewPage extends StatefulWidget {
  final String userId;
  final DocumentSnapshot userData;
  const AdminAddInterviewPage(
      {super.key, required this.userId, required this.userData});

  @override
  State<AdminAddInterviewPage> createState() => _AdminAddInterviewPageState();
}

class _AdminAddInterviewPageState extends State<AdminAddInterviewPage> {
  final _formKey = GlobalKey<FormState>();
  String language = '';
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _textController = TextEditingController();
  int mills = DateTime.now().millisecondsSinceEpoch;

  bool loading = false;
  String pressTitle = '';
  String pressSummary = '';
  String pressBody = '';
  File? _imageFile;
  final String _uploadedFileURL = '-';
  int? selectedOption;
  bool checkBoxValue = false;
  List<String> categories = [];
  final Map<String, Map<String, String>> categoryLabels = {
    'ro': {
      'CONSTRUCTIONS': 'CONSTRUCȚII',
      'EVENT': 'EVENIMENT',
      'TECH': 'TECH',
      'POLITICAL': 'POLITIC',
      'ECONOMIC': 'ECONOMIC',
      'HEALTH': 'SĂNĂTATE',
      'HOSPITALITY': 'HORECA',
      'LIFESTYLE': 'LIFESTYLE',
      'SOCIAL': 'SOCIAL',
    },
    'eng': {
      'CONSTRUCTIONS': 'CONSTRUCTIONS',
      'EVENT': 'EVENT',
      'TECH': 'TECH',
      'POLITICAL': 'POLITICAL',
      'ECONOMIC': 'ECONOMIC',
      'HEALTH': 'HEALTH',
      'HOSPITALITY': 'HOSPITALITY',
      'LIFESTYLE': 'LIFESTYLE',
      'SOCIAL': 'SOCIAL',
    },
  };

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _introController = TextEditingController();
  final TextEditingController _qnOneController = TextEditingController();
  final TextEditingController _qnTwoController = TextEditingController();
  final TextEditingController _qnThreeController = TextEditingController();
  final TextEditingController _qnFourController = TextEditingController();
  final TextEditingController _qnFiveController = TextEditingController();
  final TextEditingController _qnSixController = TextEditingController();
  final TextEditingController _companyDescController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  final TextEditingController _linkController =
      TextEditingController(text: '-');
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  int step = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      language = widget.userData['user_language'];
    });
    _titleController.addListener(() {
      setState(() {
        // This will trigger a rebuild every time the content changes.
      });
    });
    _introController.addListener(() {
      setState(() {
        // This will trigger a rebuild every time the content changes.
      });
    });
    _qnOneController.addListener(() {
      setState(() {
        // This will trigger a rebuild every time the content changes.
      });
    });
    _qnTwoController.addListener(() {
      setState(() {
        // This will trigger a rebuild every time the content changes.
      });
    });
    _qnThreeController.addListener(() {
      setState(() {
        // This will trigger a rebuild every time the content changes.
      });
    });
    _qnFourController.addListener(() {
      setState(() {
        // This will trigger a rebuild every time the content changes.
      });
    });
    _qnFiveController.addListener(() {
      setState(() {
        // This will trigger a rebuild every time the content changes.
      });
    });
    _qnSixController.addListener(() {
      setState(() {
        // This will trigger a rebuild every time the content changes.
      });
    });
    _companyDescController.addListener(() {
      setState(() {
        // This will trigger a rebuild every time the content changes.
      });
    });
    _authorController.addListener(() {
      setState(() {
        // This will trigger a rebuild every time the content changes.
      });
    });
    _tagsController.addListener(() {
      setState(() {
        // This will trigger a rebuild every time the content changes.
      });
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _introController.dispose();
    _qnOneController.dispose();
    _qnTwoController.dispose();
    _qnThreeController.dispose();
    _qnFourController.dispose();
    _qnFiveController.dispose();
    _qnSixController.dispose();
    _companyDescController.dispose();
    _tagsController.dispose();
    _linkController.dispose();
    _authorController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _uploadImage(BuildContext context) async {
    final DateTime now = DateTime.now();
    final String year = DateFormat('yyyy').format(now);

    try {
      Reference pressStorageReference = FirebaseStorage.instance.ref().child(
          'XArticles/Interviews/$year/${now.millisecondsSinceEpoch.toString()}.jpg');
      UploadTask uploadTask = pressStorageReference.putFile(_imageFile!);

      uploadTask.whenComplete(() async {
        String url = await pressStorageReference.getDownloadURL();

        if (mounted) {
          saveInterview(url);
        }
      }).catchError((onError) {
        setState(() {
          loading = false;
        });
        snackError(
          widget.userData['user_language'] == 'ro'
              ? 'A apărut o eroare, încercați din nou.'
              : 'An error occurred, try again',
          context,
        );
      });
    } on FirebaseException catch (e) {
      setState(() {
        loading = false;
      });
      snackError(
        widget.userData['user_language'] == 'ro'
            ? 'A apărut o eroare, încercați din nou.'
            : 'An error occurred, try again',
        context,
      );
    }
  }

  saveInterview(String url) {
    DocumentReference interviewRef = FirebaseFirestore.instance
        .collection('XArticles')
        .doc('Interviews')
        .collection('Dominant')
        .doc(widget.userId);
    Map<String, dynamic> prompt = {
      'interview_title': _titleController.text,
      'interview_category': FieldValue.arrayUnion(categories),
      'interview_summary': _introController.text,
      'interview_body_html': '-',
      'interview_body_plain_text': '-',
      'interview_about_company': _companyDescController.text,
      'interview_author': _authorController.text,
      'interview_image': url,
      'interview_time': FieldValue.serverTimestamp(),
      'interview_poster': widget.userId,
      'interview_poster_email': widget.userData['user_email'],
      'interview_linked_url': _linkController.text,
      //'interview_loop_status': checkedValue ? '1' : '2',
      'interview_loop_status': '2',
      'interview_status': '-',
      'interview_editing_user': '-',
      'interview_journalist_editor': '-',
      'interview_journalist_email': '-',
      'interview_2value_editor': '-',
      'interview_2value_editor_email': '-',
      'interview_rejected_count': 0,
      'interview_search_keywords': FieldValue.arrayUnion(categories),
      'interview_tags': FieldValue.arrayUnion(categories),
      'interview_id': interviewRef.id,
      'interview_action_title': '-',
      'interview_stats_sent': false,
      'interview_journalist_take_over_time': FieldValue.serverTimestamp(),
      'interview_company_can_chat': true,
      'interview_journalist_can_chat': true,

      ///Analytics data
      'interview_views_count': 0,
      'interview_unique_views_count': 0,
      'interview_total_share_count': 0,
      'interview_facebook_share_count': 0,
      'interview_linkedIn_share_count': 0,
      'interview_twitter_share_count': 0,
      'interview_whatsApp_share_count': 0,
      'interview_other_share_count': 0,
      'interview_email_notifications_sent': 0,
      'interview_emails_open_count': 0,
      'interview_comments_count': 0,
      'interview_extra': '-',

      ///************* SOLVING ABEID'S ERRORS *************

      'interview_qn_one': _qnOneController.text,
      'interview_qn_two': _qnTwoController.text,
      'interview_qn_three': _qnThreeController.text,
      'interview_qn_four': _qnFourController.text,
      'interview_qn_five': _qnFiveController.text,
      'interview_qn_six': _qnSixController.text,
    };
    interviewRef.set(prompt, SetOptions(merge: true)).then((value) {
      setState(() {
        loading = false;
      });
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
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
            title: Text(
              language == 'ro' ? 'Interviu' : 'Interview',
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///press title
                    step == 0
                        ? Column(
                            children: [
                              leftInstructor(
                                  width,
                                  'assets/personas/first_male.png',
                                  language == 'ro'
                                      ? 'Iată titlul interviului dvs. (cel puțin 10 cuvinte)'
                                      : 'Here goes the title of your interview (est. 10 words)'),
                              addVerticalSpace(20.0),
                              CustomTextFormField(
                                labelText: language == 'ro'
                                    ? 'Titlul interviului'
                                    : 'Interview title',
                                hintText: "",
                                controller: _titleController,
                                keyboardType: TextInputType.multiline,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return (language == 'ro'
                                        ? 'Prea scurt'
                                        : 'Too short');
                                  }
                                  return null;
                                },
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),

                    ///press title
                    step == 1
                        ? Column(
                            children: [
                              rightInstructor(
                                  width,
                                  language == 'ro'
                                      ? 'Cine? Ce? Cum? Unde? Când? Evidențiază un interes pentru publicul larg (est. 80 cuvinte)'
                                      : 'Who? What? How? Where? When? Highlight the interest for the general public (est. 80 words)'),
                              addVerticalSpace(20.0),
                              CustomTextFormField(
                                labelText: language == 'ro'
                                    ? 'Introducere interviu'
                                    : 'Interview introduction',
                                hintText: "",
                                controller: _introController,
                                keyboardType: TextInputType.multiline,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return (language == 'ro'
                                        ? 'Prea scurt'
                                        : 'Too short');
                                  }
                                  return null;
                                },
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),

                    ///interview categories
                    step == 2
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              leftInstructor(
                                  width,
                                  'assets/personas/sixth_male.png',
                                  language == 'ro'
                                      ? 'Selectați categoria interviului'
                                      : 'Select the category of the interview'),
                              addVerticalSpace(20.0),
                              ChipsChoice<String>.multiple(
                                value: categories,
                                onChanged: (val) {
                                  setState(() {
                                    categories = val;
                                  });
                                },
                                choiceItems: C2Choice.listFrom<String, String>(
                                  source:
                                      categoryLabels[language]!.keys.toList(),
                                  value: (i, v) => v,
                                  label: (i, v) =>
                                      categoryLabels[language]![v]!,
                                ),
                                choiceBuilder: (item, index) {
                                  return ChoiceChip(
                                    label: categories.contains(item.value)
                                        ? whiteChipText(item.label!)
                                        : blackChipText(item.label!),
                                    selected: categories.contains(item.value),
                                    onSelected: (selected) {
                                      setState(() {
                                        if (selected) {
                                          categories.add(item.value!);
                                        } else {
                                          categories.remove(item.value);
                                        }
                                      });
                                    },
                                    selectedColor: Colors
                                        .blueGrey, // The background color for selected items
                                    backgroundColor: Colors.grey[
                                        200], // The background color for non-selected items
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                  );
                                },
                                wrapped: true,
                                wrapCrossAlignment: WrapCrossAlignment.start,
                                alignment: WrapAlignment.start,
                                runAlignment: WrapAlignment.start,
                                padding: EdgeInsets.zero,
                                spacing: 10,
                                runSpacing: 0,
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),

                    ///question one
                    step == 3
                        ? Column(
                            children: [
                              rightInstructor(
                                width,
                                language == 'ro'
                                    ? 'Cum ți-a venit ideea de afacere?'
                                    : 'How did you come up with the business idea?',
                              ),
                              addVerticalSpace(20.0),
                              CustomTextFormField(
                                labelText:
                                    language == 'ro' ? 'Raspuns' : 'Response',
                                hintText: "",
                                controller: _qnOneController,
                                keyboardType: TextInputType.multiline,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return (language == 'ro'
                                        ? 'Prea scurt'
                                        : 'Too short');
                                  }
                                  return null;
                                },
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),

                    ///question two
                    step == 4
                        ? Column(
                            children: [
                              rightInstructor(
                                width,
                                language == 'ro'
                                    ? 'Cum ai dezvoltat afacerea/proiectul?'
                                    : 'How did you develop your business/project?',
                              ),
                              addVerticalSpace(20.0),
                              CustomTextFormField(
                                labelText:
                                    language == 'ro' ? 'Raspuns' : 'Response',
                                hintText: "",
                                controller: _qnTwoController,
                                keyboardType: TextInputType.multiline,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return (language == 'ro'
                                        ? 'Prea scurt'
                                        : 'Too short');
                                  }
                                  return null;
                                },
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),

                    ///question three
                    step == 5
                        ? Column(
                            children: [
                              rightInstructor(
                                width,
                                language == 'ro'
                                    ? 'Cum ai finanțat afacerea/proiectul?'
                                    : 'How did you finance the business/project?',
                              ),
                              addVerticalSpace(20.0),
                              CustomTextFormField(
                                labelText:
                                    language == 'ro' ? 'Raspuns' : 'Response',
                                hintText: "",
                                controller: _qnThreeController,
                                keyboardType: TextInputType.multiline,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return (language == 'ro'
                                        ? 'Prea scurt'
                                        : 'Too short');
                                  }
                                  return null;
                                },
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),

                    ///question four
                    step == 6
                        ? Column(
                            children: [
                              rightInstructor(
                                width,
                                language == 'ro'
                                    ? 'Ce cifră de afaceri ai atins?'
                                    : 'What turnover did you reach?',
                              ),
                              addVerticalSpace(20.0),
                              CustomTextFormField(
                                labelText:
                                    language == 'ro' ? 'Raspuns' : 'Response',
                                hintText: "",
                                controller: _qnFourController,
                                keyboardType: TextInputType.multiline,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return (language == 'ro'
                                        ? 'Prea scurt'
                                        : 'Too short');
                                  }
                                  return null;
                                },
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),

                    ///question five
                    step == 7
                        ? Column(
                            children: [
                              rightInstructor(
                                width,
                                language == 'ro'
                                    ? 'Care sunt principalele provocări?'
                                    : 'What are the main challenges?',
                              ),
                              addVerticalSpace(20.0),
                              CustomTextFormField(
                                labelText:
                                    language == 'ro' ? 'Raspuns' : 'Response',
                                hintText: "",
                                controller: _qnFiveController,
                                keyboardType: TextInputType.multiline,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return (language == 'ro'
                                        ? 'Prea scurt'
                                        : 'Too short');
                                  }
                                  return null;
                                },
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),

                    ///question six
                    step == 8
                        ? Column(
                            children: [
                              rightInstructor(
                                width,
                                language == 'ro'
                                    ? 'Care sunt previziunile de business?'
                                    : 'What are the business forecasts?',
                              ),
                              addVerticalSpace(20.0),
                              CustomTextFormField(
                                labelText:
                                    language == 'ro' ? 'Raspuns' : 'Response',
                                hintText: "",
                                controller: _qnSixController,
                                keyboardType: TextInputType.multiline,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return (language == 'ro'
                                        ? 'Prea scurt'
                                        : 'Too short');
                                  }
                                  return null;
                                },
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),

                    ///about company
                    step == 9
                        ? Column(
                            children: [
                              rightInstructor(
                                width,
                                language == 'ro'
                                    ? 'O scurtă prezentare a companiei (est. 80 cuvinte)'
                                    : 'A brief introduction of the company (est. 80 words)',
                              ),
                              addVerticalSpace(20.0),
                              CustomTextFormField(
                                labelText: language == 'ro'
                                    ? 'Despre companie'
                                    : 'About company',
                                hintText: "",
                                controller: _companyDescController,
                                keyboardType: TextInputType.multiline,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return (language == 'ro'
                                        ? 'Prea scurt'
                                        : 'Too short');
                                  }
                                  return null;
                                },
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),

                    ///author name
                    step == 10
                        ? Column(
                            children: [
                              rightInstructor(
                                width,
                                language == 'ro'
                                    ? 'Aici este numele autorului interviului (est. 2 cuvinte)'
                                    : 'Here goes the name author of the interview (est. 2 words)',
                              ),
                              addVerticalSpace(20.0),
                              CustomTextFormField(
                                labelText: language == 'ro'
                                    ? 'Numele autorului'
                                    : 'Name of the author',
                                hintText: "",
                                controller: _authorController,
                                keyboardType: TextInputType.multiline,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return (language == 'ro'
                                        ? 'Prea scurt'
                                        : 'Too short');
                                  }
                                  return null;
                                },
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),

                    ///tags
                    step == 11
                        ? Column(
                            children: [
                              rightInstructor(
                                width,
                                language == 'ro'
                                    ? 'Iată etichetele relevante pentru interviu. Etichetele ajută la afișarea interviului în rezultatele căutării (de aproximativ 4 etichete).'
                                    : 'Here goes the relevant tags for the interview. Tags help to show the interview in search results (est. 4 tags).',
                              ),
                              addVerticalSpace(20.0),
                              CustomTextFormField(
                                labelText: language == 'ro'
                                    ? 'Etichete relevante'
                                    : 'Relevant tags',
                                hintText: "",
                                controller: _tagsController,
                                keyboardType: TextInputType.multiline,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return (language == 'ro'
                                        ? 'Prea scurt'
                                        : 'Too short');
                                  }
                                  return null;
                                },
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),

                    ///image
                    step == 12
                        ? Column(
                            children: [
                              rightInstructor(
                                width,
                                language == 'Romanian'
                                    ? 'Imaginea care va fi prezentată pentru interviu. Se recomandă o imagine de înaltă calitate'
                                    : 'The image that shall be featured for the interview. A high-quality image is recommended',
                              ),
                              addVerticalSpace(20.0),
                              Center(
                                child: AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: Container(
                                    //height: 160.0,
                                    width: double.infinity,
                                    child: InkWell(
                                      child: _imageFile == null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              child: const Image(
                                                image: AssetImage(
                                                  'assets/images/place_holder.png',
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              child: Image(
                                                image: FileImage(_imageFile!),
                                                fit: BoxFit.cover,
                                                //child: Text('Select Image'),
                                              ),
                                            ),
                                      onTap: () {
                                        getImage();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),

                    ///link
                    step == 13
                        ? Column(
                            children: [
                              rightInstructor(
                                  width,
                                  language == 'ro'
                                      ? 'Aici puteți adăuga opțional un link către un videoclip sau conținut similar pentru a susține interviul. (optional)'
                                      : 'Here you can optionally add a link you a video or related content to support the interview. (optional)'),
                              addVerticalSpace(20.0),
                              CustomTextFormField(
                                labelText: language == 'ro'
                                    ? 'Link suplimentar'
                                    : 'Additional link',
                                hintText: "",
                                controller: _linkController,
                                keyboardType: TextInputType.multiline,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return (language == 'ro'
                                        ? 'Prea scurt'
                                        : 'Too short');
                                  }
                                  return null;
                                },
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),

                    addVerticalSpace(30.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        step == 0
                            ? SizedBox.shrink()
                            : InkWell(
                                onTap: () {
                                  setState(() {
                                    step = step - 1;
                                  });
                                },
                                child: previousButton(
                                  language == 'ro' ? 'Anterior' : 'Previous',
                                ),
                              ),
                        step == 13
                            ? SizedBox.shrink()
                            : InkWell(
                                onTap: () {
                                  if (step == 0) {
                                    if (_titleController.text.isEmpty) {
                                      snackError(
                                          language == 'ro'
                                              ? 'Completați titlul!'
                                              : 'Fill the title!',
                                          context);
                                    } else {
                                      setState(() {
                                        step = step + 1;
                                      });
                                    }
                                  } else if (step == 1) {
                                    if (_introController.text.isEmpty) {
                                      snackError(
                                          language == 'ro'
                                              ? 'Completați introducerea!'
                                              : 'Fill the introduction!',
                                          context);
                                    } else {
                                      setState(() {
                                        step = step + 1;
                                      });
                                    }
                                  } else if (step == 2) {
                                    print('here0');
                                    if (categories.isEmpty) {
                                      snackError(
                                          language == 'ro'
                                              ? 'Selectați măcar o categorie!'
                                              : 'Select at least one category!',
                                          context);
                                    } else {
                                      setState(() {
                                        step = step + 1;
                                      });
                                    }
                                  } else if (step == 3) {
                                    if (_qnOneController.text.isEmpty) {
                                      snackError(
                                          language == 'ro'
                                              ? 'Vă rugăm să completați un răspuns!'
                                              : 'Please fill in an answer!',
                                          context);
                                    } else {
                                      setState(() {
                                        step = step + 1;
                                      });
                                    }
                                  } else if (step == 4) {
                                    if (_qnTwoController.text.isEmpty) {
                                      snackError(
                                          language == 'ro'
                                              ? 'Vă rugăm să completați un răspuns!'
                                              : 'Please fill in an answer!',
                                          context);
                                    } else {
                                      setState(() {
                                        step = step + 1;
                                      });
                                    }
                                  } else if (step == 5) {
                                    if (_qnThreeController.text.isEmpty) {
                                      snackError(
                                          language == 'ro'
                                              ? 'Vă rugăm să completați un răspuns!'
                                              : 'Please fill in an answer!',
                                          context);
                                    } else {
                                      setState(() {
                                        step = step + 1;
                                      });
                                    }
                                  } else if (step == 6) {
                                    if (_qnFourController.text.isEmpty) {
                                      snackError(
                                          language == 'ro'
                                              ? 'Vă rugăm să completați un răspuns!'
                                              : 'Please fill in an answer!',
                                          context);
                                    } else {
                                      setState(() {
                                        step = step + 1;
                                      });
                                    }
                                  } else if (step == 7) {
                                    if (_qnFiveController.text.isEmpty) {
                                      snackError(
                                          language == 'ro'
                                              ? 'Vă rugăm să completați un răspuns!'
                                              : 'Please fill in an answer!',
                                          context);
                                    } else {
                                      setState(() {
                                        step = step + 1;
                                      });
                                    }
                                  } else if (step == 8) {
                                    if (_qnSixController.text.isEmpty) {
                                      snackError(
                                          language == 'ro'
                                              ? 'Vă rugăm să completați un răspuns!'
                                              : 'Please fill in an answer!',
                                          context);
                                    } else {
                                      setState(() {
                                        step = step + 1;
                                      });
                                    }
                                  } else if (step == 9) {
                                    if (_companyDescController.text.isEmpty) {
                                      snackError(
                                          language == 'ro'
                                              ? 'Vă rugăm să completați o descriere!'
                                              : 'Please fill in a description!',
                                          context);
                                    } else {
                                      setState(() {
                                        step = step + 1;
                                      });
                                    }
                                  } else if (step == 10) {
                                    if (_authorController.text.isEmpty) {
                                      snackError(
                                          language == 'ro'
                                              ? 'Vă rugăm să completați un nume!'
                                              : 'Please fill in a name!',
                                          context);
                                    } else {
                                      setState(() {
                                        step = step + 1;
                                      });
                                    }
                                  } else if (step == 11) {
                                    if (_tagsController.text.isEmpty) {
                                      snackError(
                                          language == 'ro'
                                              ? 'Vă rugăm să completați câmpul!'
                                              : 'Please fill in the field!',
                                          context);
                                    } else {
                                      setState(() {
                                        step = step + 1;
                                      });
                                    }
                                  } else if (step == 12) {
                                    if (_imageFile == null) {
                                      snackError(
                                          language == 'ro'
                                              ? 'Vă rugăm să selectați o imagine!'
                                              : 'Please select an image!',
                                          context);
                                    } else {
                                      setState(() {
                                        step = step + 1;
                                      });
                                    }
                                  }
                                },
                                child: nextButton(
                                  language == 'ro' ? 'Următorul' : 'Next',
                                ),
                              ),
                      ],
                    ),
                    addVerticalSpace(30.0),
                    greyNormalText(
                        language == 'ro' ? 'Previzualizare:' : 'Preview:'),
                    const Divider(),

                    ///preview
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.teal.withOpacity(.03),
                        border: Border.all(
                          color: Colors.teal.withOpacity(.1),
                          width: 0.5,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            addVerticalSpace(10),
                            blackBoldTextWithSize(
                                _titleController.text.trim(), 16),
                            addVerticalSpace(4.0),
                            _authorController.text.trim().isNotEmpty
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.person_rounded,
                                            color:
                                                Colors.blueGrey.withOpacity(.5),
                                            size: 14,
                                          ),
                                          addHorizontalSpace(10),
                                          Text(
                                            capitalize(
                                                _authorController.text.trim()),
                                            style: GoogleFonts.quicksand(
                                              fontSize: 12,
                                              color: Colors.blueGrey
                                                  .withOpacity(.5),
                                              letterSpacing: .5,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        DateFormat('dd MMM, yyyy').format(
                                          DateTime.now(),
                                        ),
                                        style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                            fontSize: 12.0,
                                            color:
                                                Colors.blueGrey.withOpacity(.5),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                            addVerticalSpace(4.0),
                            greyNormalText(_introController.text.trim()),
                            _imageFile == null
                                ? Container()
                                : Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Center(
                                      child: AspectRatio(
                                        aspectRatio: 16 / 9,
                                        child: Container(
                                          //height: 160.0,
                                          width: double.infinity,
                                          child: InkWell(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              child: Image(
                                                image: FileImage(_imageFile!),
                                                fit: BoxFit.cover,
                                                //child: Text('Select Image'),
                                              ),
                                            ),
                                            onTap: () {
                                              getImage();
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                            addVerticalSpace(10.0),
                            Wrap(
                              spacing: 10.0, // gap between adjacent chips
                              runSpacing: 6.0, // gap between lines
                              children: List<Widget>.generate(
                                categories.length,
                                (int index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color:
                                          TAppTheme.greenColor.withOpacity(.2),
                                      border: Border.all(
                                        color: TAppTheme.greenColor
                                            .withOpacity(.2),
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5.0),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 3),
                                      child: miniGreenText(categories[index]),
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                            _qnOneController.text.trim().toString().isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10.0,
                                    ),
                                    child: blackBoldText(
                                      language == 'ro'
                                          ? 'Cum ți-a venit ideea de afacere?'
                                          : 'How did you come up with the business idea?',
                                    ),
                                  )
                                : Container(),
                            addVerticalSpace(2.0),
                            blackNormalText(_qnOneController.text.trim()),

                            ///question two
                            addVerticalSpace(10.0),
                            _qnTwoController.text.trim().toString().isEmpty
                                ? Container()
                                : blackBoldText(
                                    language == 'ro'
                                        ? 'Cum ai dezvoltat afacerea/proiectul?'
                                        : 'How did you develop your business/project?',
                                  ),
                            addVerticalSpace(2.0),
                            blackNormalText(_qnTwoController.text.trim()),

                            ///question three
                            addVerticalSpace(10.0),
                            _qnThreeController.text.trim().toString().isEmpty
                                ? Container()
                                : blackBoldText(
                                    language == 'ro'
                                        ? 'Cum ai finanțat afacerea/proiectul?'
                                        : 'How did you finance the business/project?',
                                  ),
                            addVerticalSpace(2.0),
                            blackNormalText(_qnThreeController.text.trim()),

                            ///question four
                            addVerticalSpace(10.0),
                            _qnFourController.text.trim().toString().isEmpty
                                ? Container()
                                : blackBoldText(
                                    language == 'ro'
                                        ? 'Ce cifră de afaceri ai atins?'
                                        : 'What turnover did you reach?',
                                  ),
                            addVerticalSpace(2.0),
                            blackNormalText(_qnFourController.text.trim()),

                            ///question five
                            addVerticalSpace(10.0),
                            _qnFiveController.text.trim().toString().isEmpty
                                ? Container()
                                : blackBoldText(
                                    language == 'ro'
                                        ? 'Care sunt principalele provocări?'
                                        : 'What are the main challenges?',
                                  ),
                            addVerticalSpace(2.0),
                            blackNormalText(_qnFiveController.text.trim()),

                            ///question six
                            addVerticalSpace(10.0),
                            _qnSixController.text.trim().toString().isEmpty
                                ? Container()
                                : blackBoldText(
                                    language == 'ro'
                                        ? 'Care sunt previziunile de business?'
                                        : 'What are the business forecasts?',
                                  ),
                            addVerticalSpace(2.0),
                            blackNormalText(_qnSixController.text.trim()),

                            addVerticalSpace(16.0),
                            _companyDescController.text
                                    .trim()
                                    .toString()
                                    .isEmpty
                                ? Container()
                                : blackBoldText(language == 'ro'
                                    ? 'Despre companie'
                                    : 'About company'),
                            addVerticalSpace(2.0),
                            blackNormalText(_companyDescController.text.trim()),
                          ],
                        ),
                      ),
                    ),

                    ///submit button
                    addVerticalSpace(40),
                    InkWell(
                        onTap: () {
                          submitPressed();
                        },
                        child: simpleDarkRoundedButton('Submit')),
                    addVerticalSpace(60),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  submitPressed() {
    FocusScope.of(context).unfocus();

    if (_imageFile != null) {
      setState(() {
        loading = true;
      });
      _uploadImage(context);
    } else {
      loading = false;
      snackError(
          widget.userData['user_language'] == 'ro'
              ? 'Te rugăm să completezi toate câmpurile!'
              : 'Please fill everything',
          context);
    }
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
}
