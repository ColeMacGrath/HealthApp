//
//  OpenAIService.swift
//  HealthApp
//
//  Created by Moises Cordova on 11/15/2025.
//

import Foundation
import UIKit

final class OpenAIService {
    private let apiKey: String
    private let model: String
    private let endpoint = "https://api.openai.com/v1/chat/completions"
    
    init(apiKey: String, model: String = AppConfiguration.openAIModel) {
        self.apiKey = apiKey
        self.model = model
    }

    func analyzeFoodImage(_ image: UIImage, additionalContext: String = "") async throws -> String {
        if AppConfiguration.simulateOpenAIResponses {
            try await Task.sleep(nanoseconds: 2_000_000_000)
            return getMockFoodAnalysisResponse()
        }
        
        guard let imageData = image.jpegData(compressionQuality: AppConfiguration.imageCompressionQuality) else { throw OpenAIError.imageProcessingFailed }
        let base64Image = imageData.base64EncodedString()
        let prompt = buildFoodAnalysisPrompt(additionalContext: additionalContext)
        let requestBody = buildRequestBody(prompt: prompt, base64Image: base64Image)
        let request = try buildURLRequest(body: requestBody)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else { throw OpenAIError.invalidResponse }
        
        guard httpResponse.statusCode == 200 else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw OpenAIError.apiError(statusCode: httpResponse.statusCode, message: errorMessage)
        }
        let openAIResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)
        
        guard let content = openAIResponse.choices.first?.message.content else { throw OpenAIError.noContentInResponse }
        
        return content
    }
    
    private func buildFoodAnalysisPrompt(additionalContext: String) -> String {
        var prompt = """
        You are a professional nutritionist analyzing a food image. Please provide a detailed analysis of the food in this image.
        
        Include the following information in your response:
        
        1. **Food Name**: The main dish or food item
        2. **Ingredients**: List all visible ingredients and components
        3. **Estimated Serving Size**: Approximate portion size
        4. **Detailed Nutritional Information**:
           - Calories (kcal)
           - Protein (grams)
           - Carbohydrates (grams)
           - Fat (grams)
           - Sodium (milligrams)
           - Potassium (milligrams)
           - Fiber (grams)
           - Sugar (grams)
           - Cholesterol (milligrams)
           - Calcium (milligrams)
           - Iron (milligrams)
           - Vitamin C (milligrams)
           - Vitamin A (micrograms)
        
        5. **Preparation Method**: How the food appears to be prepared (grilled, fried, baked, etc.)
        6. **Additional Notes**: Any relevant dietary information (allergens, special considerations, etc.)
        
        Be as accurate as possible with nutritional estimates based on typical portions and preparation methods. If you cannot identify something clearly, please indicate your best estimate.
        
        Format your response in a clear, structured way with sections and bullet points where appropriate.
        """
        
        if !additionalContext.isEmpty {
            prompt += "\n\nAdditional context from user: \(additionalContext)"
        }
        
        return prompt
    }
    
    private func buildRequestBody(prompt: String, base64Image: String) -> [String: Any] {
        return [
            "model": model,
            "messages": [
                [
                    "role": "user",
                    "content": [
                        [
                            "type": "text",
                            "text": prompt
                        ],
                        [
                            "type": "image_url",
                            "image_url": [
                                "url": "data:image/jpeg;base64,\(base64Image)"
                            ]
                        ]
                    ]
                ]
            ],
            "max_tokens": AppConfiguration.openAIMaxTokens,
            "temperature": AppConfiguration.openAITemperature
        ]
    }
    
    private func buildURLRequest(body: [String: Any]) throws -> URLRequest {
        guard let url = URL(string: endpoint) else {
            throw OpenAIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        return request
    }
    
    private func getMockFoodAnalysisResponse() -> String {
        return """
        🍝 Food Analysis Report
        
        1. Food Name
        
        Spaghetti with Tomato Sauce (classic Italian-style simple pasta, likely spaghetti al pomodoro).
        
        ⸻
        
        2. Visible Ingredients
        
        Based on the image, the dish appears minimalistic:
        • Spaghetti
        • Tomato-based sauce (likely tomatoes, olive oil, salt, possibly garlic/onion)
        • Basil leaf (garnish)
        • Possible olive oil sheen on the pasta
        
        No cheese, meat, or vegetables are visible.
        
        ⸻
        
        3. Estimated Serving Size
        
        The portion looks like a medium pasta serving, approx.:
        • 1 to 1.25 cups cooked pasta
        • Equivalent to 90–110 g dry pasta
        
        This is a typical individual serving.
        
        ⸻
        
        4. Detailed Nutritional Information (Estimated)
        
        Based on ~100 g dry spaghetti + simple tomato sauce (≈ ½ cup):
        
        Approximate Nutrition per Serving:
        
        • Calories: 390 kcal
        • Protein: 13 g
        • Carbohydrates: 65 g
        • Fat: 6 g (mainly from olive oil)
        • Sodium: 450 mg
        • Potassium: 375 mg
        • Fiber: 4 g
        • Sugar: 8 g (natural tomato sugars)
        • Cholesterol: 0 mg
        • Calcium: 30 mg
        • Iron: 2 mg
        • Vitamin C: 9 mg (from tomato sauce)
        • Vitamin A: 225 μg (from tomatoes)
        
        These values are realistic estimates for this dish without cheese or meat additions.
        
        ⸻
        
        5. Preparation Method
        
        The dish appears to be prepared in the following way:
        • Boiled spaghetti
        • Tomato sauce simmered with olive oil
        • Pasta tossed together with the sauce
        • Garnished with a fresh basil leaf
        
        No frying or baking is visible.
        
        ⸻
        
        6. Additional Notes
        
        Allergens:
        • Gluten (from wheat pasta)
        
        Dietary Considerations:
        • Vegetarian
        • Vegan (if tomato sauce contains no dairy)
        • Low fat
        • Moderate sodium (varies with sauce)
        • High carbohydrate meal
        • Low in protein unless paired with meat, cheese, or legumes
        
        Best For:
        • Pre-workout meal (easy carbs)
        • Light lunch or dinner
        • Easily adjustable for low-sodium diets (homemade sauce)
        """
    }
}

private struct OpenAIResponse: Codable {
    let choices: [Choice]
    
    struct Choice: Codable {
        let message: Message
    }
    
    struct Message: Codable {
        let content: String
    }
}

enum OpenAIError: LocalizedError {
    case invalidURL
    case imageProcessingFailed
    case invalidResponse
    case apiError(statusCode: Int, message: String)
    case noContentInResponse
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid API URL"
        case .imageProcessingFailed:
            return "Failed to process the image"
        case .invalidResponse:
            return "Invalid response from OpenAI"
        case .apiError(let statusCode, let message):
            return "API Error (\(statusCode)): \(message)"
        case .noContentInResponse:
            return "No content in OpenAI response"
        }
    }
}
