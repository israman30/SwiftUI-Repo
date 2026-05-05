//
//  AuthAPI.swift
//  Login Flow
//
//  Created by Israel Manzo on 5/5/26.
//

import Foundation

/// Errors surfaced by the demo auth implementation.
///
/// In a real app, your API layer would map backend errors to user-friendly messages.
enum AuthAPIError: LocalizedError, Equatable {
    case invalidEmail
    case weakPassword
    case emailAlreadyInUse
    case invalidCredentials
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Please enter a valid email address."
        case .weakPassword:
            return "Your password must be at least 8 characters."
        case .emailAlreadyInUse:
            return "That email is already in use."
        case .invalidCredentials:
            return "Incorrect email or password."
        }
    }
}

/// Minimal, demo-only auth “API”.
///
/// ## Important
/// This is **not** real authentication. It exists to make the UI flow interactive without
/// introducing networking or backend dependencies.
///
/// ## Behavior
/// - `signUp(...)` stores the email in `UserDefaults` as “registered”.
/// - `login(...)` succeeds only for previously registered emails and stores a token via `TokenManager`.
/// - A short `Task.sleep` simulates network latency.
struct AuthAPI {
    private static let registeredEmailsKey = "login_flow.registered_emails"
    
    /// Simulates a login call. Returns a token string on success.
    static func login(email: String, password: String) async throws -> String {
        try await Task.sleep(nanoseconds: 700_000_000)
        
        guard isValidEmail(email) else { throw AuthAPIError.invalidEmail }
        guard password.count >= 8 else { throw AuthAPIError.weakPassword }
        
        let lowerEmail = email.lowercased()
        let registered = loadRegisteredEmails()
        guard registered.contains(lowerEmail) else { throw AuthAPIError.invalidCredentials }
        
        // Demo rule: treat "password" as invalid even if length >= 8.
        if password.lowercased() == "password" { throw AuthAPIError.invalidCredentials }
        
        let token = UUID().uuidString
        TokenManager.shared.storeToken(token)
        return token
    }
    
    /// Simulates a registration call.
    ///
    /// Registration does not automatically sign in; it only marks the email as registered.
    static func signUp(fullName: String, email: String, password: String) async throws {
        try await Task.sleep(nanoseconds: 900_000_000)
        
        guard !fullName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw AuthAPIError.invalidCredentials
        }
        guard isValidEmail(email) else { throw AuthAPIError.invalidEmail }
        guard password.count >= 8 else { throw AuthAPIError.weakPassword }
        
        let lowerEmail = email.lowercased()
        var registered = loadRegisteredEmails()
        guard !registered.contains(lowerEmail) else { throw AuthAPIError.emailAlreadyInUse }
        
        registered.insert(lowerEmail)
        saveRegisteredEmails(registered)
    }
    
    private static func isValidEmail(_ email: String) -> Bool {
        email.contains("@") && email.contains(".")
    }
    
    private static func loadRegisteredEmails() -> Set<String> {
        let array = UserDefaults.standard.stringArray(forKey: registeredEmailsKey) ?? []
        return Set(array.map { $0.lowercased() })
    }
    
    private static func saveRegisteredEmails(_ emails: Set<String>) {
        UserDefaults.standard.set(Array(emails), forKey: registeredEmailsKey)
    }
}

