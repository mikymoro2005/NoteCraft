//
//  AuthViewModel.swift
//  NoteCraft
//
//  Created by NoteCraft AI on 2024.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn
import AuthenticationServices
import CryptoKit
import UIKit

// ViewModel per gestire l'autenticazione con Firebase
class AuthViewModel: NSObject, ObservableObject {
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentUser: User?
    
    // Nonce per Sign In with Apple
    private var currentNonce: String?
    
    override init() {
        super.init()
        // Controlla se l'utente è già autenticato
        checkAuthenticationState()
    }
    
    // MARK: - Controllo stato autenticazione
    private func checkAuthenticationState() {
        if let user = Auth.auth().currentUser {
            self.currentUser = user
            self.isAuthenticated = true
        }
    }
    
    // MARK: - Autenticazione con Google
    func signInWithGoogle() {
        // Utilizziamo UIWindowScene.windows invece di UIApplication.shared.windows (deprecato)
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let presentingViewController = windowScene.windows.first?.rootViewController else {
            self.errorMessage = "Impossibile trovare il view controller principale"
            return
        }
        
        self.isLoading = true
        self.errorMessage = nil
        
        // Configura Google Sign-In
        guard let clientID = getGoogleClientID() else {
            self.errorMessage = "Google Client ID non configurato"
            self.isLoading = false
            return
        }
        
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = "Errore Google Sign-In: \(error.localizedDescription)"
                    return
                }
                
                guard let user = result?.user,
                      let idToken = user.idToken?.tokenString else {
                    self?.errorMessage = "Impossibile ottenere il token di Google"
                    return
                }
                
                let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                               accessToken: user.accessToken.tokenString)
                
                // Autentica con Firebase
                self?.authenticateWithFirebase(credential: credential)
            }
        }
    }
    
    // MARK: - Autenticazione con Apple
    func signInWithApple() {
        let nonce = randomNonceString()
        currentNonce = nonce
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        
        self.isLoading = true
        self.errorMessage = nil
        
        authorizationController.performRequests()
    }
    
    // MARK: - Autenticazione con Firebase
    private func authenticateWithFirebase(credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = "Errore autenticazione Firebase: \(error.localizedDescription)"
                    return
                }
                
                if let user = result?.user {
                    self?.currentUser = user
                    self?.isAuthenticated = true
                    print("Utente autenticato con successo: \(user.email ?? "Email non disponibile")")
                }
            }
        }
    }
    
    // MARK: - Logout
    func signOut() {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            
            DispatchQueue.main.async {
                self.isAuthenticated = false
                self.currentUser = nil
                self.errorMessage = nil
            }
        } catch {
            self.errorMessage = "Errore durante il logout: \(error.localizedDescription)"
        }
    }
    
    // MARK: - Utility Methods
    private func getGoogleClientID() -> String? {
        // Il Client ID dovrebbe essere configurato nel GoogleService-Info.plist
        // Per ora, restituiamo nil e forniremo istruzioni per la configurazione
        guard let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: path),
              let clientID = plist["CLIENT_ID"] as? String else {
            return nil
        }
        return clientID
    }
    
    // Genera un nonce casuale per Sign In with Apple
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Impossibile generare nonce. SecRandomCopyBytes fallito con OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    // Genera SHA256 hash del nonce
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension AuthViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Richiesta di accesso non valida: manca il nonce.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                self.errorMessage = "Impossibile recuperare il token di identità"
                self.isLoading = false
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                self.errorMessage = "Impossibile serializzare il token: \(appleIDToken.debugDescription)"
                self.isLoading = false
                return
            }
            
            // Utilizziamo il metodo non deprecato per creare la credenziale
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                          rawNonce: nonce,
                                                          fullName: appleIDCredential.fullName)
            
            // Autentica con Firebase
            authenticateWithFirebase(credential: credential)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        DispatchQueue.main.async {
            self.isLoading = false
            self.errorMessage = "Errore Sign In with Apple: \(error.localizedDescription)"
        }
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
extension AuthViewModel: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        // Utilizziamo UIWindowScene.windows invece di UIApplication.shared.windows (deprecato)
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return UIWindow()
        }
        return window
    }
}