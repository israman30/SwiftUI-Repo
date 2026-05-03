# SwiftUI-Repo

Samples, blueprints, and reusable components for iOS development—focused on modern Swift/SwiftUI methodologies and patterns used to build **applications**, **frameworks**, and **playgrounds**.

### What this repo is

This repository is grounded in **samples and blueprints of iOS methodologies**, offering practical references that you can:

- **Study**: architecture, concurrency, networking, dependency injection, state management, and more
- **Reuse**: UI components and utilities
- **Prototype**: playground-driven experiments and spikes

### How to navigate

The root is organized by topic. Most folders are self-contained and may include:

- **Sample apps**: small focused projects that demonstrate an approach end-to-end
- **Blueprints**: minimal implementations that you can copy into a new project
- **Components**: reusable UI pieces, helpers, extensions, and utilities
- **Playgrounds**: quick experiments (look for `*.playground`)

Open the project/workspace inside a folder in Xcode and run it as usual. If a folder includes dependencies (e.g. CocoaPods / npm for a companion server), follow that folder’s local setup instructions.

---

### Arlo's Commit Notation Cheat Sheet

```
F!! | Feature > 8 LoC
F - | Feature <= 8 LoC
B!! | Bug Fix > 8 LoC
B - | Bug Fix <= 8 LoC
R!! | Non-provable refactoring
R - | Test-supported procedural refactoring
r - | Provable refactoring (automated, or from published recipe)
d - | Developer-visible documentation
a - | Automatic formatting/generation
e - | Environment (non-code) changes that affect development setup
t - | Test-only
_* | Known to be broken, or can't check now
note: Any commit message starting with # will be ignored
```

_source: [Arlo commit notation](https://github.com/RefactoringCombos/ArlosCommitNotation)_

### Xcode keyboard shortcuts

Keyboard shortcuts in Xcode are designed to streamline your workflow, enabling you to perform tasks more efficiently.

| key    | do   |
| -------- | ------- |
| Cmd + B  | Build project |
| Cmd + R  | Run project |
| Cmd + k | Clean project |
| Cmd + Shift + K | Clean build folder |
| Cmd + Shift + O | Search+open file |
| Cmd + Shift + L | Open Library |
| Cmd + F | Search line of in code |
| Cmd + G | Jump text to text in code |
| Cmd + Shift + F | Search within the project |
| Cmd + L | Search number of line of code |
| Ctrl + 6 | Search line of code |
| Opt + Cmd + <- | Fold block of code |
| Opt + Cmd + -> | Unfold block of code |
| Cmd + T | Open a new tab |
| Cmd + W | Close current tab |
| Cmd + Opt + [ or ] | Move line of code up/down |
| Shift + Cmd + Y | Open/close debuge console |
| Cmd + / | Comment code |
| Cmd + 0 | Open/close file navigator |
| Opt + Cmd + 0 | Open/close right navigator |
| Ctrl + i | Fix indentation |
| Opt + Cmd + / | Create documentation for functionality |
| Opt + Cmd + return | Hide/show canvas |
| Opt + Shift + Cmd + M | Hide/show mini map |
| Shift + Ctrl | Multiple inserts |
| Opt + drag down | add as many inserts |
| Cmd + arrows | Simulator orientation |
| Ctrl + M | Split a long expression |
| Cmd + M | hide window in tool bar |

---

### Contributing (policies & procedures)

Contributions are welcome as long as they align with the intent of the repository: **iOS learning assets** (samples, blueprints, and components).

#### Policies

- **Keep things focused**: each addition should demonstrate one concept or a small cohesive set of concepts.
- **No secrets or private keys**: do not commit `.env`, tokens, credentials, signing assets, or personal data.
- **Respect licensing**: only add code/assets you have the right to publish. If you add third‑party code, include attribution and ensure the license permits redistribution.
- **Avoid generated artifacts**: don’t commit `DerivedData`, build outputs, or other machine-specific files.

#### Procedure

1. **Create a branch** off the default branch (e.g. `feature/<topic>` or `fix/<topic>`).
2. **Make the change** in the most relevant topic folder (or create a new one if needed).
3. **Keep it runnable**:
   - If it’s an Xcode project: it should build with a current Xcode version.
   - If it’s a playground: it should run without extra manual steps.
4. **Use the commit notation** above for commit messages.
5. **Open a PR** with:
   - what you added/changed and why
   - how to run/validate it (steps or notes)

By submitting a contribution, you agree that your work may be used, modified, and redistributed as part of this repository.

---

### Copyright

© 2021–2026 Israel Manzo. All rights reserved.

Third‑party dependencies included inside some sample projects remain under their respective licenses.
