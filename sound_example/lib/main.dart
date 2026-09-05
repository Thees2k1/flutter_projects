import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'dart:developer' as dev;

import 'package:sound_example/utils/audio/audio_controller.dart';
final rnd = Random();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Logger.root.level = kDebugMode ? Level.FINE : Level.INFO;
  Logger.root.onRecord.listen((record) {
    dev.log(
      record.message,
      time: record.time,
      level: record.level.value,
      name: record.loggerName,
      zone: record.zone,
      error: record.error,
      stackTrace: record.stackTrace,
    );
  });

  final audioController = AudioController();
  await audioController.initialize();
  runApp(MainApp(audioController: audioController));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.audioController});

  final AudioController audioController;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SoLoud Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
      home: MyHomePage(audioController: audioController),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.audioController});
  final AudioController audioController;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const _gap = SizedBox(height: 16,);
  late final AudioController audioCtrl;
  final pewSounds =[
    'assets/audio/sounds/pew1.mp3',
    'assets/audio/sounds/pew2.mp3',
    'assets/audio/sounds/pew3.mp3',
  ];
  bool filterApplied =false;

  @override
  void initState() {
    audioCtrl = widget.audioController;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('data')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () {
                if(pewSounds.isEmpty) return;
                audioCtrl.playSound(pewSounds[rnd.nextInt(pewSounds.length-1)]);
              },
              child: const Text('Play Sound'),
            ),
           _gap,
            OutlinedButton(
              onPressed: () {
                audioCtrl.startMusic();
              },
              child: const Text('Star Music'),
            ),
           _gap,
            OutlinedButton(
              onPressed: () {
                audioCtrl.fadeOutMusic();
              },
              child: const Text('Stop Sound'),
            ),
            _gap,
            Row(
              mainAxisSize: MainAxisSize.min
              ,children: [
                const Text('Apply Filter'),
                Checkbox(value:filterApplied,onChanged:(nVal){
                  setState(() {
                    filterApplied = nVal!;
                  });
                  if (filterApplied){
                    audioCtrl.appFilter();
                  }else{
                    audioCtrl.removeFilter();
                  }
                }

                 ,),
            ],),
          ],
        ),
      ),
    );
  }
}
