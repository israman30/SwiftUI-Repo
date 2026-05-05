//
//  SignUpViewModel.swift
//  Login Flow
//
//  Created by Israel Manzo on 5/5/26.
//

import Foundation
import Combine

/// Coarse password strength categories used by `PasswordStrengthView`.
///
/// This sample uses simple heuristics (length + character classes) to compute strength.
enum PasswordStrength: Int {
    case `weak` = 1
    case fair = 2
    case strong = 3
    case veryStrong = 4
    
    var label: String {
        switch self {
        case .weak:
            return "Weak"
        case .fair:
            return "Fair"
        case .strong:
            return "Strong"
        case .veryStrong:
            return "Very Strong"
        }
    }
    
    var color: String {
        switch self {
        case .weak:       
            return "red"
        case .fair:       
            return "orange"
        case .strong:     
            return "blue"
        case .veryStrong:
            return "green"
        }
    }
}


@MainActor
/// View model backing `SignUpView`.
///
/// ## Responsibilities
/// - Holds registration form input and validation (`isFormValid`).
/// - Computes `passwordStrength` for live feedback while typing.
/// - Performs async registration via `AuthAPI` and flips `isRegistered` on success.
///
/// ## Usage
/// Call `await signUp()` from UI actions. `SignUpView` observes `isRegistered` and
/// routes back to sign-in once registration succeeds.
final class SignUpViewModel: ObservableObject {
    @Published var fullName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isRegistered: Bool = false
    
    var isFormValid: Bool {
        !fullName.isEmpty
        && isValidEmail
        && password.count >= 8
        && password == confirmPassword
    }
    
    var isValidEmail: Bool {
        email.contains("@") && email.contains(".")
    }
    
    var passwordsMatch: Bool {
        !confirmPassword.isEmpty && password == confirmPassword
    }
    
    var passwordStrength: PasswordStrength {
        let p = password
        var score = 0
        if p.count >= 8  { score += 1 }
        if p.count >= 12 { score += 1 }
        if p.rangeOfCharacter(from: .uppercaseLetters) != nil { score += 1 }
        if p.rangeOfCharacter(from: .decimalDigits) != nil    { score += 1 }
        if p.rangeOfCharacter(from: .punctuationCharacters) != nil { score += 1 }
        
        switch score {
        case 0...1:
            return .weak
        case 2:
            return .fair
        case 3:
            return .strong
        default:
            return .veryStrong
        }
    }
    
    /// Attempts to register a new user with the current form fields.
    ///
    /// On success, `isRegistered` becomes `true` so the view can transition back to login.
    func signUp() async {
        guard isFormValid else {
            errorMessage = "Please fill in all fields correctly."
            return
        }
        
        isLoading = true
        errorMessage = nil
        defer {
            isLoading = false
        }
        
        do {
            try await AuthAPI.signUp(
                fullName: fullName,
                email: email,
                password: password
            )
            isRegistered = true
            
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription
            ?? "Registration failed. Please try again."
        }
    }
}
