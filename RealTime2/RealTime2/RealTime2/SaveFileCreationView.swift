//
//  SaveFileCreationView.swift
//  RealTime2
//
//  Created by Alex Rhodes on 11/2/23.
//

import Foundation
import SwiftUI
import CoreData

struct SaveFileCreationView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var fileName = ""
    
    var body: some View {
        VStack {
            Text("Save File Creation")
                .font(.title)
                .padding()
            
            TextField("Enter file name", text: $fileName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Save") {
                saveFile()
            }
            .padding()
        }
        .navigationBarItems(trailing: Button("Cancel") {
            presentationMode.wrappedValue.dismiss()
        })
    }
    
    private func saveFile() {
        guard !fileName.isEmpty else {
            return
        }
        
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        
        do {
            let data = try JSONEncoder().encode(fileName)
            try data.write(to: fileURL)
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Error saving file: \(error.localizedDescription)")
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
