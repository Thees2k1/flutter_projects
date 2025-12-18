import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_nextgen_ui/orb_shader/orb_shader.dart';
import 'package:flutter_nextgen_ui/title_screen/particle_overlay.dart';
import 'package:rnd/rnd.dart';

import '../assets.dart';
import '../styles.dart';
import 'title_screen_ui.dart';

final _rnd = Random();

class TitleScreen extends StatefulWidget {
  const TitleScreen({super.key});

  @override
  State<TitleScreen> createState() => _TitleScreenState();
}

class _TitleScreenState extends State<TitleScreen>
    with SingleTickerProviderStateMixin {
  final _orbKey = GlobalKey<OrbShaderWidgetState>();

  final _minReceiveLightAmt = 0.35;
  final _maxReceiveLightAmt = 0.7;

  double get randomReceiveLightAmt =>
      _rnd.getDouble(_minReceiveLightAmt, _maxReceiveLightAmt);
  // Add this attribute

  final _minEmitLightAmt = 0.35;
  final _maxEmitLightAmt = 0.7;

  double get randomEmitLightAmt =>
      _rnd.getDouble(_minEmitLightAmt, _maxEmitLightAmt);

  var _mousePos = Offset.zero;

  Color get _emitColor =>
      AppColors.emitColors[_difficultyOverride ?? _difficulty];

  Color get _orbColor =>
      AppColors.orbColors[_difficultyOverride ?? _difficulty];

  /// Currently selected difficulty
  int _difficulty = 0;

  /// Currently focused difficulty (if any)
  int? _difficultyOverride;

  double _orbEnergy = 0;
  double _minOrbEnergy = 0;

  double get _finalReceiveLightAmt {
    final light =
        lerpDouble(_minReceiveLightAmt, _maxEmitLightAmt, _orbEnergy) ?? 0;
    return light + _pulseEffect.value * .05 * _orbEnergy;
  }

  double get _finalEmitLightAmt =>
      lerpDouble(_minEmitLightAmt, _maxEmitLightAmt, _orbEnergy) ?? 0;

  late final _pulseEffect = AnimationController(
    vsync: this,
    duration: _getRndPulseDuration(),
    lowerBound: -1,
    upperBound: 1,
  );

  Duration _getRndPulseDuration() => 100.ms + 200.ms * _rnd.nextDouble();

  double _getMinEnergyForDifficulty(int difficulty) => switch (difficulty) {
    1 => .3,
    2 => .6,
    _ => 0,
  };

  @override
  void initState() {
    super.initState();
    _pulseEffect.forward();
    _pulseEffect.addListener(_handlePulseEffectUpdate);
  }

  void _handlePulseEffectUpdate() {
    if (_pulseEffect.status == AnimationStatus.completed) {
      _pulseEffect.reverse();
      _pulseEffect.duration = _getRndPulseDuration();
    } else if (_pulseEffect.status == AnimationStatus.dismissed) {
      _pulseEffect.duration = _getRndPulseDuration();
      _pulseEffect.forward();
    }
  }

  void _handleDifficultyPressed(int value) {
    setState(() => _difficulty = value);
    _bumpMinEnergy();
  }

  Future<void> _bumpMinEnergy([double amount = 0.1]) async {
    setState(() {
      _minOrbEnergy = _getMinEnergyForDifficulty(_difficulty) + amount;
    });

    await Future<void>.delayed(.2.seconds);
    setState(() {
      _minOrbEnergy = _getMinEnergyForDifficulty(_difficulty);
    });
  }

  void _handleDifficultyFocused(int? value) {
    setState(() {
      _difficultyOverride = value;

      if (value == null) {
        _minOrbEnergy = _getMinEnergyForDifficulty(_difficulty);
      } else {
        _minOrbEnergy = _getMinEnergyForDifficulty(value);
      }
    });
  }

  void _handleMouseMove(PointerHoverEvent e) {
    setState(() {
      _mousePos = e.localPosition;
    });
  }

  void _handleStartPressed() => _bumpMinEnergy(.3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: MouseRegion(
          onHover: _handleMouseMove,
          child: _AnimatedColors(
            orbColor: _orbColor,
            emitColor: _emitColor,
            builder: (context, orbColor, emitColor) {
              return Stack(
                children: [
                  /// Bg-Base
                  Image.asset(AssetsPaths.titleBgBase),

                  /// Bg-Receive
                  _LitImage(
                    color: orbColor,
                    lightAmt: _finalReceiveLightAmt,
                    imgSrc: AssetsPaths.titleBgReceive,
                    pulseEffect: _pulseEffect,
                  ),

                  /// Orb
                  Positioned.fill(
                    child: Stack(
                      children: [
                        OrbShaderWidget(
                          key: _orbKey,
                          config: OrbShaderConfig(
                            ambientLightColor: orbColor,
                            materialColor: orbColor,
                            lightColor: orbColor,
                          ),
                          mousePos: _mousePos,
                          minEnergy: _minOrbEnergy,
                          onUpdate: (energy) {
                            _orbEnergy = energy;
                          },
                        ),
                      ],
                    ),
                  ),

                  /// Mg-Base
                  _LitImage(
                    pulseEffect: _pulseEffect,
                    color: orbColor,
                    lightAmt: _finalReceiveLightAmt,
                    imgSrc: AssetsPaths.titleMgBase,
                  ),

                  /// Mg-Receive
                  _LitImage(
                    pulseEffect: _pulseEffect,
                    color: orbColor,
                    lightAmt: _finalReceiveLightAmt,
                    imgSrc: AssetsPaths.titleMgReceive,
                  ),

                  /// Mg-Emit
                  _LitImage(
                    pulseEffect: _pulseEffect,
                    color: emitColor,
                    lightAmt: _finalEmitLightAmt,
                    imgSrc: AssetsPaths.titleMgEmit,
                  ),

                  Positioned.fill(
                    child: IgnorePointer(
                      child: ParticleOverlay(
                        color: orbColor,
                        energy: _orbEnergy,
                      ),
                    ),
                  ),

                  /// Fg-Rocks
                  Image.asset(AssetsPaths.titleFgBase),

                  /// Fg-Receive
                  _LitImage(
                    pulseEffect: _pulseEffect,
                    color: orbColor,
                    lightAmt: _finalReceiveLightAmt,
                    imgSrc: AssetsPaths.titleFgReceive,
                  ),

                  /// Fg-Emit
                  _LitImage(
                    pulseEffect: _pulseEffect,
                    color: emitColor,
                    lightAmt: _finalEmitLightAmt,
                    imgSrc: AssetsPaths.titleFgEmit,
                  ),

                  Positioned.fill(
                    child: TitleScreenUi(
                      difficulty: _difficulty,
                      onStartPressed: _handleStartPressed,
                      onDifficultyFocused: _handleDifficultyFocused,
                      onDifficultyPressed: _handleDifficultyPressed,
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: .3.seconds, duration: 1.seconds);
            },
          ),
        ),
      ),
    );
  }
}

class _LitImage extends StatelessWidget {
  // Add from here...
  const _LitImage({
    required this.pulseEffect,
    required this.color,
    required this.imgSrc,
    required this.lightAmt,
  });
  final Color color;
  final String imgSrc;
  final double lightAmt;
  final AnimationController pulseEffect;

  @override
  Widget build(BuildContext context) {
    final hsl = HSLColor.fromColor(color);
    return ListenableBuilder(
      listenable: pulseEffect,
      builder: (context, child) {
        return Image.asset(
          imgSrc,
          color: hsl.withLightness(hsl.lightness * lightAmt).toColor(),
          colorBlendMode: BlendMode.modulate,
        );
      },
    );
  }
}

class _AnimatedColors extends StatelessWidget {
  const _AnimatedColors({
    required this.emitColor,
    required this.orbColor,
    required this.builder,
  });

  final Color emitColor;
  final Color orbColor;

  final Widget Function(BuildContext context, Color orbColor, Color emitColor)
  builder;

  @override
  Widget build(BuildContext context) {
    final duration = .5.seconds;
    return TweenAnimationBuilder(
      tween: ColorTween(begin: emitColor, end: emitColor),
      duration: duration,
      builder: (_, emitColor, _) {
        return TweenAnimationBuilder(
          tween: ColorTween(begin: orbColor, end: orbColor),
          duration: duration,
          builder: (context, orbColor, _) {
            return builder(context, orbColor!, emitColor!);
          },
        );
      },
    );
  }
}
