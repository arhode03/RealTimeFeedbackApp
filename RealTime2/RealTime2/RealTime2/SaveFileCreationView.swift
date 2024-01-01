//
//  SaveFileCreationView.swift
//  RealTime2
//
//  Created by Alex Rhodes on 11/2/23.
//
import Foundation
import SwiftUI
import CoreData

// Define a SwiftUI view for saving a file
struct SaveFileCreationView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var fileName = ""
    
    var body: some View {
        VStack {
            Text("Save File Creation")
                .font(.title)
                .padding()
            
            // Text field for entering the file name
            TextField("Enter file name", text: $fileName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            // Button to trigger the saveFile() function
            Button("Save") {
                saveFile()
            }
            .padding()
        }
        .navigationBarItems(trailing: Button("Cancel") {
            presentationMode.wrappedValue.dismiss()
        })
    }
    
    // Function to save the file
    private func saveFile() {
        // Check if the file name is not empty
        guard !fileName.isEmpty else {
            return
        }
        
        // Get the file URL by appending the file name to the documents directory
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        
        do {
            // Encode the file name as JSON data
            let data = try JSONEncoder().encode(fileName)
            
            // Write the data to the file URL
            try data.write(to: fileURL)
            
            // Dismiss the view presentation mode
            presentationMode.wrappedValue.dismiss()
        } catch {
            // Print an error message if there is an error saving the file
            print("Error saving file: \(error.localizedDescription)")
        }
    }
    
    // Function to get the documents directory URL
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
