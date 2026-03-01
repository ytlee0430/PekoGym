import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironmon/presentation/shared/audio_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MockAudioPlayer extends Mock
    implements AudioPlayer {}

AudioService _makeService() {
  final mock = _MockAudioPlayer();
  when(() => mock.setVolume(any())).thenAnswer(
    (_) async {},
  );
  when(() => mock.setReleaseMode(any())).thenAnswer(
    (_) async {},
  );
  when(() => mock.play(any())).thenAnswer(
    (_) async {},
  );
  when(() => mock.stop()).thenAnswer((_) async {});
  when(() => mock.dispose()).thenAnswer(
    (_) async {},
  );
  return AudioService(playerFactory: () => mock);
}

void main() {
  setUpAll(() {
    registerFallbackValue(ReleaseMode.release);
    registerFallbackValue(AssetSource(''));
  });

  group('AudioService', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('initializes with default volume values', () {
      final svc = _makeService();
      expect(svc.bgmVolume, closeTo(0.7, 0.01));
      expect(svc.sfxVolume, closeTo(1.0, 0.01));
      expect(svc.isMuted, isFalse);
    });

    test('setMuted toggles mute state', () async {
      final svc = _makeService();
      expect(svc.isMuted, isFalse);
      await svc.setMuted(true);
      expect(svc.isMuted, isTrue);
      await svc.setMuted(false);
      expect(svc.isMuted, isFalse);
    });

    test('setBgmVolume clamps to [0.0, 1.0]', () async {
      final svc = _makeService();
      await svc.setBgmVolume(1.5);
      expect(svc.bgmVolume, 1.0);
      await svc.setBgmVolume(-0.3);
      expect(svc.bgmVolume, 0.0);
    });

    test('setSfxVolume clamps to [0.0, 1.0]', () async {
      final svc = _makeService();
      await svc.setSfxVolume(2.0);
      expect(svc.sfxVolume, 1.0);
    });

    test('bgmVolume persists via SharedPreferences',
        () async {
      final svc = _makeService();
      await svc.setBgmVolume(0.5);
      await svc.setSfxVolume(0.3);

      final prefs =
          await SharedPreferences.getInstance();
      expect(
        prefs.getDouble('audio_bgm_volume'),
        closeTo(0.5, 0.01),
      );
      expect(
        prefs.getDouble('audio_sfx_volume'),
        closeTo(0.3, 0.01),
      );
    });

    test('muted state persists via SharedPreferences',
        () async {
      final svc = _makeService();
      await svc.setMuted(true);

      final prefs =
          await SharedPreferences.getInstance();
      expect(prefs.getBool('audio_muted'), isTrue);
    });

    test('init loads persisted values', () async {
      SharedPreferences.setMockInitialValues({
        'audio_bgm_volume': 0.4,
        'audio_sfx_volume': 0.6,
        'audio_muted': true,
      });

      final svc = _makeService();
      await svc.init();

      expect(svc.bgmVolume, closeTo(0.4, 0.01));
      expect(svc.sfxVolume, closeTo(0.6, 0.01));
      expect(svc.isMuted, isTrue);
    });
  });
}
