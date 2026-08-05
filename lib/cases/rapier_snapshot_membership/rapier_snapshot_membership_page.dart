import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scene_rapier/flutter_scene_rapier.dart';
import 'package:scene/physics.dart';
import 'package:vector_math/vector_math.dart';

class RapierSnapshotMembershipPage extends StatefulWidget {
  const RapierSnapshotMembershipPage({super.key});

  @override
  State<RapierSnapshotMembershipPage> createState() =>
      _RapierSnapshotMembershipPageState();
}

class _RapierSnapshotMembershipPageState
    extends State<RapierSnapshotMembershipPage> {
  late final Future<void> _ready;
  RapierWorld? _world;
  Uint8List? _snapshot;
  int? _originalBody;
  final _members = <String>['A'];
  List<String>? _snapshotMembers;
  var _nextBodyIndex = 1;
  bool? _restoreAccepted;
  var _restoreResult = 'Take a snapshot, then change body membership.';

  @override
  void initState() {
    super.initState();
    _ready = _initialize();
  }

  Future<void> _initialize() async {
    await RapierWorld.ensureInitialized();
    final world = RapierWorld(gravity: Vector3.zero());
    _world = world;
    _originalBody = _createBody(world, Vector3.zero());
  }

  int _createBody(RapierWorld world, Vector3 position) {
    return world.createBody(
      target: SimplePoseTarget(translation: position),
      type: BodyType.dynamic_,
      additionalMass: 1,
    );
  }

  void _takeSnapshot() {
    setState(() {
      _snapshot = _world!.snapshot();
      _snapshotMembers = List.of(_members);
      _restoreAccepted = null;
      _restoreResult = 'Snapshot captured with ${_members.length} body.';
    });
  }

  void _addBody() {
    final world = _world!;
    setState(() {
      _createBody(world, Vector3(2, 0, 0));
      _members.add(String.fromCharCode(65 + _nextBodyIndex));
      _nextBodyIndex++;
      _restoreAccepted = null;
      _restoreResult = 'A body was created after the snapshot.';
    });
  }

  void _removeOriginalBody() {
    final body = _originalBody;
    if (body == null) return;
    setState(() {
      _world!.destroyBody(body);
      _originalBody = null;
      _members.remove('A');
      _restoreAccepted = null;
      _restoreResult = 'The original body was destroyed after the snapshot.';
    });
  }

  void _restoreSnapshot() {
    final membershipChanged = !listEquals(_snapshotMembers, _members);
    final restored = _world!.restore(_snapshot!);
    setState(() {
      _restoreAccepted = restored;
      _restoreResult = switch ((restored, membershipChanged)) {
        (true, true) =>
          'Restore accepted despite changed membership: baseline bug reproduced.',
        (true, false) => 'Restore accepted: body membership is unchanged.',
        (false, true) =>
          'Restore rejected after membership changed; native and Dart remain aligned.',
        (false, false) =>
          'Restore rejected although body membership is unchanged.',
      };
    });
  }

  void _reset() {
    _world?.dispose();
    setState(() {
      final world = RapierWorld(gravity: Vector3.zero());
      _world = world;
      _originalBody = _createBody(world, Vector3.zero());
      _snapshot = null;
      _members
        ..clear()
        ..add('A');
      _snapshotMembers = null;
      _nextBodyIndex = 1;
      _restoreAccepted = null;
      _restoreResult = 'Take a snapshot, then change body membership.';
    });
  }

  @override
  void dispose() {
    _world?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rapier Snapshot Membership'),
        actions: [
          IconButton(
            tooltip: 'Reset scenario',
            onPressed: _world == null ? null : _reset,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: _ready,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          return _SnapshotPanel(
            currentMembers: _members,
            snapshotMembers: _snapshotMembers,
            restoreAccepted: _restoreAccepted,
            hasSnapshot: _snapshot != null,
            hasOriginalBody: _originalBody != null,
            restoreResult: _restoreResult,
            onSnapshot: _takeSnapshot,
            onAddBody: _snapshot == null ? null : _addBody,
            onDestroyOriginal: _snapshot == null || _originalBody == null
                ? null
                : _removeOriginalBody,
            onRestore: _snapshot == null ? null : _restoreSnapshot,
          );
        },
      ),
    );
  }
}

class _SnapshotPanel extends StatelessWidget {
  const _SnapshotPanel({
    required this.currentMembers,
    required this.snapshotMembers,
    required this.restoreAccepted,
    required this.hasSnapshot,
    required this.hasOriginalBody,
    required this.restoreResult,
    required this.onSnapshot,
    required this.onAddBody,
    required this.onDestroyOriginal,
    required this.onRestore,
  });

  final List<String> currentMembers;
  final List<String>? snapshotMembers;
  final bool? restoreAccepted;
  final bool hasSnapshot;
  final bool hasOriginalBody;
  final String restoreResult;
  final VoidCallback onSnapshot;
  final VoidCallback? onAddBody;
  final VoidCallback? onDestroyOriginal;
  final VoidCallback? onRestore;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Native and Dart body membership',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text('Current Dart body count: ${currentMembers.length}'),
              Text('Snapshot: ${hasSnapshot ? 'captured' : 'not captured'}'),
              Text(
                'Original body: ${hasOriginalBody ? 'present' : 'destroyed'}',
              ),
              if (snapshotMembers != null) ...[
                const SizedBox(height: 20),
                _MembershipDiagram(
                  snapshotMembers: snapshotMembers!,
                  currentMembers: currentMembers,
                  restoreAccepted: restoreAccepted,
                ),
              ],
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(
                    onPressed: onSnapshot,
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text('Snapshot world'),
                  ),
                  OutlinedButton.icon(
                    onPressed: onAddBody,
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('Add body'),
                  ),
                  OutlinedButton.icon(
                    onPressed: onDestroyOriginal,
                    icon: const Icon(Icons.remove_circle_outline),
                    label: const Text('Destroy original'),
                  ),
                  FilledButton.icon(
                    onPressed: onRestore,
                    icon: const Icon(Icons.settings_backup_restore),
                    label: const Text('Restore snapshot'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  border: Border.all(color: scheme.outlineVariant),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(restoreResult),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MembershipDiagram extends StatelessWidget {
  const _MembershipDiagram({
    required this.snapshotMembers,
    required this.currentMembers,
    required this.restoreAccepted,
  });

  final List<String> snapshotMembers;
  final List<String> currentMembers;
  final bool? restoreAccepted;

  @override
  Widget build(BuildContext context) {
    final nativeLabel = switch (restoreAccepted) {
      null => 'Native restore target',
      true => 'Native after accepted restore',
      false => 'Native after rejected restore',
    };
    final nativeMembers = restoreAccepted == false
        ? currentMembers
        : snapshotMembers;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _MembershipState('Snapshot membership', snapshotMembers),
          const Icon(Icons.arrow_forward),
          _MembershipState('Dart registry', currentMembers),
          const Icon(Icons.arrow_forward),
          _MembershipState(nativeLabel, nativeMembers),
        ],
      ),
    );
  }
}

class _MembershipState extends StatelessWidget {
  const _MembershipState(this.label, this.members);

  final String label;
  final List<String> members;

  @override
  Widget build(BuildContext context) {
    return Text('$label: [${members.join(', ')}]');
  }
}
