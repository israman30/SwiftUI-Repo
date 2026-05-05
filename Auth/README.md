## Auth (SwiftUI)

This folder contains **two SwiftUI authentication samples** that demonstrate JWT-based sessions with different goals:

- **`Login with JWT`**: Real backend integration + **Keychain** storage + refresh-if-needed.
- **`JWT Auth`**: Learning/demo app that generates a **mock JWT** locally, stores it in **UserDefaults**, schedules refresh, and retries requests on 401.

## Projects in this folder

### 1) Login with JWT (backend + Keychain)

- **What it shows**: Email/password login against your API, storing tokens securely in Keychain, and using Bearer tokens for authorized requests (with proactive refresh).
- **When to use**: You have (or are building) an auth backend and want a realistic client-side structure.

#### Key components (with file links)

- **App entry**
  - [`Login_with_JWTApp.swift`](Login%20with%20JWT/Login%20with%20JWT/Login_with_JWTApp.swift)
- **Routing**
  - [`RootView.swift`](Login%20with%20JWT/Login%20with%20JWT/RootView.swift): switches between `LoginView` and `ContentView`, and calls `refreshIfNeeded()` on launch.
- **Login UI**
  - [`LoginView.swift`](Login%20with%20JWT/Login%20with%20JWT/LoginView.swift): form bound to `LoginViewModel`.
- **State / MVVM**
  - [`LoginViewModel.swift`](Login%20with%20JWT/Login%20with%20JWT/LoginViewModel.swift): holds UI state + `isAuthenticated`, calls `AuthApi`, persists via `TokenManager`.
- **Post-login UI**
  - [`ContentView.swift`](Login%20with%20JWT/Login%20with%20JWT/ContentView.swift): shows decoded token info, refresh, logout.

#### JWT/session implementation

- **Auth API calls**
  - [`AuthAPI.swift`](Login%20with%20JWT/Login%20with%20JWT/JWT/AuthAPI.swift)
    - `POST /auth/login` → returns `JWToken`
    - `POST /auth/refresh` → returns `JWToken`
    - **Configure** your base URL in `Constants.endpoint`.
- **Token model + payload decode (display only)**
  - [`JWToken.swift`](Login%20with%20JWT/Login%20with%20JWT/JWT/JWToken.swift): computes expiry, decodes JWT payload for UI display (does **not** verify signatures).
- **Secure persistence + refresh decisions**
  - [`TokenManager.swift`](Login%20with%20JWT/Login%20with%20JWT/JWT/TokenManager.swift): reads/writes `JWToken` via Keychain and refreshes shortly before expiry.
- **Keychain wrapper**
  - [`KeychainManager.swift`](Login%20with%20JWT/Login%20with%20JWT/JWT/KeychainManager.swift): JSON-encodes values and stores them with `kSecAttrAccessibleWhenUnlockedThisDeviceOnly`.
- **Errors surfaced to UI**
  - [`AuthError.swift`](Login%20with%20JWT/Login%20with%20JWT/JWT/AuthError.swift)

#### Authorized networking example

- [`NetworkServices.swift`](Login%20with%20JWT/Login%20with%20JWT/NetworkServices/NetworkServices.swift): refreshes opportunistically and attaches `Authorization: Bearer ...` headers.

#### More documentation

- See the per-project doc: [`Login with JWT/README.md`](Login%20with%20JWT/README.md)

---

### 2) JWT Auth (mock JWT + refresh loop + request retry)

- **What it shows**: A complete “auth-shaped” app without a backend dependency:
  - mint a JWT-shaped token locally
  - decode claims locally for display
  - refresh before expiry
  - attach Bearer tokens to requests and retry once on 401
- **When to use**: You want to learn the moving pieces (token minting/decoding, refresh scheduling, request retry) without setting up a server.

#### Key components (with file links)

- **App entry**
  - [`JWT_AuthApp.swift`](JWT%20Auth/JWT%20Auth/JWT_AuthApp.swift): installs `AuthStore` as an `EnvironmentObject`.
- **Routing**
  - [`ContentView.swift`](JWT%20Auth/JWT%20Auth/View/ContentView.swift): switches between `LoginView` and `UsersView` based on `auth.isAuthenticated`.
- **Login UI**
  - [`LoginView.swift`](JWT%20Auth/JWT%20Auth/View/LoginView.swift): calls `auth.login(...)` (mock).
- **Authenticated UI**
  - [`UsersView.swift`](JWT%20Auth/JWT%20Auth/View/UsersView.swift): shows token claims + fetched users list and supports logout.
- **Users state**
  - [`ViewModel.swift`](JWT%20Auth/JWT%20Auth/ViewModels/ViewModel.swift): loads users via `NetworkManager`, presents unauthorized errors.

#### JWT/session implementation

- **Auth state**
  - [`AuthStore.swift`](JWT%20Auth/JWT%20Auth/NetworkManager/AuthStore.swift)
    - bootstraps from stored tokens
    - schedules a refresh before expiry
    - exposes `isAuthenticated`, `claims`, `errorMessage`
- **Token storage + refresh (demo)**
  - [`TokenManager.swift`](JWT%20Auth/JWT%20Auth/NetworkManager/TokenManager.swift)
    - stores tokens in `UserDefaults`
    - provides `validAccessToken(minValidity:)`
    - refresh uses “single-flight” to avoid concurrent refresh stampedes
- **JWT minting + decoding**
  - [`JWT.swift`](JWT%20Auth/JWT%20Auth/NetworkManager/JWT.swift): creates a JWT-shaped string and decodes `JWTClaims` (no signature verification).

#### Networking implementation

- **Authorized requests + retry-on-401**
  - [`NetworkManager.swift`](JWT%20Auth/JWT%20Auth/NetworkManager/NetworkManager.swift)
    - attaches `Authorization: Bearer <token>`
    - retries once after a refresh when a request returns 401
- **Model**
  - [`User.swift`](JWT%20Auth/JWT%20Auth/Models/User.swift): decodes users from JSONPlaceholder.

---

## Running the samples

- **Login with JWT**
  - Open [`Login with JWT.xcodeproj`](Login%20with%20JWT/Login%20with%20JWT.xcodeproj)
  - Set your API base URL in [`AuthAPI.swift`](Login%20with%20JWT/Login%20with%20JWT/JWT/AuthAPI.swift) (`Constants.endpoint`)
  - Run

- **JWT Auth**
  - Open [`JWT Auth.xcodeproj`](JWT%20Auth/JWT%20Auth.xcodeproj)
  - Run (no backend required)

## Security notes (applies to both)

- **JWT payload decoding is for display only**: both projects decode claims locally, but **do not** validate JWT signatures. Treat decoded claims as untrusted input.
- **Token storage**:
  - `Login with JWT` stores tokens in **Keychain** (recommended for real apps).
  - `JWT Auth` stores tokens in **UserDefaults** (intentional demo simplification).
