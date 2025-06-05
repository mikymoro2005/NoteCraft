//
//  WelcomeView.swift
//  NoteCraft
//
//  Created by Michele Moretti on 05/06/25.
//

import SwiftUI
import CoreData
import FirebaseAuth

struct WelcomeView: View {
    // Stato per rilevare l'orientamento del dispositivo
    @State private var isLandscape = false
    
    // Stato per la navigazione
    @State private var navigateToSignUp = false
    
    // AuthViewModel per gestire l'autenticazione
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        GeometryReader { geometry in
                // Determina l'orientamento in base alle dimensioni dello schermo
                let isLandscape = geometry.size.width > geometry.size.height
                
                ZStack {
                // Background a tutta pagina
                Color(UIColor.systemIndigo)
                    .opacity(0.1)
                    .ignoresSafeArea()
                
                // Pattern di sfondo (opzionale)
                Image(systemName: "pencil.and.outline")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.primary.opacity(0.03))
                    .frame(width: geometry.size.width * 0.8)
                    .offset(y: -geometry.size.height * 0.2)
                    .ignoresSafeArea()
                
                // Contenuto principale
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: geometry.size.height * 0.1)
                    
                    // Titolo e sottotitolo
                    Text("Welcome to NoteCraft")
                        .font(.system(size: isLandscape ? 36 : 32, weight: .bold))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Text("Your all-in-one workspace for notes, tasks, and ideas. Sign up or log in to get started.")
                        .font(.system(size: isLandscape ? 18 : 16))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .padding(.top, 8)
                        .foregroundColor(.secondary)
                    
                    // Spaziatura adattiva tra titolo e pulsanti
                    Spacer()
                        .frame(height: isLandscape ? geometry.size.height * 0.08 : geometry.size.height * 0.12)
                    
                    // Pulsanti di autenticazione
                    VStack(spacing: 16) {
                        AuthButton(
                            title: "Continue with Google",
                            iconName: "g.circle.fill",
                            isLoading: authViewModel.isLoading,
                            action: { authViewModel.signInWithGoogle() }
                        )
                        
                        AuthButton(
                            title: "Continue with Apple",
                            iconName: "apple.logo",
                            isLoading: authViewModel.isLoading,
                            action: { authViewModel.signInWithApple() }
                        )
                        
                        NavigationLink(destination: SignInView()) {
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .font(.system(size: 18))
                                    .frame(width: 24, height: 24)
                                
                                Text("Sign In with Email")
                                    .font(.system(size: 16, weight: .medium))
                                    .padding(.leading, 8)
                                
                                Spacer()
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(UIColor.systemBackground))
                                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                            )
                            .foregroundColor(.primary)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .disabled(authViewModel.isLoading)
                        
                        NavigationLink(destination: SignUpView()) {
                            HStack {
                                Image(systemName: "person.fill.badge.plus")
                                    .font(.system(size: 18))
                                    .frame(width: 24, height: 24)
                                
                                Text("Sign Up with Email")
                                    .font(.system(size: 16, weight: .medium))
                                    .padding(.leading, 8)
                                
                                Spacer()
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(UIColor.systemBackground))
                                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                            )
                            .foregroundColor(.primary)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .disabled(authViewModel.isLoading)
                    }
                    .frame(width: min(geometry.size.width * 0.85, 400))
                    
                    // Spaziatura adattiva tra pulsanti e note legali
                    Spacer()
                    
                    // Note legali
                    Text("By continuing, you agree to our Terms of Service and Privacy Policy.")
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 20)
                }
                .padding()
            }
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $authViewModel.isAuthenticated) {
            MainView()
                .environmentObject(authViewModel)
        }
        .alert("Errore di Autenticazione", isPresented: .constant(authViewModel.errorMessage != nil)) {
            Button("OK") {
                authViewModel.errorMessage = nil
            }
        } message: {
            Text(authViewModel.errorMessage ?? "")
        }
    }
}

// Componente riutilizzabile per i pulsanti di autenticazione
struct AuthButton: View {
    let title: String
    let iconName: String
    let isLoading: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                        .frame(width: 24, height: 24)
                } else {
                    Image(systemName: iconName)
                        .font(.system(size: 18))
                        .frame(width: 24, height: 24)
                }
                
                Text(isLoading ? "Autenticazione..." : title)
                    .font(.system(size: 16, weight: .medium))
                    .padding(.leading, 8)
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(UIColor.systemBackground))
                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isLoading)
    }
}

#Preview {
    WelcomeView()
}