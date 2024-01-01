//
//  SavedProjectView.swift
//  Real_time
//
//  Created by Alex Rhodes on 9/2/23.
//

import SwiftUI
import Foundation
import CoreData


struct SavedProjectView: View {
    @State private var savedFiles: [SavedFile] = []
    @State private var selectedFile: SavedFile?
    @State private var isEditing = false
    @State private var isSelecting = false
    @State private var isShareSheetPresented = false
    
    struct SavedFile: Identifiable {
        let id = UUID()
        let name: String
        let fileURL: URL
        var gaugeData: GaugeData?
    }
    
    struct GaugeData: Codable {
        var gauge1Values: [Double]
        var gauge2Values: [Double]
        var gauge3Values: [Double]
        var gauge4Values: [Double]
        var gauge5Values: [Double]
    }
    
    func loadSavedFiles() {
        do {
            // Get the URL for the document directory
            let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            
            // Get the URLs of all files in the document directory
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentDirectoryURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            
            // Filter the file URLs to only include files with the ".json" extension
            savedFiles = fileURLs.filter { $0.pathExtension == "json" }.map {
                // Create a SavedFile object for each file URL
                SavedFile(name: $0.lastPathComponent, fileURL: $0)
            }
        } catch {
            // Handle any errors that occur during the file loading process
            print("Error loading saved files: \(error.localizedDescription)")
        }
    }
    
    func loadGaugeData(file: inout SavedFile) {
        do {
            // Read the contents of the file at the specified fileURL
            let jsonData = try Data(contentsOf: file.fileURL)
            
            // Create a JSON decoder
            let decoder = JSONDecoder()
            
            // Decode the JSON data into a GaugeData object using the decoder
            file.gaugeData = try decoder.decode(GaugeData.self, from: jsonData)
        } catch {
            // Handle any errors that occur during the loading and decoding process
            print("Error loading gauge data for file \(file.name): \(error.localizedDescription)")
        }
    }
    
    func deleteFile(file: SavedFile) {
        do {
            // Remove the file at the specified fileURL using FileManager
            try FileManager.default.removeItem(at: file.fileURL)
            
            // Remove the file from the savedFiles array using removeAll(where:)
            savedFiles.removeAll(where: { $0.id == file.id })
        } catch {
            // Handle any errors that occur during the file deletion process
            print("Error deleting file \(file.name): \(error.localizedDescription)")
        }
    }
  
    struct ShareSheet: UIViewControllerRepresentable {
        // An array of activity items to be shared
        let activityItems: [Any]

        // Create a UIActivityViewController and return it as a UIViewController
        func makeUIViewController(context: Context) -> UIActivityViewController {
            let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            return activityViewController
        }

        // Update the UIActivityViewController when the context changes (not implemented in this case)
        func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
    }
    
    var body: some View {
        VStack {
            if savedFiles.isEmpty {
                Text("No saved files found.")
            } else {
                List(savedFiles) { file in
                    HStack {
                        Button(action: {
                            selectedFile = file
                            loadGaugeData(file: &selectedFile!)
                        }) {
                            Text(file.name)
                        }
                        Spacer()
                        if isSelecting {
                            Button(action: {
                                // Select the file
                                selectedFile = file
                                // Bring up the share screen
                                isShareSheetPresented = true
                            }) {
                                Image(systemName: "square.and.arrow.up")
                            }
                        }
                        if isEditing {
                            Button(action: {
                                // Select the file
                                selectedFile = file
                                deleteFile(file: file)
                            }) {
                                Image(systemName: "trash")
                            }
                        }
                    }
                    .sheet(isPresented: $isShareSheetPresented) {
                        // Share sheet
                        if let fileURL = selectedFile?.fileURL {
                            ShareSheet(activityItems: [fileURL])
                        }
                    }
                }
                .toolbar {
                    Button(action: {
                        isEditing.toggle()
                    }) {
                        Text(isEditing ? "Done" : "Edit")
                    }
                    Button(action: {
                        isSelecting.toggle()
                    }) {
                        Text(isSelecting ? "Done" : "Select")
                    }
                }
            }
            
            if let selectedFile = selectedFile {
                if let gaugeData = selectedFile.gaugeData {
                    ScrollView(.vertical) {
                        HStack {
                            VStack {
                                Text("Voltage:")
                                ForEach(gaugeData.gauge1Values, id: \.self) { value in
                                    Text(String(format: "%.2f", value))
                                }
                            }
                            VStack {
                                Text("X-Axis:")
                                ForEach(gaugeData.gauge2Values, id: \.self) { value in
                                    Text(String(format: "%.2f", value))
                                }
                            }
                            VStack {
                                Text("Y Axis:")
                                ForEach(gaugeData.gauge3Values, id: \.self) { value in
                                    Text(String(format: "%.2f", value))
                                }
                            }
                            VStack {
                                Text("Z Axis:")
                                ForEach(gaugeData.gauge4Values, id: \.self) { value in
                                    Text(String(format: "%.2f", value))
                                }
                            }
                            VStack {
                                Text("Rod Length:")
                                ForEach(gaugeData.gauge5Values, id: \.self) { value in
                                    Text(String(format: "%.2f", value))
                                }
                            }
                        }
                    }
                } else {
                    Text("No gauge data found for file \(selectedFile.name).")
                }
            } else {
                Text("Select a file to view gauge values.")
            }
            NavigationLink(destination: LineChartView()) {
                           Text("Go to Line Chart View")
                       }
        }
        .onAppear {
            loadSavedFiles()
        }
    }
}
