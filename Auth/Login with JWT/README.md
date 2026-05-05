### Auth (Login with JWT)

SwiftUI example that logs in against a backend, stores JWTs securely in Keychain, and uses the stored access token for authorized requests (with optional refresh when near expiry).

### Folder layout

- **`Login with JWT/`**: SwiftUI app views + view model
- **`Login with JWT/JWT/`**: Auth API + token model + Keychain storage + refresh logic
- **`Login with JWT/NetworkServices/`**: Example of building authorized API requests

### Components

### App entry + routing

- **`Login_with_JWTApp.swift`**: App entry point; loads `RootView`.
- **`RootView.swift`**: Decides which screen to show:
  - Shows `LoginView` when not authenticated
  - Shows `ContentView` when authenticated
  - Calls `refreshIfNeeded()` on launch via `.task`

### Login UI

- **`LoginView.swift`**: Email/password form bound to `LoginViewModel`; triggers `vm.login()`.
- **`LoginViewModel.swift`**: Main auth state holder:
  - **Inputs**: `email`, `password`
  - **UI state**: `isLoading`, `errorMessage`
  - **Session**: `isAuthenticated` + derived helpers (`currentUserEmail`, `currentUserId`, `tokenExpirationDate`)
  - **Actions**: `login()`, `logout()`, `refreshIfNeeded()`

### Post-login screen

- **`ContentView.swift`**: Simple “Home” screen that displays decoded token info and provides:
  - manual refresh (`vm.refreshIfNeeded()`)
  - logout (`vm.logout()`)

### JWT + session layer

- **`JWT/AuthAPI.swift`**: Network calls for:
  - `POST /auth/login` (email + password) → returns `JWToken`
  - `POST /auth/refresh` (refreshToken) → returns `JWToken`
  - Defines `AuthResponse` mapping common OAuth/JWT field names (`access_token`, `expires_in`, etc.)
- **`JWT/JWToken.swift`**:
  - `JWToken`: access/refresh token bundle + computed expiry helpers
  - `JWTPayload`: *decoded* (not verified) claims used for display (email, exp, roles, etc.)
- **`JWT/TokenManager.swift`**:
  - Persists `JWToken` to Keychain
  - Exposes `isAuthenticated`, `bearerHeader`
  - Proactively refreshes token when near expiry (`refreshTokenIfNeeded()`)
- **`JWT/KeychainManager.swift`**:
  - Minimal JSON-encoding Keychain wrapper
  - Uses `kSecAttrAccessibleWhenUnlockedThisDeviceOnly`
- **`JWT/AuthError.swift`**: UI-friendly auth error messages

### Authorized networking example

- **`NetworkServices/NetworkServices.swift`**: Example helper that:
  - refreshes token *opportunistically* if near expiry
  - builds `Authorization: Bearer <token>` requests
  - shows an example `fetchUsers()` call

### Setup

### 1) Configure your API base URL

Update `Constants.endpoint` in `Login with JWT/JWT/AuthAPI.swift`:

```swift
struct Constants {
    static let endpoint = "https://api.yourdomain.com"
}
```

### 2) Backend expectations

This sample expects:

- **Login**: `POST /auth/login`
  - body: `{ "email": "...", "password": "..." }`
  - response JSON:

```json
{
  "access_token": "jwt-here",
  "refresh_token": "optional-refresh-token",
  "expires_in": 3600,
  "token_type": "Bearer"
}
```

- **Refresh**: `POST /auth/refresh`
  - body: `{ "refreshToken": "..." }`
  - response JSON: same shape as login

### Usage patterns

### Show login vs home

Use `RootView` as the top-level router (already wired in `Login_with_JWTApp.swift`).

### Make authorized API calls elsewhere

Before building a request, ensure the token is refreshed if needed and attach the Bearer header (the project’s `NetworkServices` already demonstrates this pattern):

```swift
try await TokenManager.shared.refreshTokenIfNeeded()
guard let bearer = TokenManager.shared.bearerHeader else { return }

var request = URLRequest(url: url)
request.setValue(bearer, forHTTPHeaderField: "Authorization")
```

### Logout

```swift
try? TokenManager.shared.clearToken()
```

### Notes / security

- **JWT payload decoding is for display only**: `JWToken.payload` decodes the JWT payload segment but does not validate signatures.
- **Tokens are stored in Keychain** (not `UserDefaults`) via `KeychainManager`.
