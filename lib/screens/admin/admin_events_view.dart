import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:two_value/src/time_ago_eng.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../src/helper_widgets.dart';
import '../../src/theme.dart';

class AdminEventsView extends StatefulWidget {
  final String userId;
  final DocumentSnapshot userData;
  const AdminEventsView(
      {super.key, required this.userId, required this.userData});

  @override
  State<AdminEventsView> createState() => _AdminEventsViewState();
}

class _AdminEventsViewState extends State<AdminEventsView> {
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
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('XEvents')
          .where('event_visibility', isEqualTo: true)
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
                  child: eventPublicItem(doc, widget.userId),
                );
              },
            );
          }
        }
      },
    );
  }

  void _showBottomSheet(BuildContext context, DocumentSnapshot doc) {
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
                    GestureDetector(
                      onTap: () {
                        _launchUrl(doc['event_link']);
                      },
                      child: simpleDarkRoundedButton(
                        language == 'ro'
                            ? 'Vizualizați evenimentul'
                            : 'View Event',
                      ),
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
