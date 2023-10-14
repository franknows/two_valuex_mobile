import 'package:any_link_preview/any_link_preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:two_value/src/time_ago_eng.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../src/helper_widgets.dart';
import '../../src/theme.dart';

class AdminApproveEventsPage extends StatefulWidget {
  final String userId;
  final DocumentSnapshot userData;
  const AdminApproveEventsPage(
      {super.key, required this.userId, required this.userData});

  @override
  State<AdminApproveEventsPage> createState() => _AdminApproveEventsPageState();
}

class _AdminApproveEventsPageState extends State<AdminApproveEventsPage> {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TAppTheme.primaryColor,
        elevation: 4,
        title: Text(
          language == 'ro' ? 'Aprobați evenimente' : 'Approve Events',
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
      body: Container(
        color: Colors.grey.withOpacity(.1),
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('XEvents')
                .where('event_visibility', isEqualTo: false)
                .orderBy('event_posted_time', descending: true)
                .limit(10)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SizedBox(
                  height: size.height - 300,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      color: TAppTheme.primaryColor.withOpacity(.4),
                      backgroundColor: Colors.white,
                    ),
                  ),
                );
              } else {
                if (snapshot.data!.docs.isEmpty) {
                  return Column(
                    children: [
                      addVerticalSpace(200),
                      const Center(
                        child: Image(
                          height: 200,
                          image: AssetImage('assets/images/empty_list.png'),
                        ),
                      ),
                    ],
                  );
                } else {
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot doc = snapshot.data!.docs[index];
                      return GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   CupertinoPageRoute(
                          //     builder: (_) => AdminSinglePressView(
                          //       userId: widget.userId,
                          //       userData: widget.userData,
                          //       pressData: doc,
                          //     ),
                          //   ),
                          // );
                          _showBottomSheet(context, doc);
                        },
                        child: eventAdminApproveItem(doc, widget.userId),
                      );
                    },
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, DocumentSnapshot doc) {
    Map<String, PreviewData> datas = {};

    List<String> urls = [doc['event_link']];
    var size = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          child: Container(
            // height: 980, // you can adjust this value as needed
            color: Colors.white,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    addVerticalSpace(16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: CachedNetworkImage(
                          imageUrl: doc['event_image'],
                          placeholder: (context, url) => Image.asset(
                            'assets/images/vertical_placeholder.png',
                            fit: BoxFit.cover,
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/images/vertical_placeholder.png',
                            fit: BoxFit.cover,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    addVerticalSpace(10),
                    Row(
                      children: [
                        Container(
                          height: 60,
                          width: 50,
                          decoration: BoxDecoration(
                            color: TAppTheme.darkBlue.withOpacity(.2),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              blueBodyTextLarge(
                                doc['event_date'] == null
                                    ? '-'
                                    : DateFormat('MMM').format(
                                        DateTime.parse(
                                          doc['event_date'].toDate().toString(),
                                        ),
                                      ),
                              ),
                              blueBodyTextWithSize(
                                  doc['event_date'] == null
                                      ? '-'
                                      : DateFormat('dd').format(
                                          DateTime.parse(
                                            doc['event_date']
                                                .toDate()
                                                .toString(),
                                          ),
                                        ),
                                  24),
                            ],
                          ),
                        ),
                        addHorizontalSpace(20),
                        Flexible(
                          child: Text(
                            doc['event_title'].toString().toUpperCase(),
                            style: GoogleFonts.quicksand(
                              fontSize: 14,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              letterSpacing: .5,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    addVerticalSpace(4.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.business,
                              color: Colors.blueGrey.withOpacity(.5),
                              size: 14,
                            ),
                            addHorizontalSpace(10),
                            Text(
                              capitalize(doc['event_author']),
                              style: GoogleFonts.quicksand(
                                fontSize: 12,
                                color: Colors.blueGrey.withOpacity(.5),
                                letterSpacing: .5,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        Text(
                          timeAgoEn(doc['event_posted_mills']),
                          style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                              fontSize: 12.0,
                              color: Colors.blueGrey.withOpacity(.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                    addVerticalSpace(4.0),
                    Text(
                      doc['event_description'],
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        color: Colors.black54,
                        letterSpacing: .5,
                      ),
                      // overflow: TextOverflow.ellipsis,
                    ),
                    addVerticalSpace(20.0),
                    AnyLinkPreview(
                      link: doc['event_link'],
                      displayDirection: UIDirection.uiDirectionHorizontal,
                      showMultimedia: true,
                      bodyMaxLines: 5,
                      bodyTextOverflow: TextOverflow.ellipsis,
                      titleStyle: GoogleFonts.quicksand(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        letterSpacing: .5,
                      ),
                      bodyStyle: TextStyle(color: Colors.grey, fontSize: 12),
                      errorBody:
                          'The hyperlink embedded within this document may not display a preview. However, this does not preclude its functionality or accessibility.',
                      errorTitle: 'No preview',
                      errorWidget: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: TAppTheme.darkBlue.withOpacity(.2),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: blackBoldText('Bad Link'),
                            ),
                          )),
                      errorImage:
                          "https://firebasestorage.googleapis.com/v0/b/two-value.appspot.com/o/XHolder%2Ferror.png?alt=media&token=922b2058-93e4-4b42-a036-99238c63713d",
                      cache: Duration(days: 7),
                      backgroundColor: Colors.grey[200],
                      borderRadius: 12,
                      removeElevation: true,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 3,
                          color: Colors.grey,
                        )
                      ],
                      // onTap: () {}, // This disables tap event
                    ),
                    addVerticalSpace(20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            DocumentReference ds = FirebaseFirestore.instance
                                .collection('XEvents')
                                .doc(doc['event_id']);

                            Map<String, dynamic> tasks = {
                              'event_visibility': false,
                            };

                            ds.update(tasks);
                            Navigator.pop(context);
                          },
                          child: SizedBox(
                            width: size.width / 2.4,
                            child: simpleErrorDarkRoundedButton(
                              language == 'ro' ? 'Respinge' : 'Reject',
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            DocumentReference ds = FirebaseFirestore.instance
                                .collection('XEvents')
                                .doc(doc['event_id']);

                            Map<String, dynamic> tasks = {
                              'event_visibility': true,
                            };

                            ds.update(tasks);
                            Navigator.pop(context);
                          },
                          child: SizedBox(
                            width: size.width / 2.4,
                            child: simpleDarkRoundedButton(
                              language == 'ro' ? 'Aproba' : 'Approve',
                            ),
                          ),
                        ),
                      ],
                    ),
                    addVerticalSpace(60.0),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      backgroundColor: Colors
          .transparent, // To ensure no color is applied outside the ClipRRect
    );
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
