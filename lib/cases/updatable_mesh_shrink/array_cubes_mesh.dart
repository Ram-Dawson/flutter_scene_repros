import 'dart:typed_data';

import 'package:flutter_scene/scene.dart';

MeshData buildArrayCubesMeshData({required int count, double spacing = 1.5}) {
  if (count < 1) {
    throw ArgumentError.value(count, 'count', 'must be at least 1');
  }

  final positions = <double>[];
  final indices = <int>[];
  final firstCenter = -((count - 1) * spacing) / 2;
  for (var cube = 0; cube < count; cube += 1) {
    final vertexOffset = positions.length ~/ 3;
    positions.addAll(_cubePositions(firstCenter + cube * spacing));
    indices.addAll(_cubeIndices.map((index) => vertexOffset + index));
  }

  return MeshData.build(
    positions: Float32List.fromList(positions),
    indices: indices,
  );
}

const _cubeIndices = <int>[
  0,
  2,
  1,
  0,
  3,
  2,
  4,
  5,
  6,
  4,
  6,
  7,
  0,
  1,
  5,
  0,
  5,
  4,
  1,
  2,
  6,
  1,
  6,
  5,
  2,
  3,
  7,
  2,
  7,
  6,
  3,
  0,
  4,
  3,
  4,
  7,
];

List<double> _cubePositions(double centerX) {
  const half = 0.5;
  final minimumX = centerX - half;
  final maximumX = centerX + half;
  return [
    minimumX,
    -half,
    -half,
    maximumX,
    -half,
    -half,
    maximumX,
    half,
    -half,
    minimumX,
    half,
    -half,
    minimumX,
    -half,
    half,
    maximumX,
    -half,
    half,
    maximumX,
    half,
    half,
    minimumX,
    half,
    half,
  ];
}
