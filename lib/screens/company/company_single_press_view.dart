import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' show PreviewData;
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:two_value/src/helper_widgets.dart';

import '../../src/theme.dart';

class CompanySinglePressView extends StatefulWidget {
  final String userId;
  final DocumentSnapshot userData;
  final DocumentSnapshot pressData;
  const CompanySinglePressView(
      {super.key,
      required this.userId,
      required this.userData,
      required this.pressData});

  @override
  State<CompanySinglePressView> createState() => _CompanySinglePressViewState();
}

class _CompanySinglePressViewState extends State<CompanySinglePressView> {
  String language = '';
  Map<String, PreviewData> datas = {};

  List<String> get urls => [
        widget.pressData['press_linked_url'],
      ];

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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: TAppTheme.primaryColor,
              expandedHeight: size.width * 9 / 16,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: 'pressHero${widget.pressData['press_id']}',
                  child: CachedNetworkImage(
                    imageUrl: widget.pressData['press_image'],
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
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        addVerticalSpace(20),
                        blackBoldTextWithSize(
                            widget.pressData['press_title'].toString().trim(),
                            16),
                        addVerticalSpace(4.0),
                        greyNormalText(widget.pressData['press_summary']
                            .toString()
                            .trim()),
                        addVerticalSpace(10.0),
                        Wrap(
                          spacing: 10.0, // gap between adjacent chips
                          runSpacing: 6.0, // gap between lines
                          children: List<Widget>.generate(
                            widget.pressData['press_category'].length,
                            (int index) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: TAppTheme.greenColor.withOpacity(.2),
                                  border: Border.all(
                                    color: TAppTheme.greenColor.withOpacity(.2),
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  child: miniGreenText(widget
                                      .pressData['press_category'][index]),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                        addVerticalSpace(10.0),
                        blackNormalText(widget
                            .pressData['press_body_plain_text']
                            .toString()
                            .trim()),
                        addVerticalSpace(16.0),
                        blackBoldText(language == 'ro'
                            ? 'Despre companie'
                            : 'About company'),
                        addVerticalSpace(10.0),
                        blackNormalText(widget.pressData['press_about_company']
                            .toString()
                            .trim()),
                        addVerticalSpace(30.0),
                        Container(
                          key: ValueKey(urls[0]),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            color: Color(0xfff7f7f8),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            child: LinkPreview(
                              enableAnimation: true,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              onPreviewDataFetched: (data) {
                                setState(() {
                                  datas = {
                                    ...datas,
                                    urls[0]: data,
                                  };
                                });
                              },
                              previewData: datas[urls[
                                  0]], // Pass the preview data from the state
                              text: widget.pressData['press_linked_url'],
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                        ),
                        addVerticalSpace(30.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
