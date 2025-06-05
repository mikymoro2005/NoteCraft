//
//  MainView.swift
//  NoteCraft
//
//  Created by NoteCraft AI on 2024.
//

import SwiftUI
import FirebaseAuth

struct MainView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Icona di successo
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
                
                // Messaggio di benvenuto
                VStack(spacing: 10) {
                    Text("Autenticazione Riuscita!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    if let user = authViewModel.currentUser {
                        Text("Benvenuto, \(user.displayName ?? user.email ?? "Utente")")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Informazioni utente
                if let user = authViewModel.currentUser {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Email:")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(user.email ?? "Non disponibile")
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Text("Provider:")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(getProviderName(user: user))
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Text("UID:")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(String(user.uid.prefix(8)) + "...")
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(UIColor.secondarySystemBackground))
                    )
                }
                
                Spacer()
                
                // Pulsante di logout
                Button(action: {
                    authViewModel.signOut()
                }) {
                    HStack {
                        Image(systemName: "arrow.right.square")
                        Text("Logout")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.red)
                    )
                }
                
                // Nota per lo sviluppo
                Text("Questa è una schermata placeholder.\nQui verrà implementata la funzionalità principale dell'app.")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.top)
            }
            .padding()
            .navigationTitle("NoteCraft")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // Funzione helper per ottenere il nome del provider di autenticazione
    private func getProviderName(user: User) -> String {
        guard let providerData = user.providerData.first else {
            return "Sconosciuto"
        }
        
        switch providerData.providerID {
        case "google.com":
            return "Google"
        case "apple.com":
            return "Apple"
        case "password":
            return "Email/Password"
        default:
            return providerData.providerID
        }
    }
}

#Preview {
    MainView()
        .environmentObject(AuthViewModel())
}