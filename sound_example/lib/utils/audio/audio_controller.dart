import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:logging/logging.dart';

class AudioController {
  static final Logger _log = Logger('AudioController');
  SoLoud? _soloud;

  SoundHandle? _musicHandle;
  Future<void> initialize() async {
    //TODO: Error handling
    _soloud = SoLoud.instance;
    await _soloud!.init();

    /*
    Soloud Apis:
      - play(musicSource, volume: volume)
      - setVolume(musicHandle, volume)
     */
  }

  void dispose() {
    _soloud?.deinit();
  }

  Future<void> playSound(String assetKey) async {
    try {
      final source = await _soloud!.loadAsset(assetKey);
      await _soloud!.play(source);
    } on SoLoudException catch (e) {
      _log.severe("Cannot play sound '$assetKey'. Ignoring.", e);
    }
  }

  Future<void> startMusic() async {
    if (_musicHandle != null) {
      if (_soloud!.getIsValidVoiceHandle(_musicHandle!)) {
        _log.info('Music is already playing. Stopping first.');
        await _soloud!.stop(_musicHandle!);
      }
    }


    _log.info('Loading music');
        final musicSource = await _soloud!.loadAsset(
      'assets/audio/music/looped-song.ogg',
      mode: LoadMode.disk,
    );
    musicSource.allInstancesFinished.first.then((_){
      _soloud!.disposeSource(musicSource);
      _log.info('Music is disposed');
      _musicHandle =null;
    });

    _log.info('Playing music');
    _musicHandle = await _soloud!.play(
      musicSource,
      looping: true,
      volume: 0.6,
      loopingStartAt: const Duration(seconds: 25, milliseconds: 43),
    );
  }

  void fadeOutMusic() {
    if(_musicHandle ==null){
      _log.info('Nothing to fade out');
      return;
    }

    const time = Duration(seconds:5);
    _soloud!.fadeVolume(_musicHandle!, 0, time);
    _soloud!.scheduleStop(_musicHandle!, time);
  }

  void appFilter() {
    _soloud!.filters.freeverbFilter.activate();
    _soloud!.filters.freeverbFilter.wet.value =0.2;
    _soloud!.filters.freeverbFilter.roomSize.value =0.9;
   
  }

  void removeFilter() {
   _soloud!.filters.freeverbFilter.deactivate();
  }
}
