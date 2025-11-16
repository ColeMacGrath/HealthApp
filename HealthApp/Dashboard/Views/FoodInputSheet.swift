//
//  FoodInputSheet.swift
//  HealthApp
//
//  Created by Moises Cordova on 11/15/2025.
//

import SwiftUI

struct FoodInputSheet: View {
    @Binding var dishDescription: String
    @Binding var selectedSuggestions: Set<String>
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                
                HStack(alignment: .bottom, spacing: 12) {
                    TextField("Ask for an advice...", text: $dishDescription, axis: .vertical)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .focused($isTextFieldFocused)
                    
                    Button(action: {
                        // Send action
                        submitDish()
                    }) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.title)
                            .foregroundStyle(dishDescription.isEmpty ? .secondary : .primary)
                    }
                    .disabled(dishDescription.isEmpty)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationTitle("What's on your plate?")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                isTextFieldFocused = true
            }
        }
    }
    
    private func submitDish() {
        // Handle dish submission
        print("Dish description: \(dishDescription)")
        print("Selected suggestions: \(selectedSuggestions)")
        dismiss()
    }
}
