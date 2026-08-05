import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_scene/scene.dart';
import 'package:vector_math/vector_math.dart';

import 'array_cubes_mesh.dart';

class UpdatableMeshShrinkPage extends StatefulWidget {
  const UpdatableMeshShrinkPage({super.key});

  @override
  State<UpdatableMeshShrinkPage> createState() =>
      _UpdatableMeshShrinkPageState();
}

class _UpdatableMeshShrinkPageState extends State<UpdatableMeshShrinkPage> {
  late final Future<void> _ready;
  Scene? _scene;
  MeshGeometry? _geometry;
  var _count = 64;
  var _rebuildDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _ready = _initialize();
  }

  Future<void> _initialize() async {
    await Scene.initializeStaticResources();
    _scene = Scene();
    _rebuildGeometry(64);
  }

  void _rebuildGeometry(int count) {
    final stopwatch = Stopwatch()..start();
    final meshData = buildArrayCubesMeshData(count: count);
    final geometry = _geometry;
    if (geometry == null) {
      final newGeometry = MeshGeometry.fromMeshData(
        meshData,
        storage: GeometryStorage.updatable,
      );
      _scene!.add(
        Node(
          mesh: Mesh(
            newGeometry,
            UnlitMaterial()..baseColorFactor = Vector4(0.16, 0.86, 0.76, 1),
          ),
        ),
      );
      _geometry = newGeometry;
    } else {
      geometry.applyMeshData(meshData);
    }
    stopwatch.stop();
    _count = count;
    _rebuildDuration = stopwatch.elapsed;
  }

  void _updateCount(double value) {
    setState(() => _rebuildGeometry(value.round()));
  }

  PerspectiveCamera _camera() {
    final extent = math.max(6.0, (_count - 1) * 1.5 + 5.0);
    return PerspectiveCamera(
      position: Vector3(0, extent * 0.38, -extent),
      target: Vector3.zero(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Updatable Mesh Shrink')),
      body: FutureBuilder<void>(
        future: _ready,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          return Stack(
            children: [
              Positioned.fill(
                child: SceneView(_scene!, camera: _camera(), autoTick: false),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: _Controls(
                  count: _count,
                  rebuildDuration: _rebuildDuration,
                  onCountChanged: _updateCount,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({
    required this.count,
    required this.rebuildDuration,
    required this.onCountChanged,
  });

  final int count;
  final Duration rebuildDuration;
  final ValueChanged<double> onCountChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 520,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xee182225),
        border: Border.all(color: const Color(0xff334447)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text('Count'),
              const Spacer(),
              Text('$count cubes'),
            ],
          ),
          Slider(
            value: count.toDouble(),
            min: 1,
            max: 64,
            divisions: 63,
            onChanged: onCountChanged,
          ),
          Row(
            children: [
              Text('Last rebuild: ${rebuildDuration.inMicroseconds} us'),
            ],
          ),
        ],
      ),
    );
  }
}
