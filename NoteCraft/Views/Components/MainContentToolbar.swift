//
//  MainContentToolbar.swift
//  NoteCraft
//
//  Created by NoteCraft AI on 2024
//

import SwiftUI

// MARK: - MainContentToolbar Component
struct MainContentToolbar: View {
    @Binding var searchText: String
    @Binding var showingNewItemOptions: Bool
    
    var body: some View {
        HStack {
            // Barra di ricerca
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
                
                TextField("Cerca quaderni e cartelle", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(.system(size: 16))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemGray6))
            )
            .frame(width: 250)
            
            // Pulsante Nuovo Elemento
            Button(action: {
                showingNewItemOptions = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
        }
    }
}

// MARK: - Preview
struct MainContentToolbar_Previews: PreviewProvider {
    static var previews: some View {
        MainContentToolbar(
            searchText: .constant(""),
            showingNewItemOptions: .constant(false)
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}