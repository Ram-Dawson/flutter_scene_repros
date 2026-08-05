# Updatable Mesh Shrink Evidence

These files support the parent [`Updatable Mesh Shrink`](../README.md)
reproduction. They are not a pixel-for-pixel comparison: the two captures were
taken at different cube counts. The behavioral verdict comes from the text
evidence and the device regression, not from image similarity.

| State | File | SHA-256 | Meaning |
| --- | --- | --- | --- |
| Upstream baseline | `android-before-range-error-ui.png` | `6E6AD280AFC070C2D72CEB9A41B6A5F7D8A0D7E8AB0EB0B1D6AF4D648C4E04DB` | Supporting UI sample; `before-range-error.txt` records the `RangeError`. |
| Fixed local engine | `android-fixed-live-update-ui.png` | `AFE84ED2FE24D0C6BA2845D0D289DC3C9CD28268B5FFA9AF2B411B335F9E622C` | Supporting post-fix UI sample at 26 cubes. `after-android-pass.txt` records the focused Android regression pass. |

The image files contain no source or machine-specific paths. When filing an
upstream Issue or PR, upload copies as GitHub attachments rather than linking to
local or private-repository paths.
