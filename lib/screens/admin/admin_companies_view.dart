import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../src/helper_widgets.dart';
import '../../src/theme.dart';

class AdminCompaniesView extends StatefulWidget {
  final String userId;
  final DocumentSnapshot userData;
  const AdminCompaniesView(
      {super.key, required this.userId, required this.userData});

  @override
  State<AdminCompaniesView> createState() => _AdminCompaniesViewState();
}

class _AdminCompaniesViewState extends State<AdminCompaniesView> {
  String language = '';
  int _limit = 20; // Initial limit, change as needed
  int total = 20;
  QuerySnapshot? query;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCompanies(_limit);
    setState(() {
      language = widget.userData['user_language'];
    });
  }

  void _getCompanies(int limit) {
    FirebaseFirestore.instance
        .collection('XUsers')
        .where('account_type', isEqualTo: 'Company')
        .orderBy('creation_date', descending: true)
        .limit(limit)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      setState(() {
        query = snapshot;
        total = snapshot.size;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    if (query == null) {
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
      if (query!.size == 0) {
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
        return Flexible(
          child: SingleChildScrollView(
            child: Column(
              children: [
                GridView.builder(
                  padding: const EdgeInsets.only(
                    bottom: 20,
                    left: 16,
                    right: 16,
                    top: 10,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: query!.size,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14.0, // Spacing between items in a row
                    mainAxisSpacing: 14.0, // Spacing between rows
                  ),
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = query!.docs[index];
                    return GestureDetector(
                      onTap: () {
                        _showBottomSheet(context, doc);
                      },
                      child: companyPublicItem(doc),
                    );
                  },
                ),
                if (_limit <= total)
                  SizedBox(
                    width: 200,
                    child: GestureDetector(
                      onTap: () {
                        _getCompanies(_limit + 20);
                        setState(() {
                          _limit += 20; // Add 10 more items
                        });
                      },
                      child: tealButton(
                        language == 'ro' ? 'Incarca mai mult' : 'Load More',
                      ),
                    ),
                  ),
                addVerticalSpace(20),
              ],
            ),
          ),
        );
      }
    }
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
            // height: 480, // you can adjust this value as needed
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  addVerticalSpace(16),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: SizedBox(
                          height: 100,
                          width: 100,
                          child: CachedNetworkImage(
                            imageUrl: doc['user_image'],
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
                      addHorizontalSpace(20),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doc['user_name'],
                              style: GoogleFonts.quicksand(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                letterSpacing: .5,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            addVerticalSpace(4),
                            Row(
                              children: [
                                const Icon(
                                  CupertinoIcons.envelope,
                                  size: 10,
                                  color: Colors.grey,
                                ),
                                addHorizontalSpace(10),
                                miniBlackText(doc['user_email']),
                              ],
                            ),
                            addVerticalSpace(4),
                            Row(
                              children: [
                                const Icon(
                                  CupertinoIcons.phone_circle,
                                  size: 10,
                                  color: Colors.grey,
                                ),
                                addHorizontalSpace(10),
                                miniBlackText(doc['user_phone']),
                              ],
                            ),
                            addVerticalSpace(10.0),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(.7),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(6.0),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 3,
                                ),
                                child: Text(
                                  doc['user_plan'] == '-'
                                      ? 'DEMO'
                                      : doc['user_plan'],
                                  style: GoogleFonts.quicksand(
                                    textStyle: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      letterSpacing: .5,
                                    ),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  addVerticalSpace(10),
                  Text(
                    doc['about_user'],
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
                      _callPhoneNumber('tel:${doc['user_phone']}');
                    },
                    child: simpleRoundedButtonWithIcon(
                      language == 'ro' ? 'Apelați compania' : 'Call company',
                      CupertinoIcons.phone,
                    ),
                  ),
                  addVerticalSpace(60.0),
                ],
              ),
            ),
          ),
        );
      },
      backgroundColor: Colors
          .transparent, // To ensure no color is applied outside the ClipRRect
    );
  }

  Future<void> _callPhoneNumber(String url) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
