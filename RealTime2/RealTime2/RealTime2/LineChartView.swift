//
//  LineChartView.swift
//  RealTime2
//
//  Created by Alex Rhodes on 12/3/23.
//

import Foundation
import SwiftUI
import SwiftUICharts


struct LineChartView: View {
    
    @State private var savedFiles: [SavedFile] = []
    @State private var selectedFile: SavedFile?
    @State private var selectedGauge: Int?
    @State private var isSelected = false
    
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
            let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentDirectoryURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            savedFiles = fileURLs.filter { $0.pathExtension == "json" }.map {
                SavedFile(name: $0.lastPathComponent, fileURL: $0)
            }
        } 
        catch {
            print("Error loading saved files: \(error.localizedDescription)")
        }
    }
    
    func loadGaugeData(file: inout SavedFile) {
        do {
            let jsonData = try Data(contentsOf: file.fileURL)
            let decoder = JSONDecoder()
            file.gaugeData = try decoder.decode(GaugeData.self, from: jsonData)
        } 
        catch {
            print("Error loading gauge data for file \(file.name): \(error.localizedDescription)")
        }
    }
    
    func deleteFile(at indexSet: IndexSet) {
        let indicesToRemove = IndexSet(indexSet)
        savedFiles.remove(atOffsets: indicesToRemove)
    }
    
    var body: some View {
        VStack {
            if savedFiles.isEmpty {
                Text("No saved files found.")
            }
            else {
                List(savedFiles) { file in
                    HStack {
                        Button(action: {
                            selectedFile = file
                            loadGaugeData(file: &selectedFile!)
                            isSelected = true
                        }) {
                            Text(file.name)
                        }
                        .onTapGesture {
                            selectedFile = file
                            loadGaugeData(file: &selectedFile!)
                        }
                        
                    }
                }
                .sheet(isPresented: $isSelected){
                    if let selectedFile = selectedFile {
                        if let gaugeData = selectedFile.gaugeData {
                            ScrollView(.vertical) {
                                VStack {
                                    Spacer().frame(height: 15)
                                    Text(selectedFile.name)
                                                            .font(.title)
                                                            .fontWeight(.bold)
                                                            .foregroundColor(Color.orange)
                                    Spacer().frame(height: 20)
                                    HStack {

                                        Button(action: {
                                            selectedGauge = 0
                                        }) {
                                            RectangleButton(color: Color.orange, title: "Voltage")
                                        }
                                        Button(action: {
                                            selectedGauge = 1
                                        }) {
                                            RectangleButton(color: Color.orange, title: "X-Axis")
                                        }
                                        Button(action: {
                                            selectedGauge = 2
                                        }) {
                                            RectangleButton(color: Color.orange, title: "Y-Axis")
                                        }
                                    }
                                    .padding(.bottom, 20)
                                    HStack {
                                        Button(action: {
                                            selectedGauge = 3
                                        }) {
                                            RectangleButton(color: Color.orange, title: "Z-Axis")
                                        }
                                        Button(action: {
                                            selectedGauge = 4
                                        }) {
                                            RectangleButton(color: Color.orange, title: "Rod Left")
                                        }
                                    }
                                    if let selectedGauge = selectedGauge {
                                        switch selectedGauge {
                                        case 0:
                                            LineView(data: gaugeData.gauge1Values, title: "Voltage")
                                                
                                        case 1:
                                            LineView(data: gaugeData.gauge2Values, title: "X-Axis")
                                                
                                        case 2:
                                            LineView(data: gaugeData.gauge3Values, title: "Y-Axis")
                                                
                                        case 3:
                                            LineView(data: gaugeData.gauge4Values, title: "Z-Axis")
                                        case 4:
                                            LineView(data: gaugeData.gauge5Values, title: "Rod Length")
                                        default:
                                            Text("Invalid gauge selected.")
                                        }
                                    }
                                        Spacer()
                                }
                            }
                            
                        } else {
                            Text("No gauge data found for file \(selectedFile.name).")
                        }
                    } else {
                        Text("Select a file to view gauge values.")
                    }
                }
                
            }
        }
                .onAppear {
                    loadSavedFiles()
                }
        }
    }
