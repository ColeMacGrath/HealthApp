//
//  NutritionData.swift
//  HealthApp
//
//  Created by Moises Cordova on 11/15/2025.
//

import Foundation

struct NutritionData: Codable {
    let foodName: String
    let calories: Double
    let protein: Double?
    let carbohydrates: Double?
    let fat: Double?
    let sodium: Double?
    let potassium: Double?
    let fiber: Double?
    let sugar: Double?
    let cholesterol: Double?
    let calcium: Double?
    let iron: Double?
    let vitaminC: Double?
    let vitaminA: Double?
    let servingSize: String?
    
    enum CodingKeys: String, CodingKey {
        case foodName = "food_name"
        case calories
        case protein
        case carbohydrates
        case fat
        case sodium
        case potassium
        case fiber
        case sugar
        case cholesterol
        case calcium
        case iron
        case vitaminC = "vitamin_c"
        case vitaminA = "vitamin_a"
        case servingSize = "serving_size"
    }
}

struct FoodAnalysis {
    let rawDescription: String
    let nutritionData: NutritionData?
}
