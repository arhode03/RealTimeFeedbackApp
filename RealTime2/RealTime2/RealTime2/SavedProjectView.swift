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
    @State private var isMath = false
    
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
        
        var slider1Range: ClosedRange<Double>
        var slider2Range: ClosedRange<Double>
        var slider3Range: ClosedRange<Double>
        var slider4Range: ClosedRange<Double>
        var slider5Range: ClosedRange<Double>
        
        var slider1Lower: ClosedRange<Double>
        var slider2Lower: ClosedRange<Double>
        var slider3Lower: ClosedRange<Double>
        var slider4Lower: ClosedRange<Double>
        var slider5Lower: ClosedRange<Double>
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
    
    func isInRange(_ value: Double, lowerBound: Double, upperBound: Double) -> Bool {
        return value >= lowerBound && value < upperBound
    }
    
    func Range2(value: Double, lowerBound: Double, upperBound: Double) -> Bool {
        return value >= lowerBound && value < upperBound
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
    
    func calculateAverage(of values: [Double]) -> Double? {
        guard !values.isEmpty else {
            return nil
        }
        
        let sum = values.reduce(0, +)
        let average = sum / Double(values.count)
        
        return average
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
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                VStack {
                                    Text("Time")
                                    ForEach(0..<gaugeData.gauge1Values.count, id: \.self) { index in
                                        Text(String(index + 1) + "s")
                                    }
                                }
                                VStack {
                                    Text("Current")
                                    ForEach(gaugeData.gauge1Values, id: \.self) { value in
                                        Text(String(format: "%.2f", value) + "A")
                                            .foregroundColor(isInRange(value, lowerBound: gaugeData.slider1Lower.upperBound, upperBound: gaugeData.slider1Range.upperBound) ? .green : .red)
                                           
                                    }
                                }
                                VStack {
                                    Text("X-Axis")
                                    ForEach(gaugeData.gauge2Values, id: \.self) { value in
                                        Text(String(format: "%.2f", value) + "°")
                                            .foregroundColor(isInRange(value, lowerBound: gaugeData.slider2Lower.upperBound, upperBound: gaugeData.slider2Range.upperBound) ? .green : .red)
                                    }
                                }
                                VStack {
                                    Text("Y Axis")
                                    ForEach(gaugeData.gauge3Values, id: \.self) { value in
                                        Text(String(format: "%.2f", value) + "°")
                                            .foregroundColor(isInRange(value, lowerBound: gaugeData.slider3Lower.upperBound, upperBound: gaugeData.slider3Range.upperBound) ? .green : .red)
                                    }
                                }
                                VStack {
                                    Text("Z Axis")
                                    ForEach(gaugeData.gauge4Values, id: \.self) { value in
                                        Text(String(format: "%.2f", value) + "°")
                                            .foregroundColor(isInRange(value, lowerBound: gaugeData.slider4Lower.upperBound, upperBound: gaugeData.slider4Range.upperBound) ? .green : .red)
                                    }
                                }
                                VStack {
                                    Text("Rod Left:")
                                    ForEach(gaugeData.gauge5Values, id: \.self) { value in
                                        Text(String(format: "%.2f", value) + " in")
                                            .foregroundColor(isInRange(value, lowerBound: gaugeData.slider5Lower.upperBound, upperBound: gaugeData.slider5Range.upperBound) ? .green : .red)
                                    }
                                }
                            }
                        }
                        .toolbar {
                            Button(action: {
                                isMath.toggle()
                            }) {
                                Text("Analytics")
                            }
                        }
                        .sheet(isPresented: $isMath) {
                            VStack{
                                Text("Limits")
                                    .font(.title)
                                    .bold()
                                    .foregroundStyle(.orange)
                                    .padding(.bottom, 10)
                                HStack(spacing: 25) {
                                    VStack {
                                        Text("Current Range")
                                            .bold()
                                            .foregroundColor(.orange)
                                        HStack{
                                            Text(String(format: "%.0f", gaugeData.slider1Lower.upperBound) + "A")
                                                .foregroundColor(.green)
                                            Text("->")
                                                .foregroundColor(.orange)
                                            Text(String(format: "%.0f", gaugeData.slider1Range.upperBound) + "A")
                                                .foregroundColor(.red)
                                        }
                                    }
                                   
                                    VStack {
                                        Text("X-Axis Range")
                                            .bold()
                                            .foregroundColor(.orange)
                                        HStack{
                                            Text(String(format: "%.0f", gaugeData.slider2Lower.upperBound) + "°")
                                                .foregroundColor(.green)
                                            Text("->")
                                                .foregroundColor(.orange)
                                            Text(String(format: "%.0f", gaugeData.slider2Range.upperBound) + "°")
                                                .foregroundColor(.red)
                                        }
                                    }
                                   
                                    VStack {
                                        Text("Y-Axis Range")
                                            .bold()
                                            .foregroundColor(.orange)
                                        HStack{
                                            Text(String(format: "%.0f", gaugeData.slider3Lower.upperBound) + "°")
                                                .foregroundColor(.green)
                                            Text("->")
                                                .foregroundColor(.orange)
                                            Text(String(format: "%.0f", gaugeData.slider3Range.upperBound) + "°")
                                                .foregroundColor(.red)
                                        }
                                    }
                                    
                                }
                                .padding(.bottom, 20)
                                HStack(spacing: 25) {
                                    VStack {
                                        Text("Z-Axis Range")
                                            .bold()
                                            .foregroundColor(.orange)
                                        HStack{
                                            Text(String(format: "%.0f", gaugeData.slider4Lower.upperBound) + "°")
                                                .foregroundColor(.green)
                                            Text("->")
                                                .foregroundColor(.orange)
                                            Text(String(format: "%.0f", gaugeData.slider4Range.upperBound) + "°")
                                                .foregroundColor(.red)
                                        }
                                    }
                               
                                    VStack {
                                        Text("Rod Length Buffer")
                                            .bold()
                                            .foregroundColor(.orange)
                                        HStack{
                                            Text(String(format: "%.0f", gaugeData.slider5Lower.upperBound) + "in")
                                                .foregroundColor(.green)
                                            Text("->")
                                                .foregroundColor(.orange)
                                            Text(String(format: "%.0f", gaugeData.slider5Range.upperBound) + "in")
                                                .foregroundColor(.red)
                                        }
                                    }
                               
                                }
                                .padding(.bottom, 30)
                                VStack{
                                    Text("Averages")
                                        .font(.title)
                                        .bold()
                                        .foregroundStyle(.orange)
                                        .padding(.bottom, 10)
                                    
                                    HStack(spacing: 20) {
                                        VStack {
                                            Text("Average Current")
                                                .bold()
                                                .foregroundStyle(.orange)
                                         
                                            
                                            if let averageValue1 = calculateAverage(of: gaugeData.gauge1Values) {
                                                Text(String(format: "%.2f", averageValue1))
                                                    .foregroundColor(Range2(value: averageValue1, lowerBound: gaugeData.slider1Lower.upperBound, upperBound: gaugeData.slider1Range.upperBound) ? .green : .red)
                                            } else {
                                                Text("No values found")
                                            }
                                        }
                                        
                                        VStack {
                                            Text("Average X-Axis")
                                                .bold()
                                                .foregroundStyle(.orange)
                                            
                                            if let averageValue2 = calculateAverage(of: gaugeData.gauge2Values) {
                                                Text(String(format: "%.2f", averageValue2))
                                                    .foregroundColor(Range2(value: averageValue2, lowerBound: gaugeData.slider2Lower.upperBound, upperBound: gaugeData.slider2Range.upperBound) ? .green : .red)
                                            } else {
                                                Text("No values found")
                                            }
                                        }
                                        VStack {
                                            Text("Average Y-Axis")
                                                .bold()
                                                .foregroundStyle(.orange)
                                            
                                            if let averageValue3 = calculateAverage(of: gaugeData.gauge3Values) {
                                                Text(String(format: "%.2f", averageValue3))
                                                    .foregroundColor(Range2(value: averageValue3, lowerBound: gaugeData.slider3Lower.upperBound, upperBound: gaugeData.slider3Range.upperBound) ? .green : .red)
                                            } else {
                                                Text("No values found")
                                            }
                                        }
                                    }
                                    HStack(spacing: 20){
                                        VStack {
                                            Text("Average Z-Axis")
                                                .bold()
                                                .foregroundStyle(.orange)
                                            
                                            if let averageValue4 = calculateAverage(of: gaugeData.gauge4Values) {
                                                Text(String(format: "%.2f", averageValue4))
                                                    .foregroundColor(Range2(value: averageValue4, lowerBound: gaugeData.slider4Lower.upperBound, upperBound: gaugeData.slider4Range.upperBound) ? .green : .red)
                                            } else {
                                                Text("No values found")
                                            }
                                        }
                                        VStack {
                                            Text("Average Rod")
                                                .bold()
                                                .foregroundStyle(.orange)
                                            
                                            if let averageValue5 = calculateAverage(of: gaugeData.gauge5Values) {
                                                Text(String(format: "%.2f", averageValue5))
                                                    .foregroundColor(Range2(value: averageValue5, lowerBound: gaugeData.slider5Lower.upperBound, upperBound: gaugeData.slider5Range.upperBound) ? .green : .red)
                                            } else {
                                                Text("No values found")
                                            }
                                        }
                                    }
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
