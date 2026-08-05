# Flutter Scene Repros

This repository is a public catalog of minimal, device-testable `flutter_scene` reproductions. `main` contains only a runnable Flutter catalog shell; each runnable case lives on its own `case/<id>` branch so its Flutter and package dependency pins cannot affect another case.

## Cases

| Case | Runnable branch | Before tag | Fixed tag | Verification boundary |
| --- | --- | --- | --- | --- |
| Updatable Mesh Shrink | [`case/updatable-mesh-shrink`](https://github.com/Ram-Dawson/flutter_scene_repros/tree/case/updatable-mesh-shrink) | [`repro/updatable-mesh-shrink-before`](https://github.com/Ram-Dawson/flutter_scene_repros/tree/repro/updatable-mesh-shrink-before) | [`repro/updatable-mesh-shrink-fixed`](https://github.com/Ram-Dawson/flutter_scene_repros/tree/repro/updatable-mesh-shrink-fixed) | Android GPU upload regression: `64 -> 1 -> 64` mesh update. |
| Rapier Snapshot Membership | [`case/rapier-snapshot-membership`](https://github.com/Ram-Dawson/flutter_scene_repros/tree/case/rapier-snapshot-membership) | [`repro/rapier-snapshot-membership-before`](https://github.com/Ram-Dawson/flutter_scene_repros/tree/repro/rapier-snapshot-membership-before) | [`repro/rapier-snapshot-membership-fixed`](https://github.com/Ram-Dawson/flutter_scene_repros/tree/repro/rapier-snapshot-membership-fixed) | Snapshot restore must reject body membership changes. |

## Use A Case

Check out its fixed tag to build the manual verification APK:

```powershell
git checkout repro/<case-id>-fixed
fvm flutter pub get
fvm flutter build apk --debug
```

Check out the matching `before` tag to observe the historical behavior. A baseline tag may intentionally fail its focused regression test; its case README states the expected result and the manual verification steps.

## Maintenance Rule

1. Develop an unrelated reproduction on `case/<id>`.
2. Pin every `flutter_scene` monorepo package used by that case to one identical Git revision.
3. Create immutable `repro/<id>-before` and `repro/<id>-fixed` tags after validating each dependency state.
4. Add the case to this table only after its branch, tags, and README are ready.

Keep `main` limited to the catalog shell and Flutter base dependencies. Add a case's `flutter_scene` packages, exact revision pins, page, tests, and evidence only in its own branch.
