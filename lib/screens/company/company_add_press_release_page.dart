import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:two_value/src/theme.dart';

import '../../src/helper_widgets.dart';

class CompanyAddPressReleasePage extends StatefulWidget {
  final String userId;
  final DocumentSnapshot userData;
  const CompanyAddPressReleasePage(
      {super.key, required this.userId, required this.userData});

  @override
  State<CompanyAddPressReleasePage> createState() =>
      _CompanyAddPressReleasePageState();
}

class _CompanyAddPressReleasePageState
    extends State<CompanyAddPressReleasePage> {
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
  String _uploadedFileURL = '-';
  int? selectedOption;
  bool checkBoxValue = false;
  List<String> tags = [];
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
  final TextEditingController _bodyController = TextEditingController();
  final TextEditingController _companyDescController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  FocusNode _focusNodeField1 = FocusNode();
  FocusNode _focusNodeField2 = FocusNode();
  FocusNode _focusNodeField3 = FocusNode();
  FocusNode _focusNodeField4 = FocusNode();
  FocusNode _focusNodeField5 = FocusNode();
  FocusNode _focusNodeField6 = FocusNode();
  FocusNode _focusNodeField7 = FocusNode();
  FocusNode _focusNodeField10 = FocusNode();

  int focusedField = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      language = widget.userData['user_language'];
    });
    _focusNodeField1.addListener(() {
      if (_focusNodeField1.hasFocus) {
        setState(() {
          focusedField = 1;
        });
      }
    });

    _focusNodeField2.addListener(() {
      if (_focusNodeField2.hasFocus) {
        setState(() {
          focusedField = 2;
        });
      }
    });

    _focusNodeField3.addListener(() {
      if (_focusNodeField3.hasFocus) {
        setState(() {
          focusedField = 3;
        });
      }
    });

    _focusNodeField4.addListener(() {
      if (_focusNodeField4.hasFocus) {
        setState(() {
          focusedField = 4;
        });
      }
    });

    _focusNodeField5.addListener(() {
      if (_focusNodeField5.hasFocus) {
        setState(() {
          focusedField = 5;
        });
      }
    });

    _focusNodeField6.addListener(() {
      if (_focusNodeField6.hasFocus) {
        setState(() {
          focusedField = 6;
        });
      }
    });

    _focusNodeField7.addListener(() {
      if (_focusNodeField7.hasFocus) {
        setState(() {
          focusedField = 7;
        });
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _introController.dispose();
    _bodyController.dispose();
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
          'Articles/Presses/$year/${now.millisecondsSinceEpoch.toString()}.jpg');
      UploadTask uploadTask = pressStorageReference.putFile(_imageFile!);

      uploadTask.whenComplete(() async {
        String url = await pressStorageReference.getDownloadURL();

        if (mounted) {
          savePress(url);
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

  savePress(String url) {
    DocumentReference customerMsgRef = FirebaseFirestore.instance
        .collection('Articles')
        .doc('Presses')
        .collection('Dominant')
        .doc(widget.userId);
    Map<String, dynamic> prompt = {
      'press_title': _titleController.text,
      'image_prompt': _imageController.text,
      'press_category': FieldValue.arrayUnion(tags),
      'press_summary': pressSummary,
      'press_body_html': pressBody,
      'press_body_plain_text': pressBody,
      'press_about_company': _companyDescController.text,
      'press_author': _authorController.text,
      'press_image': _uploadedFileURL,
      'press_time': FieldValue.serverTimestamp(),
      'press_poster': widget.userId,
      'press_poster_email': widget.userData['user_email'],
      'press_linked_url': _linkController.text,
      //'press_loop_status': checkedValue ? '1' : '2',
      'press_loop_status': '2',
      'press_status': '-',
      'press_editing_user': '-',
      'press_journalist_editor': '-',
      'press_journalist_email': '-',
      'press_2value_editor': '-',
      'press_2value_editor_email': '-',
      'press_rejected_count': 0,
      'press_search_keywords': FieldValue.arrayUnion(tags),
      'press_tags': FieldValue.arrayUnion(_tagsController.text.split(',')),
      'press_id': customerMsgRef.id,
      'press_action_title': '-',
      'press_stats_sent': false,
      'press_journalist_take_over_time': 0,
      'press_company_can_chat': true,
      'press_journalist_can_chat': true,

      ///Analytics data
      'press_views_count': 0,
      'press_unique_views_count': 0,
      'press_total_share_count': 0,
      'press_facebook_share_count': 0,
      'press_linkedIn_share_count': 0,
      'press_twitter_share_count': 0,
      'press_whatsApp_share_count': 0,
      'press_other_share_count': 0,
      'press_email_notifications_sent': 0,
      'press_emails_open_count': 0,
      'press_comments_count': 0,
      'press_extra': '-',
    };
    customerMsgRef.set(prompt, SetOptions(merge: true));
  }

  saveRevisionPress(String url) {
    DocumentReference customerMsgRef = FirebaseFirestore.instance
        .collection('Articles')
        .doc('Presses')
        .collection('Revisions')
        .doc(widget.userId);
    Map<String, dynamic> prompt = {
      'press_title': _titleController.text,
      'image_prompt': _imageController.text,
      'press_category': FieldValue.arrayUnion(tags),
      'press_summary': pressSummary,
      'press_body_html': pressBody,
      'press_body_plain_text': pressBody,
      'press_about_company': _companyDescController.text,
      'press_author': _authorController.text,
      'press_image': _uploadedFileURL,
      'press_time': FieldValue.serverTimestamp(),
      'press_poster': widget.userId,
      'press_poster_email': widget.userData['user_email'],
      'press_linked_url': _linkController.text,
      //'press_loop_status': checkedValue ? '1' : '2',
      'press_loop_status': '2',
      'press_status': '-',
      'press_editing_user': '-',
      'press_journalist_editor': '-',
      'press_journalist_email': '-',
      'press_2value_editor': '-',
      'press_2value_editor_email': '-',
      'press_rejected_count': 0,
      'press_search_keywords': FieldValue.arrayUnion(tags),
      'press_tags': FieldValue.arrayUnion(_tagsController.text.split(',')),
      'press_id': customerMsgRef.id,
      'press_action_title': '-',
      'press_stats_sent': false,
      'press_journalist_take_over_time': 0,
      'press_company_can_chat': true,
      'press_journalist_can_chat': true,

      ///Analytics data
      'press_views_count': 0,
      'press_unique_views_count': 0,
      'press_total_share_count': 0,
      'press_facebook_share_count': 0,
      'press_linkedIn_share_count': 0,
      'press_twitter_share_count': 0,
      'press_whatsApp_share_count': 0,
      'press_other_share_count': 0,
      'press_email_notifications_sent': 0,
      'press_emails_open_count': 0,
      'press_comments_count': 0,
      'press_extra': '-',
    };
    customerMsgRef.set(prompt, SetOptions(merge: true));
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
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: TAppTheme.primaryColor,
          elevation: 4,
          title: Text(
            language == 'ro' ? 'Comunicat de presă' : 'Press release',
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
                  focusedField == 1
                      ? Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Image(
                                image: AssetImage(
                                    'assets/personas/first_male.png'),
                                height: 60,
                                width: 60,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 28.0),
                                child: ChatBubble(
                                  clipper: ChatBubbleClipper3(
                                    type: BubbleType.receiverBubble,
                                  ),
                                  backGroundColor: const Color(0xffd7dde9),
                                  elevation: 1.0,
                                  shadowColor: Colors.grey,
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.68,
                                    child: DefaultTextStyle(
                                      style: GoogleFonts.quicksand(
                                        color: Colors.black87,
                                        fontSize: 14,
                                        letterSpacing: .5,
                                      ),
                                      textAlign: TextAlign.center,
                                      child: AnimatedTextKit(
                                        animatedTexts: [
                                          TypewriterAnimatedText(
                                            language == 'ro'
                                                ? 'Să începem cu titlul. Iată titlul comunicatului de presă (est. 10 cuvinte)'
                                                : 'Let us start with the title. Here goes the title of the press release (est. 10 words)',
                                            textAlign: TextAlign.start,
                                            speed: const Duration(
                                              milliseconds: 80,
                                            ),
                                            textStyle: GoogleFonts.quicksand(
                                              fontSize: 14,
                                              color: Colors.black,
                                              letterSpacing: .5,
                                            ),
                                          ),
                                        ],
                                        onTap: null,
                                        pause:
                                            const Duration(milliseconds: 3000),
                                        repeatForever: false,
                                        isRepeatingAnimation: false,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  addVerticalSpace(20.0),
                  TextFormField(
                    controller: _titleController,
                    focusNode: _focusNodeField1,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: GoogleFonts.quicksand(
                      textStyle: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.black54,
                        letterSpacing: .5,
                      ),
                    ),
                    decoration: inputDecoration(
                      language == 'ro'
                          ? 'Titlul comunicatului de presă'
                          : 'Title of the press release',
                    ),
                    onChanged: (val) {
                      setState(() {
                        pressTitle = val.trim();
                      });
                    },
                    validator: (val) => val!.length < 10
                        ? (language == 'ro' ? 'Prea scurt' : 'Too short')
                        : null,
                  ),

                  ///press introduction
                  focusedField == 2
                      ? Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(bottom: 28.0),
                                  child: ChatBubble(
                                    clipper: ChatBubbleClipper3(
                                      type: BubbleType.sendBubble,
                                    ),
                                    backGroundColor: const Color(0xffd7dde9),
                                    elevation: 1.0,
                                    shadowColor: Colors.grey,
                                    child: Container(
                                      // constraints: BoxConstraints(
                                      //   maxWidth: MediaQuery.of(context).size.width * 0.7,
                                      // ),
                                      width: MediaQuery.of(context).size.width *
                                          0.68,
                                      child: DefaultTextStyle(
                                        style: GoogleFonts.quicksand(
                                          color: Colors.black87,
                                          fontSize: 14,
                                          letterSpacing: .5,
                                        ),
                                        textAlign: TextAlign.center,
                                        child: AnimatedTextKit(
                                          animatedTexts: [
                                            TypewriterAnimatedText(
                                              language == 'ro'
                                                  ? 'Cine? Ce? Cum? Unde? Când? Evidențiază un interes pentru publicul larg (est. 80 cuvinte)'
                                                  : 'Who? What? How? Where? When? Highlight the interest for the general public (est. 80 words)',
                                              textAlign: TextAlign.start,
                                              speed: const Duration(
                                                milliseconds: 80,
                                              ),
                                              textStyle: GoogleFonts.quicksand(
                                                fontSize: 14,
                                                color: Colors.black,
                                                letterSpacing: .5,
                                              ),
                                            ),
                                          ],
                                          onTap: null,
                                          pause: const Duration(
                                              milliseconds: 3000),
                                          repeatForever: false,
                                          isRepeatingAnimation: false,
                                        ),
                                      ),
                                    ),
                                  )),
                              const Image(
                                image: AssetImage(
                                    'assets/personas/sixth_female.png'),
                                height: 60,
                                width: 60,
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  addVerticalSpace(20.0),
                  TextFormField(
                    controller: _introController,
                    focusNode: _focusNodeField2,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: GoogleFonts.quicksand(
                      textStyle: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.black54,
                        letterSpacing: .5,
                      ),
                    ),
                    decoration: inputDecoration(
                      language == 'ro'
                          ? 'Introducere articol'
                          : 'Article introduction',
                    ),
                    onChanged: (val) {
                      setState(() {
                        pressSummary = val.trim();
                      });
                    },
                    validator: (val) =>
                        !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                .hasMatch(val!)
                            ? (language == 'ro'
                                ? 'Introdu o adresă de e-mail validă'
                                : 'Enter a valid e-mail address')
                            : null,
                  ),

                  ///press categories
                  focusedField == 0
                      ? Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Image(
                                image: AssetImage(
                                    'assets/personas/introducer.png'),
                                height: 60,
                                width: 60,
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(bottom: 28.0),
                                  child: ChatBubble(
                                    clipper: ChatBubbleClipper3(
                                      type: BubbleType.receiverBubble,
                                    ),
                                    backGroundColor: const Color(0xffd7dde9),
                                    elevation: 1.0,
                                    shadowColor: Colors.grey,
                                    child: Container(
                                      // constraints: BoxConstraints(
                                      //   maxWidth: MediaQuery.of(context).size.width * 0.7,
                                      // ),
                                      width: MediaQuery.of(context).size.width *
                                          0.68,
                                      child: DefaultTextStyle(
                                        style: GoogleFonts.quicksand(
                                          color: Colors.black87,
                                          fontSize: 14,
                                          letterSpacing: .5,
                                        ),
                                        textAlign: TextAlign.center,
                                        child: AnimatedTextKit(
                                          animatedTexts: [
                                            TypewriterAnimatedText(
                                              language == 'ro'
                                                  ? 'Selectați categoria comunicatului de presă. Trebuie să selectați cel puțin o categorie.'
                                                  : 'Select the category of the press release. You need to select at least one category.',
                                              textAlign: TextAlign.start,
                                              speed: const Duration(
                                                milliseconds: 80,
                                              ),
                                              textStyle: GoogleFonts.quicksand(
                                                fontSize: 14,
                                                color: Colors.black,
                                                letterSpacing: .5,
                                              ),
                                            ),
                                          ],
                                          onTap: null,
                                          pause: const Duration(
                                              milliseconds: 3000),
                                          repeatForever: false,
                                          isRepeatingAnimation: false,
                                        ),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        )
                      : Container(),
                  addVerticalSpace(10.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: blackNormalText(language == 'Romanian'
                        ? 'Selecteaza categoria:'
                        : 'Select category:'),
                  ),
                  addVerticalSpace(6.0),
                  ChipsChoice<String>.multiple(
                    value: tags,
                    onChanged: (val) {
                      setState(() {
                        tags = val;
                        focusedField = 0;
                        _focusNodeField1.unfocus();
                        _focusNodeField2.unfocus();
                        _focusNodeField3.unfocus();
                        _focusNodeField4.unfocus();
                        _focusNodeField6.unfocus();
                        _focusNodeField7.unfocus();
                      });
                    },
                    choiceItems: C2Choice.listFrom<String, String>(
                      source: categoryLabels[language]!.keys.toList(),
                      value: (i, v) => v,
                      label: (i, v) => categoryLabels[language]![v]!,
                    ),
                    wrapped: true,
                    wrapCrossAlignment: WrapCrossAlignment.start,
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    padding: EdgeInsets.zero,
                  ),

                  addVerticalSpace(16.0),

                  ///press body
                  focusedField == 3
                      ? Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(bottom: 28.0),
                                  child: ChatBubble(
                                    clipper: ChatBubbleClipper3(
                                      type: BubbleType.sendBubble,
                                    ),
                                    backGroundColor: const Color(0xffd7dde9),
                                    elevation: 1.0,
                                    shadowColor: Colors.grey,
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.68,
                                      child: DefaultTextStyle(
                                        style: GoogleFonts.quicksand(
                                          color: Colors.black87,
                                          fontSize: 14,
                                          letterSpacing: .5,
                                        ),
                                        textAlign: TextAlign.center,
                                        child: AnimatedTextKit(
                                          animatedTexts: [
                                            TypewriterAnimatedText(
                                              language == 'ro'
                                                  ? 'Informații suplimentare despre produs / serviciu / eveniment astfel încât să rezulte informații clare, veridice, fără aprecieri subiective. Textul trebuie să conțină 1-2 declarații ale persoanei reprezentante sau ale companiei.'
                                                  : 'Additional information about the product/service/event so that clear, truthful information results, without subjective assessments. The text should contain 1-2 statements of the representative or company.',
                                              textAlign: TextAlign.start,
                                              speed: const Duration(
                                                milliseconds: 80,
                                              ),
                                              textStyle: GoogleFonts.quicksand(
                                                fontSize: 14,
                                                color: Colors.black,
                                                letterSpacing: .5,
                                              ),
                                            ),
                                          ],
                                          onTap: null,
                                          pause: const Duration(
                                              milliseconds: 3000),
                                          repeatForever: false,
                                          isRepeatingAnimation: false,
                                        ),
                                      ),
                                    ),
                                  )),
                              const Image(
                                image: AssetImage(
                                    'assets/personas/second_female.png'),
                                height: 60,
                                width: 60,
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  addVerticalSpace(10.0),
                  TextFormField(
                    controller: _bodyController,
                    focusNode: _focusNodeField3,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: GoogleFonts.quicksand(
                      textStyle: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.black54,
                        letterSpacing: .5,
                      ),
                    ),
                    decoration: inputDecoration(
                      language == 'ro'
                          ? 'Corpul comunicatului de presă'
                          : 'Body of the press release',
                    ),
                    onChanged: (val) {
                      setState(() {
                        pressBody = val.trim();
                      });
                    },
                    validator: (val) => val!.length < 10
                        ? (language == 'ro' ? 'Prea scurt' : 'Too short')
                        : null,
                  ),

                  ///company description
                  focusedField == 4
                      ? Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Image(
                                image: AssetImage(
                                    'assets/personas/seventh_male.png'),
                                height: 60,
                                width: 60,
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(bottom: 28.0),
                                  child: ChatBubble(
                                    clipper: ChatBubbleClipper3(
                                      type: BubbleType.receiverBubble,
                                    ),
                                    backGroundColor: const Color(0xffd7dde9),
                                    elevation: 1.0,
                                    shadowColor: Colors.grey,
                                    child: Container(
                                      // constraints: BoxConstraints(
                                      //   maxWidth: MediaQuery.of(context).size.width * 0.7,
                                      // ),
                                      width: MediaQuery.of(context).size.width *
                                          0.68,
                                      child: DefaultTextStyle(
                                        style: GoogleFonts.quicksand(
                                          color: Colors.black87,
                                          fontSize: 14,
                                          letterSpacing: .5,
                                        ),
                                        textAlign: TextAlign.center,
                                        child: AnimatedTextKit(
                                          animatedTexts: [
                                            TypewriterAnimatedText(
                                              language == 'ro'
                                                  ? 'O scurtă prezentare a companiei (est. 80 cuvinte)'
                                                  : 'A brief introduction of the company (est. 80 words)',
                                              textAlign: TextAlign.start,
                                              speed: const Duration(
                                                milliseconds: 80,
                                              ),
                                              textStyle: GoogleFonts.quicksand(
                                                fontSize: 14,
                                                color: Colors.black,
                                                letterSpacing: .5,
                                              ),
                                            ),
                                          ],
                                          onTap: null,
                                          pause: const Duration(
                                              milliseconds: 3000),
                                          repeatForever: false,
                                          isRepeatingAnimation: false,
                                        ),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        )
                      : Container(),
                  addVerticalSpace(20.0),
                  TextFormField(
                    controller: _companyDescController,
                    focusNode: _focusNodeField4,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: GoogleFonts.quicksand(
                      textStyle: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.black54,
                        letterSpacing: .5,
                      ),
                    ),
                    decoration: inputDecoration(
                      language == 'ro' ? 'Despre companie' : 'About company',
                    ),
                    onChanged: (val) {
                      // setState(() {
                      //   pressSummary = val.trim();
                      // });
                    },
                    validator: (val) =>
                        !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                .hasMatch(val!)
                            ? (language == 'ro'
                                ? 'Introdu o adresă de e-mail validă'
                                : 'Enter a valid e-mail address')
                            : null,
                  ),

                  ///video link
                  focusedField == 5
                      ? Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(bottom: 28.0),
                                  child: ChatBubble(
                                    clipper: ChatBubbleClipper3(
                                      type: BubbleType.sendBubble,
                                    ),
                                    backGroundColor: const Color(0xffd7dde9),
                                    elevation: 1.0,
                                    shadowColor: Colors.grey,
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.68,
                                      child: DefaultTextStyle(
                                        style: GoogleFonts.quicksand(
                                          color: Colors.black87,
                                          fontSize: 14,
                                          letterSpacing: .5,
                                        ),
                                        textAlign: TextAlign.center,
                                        child: AnimatedTextKit(
                                          animatedTexts: [
                                            TypewriterAnimatedText(
                                              language == 'ro'
                                                  ? 'Aici puteți adăuga opțional un link către un videoclip sau conținut similar pentru a sprijini presa. (opțional)'
                                                  : 'Here you can optionally add a link you a video or related content to support the press. (optional)',
                                              textAlign: TextAlign.start,
                                              speed: const Duration(
                                                milliseconds: 80,
                                              ),
                                              textStyle: GoogleFonts.quicksand(
                                                fontSize: 14,
                                                color: Colors.black,
                                                letterSpacing: .5,
                                              ),
                                            ),
                                          ],
                                          onTap: null,
                                          pause: const Duration(
                                              milliseconds: 3000),
                                          repeatForever: false,
                                          isRepeatingAnimation: false,
                                        ),
                                      ),
                                    ),
                                  )),
                              const Image(
                                image: AssetImage(
                                    'assets/personas/sixth_female.png'),
                                height: 60,
                                width: 60,
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  addVerticalSpace(20.0),
                  TextFormField(
                    controller: _linkController,
                    focusNode: _focusNodeField5,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: GoogleFonts.quicksand(
                      textStyle: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.black54,
                        letterSpacing: .5,
                      ),
                    ),
                    decoration: inputDecoration(
                      language == 'ro' ? 'Link suplimentar' : 'Additional link',
                    ),
                    onChanged: (val) {
                      // setState(() {
                      //   pressBody = val.trim();
                      // });
                    },
                    validator: (val) => val!.length < 10
                        ? (language == 'ro' ? 'Prea scurt' : 'Too short')
                        : null,
                  ),

                  ///press tags
                  focusedField == 6
                      ? Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Image(
                                image: AssetImage(
                                    'assets/personas/sixth_male.png'),
                                height: 60,
                                width: 60,
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(bottom: 28.0),
                                  child: ChatBubble(
                                    clipper: ChatBubbleClipper3(
                                      type: BubbleType.receiverBubble,
                                    ),
                                    backGroundColor: const Color(0xffd7dde9),
                                    elevation: 1.0,
                                    shadowColor: Colors.grey,
                                    child: Container(
                                      // constraints: BoxConstraints(
                                      //   maxWidth: MediaQuery.of(context).size.width * 0.7,
                                      // ),
                                      width: MediaQuery.of(context).size.width *
                                          0.68,
                                      child: DefaultTextStyle(
                                        style: GoogleFonts.quicksand(
                                          color: Colors.black87,
                                          fontSize: 14,
                                          letterSpacing: .5,
                                        ),
                                        textAlign: TextAlign.center,
                                        child: AnimatedTextKit(
                                          animatedTexts: [
                                            TypewriterAnimatedText(
                                              language == 'ro'
                                                  ? 'Aici sunt etichetele relevante pentru comunicatul de presă. Etichetele ajută la afișarea comunicatului de presă în rezultatele căutării (est. 4 etichete)'
                                                  : 'Here goes the relevant tags for the press release. Tags help to show the press release in search results (est. 4 tags)',
                                              textAlign: TextAlign.start,
                                              speed: const Duration(
                                                milliseconds: 80,
                                              ),
                                              textStyle: GoogleFonts.quicksand(
                                                fontSize: 14,
                                                color: Colors.black,
                                                letterSpacing: .5,
                                              ),
                                            ),
                                          ],
                                          onTap: null,
                                          pause: const Duration(
                                              milliseconds: 3000),
                                          repeatForever: false,
                                          isRepeatingAnimation: false,
                                        ),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        )
                      : Container(),
                  addVerticalSpace(20.0),
                  TextFormField(
                    controller: _tagsController,
                    focusNode: _focusNodeField6,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: GoogleFonts.quicksand(
                      textStyle: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.black54,
                        letterSpacing: .5,
                      ),
                    ),
                    decoration: inputDecoration(
                      language == 'ro' ? 'Etichete relevante' : 'Relevant tags',
                    ),
                    onChanged: (val) {
                      // setState(() {
                      //   pressSummary = val.trim();
                      // });
                    },
                    validator: (val) =>
                        !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                .hasMatch(val!)
                            ? (language == 'ro'
                                ? 'Introdu o adresă de e-mail validă'
                                : 'Enter a valid e-mail address')
                            : null,
                  ),

                  ///press author
                  focusedField == 7
                      ? Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(bottom: 28.0),
                                  child: ChatBubble(
                                    clipper: ChatBubbleClipper3(
                                      type: BubbleType.sendBubble,
                                    ),
                                    backGroundColor: const Color(0xffd7dde9),
                                    elevation: 1.0,
                                    shadowColor: Colors.grey,
                                    child: Container(
                                      // constraints: BoxConstraints(
                                      //   maxWidth: MediaQuery.of(context).size.width * 0.7,
                                      // ),
                                      width: MediaQuery.of(context).size.width *
                                          0.68,
                                      child: DefaultTextStyle(
                                        style: GoogleFonts.quicksand(
                                          color: Colors.black87,
                                          fontSize: 14,
                                          letterSpacing: .5,
                                        ),
                                        textAlign: TextAlign.center,
                                        child: AnimatedTextKit(
                                          animatedTexts: [
                                            TypewriterAnimatedText(
                                              language == 'ro'
                                                  ? 'Iată numele autorului comunicatului de presă (est. 2 cuvinte)'
                                                  : 'Here goes the name author of the press release (est. 2 words)',
                                              textAlign: TextAlign.start,
                                              speed: const Duration(
                                                milliseconds: 80,
                                              ),
                                              textStyle: GoogleFonts.quicksand(
                                                fontSize: 14,
                                                color: Colors.black,
                                                letterSpacing: .5,
                                              ),
                                            ),
                                          ],
                                          onTap: null,
                                          pause: const Duration(
                                              milliseconds: 3000),
                                          repeatForever: false,
                                          isRepeatingAnimation: false,
                                        ),
                                      ),
                                    ),
                                  )),
                              const Image(
                                image: AssetImage(
                                    'assets/personas/sixth_female.png'),
                                height: 60,
                                width: 60,
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  addVerticalSpace(20.0),
                  TextFormField(
                    controller: _authorController,
                    focusNode: _focusNodeField7,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.multiline,
                    style: GoogleFonts.quicksand(
                      textStyle: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.black54,
                        letterSpacing: .5,
                      ),
                    ),
                    decoration: inputDecoration(
                      language == 'ro'
                          ? 'Numele autorului'
                          : 'Name of the author',
                    ),
                    onChanged: (val) {
                      // setState(() {
                      //   pressBody = val.trim();
                      // });
                    },
                    validator: (val) => val!.length < 10
                        ? (language == 'ro' ? 'Prea scurt' : 'Too short')
                        : null,
                  ),

                  ///press image

                  addVerticalSpace(10),
                  focusedField == 10
                      ? Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Image(
                                image: AssetImage(
                                    'assets/personas/sixth_male.png'),
                                height: 60,
                                width: 60,
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(bottom: 28.0),
                                  child: ChatBubble(
                                    clipper: ChatBubbleClipper3(
                                      type: BubbleType.receiverBubble,
                                    ),
                                    backGroundColor: const Color(0xffd7dde9),
                                    elevation: 1.0,
                                    shadowColor: Colors.grey,
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.68,
                                      child: DefaultTextStyle(
                                        style: GoogleFonts.quicksand(
                                          color: Colors.black87,
                                          fontSize: 14,
                                          letterSpacing: .5,
                                        ),
                                        textAlign: TextAlign.center,
                                        child: AnimatedTextKit(
                                          animatedTexts: [
                                            TypewriterAnimatedText(
                                              language == 'ro'
                                                  ? 'Cine? Ce? Cum? Unde? Când? Evidențiază un interes pentru publicul larg (est. 80 cuvinte)'
                                                  : 'Who? What? How? Where? When? Highlight the interest for the general public (est. 80 words)',
                                              textAlign: TextAlign.start,
                                              speed: const Duration(
                                                milliseconds: 80,
                                              ),
                                              textStyle: GoogleFonts.quicksand(
                                                fontSize: 14,
                                                color: Colors.black,
                                                letterSpacing: .5,
                                              ),
                                            ),
                                          ],
                                          onTap: null,
                                          pause: const Duration(
                                              milliseconds: 3000),
                                          repeatForever: false,
                                          isRepeatingAnimation: false,
                                        ),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        )
                      : Container(),
                  addVerticalSpace(10),
                  blackNormalText(
                      language == 'ro' ? 'Adauga imagine' : 'Add image'),

                  addVerticalSpace(10),
                  Center(
                    child: AspectRatio(
                      aspectRatio: 3 / 2,
                      child: Container(
                        //height: 160.0,
                        width: double.infinity,
                        child: InkWell(
                          child: _imageFile == null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: const Image(
                                    image: AssetImage(
                                      'assets/images/place_holder.png',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
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

                  ///check box
                  addVerticalSpace(10),
                  focusedField == 100
                      ? Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(bottom: 28.0),
                                  child: ChatBubble(
                                    clipper: ChatBubbleClipper3(
                                      type: BubbleType.sendBubble,
                                    ),
                                    backGroundColor: const Color(0xffd7dde9),
                                    elevation: 1.0,
                                    shadowColor: Colors.grey,
                                    child: Container(
                                      // constraints: BoxConstraints(
                                      //   maxWidth: MediaQuery.of(context).size.width * 0.7,
                                      // ),
                                      width: MediaQuery.of(context).size.width *
                                          0.68,
                                      child: DefaultTextStyle(
                                        style: GoogleFonts.quicksand(
                                          color: Colors.black87,
                                          fontSize: 14,
                                          letterSpacing: .5,
                                        ),
                                        textAlign: TextAlign.center,
                                        child: AnimatedTextKit(
                                          animatedTexts: [
                                            TypewriterAnimatedText(
                                              language == 'ro'
                                                  ? 'Dacă permiteți editarea comunicatului de presă, unul dintre jurnaliștii 2value va lucra la el și vi-l va trimite înapoi pentru aprobare. (opțional)'
                                                  : 'If you allow the press release to be edited one of the 2value journalists will work on it and send it back to you for approval. (optional)',
                                              textAlign: TextAlign.start,
                                              speed: const Duration(
                                                milliseconds: 80,
                                              ),
                                              textStyle: GoogleFonts.quicksand(
                                                fontSize: 14,
                                                color: Colors.black,
                                                letterSpacing: .5,
                                              ),
                                            ),
                                          ],
                                          onTap: null,
                                          pause: const Duration(
                                              milliseconds: 3000),
                                          repeatForever: false,
                                          isRepeatingAnimation: false,
                                        ),
                                      ),
                                    ),
                                  )),
                              const Image(
                                image: AssetImage(
                                    'assets/personas/sixth_female.png'),
                                height: 60,
                                width: 60,
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  Row(
                    children: [
                      Checkbox(
                        value: checkBoxValue,
                        onChanged: (value) {
                          setState(() {
                            checkBoxValue = value!;
                            focusedField = 100;
                            _focusNodeField1.unfocus();
                            _focusNodeField2.unfocus();
                            _focusNodeField3.unfocus();
                            _focusNodeField4.unfocus();
                            _focusNodeField6.unfocus();
                            _focusNodeField7.unfocus();
                          });
                        },
                      ),
                      blackNormalText(language == 'ro'
                          ? 'Permiteți unui jurnalist 2value să editeze.'
                          : 'Allow a 2value journalist to edit.')
                    ],
                  ),

                  ///submit button
                  addVerticalSpace(40),
                  simpleRoundedButton('Submit'),
                  addVerticalSpace(60),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: const IconThemeData(color: TAppTheme.primaryColor),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 4,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                textCapitalization: TextCapitalization.sentences,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: GoogleFonts.quicksand(
                  textStyle: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black54,
                    letterSpacing: .5,
                  ),
                ),
                decoration: inputDecorationChatBox(
                    language == 'ro' ? 'Trimite un mesaj' : 'Send a message'),
                // decoration: InputDecoration(
                //   hintText: "Send a message",
                //   contentPadding: const EdgeInsets.symmetric(
                //     vertical: 8.0,
                //     horizontal: 4.0,
                //   ),
                // ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _handleSubmitted(_textController.text)),
            ),
          ],
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

  void _handleSubmitted(String text) async {
    _textController.clear();

    DocumentReference headsDs1 = FirebaseFirestore.instance
        .collection('HelpDesk')
        .doc('ChatSessions')
        .collection('ChatHeads')
        .doc(widget.userId);
    Map<String, dynamic> _headsTask = {
      'session_start_time': FieldValue.serverTimestamp(),
      'session_user_type': 'Company',
      'session_user_id': widget.userId,
      'session_assistant_id': '-',
      'session_need_human': false,
      'session_last_message': text,
      'session_last_sync': FieldValue.serverTimestamp(),
      'session_id': headsDs1.id,
    };
    headsDs1.set(_headsTask, SetOptions(merge: true)).whenComplete(
      () {
        print('Chat head created');
      },
    );

    //send customers message to database
    DocumentReference customerMsgRef = FirebaseFirestore.instance
        .collection('HelpDesk')
        .doc(widget.userId)
        .collection('Chats')
        .doc();
    Map<String, dynamic> _msgTask = {
      'message_body': text,
      'message_id': customerMsgRef.id,
      'message_time': FieldValue.serverTimestamp(),
      'message_sender': widget.userId,
      'session_time_identifier': mills,
      'message_origin': 'customer',
      'message_extra': '-',
    };
    customerMsgRef.set(_msgTask);
  }
}
