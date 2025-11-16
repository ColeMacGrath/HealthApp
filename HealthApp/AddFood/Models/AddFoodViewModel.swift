//
//  AddFoodViewModel.swift
//  HealthApp
//
//  Created by Moises Cordova on 11/15/2025.
//

import Foundation
import UIKit

@Observable
final class AddFoodViewModel {
    var messageText: String = ""
    var showImageSourceMenu = false
    var showCamera = false
    var showPhotos = false
    var selectedImage: UIImage?
    var isProcessing = false
    var processingMessage = ""
    var showError = false
    var errorMessage = ""
    var foodAnalysis: FoodAnalysis?
    var nutritionData: NutritionData?
    var showResults = false
    private var openAIService: OpenAIService?
    private var nutritionParserService: NutritionParserService?
    
    init() {
        setupServices()
    }
    
    private func setupServices() {
        guard AppConfiguration.isOpenAIConfigured else { return }
        
        openAIService = OpenAIService(apiKey: AppConfiguration.openAIAPIKey ?? "")

        Task {
            do {
                nutritionParserService = try await NutritionParserService()
            } catch {
                print("Failed to initialize NutritionParserService: \(error)")
            }
        }
    }
    
    func processFoodImage() async {
        guard let image = selectedImage else {
            showErrorAlert("No image selected")
            return
        }
        
        guard AppConfiguration.isOpenAIConfigured else {
            showErrorAlert("OpenAI API key not configured. Please set your API key in AppConfiguration.swift")
            return
        }
        
        guard let openAIService = openAIService else {
            showErrorAlert("OpenAI service not initialized. Please check your API key.")
            return
        }
        
        guard let nutritionParserService = nutritionParserService else {
            showErrorAlert("Nutrition parser not initialized. Please ensure you're running iOS 18.2 or later.")
            return
        }
        
        await MainActor.run {
            isProcessing = true
            processingMessage = "Analyzing food image..."
        }
        
        do {
            let chatGPTResponse = try await openAIService.analyzeFoodImage(
                image,
                additionalContext: messageText
            )
            
            await MainActor.run {
                processingMessage = "Extracting nutrition data..."
            }
            
            let parsedNutrition = try await nutritionParserService.parseNutritionData(from: chatGPTResponse)
            
            
            await MainActor.run {
                self.foodAnalysis = FoodAnalysis(
                    rawDescription: chatGPTResponse,
                    nutritionData: parsedNutrition
                )
                self.nutritionData = parsedNutrition
                self.isProcessing = false
                self.showResults = true
                self.processingMessage = ""
            }
            
        } catch {
            await MainActor.run {
                isProcessing = false
                processingMessage = ""
                showErrorAlert("Failed to process image: \(error.localizedDescription)")
            }
        }
    }
    
    func resetForNewEntry() {
        selectedImage = nil
        messageText = ""
        foodAnalysis = nil
        nutritionData = nil
        isProcessing = false
        processingMessage = ""
    }
    
    private func showErrorAlert(_ message: String) {
        errorMessage = message
        showError = true
    }
    
    func saveToHealthKit() async {
        guard let nutritionData = nutritionData else { return }
        
        // TODO: Implement HealthKit saving logic here
        // You can use the nutritionData to create HKSamples for:
        // - Dietary Energy (calories)
        // - Protein
        // - Carbohydrates
        // - Fat
        // - Sodium
        // - Potassium
        // - Fiber
        // - Sugar
        // - Cholesterol
        // - Calcium
        // - Iron
        // - Vitamin C
        // - Vitamin A
        
        print("Ready to save to HealthKit:")
        print("Food: \(nutritionData.foodName)")
        print("Calories: \(nutritionData.calories) kcal")
        print("Protein: \(nutritionData.protein ?? 0.0)g")
        print("Carbs: \(nutritionData.carbohydrates ?? 0.0)g")
        print("Fat: \(nutritionData.fat ?? 0.0)g")
        print("Sodium: \(nutritionData.sodium ?? 0.0)mg")
        print("Potassium: \(nutritionData.potassium ?? 0.0)mg")
    }
}
