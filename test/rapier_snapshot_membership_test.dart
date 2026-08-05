import 'package:flutter_scene_rapier/flutter_scene_rapier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scene/physics.dart';
import 'package:vector_math/vector_math.dart';

void main() {
  test('restore rejects a snapshot after a body is created', () async {
    await RapierWorld.ensureInitialized();
    final world = RapierWorld(gravity: Vector3.zero());
    world.createBody(
      target: SimplePoseTarget(translation: Vector3.zero()),
      type: BodyType.dynamic_,
      additionalMass: 1,
    );
    final snapshot = world.snapshot();
    final added = world.createBody(
      target: SimplePoseTarget(translation: Vector3(2, 0, 0)),
      type: BodyType.dynamic_,
      additionalMass: 1,
    );

    expect(world.restore(snapshot), isFalse);
    expect(world.readBodyPose(added).$1.x, closeTo(2, 1e-6));
    world.dispose();
  });

  test('restore rejects a snapshot after a body is destroyed', () async {
    await RapierWorld.ensureInitialized();
    final world = RapierWorld(gravity: Vector3.zero());
    final original = world.createBody(
      target: SimplePoseTarget(translation: Vector3.zero()),
      type: BodyType.dynamic_,
      additionalMass: 1,
    );
    final snapshot = world.snapshot();
    world.destroyBody(original);

    expect(world.restore(snapshot), isFalse);
    world.dispose();
  });
}
