# SwiftUI-Repo

Samples, blueprints, and reusable components for iOS development—focused on modern Swift/SwiftUI methodologies and patterns used to build **applications**, **frameworks**, and **playgrounds**.

### Technologies / Tags

`Swift` · `iOS` · `SwiftUI` · `Combine` · `Swift Concurrency (async/await)` · `SwiftData` · `URLSession` · `Core Data` · `MapKit` · `PencilKit` · `The Composable Architecture (TCA)`

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

### Components index

Each item below includes a one-sentence description and a direct link to its implementation in this repo.

#### Topic folders (apps, blueprints, components)

- **[AI](AI/)**: AI-focused experiments and sample integrations (e.g. Gemini).
- **[API](API/)**: Networking/API-layer recipes and sample implementations.
- **[Actors](Actors/)**: Actor isolation and concurrency examples.
- **[Alert Component](<Alert Component/>)**: Reusable alert patterns and sample implementations.
- **[Analytics System Track Event](<Analytics System Track Event/>)**: A small analytics/event-tracking system sample.
- **[Animations](Animations/)**: SwiftUI animation samples and UI micro-interactions.
- **[App Modules](<App Modules/>)**: Modular app/workspace examples with separated targets/modules.
- **[App State](<App State/>)**: State management patterns, including loading data and data flow.
- **[Architecture](Architecture/)**: Architecture blueprints and patterns (e.g. MVVM, clean/container approaches).
- **[Auth](Auth/)**: Authentication flows and patterns, including JWT-based auth.
- **[Calendars](Calendars/)**: Calendar UI and date-related samples.
- **[Canvas Background Page Style](<Canvas Background Page Style/>)**: Page/background styling samples for SwiftUI.
- **[Chart Swift](<Chart Swift/>)**: Swift Charts examples and chart-driven UI samples.
- **[Code Editor](<Code Editor/>)**: A lightweight code editor UI sample.
- **[Color Mixer](<Color Mixer/>)**: A color-mixing UI sample (picker/mixer style tools).
- **[Combine](Combine/)**: Combine operators and reactive patterns in practice.
- **[Concurrency](Concurrency/)**: Concurrency patterns and guides (tasks, structured concurrency, etc.).
- **[Custom Components](<Custom Components/>)**: A collection of reusable SwiftUI components (cards, toasts, badges, etc.).
- **[Deep Link](<Deep Link/>)**: Deep linking sample app and routing patterns.
- **[Dependency Injection](<Dependency Injection/>)**: Dependency Injection techniques (modules, unit testing, async/await variants).
- **[Design Pattern](<Design Pattern/>)**: Design-pattern samples and playground-based references.
- **[Dynamic Types](<Dynamic Types/>)**: Dynamic Type/typography and accessibility scaling examples.
- **[Enums](Enums/)**: Enum patterns and small focused samples.
- **[Grids View](<Grids View/>)**: Grid layout samples using SwiftUI.
- **[Haptics Manager](<Haptics Manager/>)**: Haptic feedback wrapper(s) with usage examples.
- **[Image Handler (Download+Cache)](<Image Handler (Download+Cache)/>)**: Image downloading and caching patterns/utilities.
- **[Keychain](Keychain/)**: Keychain usage samples and storage patterns.
- **[Like Heart](<Like Heart/>)**: A “like” heart UI component/sample with animation.
- **[MapKit Autocomplete](<MapKit Autocomplete/>)**: MapKit autocomplete/search UI sample.
- **[Memory Usage Implementation](<Memory Usage Implementation/>)**: Memory usage monitoring/profiling sample.
- **[Navigation](Navigation/)**: Navigation patterns (NavigationStack, coordinators, routing, deep linking).
- **[Networking](Networking/)**: Networking layer samples (auth, async/await, Combine, and Alamofire variants).
- **[Observable Macro](<Observable Macro/>)**: Swift `@Observable` macro samples and usage patterns.
- **[PDF Loader](<PDF Loader/>)**: PDF loading/viewing sample app.
- **[Pagination](Pagination/)**: Pagination patterns and example implementations.
- **[Pencil Kit Framework](<Pencil Kit Framework/>)**: PencilKit-based framework-style sample project.
- **[PencilKit](PencilKit/)**: PencilKit drawing sample app.
- **[RGB generator](<RGB generator/>)**: RGB/color generation UI sample.
- **[Rating Hearts](<Rating Hearts/>)**: Rating component sample using hearts.
- **[Rating Stars](<Rating Stars/>)**: Rating component sample using stars.
- **[SOLID principle](<SOLID principle/>)**: SOLID-focused examples and clean-code references.
- **[Scene Phase](<Scene Phase/>)**: App lifecycle examples using scene phase handling.
- **[Search](<Search%20/>)**: Search UI samples, including Combine-driven search patterns.
- **[Segmented Control](<Segmented Control/>)**: Custom segmented control UI sample.
- **[Server Driven UI Components](<Server Driven UI Components/>)**: Server-driven UI demo with a Swift client and companion server.
- **[Store JSON in Core Data](<Store JSON in Core Data/>)**: Fetch JSON from an API and persist it into Core Data.
- **[Swift Test](<Swift Test/>)**: Swift/Xcode testing samples.
- **[SwiftData](SwiftData/)**: SwiftData CRUD and relationship samples.
- **[Text Styles](<Text Styles/>)**: Typography and text-style component samples.
- **[The Composable Architecture (TCA)](<The Composable Architecture (TCA)/>)**: Examples built with Point-Free’s Composable Architecture.
- **[Timer](Timer/)**: Timer utilities/modifiers and time-formatting samples.
- **[UI Extensions](<UI Extensions/>)**: Reusable UI extensions and layout helpers.
- **[URLSession](URLSession/)**: URLSession configuration and usage examples.
- **[Utils](Utils/)**: Small reusable utilities and helper components.
- **[VIPER](VIPER/)**: VIPER architecture samples.
- **[Video Player](<Video Player/>)**: Video playback sample app.
- **[View Modifiers](<View Modifiers/>)**: Custom SwiftUI view modifiers and accessibility-related components.
- **[Wifi Connection](<Wifi Connection/>)**: Network/Wi‑Fi connectivity samples.
- **[async:await](<async:await/>)**: Focused async/await examples and patterns.

#### Playgrounds (quick experiments)

- **[Any.playground](Any.playground/)**: Quick experiments around Swift’s `Any`/type-erasure concepts.
- **[CodingKeys+Coders.playground](<CodingKeys+Coders.playground/>)**: Codable patterns using `CodingKeys` and custom encoders/decoders.
- **[Flattening Nested JSON with Codable.playground](<Flattening Nested JSON with Codable.playground/>)**: Techniques for decoding and flattening nested JSON with `Codable`.
- **[HexConverter.playground](HexConverter.playground/)**: Hex/string conversion experiments and helpers.
- **[Logger.playground](Logger.playground/)**: Lightweight logging experiments and patterns.
- **[Macros and Wrappers.playground](<Macros and Wrappers.playground/>)**: Swift macros/property-wrapper style experiments.
- **[Nada.playground](Nada.playground/)**: Scratch playground for quick spikes and ideas.
- **[Naming convention.playground](<Naming convention.playground/>)**: Naming conventions and style experiments.
- **[Simply code.playground](<Simply code.playground/>)**: Small, focused Swift snippets and experiments.
- **[Swift Initializers.playground](<Swift Initializers.playground/>)**: Initializer patterns and Swift initialization behavior experiments.

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
