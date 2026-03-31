import 'dart:math' as math;

import 'package:arcore_flutter_plus/arcore_flutter_plus.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

import '../styles/app_styles.dart';

class ArDistanceMeasurerViewModal extends ChangeNotifier {
  static const String initialDistanceText = "Tap on floor to place marks";
  static const String resetText = "Marks reset. Tap on floor again.";
  ArCoreNode? _startNode;
  ArCoreNode? get startNode => _startNode;
  set startNode(ArCoreNode? newValue) {
    _startNode = newValue;
    notifyListeners();
  }

  ArCoreNode? _endNode;
  ArCoreNode? get endNode => _endNode;
  set endNode(ArCoreNode? newValue) {
    _endNode = newValue;
    notifyListeners();
  }

  String _distanceText = initialDistanceText;
  String get distanceText => _distanceText;
  set distanceText(String newText) {
    _distanceText = newText;
    notifyListeners();
  }

  void reset() {
    _startNode = null;
    _endNode = null;
    distanceText = resetText;
    notifyListeners();
  }

  void calculateDistance() {
    if (startNode == null || endNode == null) return;

    // .value lagana zaroori hai kyunki position ek ValueNotifier hai
    final startPos = startNode!.position!.value;
    final endPos = endNode!.position!.value;

    // Distance Formula implementation
    double dx = endPos.x - startPos.x;
    double dy = endPos.y - startPos.y;
    double dz = endPos.z - startPos.z;

    // math.sqrt use  as prefix imported hai
    double distance = math.sqrt(dx * dx + dy * dy + dz * dz);

    distanceText = "Distance: ${(distance * 100).toStringAsFixed(2)} cm";
    notifyListeners();
  }
}

class ArDistanceMeasurer extends StatefulWidget {
  const ArDistanceMeasurer({super.key, required this.viewModal});

  final ArDistanceMeasurerViewModal viewModal;

  @override
  State<ArDistanceMeasurer> createState() => _RrDistanceMeasurerState();
}

class _RrDistanceMeasurerState extends State<ArDistanceMeasurer> {
  ArCoreController? arCoreController;

  late final ArDistanceMeasurerViewModal _vm;

  ArCoreNode? get startNode => _vm.startNode;
  ArCoreNode? get endNode => _vm.endNode;
  String get distanceText => _vm.distanceText;

  static MaterialPageRoute getRoute(ArDistanceMeasurerViewModal viewModal) =>
      MaterialPageRoute(
        builder: (context) => ArDistanceMeasurer(viewModal: viewModal),
      );

  @override
  void initState() {
    _vm = widget.viewModal;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AR Distance Meter")),
      body: Stack(
        children: [
          ArCoreView(
            onArCoreViewCreated: _onArCoreViewCreated,
            enableTapRecognizer: true,
            enablePlaneRenderer: true,
            planeColor: Colors.red,
          ),

          Positioned(
            top: 50,
            left: 20,

            child: Container(
              padding: .all(12),
              color: Colors.black54,
              child: Text(distanceText, style: AppStyles.bodyText),
            ),
          ),

          Positioned(
            bottom: 30,
            left: 20,
            child: FloatingActionButton(
              onPressed: _resetMarks,
              child: const Icon(Icons.refresh),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    arCoreController?.dispose();
    super.dispose();
  }

  void _resetMarks() {
    if (startNode != null) {
      arCoreController?.removeNode(nodeName: startNode!.name);
    }
    if (endNode != null) {
      arCoreController?.removeNode(nodeName: endNode!.name);
    }

    _vm.reset();
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    arCoreController?.onPlaneTap = _handlePlaneTapped;
  }

  void _handlePlaneTapped(List<ArCoreHitTestResult> hits) {
    if (hits.isEmpty) return;

    final hit = hits.first;

    if (startNode == null) {
      _vm.startNode = _createMark(hit.pose.translation, Colors.red);
      arCoreController?.addArCoreNode(startNode!);

      _vm.distanceText = "First mark placed. Tap for second mark.";
    } else if (endNode == null) {
      _vm.endNode = _createMark(hit.pose.translation, Colors.blue);
      arCoreController?.addArCoreNode(endNode!);

      _vm.calculateDistance();
    }
  }

  ArCoreNode _createMark(vector.Vector3 position, Color color) {
    final material = ArCoreMaterial(color: color, metallic: 1.0);
    final sphere = ArCoreSphere(materials: [material], radius: 0.03);
    return ArCoreNode(shape: sphere, position: position);
  }
}
