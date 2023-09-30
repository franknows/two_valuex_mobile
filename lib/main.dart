import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'screens/auth/auth_error_page.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/setup_account.dart';
import 'screens/auth/verify_email_page.dart';
import 'screens/home/home_page.dart';
import 'src/local_notification_service.dart';
import 'src/theme.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  // print('message from background');
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  LocalNotificationService().initialize();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '2value',
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  State<AuthenticationWrapper> createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final userRef = FirebaseFirestore.instance.collection('XUsers');
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String authState = '';
  String userId = '';

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<bool> doesUserExist(String userId) async {
    final userRef = FirebaseFirestore.instance.collection('XUsers').doc(userId);
    final userDoc = await userRef.get();
    return userDoc.exists;
  }

  void _checkAuthStatus() async {
    User? user = _auth.currentUser;

    if (user == null) {
      setState(() {
        authState = 'unAuthenticated';
      });
    } else {
      bool userExists = await doesUserExist(user.uid);

      if (userExists) {
        ///update device token
        messaging.getToken().then((token) {
          userRef.doc(user.uid).update({
            'device_token': token,
            'user_last_interaction': DateTime.now().millisecondsSinceEpoch,
            'user_last_timestamp': FieldValue.serverTimestamp(),
          }).then((value) {
            // print("Token updated successfully!");
          }).catchError((error) {
            // print("Failed to update token: $error");
          });
        }).catchError((error) {
          // print('Failed to get token: $error');
        });

        ///check if profile is completed
        userRef.doc(user.uid).get().then((docSnapshot) {
          if (docSnapshot.exists) {
            var data = docSnapshot.data();
            var profileCompleted = data!['profile_completed'];
            var isEmailVerified = data['email_verification'];

            if (!isEmailVerified) {
              setState(() {
                authState = 'EmailUnverified';
                userId = user.uid;
              });
            } else if (profileCompleted) {
              setState(() {
                authState = 'ProfileCompleted';
                userId = user.uid;
              });
            } else {
              setState(() {
                authState = 'ProfileIncomplete';
                userId = user.uid;
              });
            }
          }
        });
      } else {
        setState(() {
          authState = 'NoDataAvailable';
          userId = user.uid;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (authState != '') {
      FlutterNativeSplash.remove();
    }
    switch (authState) {
      case 'unAuthenticated':
        return const LoginScreen();
      case 'ProfileCompleted':
        return HomePage(userId: userId);
      case 'EmailUnverified':
        return VerifyEmailPage(userId: userId);
      case 'ProfileIncomplete':
        return SetUpAccountPage(userId: userId);
      case 'NoDataAvailable':
        return SetUpAccountPage(userId: userId);
      default:
        return const AuthErrorPage();
    }
  }
}
