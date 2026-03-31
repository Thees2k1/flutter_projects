import 'dart:ui' as ui;
import 'package:drawing_app/src/domain/domain.dart';
import 'package:drawing_app/src/shared/theme/theme.dart';
import 'package:flutter/material.dart';

import '../notifiers/notifiers.dart';
import '../widgets/widgets.dart';

class DrawingPage extends StatefulWidget {
  const DrawingPage({super.key});

  @override
  State<DrawingPage> createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final UndoRedoStack undoRedoStack;

  final ValueNotifier<Color> selectedColor = ValueNotifier(Colors.black);
  final strokeSize = ValueNotifier(10.0);
  final eraserSize = ValueNotifier(30.0);
  final drawingTool = ValueNotifier(DrawingTool.pencil);
  final canvasKey = GlobalKey();
  final filled = ValueNotifier(false);
  final polygonSides = ValueNotifier(3);
  final backgroundImage = ValueNotifier<ui.Image?>(null);
  final currentStroke = CurrentStrokeNotifier();
  final allStrokes = ValueNotifier<List<Stroke>>([]);
  final showGrid = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    undoRedoStack = UndoRedoStack(
      strokesNotifier: allStrokes,
      currentStrokeNotifier: currentStroke,
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    undoRedoStack.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.canvasColor,
      body: HotKeyListener(
        onRedo: undoRedoStack.redo,
        onUndo: undoRedoStack.undo,
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: Listenable.merge([
                currentStroke,
                allStrokes,
                selectedColor,
                strokeSize,
                eraserSize,
                drawingTool,
                filled,
                polygonSides,
                backgroundImage,
                showGrid,
              ]),
              builder: (context, child) {
                return DrawingCanvas(
                  options: DrawingCanvasOptions(
                    currentTool: drawingTool.value,
                    size: strokeSize.value,
                    strokeColor: selectedColor.value,
                    backgroundColor: Palette.canvasColor,
                    polygonSides: polygonSides.value,
                    showGrid: showGrid.value,
                    fillShape: filled.value,
                  ),
                  canvasKey: canvasKey,
                  currentStrokeListenable: currentStroke,
                  strokesListenable: allStrokes,
                  backgroundImageListenable: backgroundImage,
                  onDrawingStrokeChanged: (val) {
                    debugPrint(val.toString());
                  },
                );
              },
            ),
            Positioned(
              top: kToolbarHeight + 10,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(-1, 0),
                  end: Offset.zero,
                ).animate(animationController),
                child: CanvasSideBar(
                  drawingTool: drawingTool,
                  selectedColor: selectedColor,
                  strokeSize: strokeSize,
                  eraserSize: eraserSize,

                  currentSketch: currentStroke,
                  allSketches: allStrokes,
                  canvasGlobalKey: canvasKey,
                  filled: filled,
                  polygonSides: polygonSides,
                  backgroundImage: backgroundImage,
                  undoRedoStack: undoRedoStack,
                  showGrid: showGrid,
                ),
              ),
            ),
            _CustomAppBar(animationController: animationController),
          ],
        ),
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  const _CustomAppBar({required this.animationController});

  final AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight,
      width: double.maxFinite,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                if (animationController.value == 0) {
                  animationController.forward();
                } else {
                  animationController.reverse();
                }
              },
              icon: const Icon(Icons.menu),
            ),
            const Text(
              'Let\'s Draw',
              style: TextStyle(fontWeight: .bold, fontSize: 19),
            ),
            const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
