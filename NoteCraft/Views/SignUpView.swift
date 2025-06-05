//
//  SignUpView.swift
//  NoteCraft
//
//  Created by Michele Moretti on 05/06/25.
//

import SwiftUI

struct SignUpView: View {
    // Stati per i campi di input
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    // Stato per rilevare l'orientamento del dispositivo
    @State private var isLandscape = false
    
    // Stato per la navigazione - NavigationManager per tornare alla root
    @Environment(\.navigationManager) private var navigationManager
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) private var presentationMode
    
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
                            Text("NoteCraft - Create your account")
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
                                
                                // Campo Conferma Password
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Confirm Password")
                                        .font(.headline)
                                        .foregroundColor(.secondary)
                                    
                                    SecureField("Confirm your password", text: $confirmPassword)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                        )
                                }
                                
                                // Requisiti Password
                                Text("La password deve contenere almeno 8 caratteri, una lettera maiuscola, un numero e un simbolo.")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                                    .padding(.top, 4)
                                    .padding(.bottom, 20)
                                
                                // Pulsante Sign Up
                                Button(action: {
                                    print("Sign Up button tapped")
                                    // Qui verrà implementata la logica di registrazione
                                }) {
                                    Text("Sign Up")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.blue)
                                        )
                                }
                                .padding(.top, 10)
                                
                                // Link per accedere
                                NavigationLink(destination: SignInView()) {
                                    Text("Already have an account? Sign in here")
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

#Preview {
    SignUpView()
}