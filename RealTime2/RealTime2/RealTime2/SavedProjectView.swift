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
    
    func countValuesInRange(of values: [Double], lowerBound: Double, upperBound: Double) -> (Int, Int, Int) {
        var belowCount = 0
        var withinCount = 0
        var aboveCount = 0
        
        for value in values {
            if value < lowerBound {
                belowCount += 1
            } else if value >= lowerBound && value <= upperBound {
                withinCount += 1
            } else {
                aboveCount += 1
            }
        }
        
        return (belowCount, withinCount, aboveCount)
    }
    
    func calculateStandardDeviation(of values: [Double]) -> Double? {
        guard !values.isEmpty else {
            return nil
        }
        
        guard let average = calculateAverage(of: values) else {
            return nil
        }
        
        let sumOfSquaredDifferences = values.reduce(0) { result, value in
            let difference = value - average
            return result + (difference * difference)
        }
        
        let variance = sumOfSquaredDifferences / Double(values.count)
        let standardDeviation = sqrt(variance)
        
        return standardDeviation
    }
    
    func calculateCoefficientOfVariation(values: [Double]) -> Double? {
        guard let standardDeviation = calculateStandardDeviation(of: values),
              let average = calculateAverage(of: values) else {
            return nil
        }
        
        let coefficientOfVariation = (standardDeviation / average) * 100
        
        return coefficientOfVariation
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
                            ScrollView(.vertical){
                            VStack{
                                Text("Limits")
                                    .font(.title)
                                    .bold()
                                    .foregroundStyle(.orange)
                                    .padding(.bottom, 10)
                                    .padding(.top, 20)
                                HStack(spacing: 25) {
                                    VStack {
                                        Text("Current Range")
                                            .bold()
                                            .underline()
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
                                            .underline()
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
                                            .underline()
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
                                            .underline()
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
                                            .underline()
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
                                                .underline()
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
                                                .underline()
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
                                                .underline()
                                                .foregroundStyle(.orange)
                                            
                                            if let averageValue3 = calculateAverage(of: gaugeData.gauge3Values) {
                                                Text(String(format: "%.2f", averageValue3))
                                                    .foregroundColor(Range2(value: averageValue3, lowerBound: gaugeData.slider3Lower.upperBound, upperBound: gaugeData.slider3Range.upperBound) ? .green : .red)
                                            } else {
                                                Text("No values found")
                                            }
                                        }
                                    }
                                    .padding(.bottom, 20)
                                    HStack(spacing: 20){
                                        VStack {
                                            Text("Average Z-Axis")
                                                .bold()
                                                .foregroundStyle(.orange)
                                                .underline()
                                            
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
                                                .underline()
                                            
                                            if let averageValue5 = calculateAverage(of: gaugeData.gauge5Values) {
                                                Text(String(format: "%.2f", averageValue5))
                                                    .foregroundColor(Range2(value: averageValue5, lowerBound: gaugeData.slider5Lower.upperBound, upperBound: gaugeData.slider5Range.upperBound) ? .green : .red)
                                            } else {
                                                Text("No values found")
                                            }
                                        }
                                    }
                                    .padding(.bottom, 30)
                                    VStack{
                                        Text("Consistancy")
                                            .font(.title)
                                            .bold()
                                            .foregroundStyle(.orange)
                                            .padding(.bottom, 10)
                                        
                                        HStack(spacing: 20) {
                                            VStack {
                                                Text("Current")
                                                    .bold()
                                                    .underline()
                                                    .foregroundStyle(.orange)
                                                
                                                if let conValue1 = calculateStandardDeviation(of: gaugeData.gauge1Values) {
                                                    Text(String(format: "%.2f", conValue1))
                                                        .foregroundColor(Range2(value: conValue1, lowerBound: 0, upperBound: 1) ? .green : .red)
                                                } else {
                                                    Text("No values found")
                                                }
                                            }
                                            VStack {
                                                Text("X-Axis")
                                                    .bold()
                                                    .underline()
                                                    .foregroundStyle(.orange)
                                                
                                                if let conValue2 = calculateStandardDeviation(of: gaugeData.gauge2Values) {
                                                    Text(String(format: "%.2f", conValue2))
                                                        .foregroundColor(Range2(value: conValue2, lowerBound: 0, upperBound: 1) ? .green : .red)
                                                } else {
                                                    Text("No values found")
                                                }
                                            }
                                            VStack {
                                                Text("Y-Axis")
                                                    .bold()
                                                    .underline()
                                                    .foregroundStyle(.orange)
                                                
                                                if let conValue3 = calculateStandardDeviation(of: gaugeData.gauge3Values) {
                                                    Text(String(format: "%.2f", conValue3))
                                                        .foregroundColor(Range2(value: conValue3, lowerBound: 0, upperBound: 1) ? .green : .red)
                                                } else {
                                                    Text("No values found")
                                                }
                                            }
                                            
                                        }
                                        .padding(.bottom, 20)
                                        HStack(spacing: 20) {
                                            VStack {
                                                Text("Z-Axis")
                                                    .bold()
                                                    .underline()
                                                    .foregroundStyle(.orange)
                                                
                                                if let conValue4 = calculateStandardDeviation(of: gaugeData.gauge4Values) {
                                                    Text(String(format: "%.2f", conValue4))
                                                        .foregroundColor(Range2(value: conValue4, lowerBound: 0, upperBound: 1) ? .green : .red)
                                                } else {
                                                    Text("No values found")
                                                }
                                            }
                                            VStack {
                                                Text("Rod")
                                                    .bold()
                                                    .underline()
                                                    .foregroundStyle(.orange)
                                                
                                                if let conValue5 = calculateStandardDeviation(of: gaugeData.gauge5Values) {
                                                    Text(String(format: "%.2f", conValue5))
                                                        .foregroundColor(Range2(value: conValue5, lowerBound: 0, upperBound: 1) ? .green : .red)
                                                } else {
                                                    Text("No values found")
                                                }
                                            }
                                        }
                                    }
                                    .padding(.bottom, 20)
                                    VStack {
                                        Text("Ranges")
                                            .font(.title)
                                            .bold()
                                            .foregroundStyle(.orange)
                                            .padding(.bottom, 10)
                                        
                                        VStack {
                                            Text("Current Ranges")
                                                .font(.system(size: 14))
                                                .bold()
                                                .underline()
                                                .foregroundStyle(.orange)
                                                .padding(.bottom, 5)
                                            
                                            HStack(spacing: 20){
                                                let result = countValuesInRange(of: gaugeData.gauge1Values, lowerBound: gaugeData.slider1Lower.upperBound, upperBound: gaugeData.slider1Range.upperBound)
                                                if let firstValue = result.0 as Int? {
                                                    VStack {
                                                        Text("Below Range")
                                                            .foregroundStyle(.orange)
                                                        Text(String(firstValue))
                                                            .foregroundStyle(.red)
                                                    }
                                                }
                                                if let SecondValue = result.1 as Int? {
                                                    VStack {
                                                        Text("In Range")
                                                            .foregroundStyle(.orange)
                                                        Text(String(SecondValue))
                                                            .foregroundStyle(.green)
                                                    }
                                                }
                                                if let thirdValue = result.2 as Int? {
                                                    VStack {
                                                        Text("Above Range")
                                                            .foregroundStyle(.orange)
                                                        Text(String(thirdValue))
                                                            .foregroundStyle(.red)
                                                    }
                                                    
                                                }
                                            }
                                        }
                                        .padding(.bottom, 10)
                                        VStack {
                                            Text("X-Axis Ranges")
                                                .font(.system(size: 14))
                                                .bold()
                                                .underline()
                                                .foregroundStyle(.orange)
                                                .padding(.bottom, 5)
                                            
                                            HStack(spacing: 20){
                                                let result1 = countValuesInRange(of: gaugeData.gauge2Values, lowerBound: gaugeData.slider2Lower.upperBound, upperBound: gaugeData.slider2Range.upperBound)
                                                if let firstValue1 = result1.0 as Int? {
                                                    VStack {
                                                        Text("Below Range")
                                                            .foregroundStyle(.orange)
                                                        Text(String(firstValue1))
                                                            .foregroundStyle(.red)
                                                    }
                                                }
                                                if let SecondValue1 = result1.1 as Int? {
                                                    VStack {
                                                        Text("In Range")
                                                            .foregroundStyle(.orange)
                                                        Text(String(SecondValue1))
                                                            .foregroundStyle(.green)
                                                    }
                                                }
                                                if let thirdValue1 = result1.2 as Int? {
                                                    VStack {
                                                        Text("Above Range")
                                                            .foregroundStyle(.orange)
                                                        Text(String(thirdValue1))
                                                            .foregroundStyle(.red)
                                                    }
                                                    
                                                }
                                            }
                                        }
                                        .padding(.bottom, 10)
                                        VStack {
                                            Text("Y-Axis Ranges")
                                                .font(.system(size: 14))
                                                .bold()
                                                .underline()
                                                .foregroundStyle(.orange)
                                                .padding(.bottom, 5)
                                            
                                            HStack(spacing: 20){
                                                let result2 = countValuesInRange(of: gaugeData.gauge3Values, lowerBound: gaugeData.slider3Lower.upperBound, upperBound: gaugeData.slider3Range.upperBound)
                                                if let firstValue2 = result2.0 as Int? {
                                                    VStack {
                                                        Text("Below Range")
                                                            .foregroundStyle(.orange)
                                                        Text(String(firstValue2))
                                                            .foregroundStyle(.red)
                                                    }
                                                }
                                                if let SecondValue2 = result2.1 as Int? {
                                                    VStack {
                                                        Text("In Range")
                                                            .foregroundStyle(.orange)
                                                        Text(String(SecondValue2))
                                                            .foregroundStyle(.green)
                                                    }
                                                }
                                                if let thirdValue2 = result2.2 as Int? {
                                                    VStack {
                                                        Text("Above Range")
                                                            .foregroundStyle(.orange)
                                                        Text(String(thirdValue2))
                                                            .foregroundStyle(.red)
                                                    }
                                                    
                                                }
                                            }
                                        }
                                        .padding(.bottom, 10)
                                        VStack {
                                            Text("Z-Axis Ranges")
                                                .font(.system(size: 14))
                                                .bold()
                                                .underline()
                                                .foregroundStyle(.orange)
                                                .padding(.bottom, 5)
                                            
                                            HStack(spacing: 20){
                                                let result3 = countValuesInRange(of: gaugeData.gauge4Values, lowerBound: gaugeData.slider4Lower.upperBound, upperBound: gaugeData.slider4Range.upperBound)
                                                if let firstValue3 = result3.0 as Int? {
                                                    VStack {
                                                        Text("Below Range")
                                                            .foregroundStyle(.orange)
                                                        Text(String(firstValue3))
                                                            .foregroundStyle(.red)
                                                    }
                                                }
                                                if let SecondValue3 = result3.1 as Int? {
                                                    VStack {
                                                        Text("In Range")
                                                            .foregroundStyle(.orange)
                                                        Text(String(SecondValue3))
                                                            .foregroundStyle(.green)
                                                    }
                                                }
                                                if let thirdValue3 = result3.2 as Int? {
                                                    VStack {
                                                        Text("Above Range")
                                                            .foregroundStyle(.orange)
                                                        Text(String(thirdValue3))
                                                            .foregroundStyle(.red)
                                                    }
                                                    
                                                }
                                            }
                                        }
                                        .padding(.bottom, 10)
                                        VStack {
                                            Text("Rod Ranges")
                                                .font(.system(size: 14))
                                                .bold()
                                                .underline()
                                                .foregroundStyle(.orange)
                                                .padding(.bottom, 5)
                                            
                                            HStack(spacing: 20){
                                                let result4 = countValuesInRange(of: gaugeData.gauge5Values, lowerBound: gaugeData.slider5Lower.upperBound, upperBound: gaugeData.slider5Range.upperBound)
                                                if let firstValue4 = result4.0 as Int? {
                                                    VStack {
                                                        Text("Below Range")
                                                            .foregroundStyle(.orange)
                                                        Text(String(firstValue4))
                                                            .foregroundStyle(.red)
                                                    }
                                                }
                                                if let SecondValue4 = result4.1 as Int? {
                                                    VStack {
                                                        Text("In Range")
                                                            .foregroundStyle(.orange)
                                                        Text(String(SecondValue4))
                                                            .foregroundStyle(.green)
                                                    }
                                                }
                                                if let thirdValue4 = result4.2 as Int? {
                                                    VStack {
                                                        Text("Above Range")
                                                            .foregroundStyle(.orange)
                                                        Text(String(thirdValue4))
                                                            .foregroundStyle(.red)
                                                    }
                                                    
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding(.bottom, 30)
                                VStack {
                                    Text("Coefficient of Variation")
                                        .font(.title)
                                        .bold()
                                        .foregroundStyle(.orange)
                                        .padding(.bottom, 10)
                                    HStack(spacing: 20){
                                        VStack {
                                            Text("Current")
                                                .foregroundStyle(.orange)
                                                .underline()
                                                .bold()
                                            if let varValue1 = calculateCoefficientOfVariation(values: gaugeData.gauge1Values) {
                                                Text(String(format: "%.2f%%", varValue1))
                                                    .foregroundColor(Range2(value: varValue1, lowerBound: 0, upperBound: 10) ? .green : .red)
                                            } else {
                                                Text("No values found")
                                            }
                                        }
                                        VStack {
                                            Text("X-Axis")
                                                .foregroundStyle(.orange)
                                                .underline()
                                                .bold()
                                            if let varValue2 = calculateCoefficientOfVariation(values: gaugeData.gauge2Values) {
                                                Text(String(format: "%.2f%%", varValue2))
                                                    .foregroundColor(Range2(value: varValue2, lowerBound: 0, upperBound: 10) ? .green : .red)
                                            } else {
                                                Text("No values found")
                                            }
                                        }
                                        VStack {
                                            Text("Y-Axis")
                                                .foregroundStyle(.orange)
                                                .underline()
                                                .bold()
                                            if let varValue3 = calculateCoefficientOfVariation(values: gaugeData.gauge3Values) {
                                                Text(String(format: "%.2f%%", varValue3))
                                                    .foregroundColor(Range2(value: varValue3, lowerBound: 0, upperBound: 10) ? .green : .red)
                                            } else {
                                                Text("No values found")
                                            }
                                        }
                                    }
                                    .padding(.bottom,  10)
                                    HStack(spacing: 20) {
                                        VStack {
                                            Text("Z-Axis")
                                                .foregroundStyle(.orange)
                                                .underline()
                                                .bold()
                                            if let varValue4 = calculateCoefficientOfVariation(values: gaugeData.gauge4Values) {
                                                Text(String(format: "%.2f%%", varValue4))
                                                    .foregroundColor(Range2(value: varValue4, lowerBound: 0, upperBound: 10) ? .green : .red)
                                            } else {
                                                Text("No values found")
                                            }
                                        }
                                        VStack {
                                            Text("Rod")
                                                .foregroundStyle(.orange)
                                                .underline()
                                                .bold()
                                            if let varValue5 = calculateCoefficientOfVariation(values: gaugeData.gauge5Values) {
                                                Text(String(format: "%.2f%%", varValue5))
                                                    .foregroundColor(Range2(value: varValue5, lowerBound: 0, upperBound: 10) ? .green : .red)
                                            } else {
                                                Text("No values found")
                                            }
                                        }
                                    }
                                    .padding(.bottom, 10)
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
