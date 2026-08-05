# Rapier Snapshot Membership

This case verifies that a `RapierWorld` snapshot cannot restore native state
after Dart body membership changes. Native Rapier snapshots preserve body
handles, but they cannot recreate the Dart pose targets that own those handles.

## Run

Resolve the engine revision pinned in `pubspec.yaml`:

```text
fvm flutter pub get
```

Open the catalog and choose **Rapier Snapshot Membership**:

```text
fvm flutter run --enable-flutter-gpu --enable-impeller
```

On the page, take a snapshot and then either add a body or destroy the
original body. **Restore snapshot** must report that the operation was
rejected. Use the reset action between the two paths.

The state diagram makes the ownership boundary explicit. Before restore, the
snapshot membership and native restore target remain `[A]`, while the Dart
registry can become `[A, B]` or `[]`. A fixed revision rejects the operation
and keeps native membership aligned with the current Dart registry.

Run the focused host-native regression:

```text
fvm flutter test test/rapier_snapshot_membership_test.dart
```

## Version Comparison

| Engine revision | Expected result |
| --- | --- |
| `2d4decc` | `restore()` accepts a changed body set, allowing Dart and native membership to diverge. |
| `3a91964` | `restore()` rejects changed membership before native state is modified. |

This baseline tag is pinned to `2d4decc`, the parent of
[`fix/rapier-snapshot-membership`](https://github.com/Ram-Dawson/flutter_scene/tree/fix/rapier-snapshot-membership).
The focused regression is expected to fail because it asserts the fixed
contract. It is a state-contract case: no screenshot is required to establish
the behavioral result.
