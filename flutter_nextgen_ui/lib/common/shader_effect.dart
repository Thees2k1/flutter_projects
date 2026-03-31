import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ShaderEffect extends Effect<double> {
  const ShaderEffect({
    super.delay,
    super.duration,
    this.shader,
    this.update,
    ShaderLayer? layer,
    Curve? curve,
  }) : layer = layer ?? ShaderLayer.replace,
       super(begin: 0, end: 1, curve: curve ?? Curves.ease);

  final ui.FragmentShader? shader;
  final ShaderUpdateCallback? update;
  final ShaderLayer layer;

  @override
  Widget build(
    BuildContext context,
    Widget child,
    AnimationController controller,
    EffectEntry entry,
  ) {
    double ratio = 1 / context.mediaQuery.devicePixelRatio;

    Animation<double> animation = buildAnimation(controller, entry);

    return getOptimizedBuilder(
      animation: animation,
      builder: (_, _) {
        return AnimatedSampler(
          (image, size, canvas) {
            EdgeInsets? insets;

            if (update != null) {
              insets = update!(
                ShaderUpdateDetails(
                  shader: shader!,
                  value: animation.value,
                  size: size,
                  image: image,
                ),
              );
            }

            Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
            rect = insets?.inflateRect(rect) ?? rect;

            void drawImage() {
              canvas.save();
              canvas.scale(ratio, ratio);
              canvas.drawImage(image, Offset.zero, Paint());
              canvas.restore();
            }

            if (layer == ShaderLayer.foreground) drawImage();
            if (shader != null) canvas.drawRect(rect, Paint());
            canvas.restore();
          },
          enabled: shader != null,
          child: child,
        );
      },
    );
  }
}

typedef AnimatedSamplerBuilder =
    void Function(ui.Image image, Size size, Canvas canvas);

class AnimatedSampler extends StatelessWidget {
  const AnimatedSampler(
    this.builder, {
    required this.child,
    super.key,
    this.enabled = true,
  });

  final AnimatedSamplerBuilder builder;
  final Widget child;
  final bool enabled;

  @override
  Widget build(BuildContext context) =>
      _ShaderSamplerBuilder(builder, enabled: enabled, child: child);
}

class _ShaderSamplerBuilder extends SingleChildRenderObjectWidget {
  const _ShaderSamplerBuilder(
    this.builder, {
    required this.enabled,
    super.child,
  });

  final AnimatedSamplerBuilder builder;
  final bool enabled;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderShaderSamplerBuilderWidget(
      devicePixelRatio: MediaQuery.of(context).devicePixelRatio,
      builder: builder,
      enabled: enabled,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderShaderSamplerBuilderWidget renderObject,
  ) {
    renderObject
      ..devicePixelRatio = context.mediaQuery.devicePixelRatio
      ..builder = builder
      ..enabled = enabled;

    super.updateRenderObject(context, renderObject);
  }
}

class _RenderShaderSamplerBuilderWidget extends RenderProxyBox {
  _RenderShaderSamplerBuilderWidget({
    required double devicePixelRatio,
    required AnimatedSamplerBuilder builder,
    required bool enabled,
  }) : _devicePixelRatio = devicePixelRatio,
       _builder = builder,
       _enabled = enabled;

  double _devicePixelRatio;
  double get devicePixelRatio => _devicePixelRatio;
  set devicePixelRatio(double value) {
    if (value == devicePixelRatio) return;

    _devicePixelRatio = value;
    markNeedsCompositedLayerUpdate();
  }

  AnimatedSamplerBuilder _builder;
  AnimatedSamplerBuilder get builder => _builder;
  set builder(AnimatedSamplerBuilder value) {
    if (value == builder) {
      return;
    }
    _builder = value;
    markNeedsCompositedLayerUpdate();
  }

  bool _enabled;
  bool get enabled => _enabled;
  set enabled(bool value) {
    if (value == enabled) {
      return;
    }
    _enabled = value;
    markNeedsPaint();
    markNeedsCompositingBitsUpdate();
  }

  @override
  OffsetLayer updateCompositedLayer({
    required covariant _ShaderSamplerBuilderLayer? oldLayer,
  }) {
    final _ShaderSamplerBuilderLayer layer =
        oldLayer ?? _ShaderSamplerBuilderLayer(builder);

    layer
      ..callback = builder
      ..size = size
      ..devicePixelRatio = devicePixelRatio;
    return layer;
  }

  @override
  bool get isRepaintBoundary => alwaysNeedsCompositing;

  @override
  bool get alwaysNeedsCompositing => enabled;

  @override
  void paint(PaintingContext context, ui.Offset offset) {
    if (size.isEmpty || !_enabled) {
      return;
    }
    assert(offset == Offset.zero);
    return super.paint(context, offset);
  }
}

/// A [Layer] that uses an [AnimatedSamplerBuilder] to creat a [ui.Picture]
/// every time it is added to a scene.
class _ShaderSamplerBuilderLayer extends OffsetLayer {
  _ShaderSamplerBuilderLayer(this._callback);

  Size _size = Size.zero;
  Size get size => _size;
  set size(Size value) {
    if (value == size) {
      return;
    }
    _size = value;
    markNeedsAddToScene();
  }

  double _devicePixelRatio = 1.0;

  double get devicePixelRatio => _devicePixelRatio;
  set devicePixelRatio(double value) {
    if (value == devicePixelRatio) {
      return;
    }
    _devicePixelRatio = value;
    markNeedsAddToScene();
  }

  AnimatedSamplerBuilder _callback;
  AnimatedSamplerBuilder get callback => _callback;
  set callback(AnimatedSamplerBuilder value) {
    if (value == _callback) return;
    _callback = value;
    markNeedsAddToScene();
  }

  ui.Image _buildChildScene(Rect bounds, double pixelRatio) {
    final ui.SceneBuilder builder = ui.SceneBuilder();
    final Matrix4 transform = Matrix4.diagonal3Values(
      pixelRatio,
      pixelRatio,
      1,
    );

    builder.pushTransform(transform.storage);

    addChildrenToScene(builder);

    builder.pop();

    return builder.build().toImageSync(
      (pixelRatio * bounds.width).ceil(),
      (pixelRatio * bounds.height).ceil(),
    );
  }

  @override
  void addToScene(ui.SceneBuilder builder) {
    if (size.isEmpty) return;

    final ui.Image image = _buildChildScene(offset & size, devicePixelRatio);
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    try {
      callback(image, size, canvas);
    } finally {
      image.dispose();
    }

    final ui.Picture picture = pictureRecorder.endRecording();
    builder.addPicture(offset, picture);
  }
}

extension on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);
}
