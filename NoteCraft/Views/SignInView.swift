//
//  SignInView.swift
//  NoteCraft
//
//  Created by NoteCraft AI on 2024.
//

import SwiftUI

struct SignInView: View {
    // MARK: - State Variables
    @State private var email: String = ""
    @State private var password: String = ""
    @Environment(\.navigationManager) private var navigationManager
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) private var presentationMode
    
    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            // Determina l'orientamento in base alle dimensioni dello schermo
            let isLandscape = geometry.size.width > geometry.size.height
            // Larghezza fissa assoluta per evitare cambiamenti con la tastiera
            // Garantiamo che la larghezza sia sempre positiva e finita
            let availableWidth = max(geometry.size.width, 1) // Assicura che sia sempre positivo
            let fixedContentWidth: CGFloat = isLandscape ? 
                min(600, max(availableWidth - 100, 300)) : // Minimo 300pt in landscape
                min(500, max(availableWidth - 60, 280))   // Minimo 280pt in portrait
            
            // Padding fisso con valori sicuri
            let fixedHorizontalPadding: CGFloat = isLandscape ? 50 : 30
            
            ZStack {
                // Background a tutta pagina
                Color(UIColor.systemBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Barra superiore con pulsante indietro - FISSA
                    HStack {
                        Button(action: {
                            // Torna sempre alla WelcomeView (root)
                            // Utilizziamo sia dismiss che presentationMode per massima compatibilità
                            dismiss()
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.primary)
                        }
                        .padding(.leading, 16)
                        
                        Spacer()
                    }
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor.systemBackground))
                    
                    // Contenuto scrollabile con larghezza fissa
                    ScrollView {
                        VStack(spacing: 0) {
                            // Titolo
                            Text("Sign In to NoteCraft")
                                .font(.system(size: isLandscape ? 28 : 24, weight: .bold))
                                .multilineTextAlignment(.center)
                                .padding(.top, 20)
                                .padding(.bottom, 30)
                            
                            // Contenitore principale con larghezza fissa
                            VStack(spacing: 20) {
                                // Campo Email
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Email")
                                        .font(.headline)
                                        .foregroundColor(.secondary)
                                    
                                    TextField("Enter your email", text: $email)
                                        .keyboardType(.emailAddress)
                                        .autocapitalization(.none)
                                        .disableAutocorrection(true)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                        )
                                }
                                
                                // Campo Password
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Password")
                                        .font(.headline)
                                        .foregroundColor(.secondary)
                                    
                                    SecureField("Enter your password", text: $password)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                        )
                                }
                                
                                // Pulsante Sign In
                                Button(action: {
                                    print("Sign In button tapped")
                                    print("Email: \(email)")
                                    print("Password: \(password)")
                                    // Qui verrà implementata la logica di autenticazione
                                }) {
                                    Text("Sign In")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.blue)
                                        )
                                }
                                .padding(.top, 20)
                                
                                // Link per registrarsi
                                NavigationLink(destination: SignUpView()) {
                                    Text("Don't have an account? Sign up here")
                                        .font(.subheadline)
                                        .foregroundColor(.blue)
                                        .underline()
                                }
                                .padding(.top, 20)
                                .padding(.bottom, 50) // Spazio extra per la tastiera
                            }
                            // Utilizziamo un valore sicuro per la larghezza
                            .frame(width: fixedContentWidth)
                            // Padding fisso con valori sicuri
                            .padding(.horizontal, fixedHorizontalPadding)
                        }
                        .frame(maxWidth: .infinity) // Centra il contenuto
                    }
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Preview
struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignInView()
        }
        .previewDevice("iPad Pro (11-inch) (4th generation)")
        .previewDisplayName("iPad Pro 11\" - Portrait")
        
        NavigationView {
            SignInView()
        }
        .previewDevice("iPad Pro (11-inch) (4th generation)")
        .previewInterfaceOrientation(.landscapeLeft)
        .previewDisplayName("iPad Pro 11\" - Landscape")
    }
}