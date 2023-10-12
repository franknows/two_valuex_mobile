import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'theme.dart';
import 'time_ago_eng.dart';

Widget addVerticalSpace(double height) {
  return SizedBox(
    height: height,
  );
}

Widget addHorizontalSpace(double width) {
  return SizedBox(
    width: width,
  );
}

searchPlanButton(String text) {
  return Container(
    height: 38,
    decoration: BoxDecoration(
      color: TAppTheme.primaryColor.withOpacity(.8),
      borderRadius: const BorderRadius.all(
        Radius.circular(19),
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          CupertinoIcons.person_2_alt,
          color: Colors.white,
          size: 18,
        ),
        const SizedBox(
          width: 10,
        ),
        whiteBoldText(
          text,
        ),
      ],
    ),
  );
}

Widget whiteTitleTextLarge(String text) {
  return Text(
    text,
    style: GoogleFonts.quicksand(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 24,
      letterSpacing: .5,
    ),
    textAlign: TextAlign.center,
  );
}

Widget whiteBodyTextLarge(String text) {
  return Text(
    text,
    style: GoogleFonts.quicksand(
        color: Colors.white, fontSize: 16, letterSpacing: .5),
    textAlign: TextAlign.center,
  );
}

whiteBoldText(String txt) {
  return Text(
    txt,
    style: GoogleFonts.quicksand(
      fontSize: 16,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      letterSpacing: .5,
    ),
  );
}

whiteNormalText(String txt) {
  return Text(
    txt,
    style: GoogleFonts.quicksand(
      fontSize: 14,
      color: Colors.white,
      letterSpacing: .5,
    ),
  );
}

miniWhiteText(String txt) {
  return Text(
    txt,
    style: GoogleFonts.quicksand(
      textStyle: const TextStyle(
        fontSize: 12,
        color: Colors.white,
        letterSpacing: .5,
      ),
    ),
  );
}

miniGreenText(String txt) {
  return Text(
    txt,
    style: GoogleFonts.quicksand(
      textStyle: const TextStyle(
        fontSize: 12,
        color: TAppTheme.greenColor,
        letterSpacing: .5,
      ),
    ),
  );
}

miniBlackText(String txt) {
  return Text(
    txt,
    style: GoogleFonts.quicksand(
      textStyle: const TextStyle(
        fontSize: 11,
        color: Colors.grey,
        letterSpacing: .5,
      ),
    ),
  );
}

Widget brownBodyTextSmall(String text) {
  return Text(
    text,
    style: GoogleFonts.quicksand(
      textStyle: const TextStyle(
        color: Color(0xff2a0000),
        fontSize: 14.0,
        letterSpacing: .5,
      ),
    ),
    textAlign: TextAlign.start,
  );
}

Widget blueBodyTextLarge(String text) {
  return Text(
    text,
    style: GoogleFonts.quicksand(
      color: TAppTheme.darkBlue,
      fontWeight: FontWeight.bold,
      fontSize: 16,
      letterSpacing: .5,
    ),
    textAlign: TextAlign.start,
  );
}

Widget blueBodyTextWithSize(String text, double size) {
  return Text(
    text,
    style: GoogleFonts.quicksand(
      color: TAppTheme.darkBlue,
      fontWeight: FontWeight.bold,
      fontSize: size,
      letterSpacing: .5,
    ),
    textAlign: TextAlign.start,
  );
}

blackNormalText(String txt) {
  return Text(
    txt,
    style: GoogleFonts.quicksand(
      fontSize: 14,
      color: Colors.black87,
      letterSpacing: .5,
    ),
  );
}

blackNormalCenteredText(String txt) {
  return Text(
    txt,
    style: GoogleFonts.quicksand(
      fontSize: 14,
      color: Colors.black87,
      letterSpacing: .5,
    ),
    textAlign: TextAlign.center,
  );
}

blackBioText(String txt) {
  return Text(
    txt,
    style: GoogleFonts.quicksand(
      fontSize: 14,
      color: Colors.black87,
      letterSpacing: .5,
    ),
    maxLines: 6,
    overflow: TextOverflow.ellipsis,
  );
}

black54BoldText(String txt) {
  return Text(
    txt,
    style: GoogleFonts.quicksand(
      fontSize: 14,
      color: Colors.black54,
      fontWeight: FontWeight.bold,
      letterSpacing: .5,
    ),
  );
}

blackBoldText(String txt) {
  return Text(
    txt,
    style: GoogleFonts.quicksand(
      fontSize: 14,
      color: Colors.black87,
      fontWeight: FontWeight.bold,
      letterSpacing: .5,
    ),
  );
}

bulletBlackText(String txt) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '⦿',
        style: GoogleFonts.quicksand(
          fontSize: 14,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
          letterSpacing: .5,
        ),
      ),
      const SizedBox(
        width: 6.0,
      ),
      Flexible(
        child: Text(
          txt,
          style: GoogleFonts.quicksand(
            fontSize: 14,
            color: Colors.black87,
            letterSpacing: .5,
          ),
        ),
      ),
    ],
  );
}

bulletColoredBlackText(String txt, MaterialColor color) {
  return Row(
    children: [
      Icon(
        CupertinoIcons.circle_fill,
        size: 10,
        color: color,
      ),
      addHorizontalSpace(10),
      blackNormalText(txt)
    ],
  );
}

Widget whiteLoginButton(String text) {
  return Container(
    height: 40.0,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4.0),
      // color: Theme.of(context).primaryColor,
      color: Colors.white,
      border: Border.all(
        color: Colors.white,
        width: 1.5,
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/google.png',
          height: 20.0,
        ),
        addHorizontalSpace(16.0),
        Text(
          text,
          style: GoogleFonts.quicksand(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

Widget simpleButton(String text) {
  return Container(
    height: 40.0,
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4.0),
      color: TAppTheme.primaryColor,
      border: Border.all(
        color: TAppTheme.primaryColor,
        width: 1.5,
      ),
    ),
    child: Center(
      child: Text(
        text,
        style: GoogleFonts.quicksand(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
          letterSpacing: .5,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );
}

Widget simpleRoundedButton(String text) {
  return Container(
    height: 40.0,
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20.0),
      color: TAppTheme.primaryColor,
      border: Border.all(
        color: TAppTheme.primaryColor,
        width: 1.5,
      ),
    ),
    child: Center(
      child: Text(
        text,
        style: GoogleFonts.quicksand(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
          letterSpacing: .5,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );
}

Widget simpleDarkRoundedButton(String text) {
  return Container(
    height: 40.0,
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20.0),
      color: TAppTheme.darkBlue,
      border: Border.all(
        color: TAppTheme.darkBlue,
        width: 1.5,
      ),
    ),
    child: Center(
      child: Text(
        text,
        style: GoogleFonts.quicksand(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
          letterSpacing: .5,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );
}

Widget nextButton(String text) {
  return Container(
    height: 40.0,
    width: 160,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20.0),
      color: TAppTheme.darkBlue,
      border: Border.all(
        color: Colors.blueGrey.withOpacity(.4),
        width: 1.5,
      ),
    ),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              text,
              style: GoogleFonts.quicksand(
                color: Colors.white,
                // fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: .5,
              ),
              textAlign: TextAlign.center,
            ),
            addHorizontalSpace(10),
            const Icon(
              CupertinoIcons.forward,
              color: Colors.white,
              size: 16,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget previousButton(String text) {
  return Container(
    height: 40.0,
    width: 160,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20.0),
      color: TAppTheme.darkBlue,
      border: Border.all(
        color: Colors.blueGrey.withOpacity(.4),
        width: 1.5,
      ),
    ),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(
              CupertinoIcons.back,
              color: Colors.white,
              size: 16,
            ),
            addHorizontalSpace(10),
            Text(
              text,
              style: GoogleFonts.quicksand(
                color: Colors.white,
                // fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: .5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget simpleRoundedButtonWithIcon(String text, IconData icon) {
  return Container(
    height: 40.0,
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20.0),
      color: TAppTheme.primaryColor,
      border: Border.all(
        color: TAppTheme.primaryColor,
        width: 1.5,
      ),
    ),
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          const SizedBox(
            width: 30,
          ),
          Text(
            text,
            style: GoogleFonts.quicksand(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              letterSpacing: .5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

Widget boarderedButtonRounded(String text) {
  return Container(
    height: 40.0,
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20.0),
      color: Colors.white,
      border: Border.all(
        color: Colors.black87,
        width: 1.0,
      ),
    ),
    child: Center(
      child: Text(
        text,
        style: GoogleFonts.quicksand(
          color: Colors.black87,
          // fontWeight: FontWeight.bold,
          fontSize: 14,
          // letterSpacing: .5,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );
}

Widget appBarWhiteText(String text) {
  return Text(
    text,
    style: GoogleFonts.quicksand(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 18,
      letterSpacing: .5,
    ),
    textAlign: TextAlign.center,
  );
}

Widget whiteButtonText(String text, BuildContext context) {
  return Text(
    text,
    style: Theme.of(context).textTheme.titleMedium!.copyWith(
          color: Colors.black87,
        ),
    textAlign: TextAlign.center,
  );
}

snackError(String text, BuildContext context) {
  var snackBar = SnackBar(
    backgroundColor: TAppTheme.errorColor,
    content: Text(
      text,
      style: GoogleFonts.quicksand(
        fontSize: 14,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        letterSpacing: .5,
      ),
      textAlign: TextAlign.center,
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

snackSuccess(String text, BuildContext context) {
  var snackBar = SnackBar(
    backgroundColor: Colors.green,
    content: Text(
      text,
      style: GoogleFonts.quicksand(
        fontSize: 14,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        letterSpacing: .5,
      ),
      textAlign: TextAlign.center,
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

miniToggleBox(String language) {
  return Container(
    decoration: BoxDecoration(
      color: language == 'sw'
          ? Colors.tealAccent.withOpacity(.1)
          : Colors.greenAccent.withOpacity(.1),
      borderRadius: const BorderRadius.all(
        Radius.circular(4.0),
      ),
      border: Border.all(
        color: language == 'sw'
            ? Colors.tealAccent.withOpacity(.8)
            : Colors.greenAccent.withOpacity(.8),
      ),
    ),
    height: 24.0,
    child: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          language == 'sw' ? 'English' : 'Swahili',
          style: TextStyle(
            color: language == 'sw' ? Colors.tealAccent : Colors.greenAccent,
            letterSpacing: .5,
            fontSize: 12,
          ),
        ),
      ),
    ),
  );
}

maleToggleBox(String language, String selectedCategory) {
  return Container(
    decoration: BoxDecoration(
      color: selectedCategory == 'MALE'
          ? const Color(0xff184a45).withOpacity(.4)
          : Colors.white,
      borderRadius: const BorderRadius.all(
        Radius.circular(4.0),
      ),
      border: Border.all(
          color: selectedCategory == 'MALE'
              ? Colors.blueGrey.withOpacity(.8)
              : Colors.grey.withOpacity(.4),
          width: 2.0),
    ),
    height: 36.0,
    child: Center(
      child: Text(
        language == 'sw' ? 'ME' : 'MALE',
        style: TextStyle(
          color: selectedCategory == 'MALE'
              ? const Color(0xff184a45)
              : Colors.grey,
          fontWeight: FontWeight.bold,
          letterSpacing: .5,
          fontSize: 14,
        ),
      ),
    ),
  );
}

femaleToggleBox(String language, String selectedCategory) {
  return Container(
    decoration: BoxDecoration(
      color: selectedCategory == 'FEMALE'
          ? const Color(0xff184a45).withOpacity(.4)
          : Colors.white,
      borderRadius: const BorderRadius.all(
        Radius.circular(4.0),
      ),
      border: Border.all(
          color: selectedCategory == 'FEMALE'
              ? Colors.blueGrey.withOpacity(.8)
              : Colors.grey.withOpacity(.4),
          width: 2.0),
    ),
    height: 36.0,
    child: Center(
      child: Text(
        language == 'sw' ? 'KE' : 'FEMALE',
        style: TextStyle(
          color: selectedCategory == 'FEMALE'
              ? const Color(0xff184a45)
              : Colors.grey,
          fontWeight: FontWeight.bold,
          letterSpacing: .5,
          fontSize: 14,
        ),
      ),
    ),
  );
}

inputDecorationWithIcon(String text, IconData icon) {
  return InputDecoration(
    filled: true,
    labelText: text,
    labelStyle: GoogleFonts.quicksand(
      textStyle: const TextStyle(
        fontSize: 16.0,
        color: Colors.grey,
        fontWeight: FontWeight.bold,
        letterSpacing: .5,
      ),
    ),
    helperStyle: GoogleFonts.quicksand(
      textStyle: const TextStyle(
        fontSize: 16.0,
        color: Colors.black54,
        letterSpacing: .5,
      ),
    ),
    errorStyle: GoogleFonts.quicksand(
      textStyle: const TextStyle(
        fontSize: 12.0,
        color: TAppTheme.errorColor,
        letterSpacing: .5,
      ),
    ),
    prefixIconColor: Colors.blueGrey,
    contentPadding: const EdgeInsets.symmetric(
      vertical: 8.0,
      horizontal: 4.0,
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        width: 1.5,
        color: Colors.grey,
      ),
      borderRadius: BorderRadius.circular(8.0),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(width: 1.5, color: Colors.redAccent),
      borderRadius: BorderRadius.circular(8.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(width: 1.5, color: Colors.grey),
      borderRadius: BorderRadius.circular(8.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(width: 1.5, color: Colors.red),
      borderRadius: BorderRadius.circular(8.0),
    ),
    prefixIcon: Icon(
      icon,
      color: Colors.blueGrey,
      size: 18,
      // size: 18,
    ),
  );
}

inputDecoration(String text) {
  return InputDecoration(
    filled: true,
    labelText: text,
    labelStyle: GoogleFonts.quicksand(
      textStyle: const TextStyle(
        fontSize: 16.0,
        color: Colors.grey,
        fontWeight: FontWeight.bold,
        letterSpacing: .5,
      ),
    ),
    helperStyle: GoogleFonts.quicksand(
      textStyle: const TextStyle(
        fontSize: 16.0,
        color: Colors.black54,
        letterSpacing: .5,
      ),
    ),
    errorStyle: GoogleFonts.quicksand(
      textStyle: const TextStyle(
        fontSize: 12.0,
        color: TAppTheme.errorColor,
        letterSpacing: .5,
      ),
    ),
    prefixIconColor: Colors.blueGrey,
    contentPadding: const EdgeInsets.symmetric(
      vertical: 8.0,
      horizontal: 10.0,
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        width: 1.5,
        color: Colors.grey,
      ),
      borderRadius: BorderRadius.circular(8.0),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(width: 1.5, color: Colors.redAccent),
      borderRadius: BorderRadius.circular(8.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(width: 1.5, color: Colors.grey),
      borderRadius: BorderRadius.circular(8.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(width: 1.5, color: Colors.red),
      borderRadius: BorderRadius.circular(8.0),
    ),
  );
}

inputDecorationChatBox(String text) {
  return InputDecoration(
    filled: true,
    // labelText: text,
    hintText: text,
    labelStyle: GoogleFonts.quicksand(
      textStyle: const TextStyle(
        fontSize: 16.0,
        color: Colors.grey,
        fontWeight: FontWeight.bold,
        letterSpacing: .5,
      ),
    ),
    helperStyle: GoogleFonts.quicksand(
      textStyle: const TextStyle(
        fontSize: 16.0,
        color: Colors.black54,
        letterSpacing: .5,
      ),
    ),
    errorStyle: GoogleFonts.quicksand(
      textStyle: const TextStyle(
        fontSize: 12.0,
        color: TAppTheme.errorColor,
        letterSpacing: .5,
      ),
    ),
    prefixIconColor: Colors.blueGrey,
    contentPadding: const EdgeInsets.symmetric(
      vertical: 4.0,
      horizontal: 10.0,
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        width: 1.0,
        color: Colors.grey,
      ),
      borderRadius: BorderRadius.circular(8.0),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        width: 1.0,
        color: Colors.redAccent,
      ),
      borderRadius: BorderRadius.circular(8.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        width: 1.0,
        color: Colors.black12,
      ),
      borderRadius: BorderRadius.circular(8.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        width: 1.0,
        color: Colors.red,
      ),
      borderRadius: BorderRadius.circular(8.0),
    ),
  );
}

errorBox(String txt) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      color: Color(0xffecc8c5),
      border: Border.all(
        color: Color(0xffb32f2d),
      ),
    ),
    width: double.infinity,
    padding: EdgeInsets.all(8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(top: 3.0),
          child: Icon(
            Icons.error_outline,
            color: Color(0xffb32f2d),
            size: 17,
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              txt,
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  fontSize: 16.0,
                  color: Color(0xffb32f2d),
                  letterSpacing: .5,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

successBox(String txt) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      color: Color(0xffc5ecc6),
      border: Border.all(
        color: Color(0xff36b32d),
      ),
    ),
    width: double.infinity,
    padding: EdgeInsets.all(8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(top: 3.0),
          child: Icon(
            Icons.error_outline,
            color: Color(0xff36b32d),
            size: 17,
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              txt,
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  fontSize: 16.0,
                  color: Color(0xff36b32d),
                  letterSpacing: .5,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

chatInputDecoration(String text) {
  return InputDecoration(
    hintText: text,
    filled: true,
    fillColor: Colors.white.withOpacity(.9),
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(10),
    ),
    contentPadding: const EdgeInsets.all(10),
    isDense: true,
  );
}

textFieldStyle() {
  return GoogleFonts.quicksand(
    textStyle: const TextStyle(
      fontSize: 18.0,
      color: Colors.black54,
      fontWeight: FontWeight.bold,
      letterSpacing: .5,
    ),
  );
}

watchButton(String txt) {
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xff184a45),
      borderRadius: const BorderRadius.all(
        Radius.circular(4.0),
      ),
      border: Border.all(
        color: const Color(0xff184a45),
      ),
    ),
    height: 34.0,
    child: Center(
      child: Text(
        txt,
        style: GoogleFonts.quicksand(
          textStyle: const TextStyle(
            fontSize: 14.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: .5,
          ),
        ),
      ),
    ),
  );
}

laterButton(String txt) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.all(
        Radius.circular(4.0),
      ),
      border: Border.all(
        color: Colors.grey.withOpacity(.6),
        width: 1,
      ),
    ),
    height: 34.0,
    child: Center(
      child: Text(
        txt,
        style: GoogleFonts.quicksand(
          textStyle: const TextStyle(
            fontSize: 14.0,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}

dangerButton(String txt) {
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xff8B0000),
      borderRadius: const BorderRadius.all(
        Radius.circular(4.0),
      ),
      border: Border.all(
        color: const Color(0xff8B0000),
      ),
    ),
    height: 34.0,
    child: Center(
      child: Text(
        txt,
        style: GoogleFonts.quicksand(
          textStyle: const TextStyle(
            fontSize: 15.0,
            color: Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}

unwatchedAdButton(String amount, String language) {
  return Padding(
    padding: const EdgeInsets.only(left: 8.0, right: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          language == 'sw' ? 'Coin $amount' : '$amount Coins',
          style: GoogleFonts.quicksand(
            textStyle: const TextStyle(
              fontSize: 14.0,
              color: CupertinoColors.black,
              fontWeight: FontWeight.bold,
              letterSpacing: .5,
            ),
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          '-',
          style: GoogleFonts.quicksand(
            textStyle: const TextStyle(
              fontSize: 14.0,
              color: CupertinoColors.black,
              fontWeight: FontWeight.bold,
              letterSpacing: .5,
            ),
          ),
          textAlign: TextAlign.center,
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xff184a45),
            borderRadius: const BorderRadius.all(
              Radius.circular(4.0),
            ),
            border: Border.all(
              color: const Color(0xff184a45),
            ),
          ),
          height: 34.0,
          width: 120,
          child: Center(
            child: Text(
              language == 'sw' ? 'Angalia' : 'Watch Ad',
              style: GoogleFonts.quicksand(
                textStyle: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: .5,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

watchedAdButton(String amount, String language) {
  return Padding(
    padding: const EdgeInsets.only(left: 8.0, right: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          language == 'sw' ? 'Coin $amount' : '$amount Coins',
          style: const TextStyle(
            color: Colors.grey,
            // fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const Text(
          '-',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(.1),
            borderRadius: const BorderRadius.all(
              Radius.circular(4.0),
            ),
            border: Border.all(
              color: Colors.grey.withOpacity(.2),
              width: 2,
            ),
          ),
          height: 34.0,
          width: 120,
          child: Center(
            child: Text(
              language == 'sw' ? 'Umeangalia' : 'Watched',
              style: TextStyle(
                color: Colors.grey.withOpacity(.4),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

dialogTitleText(String txt) {
  return Text(
    txt,
    style: GoogleFonts.quicksand(
      fontSize: 14,
      color: Colors.black87,
      fontWeight: FontWeight.bold,
      letterSpacing: .5,
    ),
    textAlign: TextAlign.center,
  );
}

blackBoldTextWithSize(String txt, double size) {
  return Text(
    txt,
    style: GoogleFonts.quicksand(
      fontSize: size,
      color: Colors.black87,
      fontWeight: FontWeight.bold,
      letterSpacing: .5,
    ),
  );
}

greyNormalText(String txt) {
  return Text(
    txt,
    style: GoogleFonts.quicksand(
      fontSize: 14,
      color: Colors.grey,
      letterSpacing: .5,
    ),
  );
}

greyBoldTextCenter(String txt) {
  return Text(
    txt,
    style: GoogleFonts.quicksand(
      fontSize: 14,
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      letterSpacing: .5,
    ),
    textAlign: TextAlign.center,
  );
}

greyNormalTextCenter(String txt) {
  return Text(
    txt,
    style: GoogleFonts.quicksand(
      fontSize: 14,
      color: Colors.grey,
      letterSpacing: .5,
    ),
    textAlign: TextAlign.center,
  );
}

whiteBoldTextWithSize(String txt, double size) {
  return Text(
    txt,
    style: GoogleFonts.quicksand(
      fontSize: size,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      letterSpacing: .5,
    ),
  );
}

dialogBodyText(String txt) {
  return Text(
    txt,
    style: GoogleFonts.quicksand(
      textStyle: const TextStyle(
        fontSize: 14.0,
        color: CupertinoColors.black,
        letterSpacing: .5,
      ),
    ),
    textAlign: TextAlign.center,
  );
}

blackChipText(String txt) {
  return Text(
    txt,
    style: GoogleFonts.quicksand(
      textStyle: const TextStyle(
        fontSize: 12.0,
        color: CupertinoColors.black,
        // fontWeight: FontWeight.bold,
        letterSpacing: .5,
      ),
    ),
    textAlign: TextAlign.center,
  );
}

whiteChipText(String txt) {
  return Text(
    txt,
    style: GoogleFonts.quicksand(
      textStyle: const TextStyle(
        fontSize: 12.0,
        color: CupertinoColors.white,
        // fontWeight: FontWeight.bold,
        letterSpacing: .5,
      ),
    ),
    textAlign: TextAlign.center,
  );
}

///chat bubbles

newSenderChatBubble(DocumentSnapshot myMessages, int index, double width) {
  return BubbleSpecialThree(
    text: 'Added iMessage shape bubbles',
    color: Color(0xFF1B97F3),
    tail: false,
    textStyle: TextStyle(color: Colors.white, fontSize: 16),
    // clipper: ChatBubbleClipper3(type: BubbleType.sendBubble),
    // alignment: Alignment.topRight,
    // margin: const EdgeInsets.all(6.0),
    // backGroundColor: const Color(0xffe0f0d8),
    // child: Container(
    //   constraints: BoxConstraints(
    //     maxWidth: width * 0.7,
    //   ),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.end,
    //     children: [
    //       blackNormalText(myMessages['message_body']),
    //       const SizedBox(
    //         height: 4,
    //       ),
    //       Row(
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           miniBlackText(
    //             myMessages['message_time'] == null
    //                 ? '-'
    //                 : DateFormat('HH:mm').format(
    //                     DateTime.parse(
    //                       myMessages['message_time'].toDate().toString(),
    //                     ),
    //                   ),
    //           ),
    //           const SizedBox(
    //             width: 4,
    //           ),
    //           myMessages['message_seen']
    //               ? const Icon(
    //                   Icons.done_all_rounded,
    //                   color: Colors.blue,
    //                   size: 14,
    //                 )
    //               : const Icon(
    //                   Icons.done_rounded,
    //                   color: Colors.grey,
    //                   size: 14,
    //                 ),
    //         ],
    //       ),
    //     ],
    //   ),
    // ),
  );
}

newReceiverChatBubble(DocumentSnapshot myMessages, int index, double width) {
  return BubbleSpecialThree(
    text: 'Please try and give some feedback on it!',
    color: Color(0xFF1B97F3),
    tail: true,
    textStyle: TextStyle(color: Colors.white, fontSize: 16),
    // clipper: ChatBubbleClipper3(type: BubbleType.receiverBubble),
    // backGroundColor: Colors.white,
    // margin: const EdgeInsets.all(6.0),
    // child: Container(
    //   constraints: BoxConstraints(
    //     maxWidth: width * 0.7,
    //   ),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.end,
    //     children: [
    //       blackNormalText(myMessages['message_body']),
    //       const SizedBox(
    //         height: 4,
    //       ),
    //       Text(
    //         myMessages['message_time'] == null
    //             ? '-'
    //             : DateFormat('HH:mm').format(
    //                 DateTime.parse(
    //                   myMessages['message_time'].toDate().toString(),
    //                 ),
    //               ),
    //         style: GoogleFonts.quicksand(
    //           textStyle: const TextStyle(
    //             fontSize: 11,
    //             // fontWeight: FontWeight.bold,
    //             color: Colors.black54,
    //             letterSpacing: .5,
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // ),
  );
}

timeChatBubble(DocumentSnapshot myMessages, int index, double width) {
  String today = DateFormat('dd MMM, yyyy').format(DateTime.now());
  String serverDate = myMessages['message_time'] != null
      ? DateFormat('dd MMM, yyyy').format(
          DateTime.parse(
            myMessages['message_time'].toDate().toString(),
          ),
        )
      : '';
  return Padding(
    padding: const EdgeInsets.all(6.0),
    child: Center(
      child: Container(
        decoration: BoxDecoration(
            color: const Color(0xffd5f2f6),
            border: Border.all(
              color: const Color(0xffd5f2f6),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4.0),
          child: blackNormalText(
            myMessages['message_time'] == null
                ? today
                : (serverDate == today ? 'Today' : serverDate),
          ),
        ),
      ),
    ),
  );
}

youBlockedBubble(DocumentSnapshot myMessages, int index, double width, name) {
  return Padding(
    padding: const EdgeInsets.all(6.0),
    child: Center(
      child: Container(
        decoration: BoxDecoration(
            color: const Color(0xffd5f2f6),
            border: Border.all(
              color: const Color(0xffd5f2f6),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4.0),
          child: blackNormalText('You blocked "$name"'),
        ),
      ),
    ),
  );
}

youUnblockedBubble(DocumentSnapshot myMessages, int index, double width, name) {
  return Padding(
    padding: const EdgeInsets.all(6.0),
    child: Center(
      child: Container(
        decoration: BoxDecoration(
            color: const Color(0xffd5f2f6),
            border: Border.all(
              color: const Color(0xffd5f2f6),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4.0),
          child: blackNormalText('You unblocked "$name"'),
        ),
      ),
    ),
  );
}

miniProfileTiles(MaterialColor color, IconData icon, String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(6.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(
              icon,
              size: 16,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          text,
          style: GoogleFonts.quicksand(
            fontSize: 14,
            color: Colors.black54,
            fontWeight: FontWeight.bold,
            letterSpacing: .5,
          ),
        ),
        Expanded(child: Container()),
        const Icon(
          CupertinoIcons.right_chevron,
          size: 18,
          color: Colors.black54,
        )
      ],
    ),
  );
}

profileTiles(String title, String body) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text(
            title,
            style: GoogleFonts.quicksand(
              fontSize: 14,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
              letterSpacing: .5,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      const SizedBox(
        height: 2.0,
      ),
      Text(
        body,
        style: GoogleFonts.quicksand(
          fontSize: 14,
          color: Colors.black,
          letterSpacing: .5,
        ),
      ),
    ],
  );
}

advancedProfileTiles(String title, String body) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: GoogleFonts.quicksand(
          fontSize: 14,
          color: Colors.black54,
          fontWeight: FontWeight.bold,
          letterSpacing: .5,
        ),
      ),
      const SizedBox(
        height: 2.0,
      ),
      Text(
        body,
        style: GoogleFonts.quicksand(
          fontSize: 14,
          color: Colors.black,
          letterSpacing: .5,
        ),
      ),
    ],
  );
}

///toggles
swToggleBox(String language) {
  return Container(
    decoration: BoxDecoration(
      color: language == 'ro'
          ? const Color(0xff184a45).withOpacity(.1)
          : Colors.white,
      borderRadius: const BorderRadius.all(
        Radius.circular(4.0),
      ),
      border: Border.all(
        color: language == 'ro'
            ? const Color(0xff184a45).withOpacity(.8)
            : Colors.grey.withOpacity(.4),
        width: 1.5,
      ),
    ),
    height: 36.0,
    child: Center(
      child: Text(
        'ROMANIAN',
        style: GoogleFonts.quicksand(
          fontSize: 14,
          color: language == 'sw' ? const Color(0xff184a45) : Colors.grey,
          fontWeight: FontWeight.bold,
          letterSpacing: .5,
        ),
      ),
    ),
  );
}

engToggleBox(String language) {
  return Container(
    decoration: BoxDecoration(
      color: language == 'eng'
          ? const Color(0xff184a45).withOpacity(.1)
          : Colors.white,
      borderRadius: const BorderRadius.all(
        Radius.circular(4.0),
      ),
      border: Border.all(
        color: language == 'eng'
            ? const Color(0xff184a45).withOpacity(.8)
            : Colors.grey.withOpacity(.4),
        width: 1.5,
      ),
    ),
    height: 36.0,
    child: Center(
      child: Text(
        'ENGLISH',
        style: GoogleFonts.quicksand(
          fontSize: 14,
          color: language == 'eng' ? const Color(0xff184a45) : Colors.grey,
          fontWeight: FontWeight.bold,
          letterSpacing: .5,
        ),
      ),
    ),
  );
}

///press item
pressItem(DocumentSnapshot doc) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Hero(
                tag: 'pressHero${doc['press_id']}',
                child: CachedNetworkImage(
                  imageUrl: doc['press_image'],
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
          Positioned(
            top: 10,
            left: 10,
            child: CircleAvatar(
              radius: 8,
              backgroundColor: doc['press_status'] == 'LIVE'
                  ? Colors.green.withOpacity(.4)
                  : Colors.blue.withOpacity(.4),
              child: CircleAvatar(
                radius: 4,
                backgroundColor: doc['press_status'] == 'LIVE'
                    ? Colors.green.withOpacity(.7)
                    : Colors.blue.withOpacity(.7),
              ),
            ),
          ),
        ],
      ),
      addVerticalSpace(10),
      Text(
        doc['press_title'].toString().toUpperCase(),
        style: GoogleFonts.quicksand(
          fontSize: 14,
          color: Colors.black54,
          fontWeight: FontWeight.bold,
          letterSpacing: .5,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      addVerticalSpace(4.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.person_rounded,
                color: Colors.blueGrey.withOpacity(.5),
                size: 14,
              ),
              addHorizontalSpace(10),
              Text(
                capitalize(doc['press_author']),
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
            doc['press_time'] == null
                ? '-'
                : DateFormat('dd MMM, yyyy').format(
                    DateTime.parse(
                      doc['press_time'].toDate().toString(),
                    ),
                  ),
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
        doc['press_summary'],
        style: GoogleFonts.quicksand(
          fontSize: 14,
          color: Colors.black54,
          letterSpacing: .5,
        ),
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
      ),
      addVerticalSpace(30.0),
    ],
  );
}

leftInstructor(double width, String image, String text) {
  return Padding(
    padding: const EdgeInsets.only(top: 20.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Image(
          image: AssetImage(image),
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
              width: width * 0.68,
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
                      text,
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
                  pause: const Duration(milliseconds: 3000),
                  repeatForever: false,
                  isRepeatingAnimation: false,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

rightInstructor(double width, String text) {
  return Padding(
    padding: const EdgeInsets.only(top: 20.0),
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
                width: width * 0.68,
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
                        text,
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
                    pause: const Duration(milliseconds: 3000),
                    repeatForever: false,
                    isRepeatingAnimation: false,
                  ),
                ),
              ),
            )),
        const Image(
          image: AssetImage('assets/personas/sixth_female.png'),
          height: 60,
          width: 60,
        ),
      ],
    ),
  );
}

pressPublicItem(DocumentSnapshot doc) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Hero(
            tag: 'pressHero${doc['press_id']}',
            child: CachedNetworkImage(
              imageUrl: doc['press_image'],
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
      addVerticalSpace(10),
      Text(
        doc['press_title'].toString().toUpperCase(),
        style: GoogleFonts.quicksand(
          fontSize: 14,
          color: Colors.black54,
          fontWeight: FontWeight.bold,
          letterSpacing: .5,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      addVerticalSpace(4.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.person_rounded,
                color: Colors.blueGrey.withOpacity(.5),
                size: 14,
              ),
              addHorizontalSpace(10),
              Text(
                capitalize(doc['press_author']),
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
            doc['press_time'] == null
                ? '-'
                : DateFormat('dd MMM, yyyy').format(
                    DateTime.parse(
                      doc['press_time'].toDate().toString(),
                    ),
                  ),
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
        doc['press_summary'],
        style: GoogleFonts.quicksand(
          fontSize: 14,
          color: Colors.black54,
          letterSpacing: .5,
        ),
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
      ),
      addVerticalSpace(30.0),
    ],
  );
}

jobPublicItem(DocumentSnapshot doc) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            addVerticalSpace(16),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: CachedNetworkImage(
                      imageUrl: doc['job_employer_logo'],
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doc['job_employer_name'],
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
                    miniBlackText(timeAgoEn(doc['job_posted_mills']))
                  ],
                ),
              ],
            ),
            addVerticalSpace(10),
            Text(
              doc['job_title'].toString().toUpperCase(),
              style: GoogleFonts.quicksand(
                fontSize: 14,
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                letterSpacing: .5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            addVerticalSpace(4.0),
            Text(
              doc['job_description'],
              style: GoogleFonts.quicksand(
                fontSize: 14,
                color: Colors.black54,
                letterSpacing: .5,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            addVerticalSpace(20.0),
          ],
        ),
      ),
    ),
  );
}

companyPublicItem(DocumentSnapshot doc) {
  return Container(
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          addVerticalSpace(20),
          CircleAvatar(
            radius: 40, // Adjust this for your desired circle size
            backgroundColor: Colors.transparent,
            backgroundImage: CachedNetworkImageProvider(
              doc['user_image'] == '-'
                  ? 'https://firebasestorage.googleapis.com/v0/b/two-value.appspot.com/o/XHolder%2Fbusiness_holder.png?alt=media&token=ba7b88f0-08ad-439a-b988-b923099ccab9'
                  : doc['user_image'],
            ),
          ),
          addVerticalSpace(10),
          Text(
            doc['user_name'].toString().toUpperCase(),
            style: GoogleFonts.quicksand(
              fontSize: 14,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
              letterSpacing: .5,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          addVerticalSpace(10.0),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(.7),
              borderRadius: BorderRadius.all(
                Radius.circular(6.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 3,
              ),
              child: Text(
                doc['user_plan'] == '-' ? 'DEMO' : doc['user_plan'],
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
          addVerticalSpace(4.0),
        ],
      ),
    ),
  );
}

journalistPublicItem(DocumentSnapshot doc) {
  return Container(
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          addVerticalSpace(20),
          CircleAvatar(
            radius: 40, // Adjust this for your desired circle size
            backgroundColor: Colors.transparent,
            backgroundImage: CachedNetworkImageProvider(
              doc['user_image'] == '-'
                  ? 'https://firebasestorage.googleapis.com/v0/b/two-value.appspot.com/o/XHolder%2Fp_holder.jpg?alt=media&token=75847331-c10f-483f-ac3c-6d3a84725c62'
                  : doc['user_image'],
            ),
          ),
          addVerticalSpace(10),
          Text(
            doc['user_name'].toString().toUpperCase(),
            style: GoogleFonts.quicksand(
              fontSize: 14,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
              letterSpacing: .5,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          addVerticalSpace(10.0),
          doc['make_money'] == '-'
              ? Container()
              : Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.withOpacity(.7),
                    borderRadius: BorderRadius.all(
                      Radius.circular(6.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 3,
                    ),
                    child: Text(
                      'PRO',
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
          addVerticalSpace(4.0),
        ],
      ),
    ),
  );
}

contactPublicItem(DocumentSnapshot doc) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10.0),
    child: Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            addVerticalSpace(10),
            Text(
              doc['name'].toString().toUpperCase(),
              style: GoogleFonts.quicksand(
                fontSize: 14,
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                letterSpacing: .5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            addVerticalSpace(4.0),
            Row(
              children: [
                Icon(
                  CupertinoIcons.envelope_fill,
                  size: 14,
                  color: Colors.grey,
                ),
                addHorizontalSpace(10),
                Text(
                  doc['email'],
                  style: GoogleFonts.quicksand(
                    fontSize: 14,
                    color: Colors.black54,
                    letterSpacing: .5,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            addVerticalSpace(10.0),
          ],
        ),
      ),
    ),
  );
}

eventPublicItem(DocumentSnapshot doc, String userId) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            addVerticalSpace(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    doc['event_title'],
                    style: GoogleFonts.quicksand(
                      textStyle: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                addHorizontalSpace(20),
                Icon(
                  doc['event_interested_users'].contains(userId)
                      ? CupertinoIcons.star
                      : CupertinoIcons.star_fill,
                  color: Colors.grey,
                )
              ],
            ),
            addVerticalSpace(10),
            Row(
              children: [
                SizedBox(
                  height: 90,
                  width: 90,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: Hero(
                        tag: 'eventHero${doc['event_id']}',
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
                  ),
                ),
                addHorizontalSpace(10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        doc['event_date'] == null
                            ? '-'
                            : DateFormat('dd MMM, yyyy').format(
                                DateTime.parse(
                                  doc['event_date'].toDate().toString(),
                                ),
                              ),
                        style: GoogleFonts.quicksand(
                          textStyle: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.pink,
                          ),
                        ),
                      ),
                      Text(
                        doc['event_description'],
                        style: GoogleFonts.quicksand(
                          fontSize: 14,
                          color: Colors.black54,
                          letterSpacing: .5,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                )
              ],
            ),
            addVerticalSpace(30.0),
          ],
        ),
      ),
    ),
  );
}

String capitalize(String text) {
  if (text.isEmpty) {
    return text;
  }
  return text
      .toLowerCase()
      .split(' ')
      .map((word) => word.isNotEmpty
          ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
          : word)
      .join(' ');
}

Widget ctaButton(String text, BuildContext context) {
  return Container(
    height: 36.0,
    width: MediaQuery.of(context).size.width - 32,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      color: TAppTheme.primaryColor,
      border: Border.all(
        color: TAppTheme.primaryColor,
        width: 1.5,
      ),
    ),
    child: Center(
      child: Text(
        text,
        style: GoogleFonts.quicksand(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
          letterSpacing: .5,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    debugPrint(size.width.toString());
    var path = Path();
    path.lineTo(0, size.height);
    var firstStart = Offset(size.width / 5, size.height);
    var firstEnd = Offset(size.width / 2.25, size.height - 50.0);
    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    var secondStart =
        Offset(size.width - (size.width / 3.24), size.height - 105);
    var secondEnd = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}

String removeHtmlTags(String htmlText) {
  final RegExp regExp = RegExp(r'<[^>]*>', multiLine: true);
  return htmlText.replaceAll(regExp, '');
}

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final IconData? icon;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final bool obscureText;
  // ... you can add other properties that TextFormField supports

  const CustomTextFormField({
    super.key,
    required this.labelText,
    this.hintText = '',
    this.icon,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.sentences,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textCapitalization: TextCapitalization.sentences,
      maxLines: null,
      style: GoogleFonts.quicksand(
        textStyle: const TextStyle(
          fontSize: 16.0,
          color: Colors.black54,
          letterSpacing: .5,
        ),
      ),
      decoration: InputDecoration(
        filled: true,
        labelText: labelText,
        labelStyle: GoogleFonts.quicksand(
          textStyle: const TextStyle(
            fontSize: 16.0,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            letterSpacing: .5,
          ),
        ),
        helperStyle: GoogleFonts.quicksand(
          textStyle: const TextStyle(
            fontSize: 16.0,
            color: Colors.black54,
            letterSpacing: .5,
          ),
        ),
        errorStyle: GoogleFonts.quicksand(
          textStyle: const TextStyle(
            fontSize: 12.0,
            color: TAppTheme.errorColor,
            letterSpacing: .5,
          ),
        ),
        prefixIconColor: Colors.blueGrey,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 10.0,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1.5,
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1.5, color: Colors.redAccent),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1.5, color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1.5, color: Colors.red),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),

      // InputDecoration(
      //   labelText: labelText,
      //   hintText: hintText,
      //   icon: icon != null ? Icon(icon) : null,
      //   // ... you can customize other decoration properties
      // ),
    );
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor,
  });
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}
