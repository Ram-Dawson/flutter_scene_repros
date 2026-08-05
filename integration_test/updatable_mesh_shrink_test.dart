import 'package:flutter/material.dart';
import 'package:flutter_scene/scene.dart';
import 'package:flutter_scene_repros/cases/updatable_mesh_shrink/array_cubes_mesh.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('updatable mesh survives shrinking and regrowing', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: SizedBox.expand())),
    );
    await tester.pump();
    await Scene.initializeStaticResources();

    final first = buildArrayCubesMeshData(count: 64);
    final geometry = MeshGeometry.fromMeshData(
      first,
      storage: GeometryStorage.updatable,
    );
    geometry.applyMeshData(buildArrayCubesMeshData(count: 1));
    geometry.applyMeshData(buildArrayCubesMeshData(count: 64));

    expect(geometry.vertexCount, 512);
  });
}
