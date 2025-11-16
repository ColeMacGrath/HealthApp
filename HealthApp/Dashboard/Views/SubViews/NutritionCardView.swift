//
//  NutritionCardView.swift
//  HealthApp
//
//  Created by Moises Cordova on 11/15/2025.
//

import SwiftUI
import Charts

struct NutritionCard: View {
    let proteinData: [HealthDataPoint]
    let carbsData: [HealthDataPoint]
    let fatData: [HealthDataPoint]
    let totalCalories: String
    let goalCalories: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "fork.knife")
                    .font(.title3)
                    .foregroundStyle(.orange)
                
                Text("Today's Nutrition")
                    .font(.headline)
                
                Spacer()
                
                Text("\(totalCalories) / \(goalCalories) Cal")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            HStack(spacing: 16) {
                MacroColumn(
                    title: "Protein",
                    value: "\(Int(proteinData.last?.value ?? 0))g",
                    target: "120g",
                    color: .red,
                    data: proteinData
                )
                MacroColumn(
                    title: "Carbs",
                    value: "\(Int(carbsData.last?.value ?? 0))g",
                    target: "250g",
                    color: .orange,
                    data: carbsData
                )
                MacroColumn(
                    title: "Fat",
                    value: "\(Int(fatData.last?.value ?? 0))g",
                    target: "67g",
                    color: .yellow,
                    data: fatData
                )
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(20)
    }
}
