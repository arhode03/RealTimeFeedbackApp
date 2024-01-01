//
//  ChatGPT.swift
//  Real_time
//
//  Created by Alex Rhodes on 10/30/23.
//

import Foundation

struct ChatGPT {
    let apiKey: String
    
    func sendMessage(_ message: String, completion: @escaping (Result<String, Error>) -> Void) {
        let apiKey = "sk" // Replace "YOUR_API_KEY" with your actual API key
        let modelName = "gpt-3.5-turbo" // Replace "YOUR_MODEL_NAME" with the desired model name
        
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = [
            "model": modelName,
            "messages": [
                ["role": "system", "content": "You are a helpful assistant."],
                ["role": "user", "content": message]
            ],
            "max_tokens": 200
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: requestBody)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let content = choices.first?["message"] as? [String: Any],
                   let text = content["content"] as? String {
                    completion(.success(text))
                    return
                }
                
                completion(.failure(NSError(domain: "Response Parsing Error", code: 0, userInfo: nil)))
            }
        }
        
        task.resume()
    }
}
