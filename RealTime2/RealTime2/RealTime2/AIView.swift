//
//  AIView.swift
//  Real_time
//
//  Created by Alex Rhodes on 10/30/23.
//

import Foundation

import SwiftUI

struct AIView: View {
    @State private var messages: [String] = []
    @State private var inputMessage: String = ""
    let chatGPT = ChatGPT(apiKey: "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")
    
    var body: some View {
        VStack {
            // Display chat messages
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(messages, id: \.self) { message in
                        Text(message)
                        Divider()
                            .background(Color.orange) // Set the divider color to orange
                            .frame(height: 4) // Set the divider height to make it thicker
                    }
                }
            }
            .padding()
            
            // Input text field and send button
            HStack {
                TextField("Enter message", text: $inputMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: sendMessage) {
                    Text("Send")
                }
            }
            .padding()
        }
    }
    
    func sendMessage() {
        chatGPT.sendMessage(inputMessage) { result in
            switch result {
            case .success(let response):
                // Update UI on the main thread
                DispatchQueue.main.async {
                    self.messages.append(self.inputMessage)
                    self.messages.append(response)
                    self.inputMessage = ""
                }
            case .failure(let error):
                // Handle the error
                print("Error: \(error)")
            }
        }
    }
}
