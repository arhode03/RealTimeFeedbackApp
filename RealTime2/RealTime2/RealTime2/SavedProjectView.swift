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
        // Add other gauge value properties as needed
    }
    
    func loadSavedFiles() {
        do {
            let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentDirectoryURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            
            savedFiles = fileURLs.filter { $0.pathExtension == "json" }.map {
                SavedFile(name: $0.lastPathComponent, fileURL: $0)
            }
        } catch {
            print("Error loading saved files: \(error.localizedDescription)")
        }
    }
    
    func loadGaugeData(file: inout SavedFile) {
        do {
            let jsonData = try Data(contentsOf: file.fileURL)
            let decoder = JSONDecoder()
            file.gaugeData = try decoder.decode(GaugeData.self, from: jsonData)
        } catch {
            print("Error loading gauge data for file \(file.name): \(error.localizedDescription)")
        }
    }
    func deleteFile(file: SavedFile) {
        do {
            try FileManager.default.removeItem(at: file.fileURL)
            savedFiles.removeAll(where: { $0.id == file.id })
        } catch {
            print("Error deleting file \(file.name): \(error.localizedDescription)")
        }
    }
  
    struct ShareSheet: UIViewControllerRepresentable {
        let activityItems: [Any]

        func makeUIViewController(context: Context) -> UIActivityViewController {
            let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            return activityViewController
        }

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
