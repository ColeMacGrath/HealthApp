//
//  RecommendationViewController.swift
//  HealthApp
//
//  Created by Cordova Garcia Moises Emmanuel on 03/01/24.
//

import UIKit

class RecommendationViewController: UIViewController {
    
    @IBOutlet weak var resultTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*guard let url = URL(string: "https://api.openai.com/v1/engines/davinci/completions"),
        let openAIKey = Config.getPropertieListValue(forKey: "openAIKey", in: "keys") else { return }
        let body: [String: Any] = [
            "model": "text-davinci-003",
            "prompt": "this is a testing API call, can you response if all correct",
            "max_tokens": 100
        ]
        let headers: [String: String] = [
            "Authorization": "Bearer \(openAIKey)",
            "Content-Type": "application/json"
        ]
        
        Task {
            let (statusCode, response) = await RequestManager.shared.request(endPoint: url, method: .post, body: body, headers: headers)
            print("Status Code: \(statusCode)")
            print("Response: \(String(describing: response))")
        }*/
        
    }
    
}
