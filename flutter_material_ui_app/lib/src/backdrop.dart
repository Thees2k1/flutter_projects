import 'package:flutter/material.dart';
import 'package:flutter_material_ui_app/src/models/product.dart';

const double _kFlingVelocity = 2.0;

class Backdrop extends StatefulWidget {
  const Backdrop({
    required this.currentCategory,
    required this.frontLayer,
    required this.backLayer,
    required this.frontTitle,
    required this.backTitle,
    super.key,
  });

  final Category currentCategory;
  final Widget frontLayer;
  final Widget backLayer;
  final Widget frontTitle;
  final Widget backTitle;

  @override
  State<Backdrop> createState() => _BackdropState();
}

class _BackdropState extends State<Backdrop>
    with SingleTickerProviderStateMixin {
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      value: 1,
      vsync: this,
    );
  }

  bool get _frontLayerVisible {
    final status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  void _toggleBackdropLayerVisibility() {
    _controller.fling(
      velocity: _frontLayerVisible ? -_kFlingVelocity : _kFlingVelocity,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      elevation: 0,
      titleSpacing: 0,
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: _toggleBackdropLayerVisibility,
      ),
      title: Text("SHRINE"),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, semanticLabel: 'search'),
          onPressed: () {
            print('Search button');
          },
        ),
        IconButton(
          icon: const Icon(Icons.tune, semanticLabel: 'filter'),
          onPressed: () {
            print('Filter button');
          },
        ),
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return _buildStack(context, constraints);
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    const double layerTitleHeight = 48.0;
    final Size layerSize = constraints.biggest;
    final double layerTop = layerSize.height - layerTitleHeight;

    final Animation<RelativeRect> layerAnimation = RelativeRectTween(
      begin: RelativeRect.fromLTRB(
        0.0,
        layerTop,
        0.0,
        layerTop - layerSize.height,
      ),
      end: const RelativeRect.fromLTRB(0, 0, 0, 0),
    ).animate(_controller.view);
    return Stack(
      key: _backdropKey,
      children: [
        ExcludeSemantics(
          excluding: _frontLayerVisible,
          child: widget.backLayer,
        ),
        PositionedTransition(
          rect: layerAnimation,
          child: _FrontLayer(child: widget.frontLayer),
        ),
      ],
    );
  }
}

class _FrontLayer extends StatelessWidget {
  const _FrontLayer({required this.child, this.ontap});

  final VoidCallback? ontap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 16.0,
      shape: const BeveledRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(46)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            child: Container(
              height: 40.0,
              alignment: AlignmentDirectional.centerStart,
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
