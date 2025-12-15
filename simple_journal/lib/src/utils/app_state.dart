import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:simple_journal/src/models/entry.dart';

class AppState {
  AppState() {
    _entriesStreamController = StreamController.broadcast(
      onListen: () {
        _addNewSampleEntry();
      },
    );
  }

  User? user;
  Stream<List<Entry>> get entries => _entriesStreamController.stream;
  late final StreamController<List<Entry>> _entriesStreamController;

  Future<void> logIn(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        user = credential.user!;
        _listenForEntries();
      } else {
        print('no user!');
      }
    } on FirebaseAuthException catch (e) {
      debugPrint("Authentication error: $e");
    }
  }

  void _addNewSampleEntry() {
    final sampleEntry = Entry(
      date: '14/12/2025',
      text: lorem,
      title: '[Example] My Journal Entry',
    );
    _entriesStreamController.add([sampleEntry]);
  }

  void writeEntryToFirebase(Entry entry) {
    final entries = FirebaseFirestore.instance.collection('Entries');
    entries.add(<String, String>{
      'title': entry.title,
      'date': entry.date.toString(),
      'text': entry.text,
    });
  }

  void _listenForEntries() {
    final entriesColection = FirebaseFirestore.instance.collection('Entries');
    entriesColection.snapshots().listen((event) {
      final entries = event.docs.map((doc) {
        final data = doc.data();
        return Entry(
          date: data['date'] as String,
          text: data['text'] as String,
          title: data['title'] as String,
        );
      }).toList();

      _entriesStreamController.add(entries);
    });
  }
}

const lorem =
    '''Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod  tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum
    ''';
