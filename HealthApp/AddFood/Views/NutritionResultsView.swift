//
//  NutritionResultsView.swift
//  HealthApp
//
//  Created by Moises Cordova on 11/15/2025.
//

import SwiftUI

struct NutritionResultsView: View {
    let nutritionData: NutritionData
    let onSave: () async -> Void
    let onCancel: () -> Void
    
    @State private var isSaving = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(nutritionData.foodName)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        if let servingSize = nutritionData.servingSize {
                            Text(servingSize)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ultraThinMaterial)
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Macronutrients")
                            .font(.headline)
                        
                        macroCard(title: "Calories", value: "\(Int(nutritionData.calories))", unit: "kcal", color: .orange)
                        
                        if let protein = nutritionData.protein {
                            macroCard(title: "Protein", value: String(format: "%.1f", protein), unit: "g", color: .red)
                        }
                        
                        if let carbohydrates = nutritionData.carbohydrates {
                            macroCard(title: "Carbohydrates", value: String(format: "%.1f", carbohydrates), unit: "g", color: .blue)
                        }
                        
                        if let fat = nutritionData.fat {
                            macroCard(title: "Fat", value: String(format: "%.1f", fat), unit: "g", color: .yellow)
                        }
                        
                        
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ultraThinMaterial)
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Micronutrients")
                            .font(.headline)
                        
                        if let sodium = nutritionData.sodium {
                            micronutrientRow(title: "Sodium", value: sodium, unit: "mg")
                        }
                        
                        if let potassium = nutritionData.potassium {
                            micronutrientRow(title: "Potassium", value: potassium, unit: "mg")
                        }
                        
                        if let fiber = nutritionData.fiber {
                            micronutrientRow(title: "Fiber", value: fiber, unit: "g")
                        }
                        
                        if let sugar = nutritionData.sugar {
                            micronutrientRow(title: "Sugar", value: sugar, unit: "g")
                        }
                        
                        if let cholesterol = nutritionData.cholesterol {
                            micronutrientRow(title: "Cholesterol", value: cholesterol, unit: "mg")
                        }
                        
                        if let calcium = nutritionData.calcium {
                            micronutrientRow(title: "Calcium", value: calcium, unit: "mg")
                        }
                        
                        if let iron = nutritionData.iron {
                            micronutrientRow(title: "Iron", value: iron, unit: "mg")
                        }
                        
                        if let vitaminC = nutritionData.vitaminC {
                            micronutrientRow(title: "Vitamin C", value: vitaminC, unit: "mg")
                        }
                        
                        if let vitaminA = nutritionData.vitaminA {
                            micronutrientRow(title: "Vitamin A", value: vitaminA, unit: "µg")
                        }
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ultraThinMaterial)
                    }
                }
                .padding()
            }
            .navigationTitle("Nutrition Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        onCancel()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        Task {
                            isSaving = true
                            await onSave()
                            isSaving = false
                        }
                    } label: {
                        if isSaving {
                            ProgressView()
                        } else {
                            Text("Save to Health")
                                .fontWeight(.semibold)
                        }
                    }
                    .disabled(isSaving)
                }
            }
        }
    }
    
    @ViewBuilder
    private func macroCard(title: String, value: String, unit: String, color: Color) -> some View {
        HStack {
            Circle()
                .fill(color.gradient)
                .frame(width: 12, height: 12)
            
            Text(title)
                .font(.body)
            
            Spacer()
            
            Text(value)
                .font(.title3)
                .fontWeight(.semibold)
            
            Text(unit)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    @ViewBuilder
    private func micronutrientRow(title: String, value: Double, unit: String) -> some View {
        HStack {
            Text(title)
                .font(.body)
            
            Spacer()
            
            Text(String(format: "%.1f", value))
                .font(.body)
                .fontWeight(.medium)
            
            Text(unit)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NutritionResultsView(
        nutritionData: NutritionData(
            foodName: "Grilled Chicken Salad",
            calories: 350,
            protein: 35,
            carbohydrates: 25,
            fat: 12,
            sodium: 450,
            potassium: 680,
            fiber: 6,
            sugar: 8,
            cholesterol: 85,
            calcium: 120,
            iron: 3.5,
            vitaminC: 45,
            vitaminA: 850,
            servingSize: "1 bowl (350g)"
        ),
        onSave: {},
        onCancel: {}
    )
}
