//
//  NutritionParserService.swift
//  HealthApp
//
//  Created by Moises Cordova on 11/15/2025.
//

import Foundation
import FoundationModels

final class NutritionParserService {
    private let session: LanguageModelSession?
    init() async throws {
        let model = SystemLanguageModel.default
        guard model.availability == .available else { throw NutritionParserError.modelUnavailable(model.availability) }
        
        let instructions = """
        You are a data extraction assistant specializing in nutritional information. 
        Your task is to extract structured nutritional data from food analysis text and return ONLY valid JSON.
        Always return pure JSON without any markdown formatting, code blocks, or explanations.
        Be precise with numbers and use null for missing optional values.
        """
        
        self.session = LanguageModelSession(instructions: instructions)
    }
    
    func parseNutritionData(from text: String) async throws -> NutritionData {
        guard let session = session else { throw NutritionParserError.invalidResponse }
        let prompt = buildParsingPrompt(from: text)
        let response = try await session.respond(to: prompt)
        let content = response.content
        let cleanedContent = cleanJSONResponse(content)
        guard let jsonData = cleanedContent.data(using: .utf8) else { throw NutritionParserError.invalidResponse }
        
        do {
            let nutritionData = try JSONDecoder().decode(NutritionData.self, from: jsonData)
            return nutritionData
        } catch {
            throw NutritionParserError.parsingFailed(error)
        }
    }

    private func cleanJSONResponse(_ response: String) -> String {
        var cleaned = response.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if cleaned.hasPrefix("```json") {
            cleaned = cleaned.replacingOccurrences(of: "```json", with: "")
        }
        if cleaned.hasPrefix("```") {
            cleaned = cleaned.replacingOccurrences(of: "```", with: "")
        }
        if cleaned.hasSuffix("```") {
            cleaned = String(cleaned.dropLast(3))
        }
        
        return cleaned.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func buildParsingPrompt(from text: String) -> String {
        return """
        You are a data extraction assistant. Extract the nutritional information from the following food analysis text and return ONLY a valid JSON object with the specified structure. Do not include any explanation, markdown formatting, or additional text - only the raw JSON.
        
        Required JSON structure:
        {
            "food_name": "string",
            "calories": number,
            "protein": number,
            "carbohydrates": number,
            "fat": number,
            "sodium": number,
            "potassium": number,
            "fiber": number or null,
            "sugar": number or null,
            "cholesterol": number or null,
            "calcium": number or null,
            "iron": number or null,
            "vitamin_c": number or null,
            "vitamin_a": number or null,
            "serving_size": "string" or null
        }
        
        Units:
        - calories: kcal
        - protein, carbohydrates, fat, fiber, sugar: grams
        - sodium, potassium, cholesterol, calcium, iron, vitamin_c: milligrams
        - vitamin_a: micrograms
        
        If a value is not found or mentioned in the text, use null for optional fields. For required fields (food_name, calories, protein, carbohydrates, fat, sodium, potassium), provide your best estimate or use 0 if truly unknown.
        
        Text to parse:
        \(text)
        
        Return only the JSON object:
        """
    }
}
