import 'package:arcore_flutter_plus/arcore_flutter_plus.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class AREmojiWorld extends StatefulWidget {
  const AREmojiWorld({super.key});

  @override
  State<AREmojiWorld> createState() => _AREmojiWorldState();
}

class _AREmojiWorldState extends State<AREmojiWorld> {
  ArCoreController? arCoreController;

  // Default Selected Model
  String selectedModel = "car.glb";

  final List<Map<String, String>> modelOptions = [
    {"name": "CAR", "icon": "🚗", "file": "car.glb"},
    {"name": "CAT", "icon": "🐱", "file": "cat.glb"},
    {"name": "TOM", "icon": "🐭", "file": "tom.glb"},
    {"name": "circle", "icon": "🟡", "file": "SHAPE_CIRCLE"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Multi-Model Placer'),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          ArCoreView(
            onArCoreViewCreated: _onArCoreViewCreated,
            enableTapRecognizer: true,
            enablePlaneRenderer: true,
            planeColor: Colors.red,
          ),

          // Selection UI
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: modelOptions.length,
                itemBuilder: (context, index) {
                  bool isSelected =
                      selectedModel == modelOptions[index]['file'];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedModel = modelOptions[index]['file']!;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 15),
                      width: 80,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.blueAccent
                            : Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          const BoxShadow(color: Colors.black26, blurRadius: 5),
                        ],
                        border: isSelected
                            ? Border.all(color: Colors.white, width: 3)
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            modelOptions[index]['icon']!,
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            modelOptions[index]['name']!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    arCoreController?.onPlaneTap = _handleOnPlaneTap;
  }

  // 2. Updated Tap Handler
  void _handleOnPlaneTap(List<ArCoreHitTestResult> hits) {
    if (hits.isEmpty) return;
    final hit = hits.first;
    final String nodeName = "node_${DateTime.now().millisecondsSinceEpoch}";

    if (selectedModel == "SHAPE_CIRCLE") {
      // Agar circle selected hai toh Package ki apni shape use karein
      final material = ArCoreMaterial(color: Colors.yellow, metallic: 1.0);
      final sphere = ArCoreCylinder(
        //try different shapes
        materials: [material],
        // radius: 0.1, // 10cm radius
        // height: 0.1,
      );
      final node = ArCoreNode(
        name: nodeName,
        shape: sphere,
        position: hit.pose.translation,
        rotation: hit.pose.rotation,
      );
      arCoreController?.addArCoreNode(node);
    } else {
      // Warna .glb model load karein
      final node = ArCoreReferenceNode(
        name: nodeName,
        object3DFileName: selectedModel,
        position: hit.pose.translation,
        rotation: hit.pose.rotation,
        scale: vector.Vector3(0.2, 0.2, 0.2),
      );
      arCoreController?.addArCoreNode(node);
    }
  }

  @override
  void dispose() {
    arCoreController?.dispose();
    super.dispose();
  }
}
