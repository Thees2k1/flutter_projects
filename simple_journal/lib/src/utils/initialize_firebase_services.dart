import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:simple_journal/src/utils/constants.dart';
import 'package:simple_journal/firebase_options.dart';

Future<void> initializeFirebaseServices() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (kDebugMode) {
    try {
      FirebaseFirestore.instance.useFirestoreEmulator(kEmulatorHost, 8080);
      FirebaseAuth.instance.useAuthEmulator(kEmulatorHost, 9099);
    } catch (e) {
      debugPrint('Firebase emulator setup error: $e');
    }
  }
}
