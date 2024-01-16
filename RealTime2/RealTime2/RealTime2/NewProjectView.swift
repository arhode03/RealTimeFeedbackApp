//
//  NewProjectView.swift
//  Real_time
//
//  Created by Alex Rhodes on 9/2/23.
//

import SwiftUI
import CoreData
import AVFoundation
import AVKit

struct GaugeView: View {
    var value: Double
    var label: String
    var range: ClosedRange<Double> // Declare a property `range` of type ClosedRange<Double>.
    @Binding private var slider1Range: ClosedRange<Double> // Declare a private property `slider1Range` of type Binding<ClosedRange<Double>>.
    @Binding private var slider2Range: ClosedRange<Double>
    @Binding private var slider3Range: ClosedRange<Double>
    @Binding private var slider4Range: ClosedRange<Double>
    @Binding private var slider5Range: ClosedRange<Double>
    @Binding private var slider1Lower: ClosedRange<Double> // Declare a private property `slider1Lower` of type Binding<ClosedRange<Double>>.
    @Binding private var slider2Lower: ClosedRange<Double>
    @Binding private var slider3Lower: ClosedRange<Double>
    @Binding private var slider4Lower: ClosedRange<Double>
    @Binding private var slider5Lower: ClosedRange<Double>
    
    init(value: Double, label: String, range: ClosedRange<Double>, slider1Range: Binding<ClosedRange<Double>>, slider2Range: Binding<ClosedRange<Double>>, slider3Range: Binding<ClosedRange<Double>>, slider4Range: Binding<ClosedRange<Double>>, slider5Range: Binding<ClosedRange<Double>>, slider1Lower: Binding<ClosedRange<Double>>, slider2Lower: Binding<ClosedRange<Double>>, slider3Lower: Binding<ClosedRange<Double>>, slider4Lower: Binding<ClosedRange<Double>>, slider5Lower: Binding<ClosedRange<Double>>) {
        self.value = value // Assign the value parameter to the `value` property.
        self.label = label
        self.range = range
        _slider1Range = slider1Range // Assign the slider1Range parameter to the `slider1Range` property.
        _slider2Range = slider2Range
        _slider3Range = slider3Range
        _slider4Range = slider4Range
        _slider5Range = slider5Range
        _slider1Lower = slider1Lower
        _slider2Lower = slider2Lower
        _slider3Lower = slider3Lower
        _slider4Lower = slider4Lower
        _slider5Lower = slider5Lower
    }
    
    var body: some View {
        VStack {
            Text(label)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.orange)
            Gauge(value: value, in: range) { // Create a Gauge view with the `value` and `range` properties.
                Text(String(format: "%.2f", value)) // Display the formatted value of the `value` property in a text view.
                    .font(.system(size: 18, design: .rounded))
                    .foregroundColor(.orange)
            }
            .accentColor(.orange) // Set the accent color of the Gauge view to orange
            .overlay( // Apply an overlay to the Gauge view.
                GeometryReader { geometry in // Use a GeometryReader to access the view's size and position.
                    ZStack {
                        if label == "Current" { // Check if the `label` property is equal to "Current".
                            Path { path in // Create a path for drawing the line.
                                let x = CGFloat(valueToPercentage(slider1Range.upperBound, range: range)) * geometry.size.width // Calculate the x-coordinate of the line based on the slider range.
                                let lineHeight: CGFloat = geometry.size.height / 2  //change the height of the line
                                path.move(to: CGPoint(x: x, y: lineHeight)) // Move the starting point of the line.
                                path.addLine(to: CGPoint(x: x, y: geometry.size.height)) // Add a line to the specified point.
                            }
                            .stroke(Color.green, lineWidth: 2) // Set the stroke color and line width.
                            Path { path in
                                let x = CGFloat(valueToPercentage(slider1Lower.upperBound, range: range)) * geometry.size.width
                                let lineHeight: CGFloat = geometry.size.height / 2
                                path.move(to: CGPoint(x: x, y: lineHeight))
                                path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                            }
                            .stroke(Color.red, lineWidth: 2)
                            
                        } else if label == "X Axis Angle" {
                            Path { path in
                                let x = CGFloat(valueToPercentage(slider2Range.upperBound, range: range)) * geometry.size.width
                                let lineHeight: CGFloat = geometry.size.height / 2
                                path.move(to: CGPoint(x: x, y: lineHeight))
                                path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                            }
                            .stroke(Color.green, lineWidth: 2)
                            Path { path in
                                let x = CGFloat(valueToPercentage(slider2Lower.upperBound, range: range)) * geometry.size.width
                                let lineHeight: CGFloat = geometry.size.height / 2
                                path.move(to: CGPoint(x: x, y: lineHeight))
                                path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                            }
                            .stroke(Color.red, lineWidth: 2)
                            
                        } else if label == "Y Axis Angle" {
                            Path { path in
                                let x = CGFloat(valueToPercentage(slider3Range.upperBound, range: range)) * geometry.size.width
                                let lineHeight: CGFloat = geometry.size.height / 2
                                path.move(to: CGPoint(x: x, y: lineHeight))
                                path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                            }
                            .stroke(Color.green, lineWidth: 2)
                            Path { path in
                                let x = CGFloat(valueToPercentage(slider3Lower.upperBound, range: range)) * geometry.size.width
                                let lineHeight: CGFloat = geometry.size.height / 2
                                path.move(to: CGPoint(x: x, y: lineHeight))
                                path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                            }
                            .stroke(Color.red, lineWidth: 2)
                            
                        } else if label == "Z Axis Angle" {
                            Path { path in
                                let x = CGFloat(valueToPercentage(slider4Range.upperBound, range: range)) * geometry.size.width
                                let lineHeight: CGFloat = geometry.size.height / 2
                                path.move(to: CGPoint(x: x, y: lineHeight))
                                path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                            }
                            .stroke(Color.green, lineWidth: 2)
                            Path { path in
                                let x = CGFloat(valueToPercentage(slider4Lower.upperBound, range: range)) * geometry.size.width
                                let lineHeight: CGFloat = geometry.size.height / 2
                                path.move(to: CGPoint(x: x, y: lineHeight))
                                path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                            }
                            .stroke(Color.red, lineWidth: 2)
                            
                        } else if label == "Rod Left" {
                            Path { path in
                                let x = CGFloat(valueToPercentage(slider5Range.upperBound, range: range)) * geometry.size.width
                                let lineHeight: CGFloat = geometry.size.height / 2
                                path.move(to: CGPoint(x: x, y: lineHeight))
                                path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                            }
                            .stroke(Color.green, lineWidth: 2)
                            Path { path in
                                let x = CGFloat(valueToPercentage(slider5Lower.upperBound, range: range)) * geometry.size.width
                                let lineHeight: CGFloat = geometry.size.height / 2
                                path.move(to: CGPoint(x: x, y: lineHeight))
                                path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                            }
                            .stroke(Color.red, lineWidth: 2)
                       }
                    }
                }
            )
        }
        .padding()
    }
}

func valueToPercentage(_ value: Double, range: ClosedRange<Double>) -> Double {
    let clampedValue = min(max(value, range.lowerBound), range.upperBound) // Clamp the value between the lower and upper bounds of the range.
    let normalizedValue = (clampedValue - range.lowerBound) / (range.upperBound - range.lowerBound) // Normalize the clamped value to a percentage between 0 and 1.
    return normalizedValue // Return the normalized value.
}

func checkGaugeValue(gaugeValue: [Double], sliderValue: [Double], sliderLower: [Double], vibrationType: UINotificationFeedbackGenerator.FeedbackType) {
    // Check the latest value from the gaugeValue array
    if let latestValue = gaugeValue.last {
        // Iterate through each value in the sliderValue array
        for value in sliderValue {
            // Compare the latest value from the gauge with the current value from the slider
            if latestValue > value {
                // Create a UINotificationFeedbackGenerator to provide haptic feedback
                let feedbackGenerator = UINotificationFeedbackGenerator()
                // Prepare the feedback generator
                feedbackGenerator.prepare()
                // Trigger the notification feedback with the specified vibration type
                feedbackGenerator.notificationOccurred(vibrationType)
                break
            }
        }
        for lower in sliderLower {
            // Compare the latest value from the gauge with the current value from the slider
            if latestValue < lower {
                // Create a UINotificationFeedbackGenerator to provide haptic feedback
                let feedbackGenerator = UINotificationFeedbackGenerator()
                // Prepare the feedback generator
                feedbackGenerator.prepare()
                // Trigger the notification feedback with the specified vibration type
                feedbackGenerator.notificationOccurred(vibrationType)
                break
            }
        }

    }
}
func playToneBasedOnGaugeValue(gaugeValue: [Double], sliderValue: [Double], sliderLower: [Double], toneIdentifier: SystemSoundID) {
    // Check the latest value from the gaugeValue array
    if let latestValue = gaugeValue.last {
        // Create an AVAudioPlayer to play the audio tone
        
        // Iterate through each value in the sliderValue array
        for value in sliderValue {
            // Compare the latest value from the gauge with the current value from the slider
            if latestValue > value {
                // Play the audio tone
                AudioServicesPlaySystemSound(toneIdentifier)
                break
            }
        }
        
        for lower in sliderLower {
            // Compare the latest value from the gauge with the current value from the slider
            if latestValue < lower {
                // Play the audio tone
                AudioServicesPlaySystemSound(toneIdentifier)
                break
            }
        }
    }
}

func playAudioTone(gaugeValue: [Double], sliderValue: [Double], sliderLower: [Double]) {
    // Check the latest value from the gaugeValue array
    if let latestValue = gaugeValue.last {
        // Iterate through each value in the sliderValue array
        for value in sliderValue {
            // Compare the latest value from the gauge with the current value from the slider
            if latestValue > value {
                // Play the sound
                guard let soundURL = Bundle.main.url(forResource: "whistle2", withExtension: "mp3") else {
                    // If the sound file is not found, print an error message and return
                    print("Error: Sound file not found")
                    return
                }
                
                let player = AVPlayer(url: soundURL)
                player.play()
            }
        }
    }
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

struct NewProjectView: View {
    
    @State private var gauge1Values: [Double] = [] // Array to store the values for gauge 1..5
    @State private var gauge2Values: [Double] = []
    @State private var gauge3Values: [Double] = []
    @State private var gauge4Values: [Double] = []
    @State private var gauge5Values: [Double] = []
    @State private var gaugeorder: [Double] = []
    @State private var gauge1Range: ClosedRange<Double> = 0...1000 // Range for gauge 1..5 for varying ranges
    @State private var gauge2Range: ClosedRange<Double> = 0...180
    @State private var gauge3Range: ClosedRange<Double> = 0...180
    @State private var gauge4Range: ClosedRange<Double> = 0...180
    @State private var gauge5Range: ClosedRange<Double> = 0...15
    @State private var slider1Range: ClosedRange<Double> = 0...1000 // Range for slider 1..5 varying ranges
    @State private var slider2Range: ClosedRange<Double> = 0...180
    @State private var slider3Range: ClosedRange<Double> = 0...180
    @State private var slider4Range: ClosedRange<Double> = 0...180
    @State private var slider5Range: ClosedRange<Double> = 0...15
    @State private var slider1Lower: ClosedRange<Double> = 0...1000 // Range for sliderLower 1..5 varying ranges
    @State private var slider2Lower: ClosedRange<Double> = 0...180
    @State private var slider3Lower: ClosedRange<Double> = 0...180
    @State private var slider4Lower: ClosedRange<Double> = 0...180
    @State private var slider5Lower: ClosedRange<Double> = 0...15
    @State private var bluetoothDataHandler = BluetoothDataHandler()
    @State private var fileName = "" // Name of the file
    @State private var showSaveFileCreation = false // Boolean flag to control whether to show the save file creation view
    @State private var saveFileName = "" // Name of the file to be saved
    @State private var isShowingSliders = false // Boolean flag to control whether to show the sliders
    @State private var timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect() // Timer that publishes values every 1 second
    @State private var isStarting = false
    @State private var isTesting = false
    
    func createSaveFile() {
        // Retrieve the first values from each gauge values array
        
        // Create an instance of GaugeData with the gauge values
        let gaugeData = GaugeData(gauge1Values: gauge1Values,
                                  gauge2Values: gauge2Values,
                                  gauge3Values: gauge3Values,
                                  gauge4Values: gauge4Values,
                                  gauge5Values: gauge5Values,
                                  slider1Range: slider1Range,
                                  slider2Range: slider2Range,
                                  slider3Range: slider3Range,
                                  slider4Range: slider4Range,
                                  slider5Range: slider5Range,
                                  slider1Lower: slider1Lower,
                                  slider2Lower: slider2Lower,
                                  slider3Lower: slider3Lower,
                                  slider4Lower: slider4Lower,
                                  slider5Lower: slider5Lower)
        
        do {
            // Encode the gaugeData instance into JSON data
            let jsonData = try JSONEncoder().encode(gaugeData)
            
            // Get the file URL for saving the JSON data
            let fileURL = getDocumentsDirectory().appendingPathComponent("\(fileName).json")
            
            // Write the JSON data to the file URL
            try jsonData.write(to: fileURL)
            
            // Print success message
            print("Data saved successfully!")
        } 
        catch {
            // Print error message if an error occurs
            print("Error saving data: \(error.localizedDescription)")
        }
    }
    
    // Returns the URL of the document directory.
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    var body: some View {
        HStack {
               Button(action: {
                   isTesting.toggle()
               }) {
                   Text(isTesting ? "Done" : "Test")
                       .font(.system(size: 18))
                       .foregroundColor(.black)
                       .padding()
                       .background(Color.orange)
                       .cornerRadius(10)
               }
               .padding(.horizontal)
               Button(action: {
                   isStarting.toggle()
               }) {
                   Text(isStarting ? "Finish" : "Start")
                       .font(.system(size: 18))
                       .foregroundColor(.black)
                       .padding()
                       .background(Color.orange)
                       .cornerRadius(10)
                   
               }
           }
        .padding(.top, 10)
            ScrollView {
                LazyVStack {
                    Spacer()
                    GaugeView(value: gauge1Values.last ?? 0, label: "Current", range: gauge1Range, slider1Range: $slider1Range, slider2Range: $slider2Range, slider3Range: $slider3Range, slider4Range: $slider4Range, slider5Range: $slider5Range, slider1Lower: $slider1Lower, slider2Lower: $slider2Lower, slider3Lower: $slider3Lower, slider4Lower: $slider4Lower, slider5Lower: $slider5Lower)
                    GaugeView(value: gauge2Values.last ?? 0, label: "X Axis Angle", range: gauge2Range, slider1Range: $slider1Range, slider2Range: $slider2Range, slider3Range: $slider3Range, slider4Range: $slider4Range, slider5Range: $slider5Range, slider1Lower: $slider1Lower, slider2Lower: $slider2Lower, slider3Lower: $slider3Lower, slider4Lower: $slider4Lower, slider5Lower: $slider5Lower)
                    GaugeView(value: gauge3Values.last ?? 0, label: "Y Axis Angle", range: gauge3Range, slider1Range: $slider1Range, slider2Range: $slider2Range, slider3Range: $slider3Range, slider4Range: $slider4Range, slider5Range: $slider5Range, slider1Lower: $slider1Lower, slider2Lower: $slider2Lower, slider3Lower: $slider3Lower, slider4Lower: $slider4Lower, slider5Lower: $slider5Lower)
                    GaugeView(value: gauge4Values.last ?? 0, label: "Z Axis Angle", range: gauge4Range, slider1Range: $slider1Range, slider2Range: $slider2Range, slider3Range: $slider3Range, slider4Range: $slider4Range, slider5Range: $slider5Range, slider1Lower: $slider1Lower, slider2Lower: $slider2Lower, slider3Lower: $slider3Lower, slider4Lower: $slider4Lower, slider5Lower: $slider5Lower)
                    GaugeView(value: gauge5Values.last ?? 0, label: "Rod Left", range: gauge5Range, slider1Range: $slider1Range, slider2Range: $slider2Range, slider3Range: $slider3Range, slider4Range: $slider4Range, slider5Range: $slider5Range, slider1Lower: $slider1Lower, slider2Lower: $slider2Lower, slider3Lower: $slider3Lower, slider4Lower: $slider4Lower, slider5Lower: $slider5Lower)
                    Spacer()
                }
                .padding(.vertical, 20)
            }
            .navigationBarItems(trailing:
                                    HStack {
                // Button to show save file creation sheet
                Button(action: {
                    // Set the flag to show the save file creation sheet
                    showSaveFileCreation = true
                }) {
                    // Display an icon for saving a file
                    Image(systemName: "square.and.arrow.down")
                }
                .padding()
                .foregroundColor(.blue)
                .sheet(isPresented: $showSaveFileCreation) {
                    VStack {
                        // Title for save file sheet
                        Text("Save File")
                            .font(.title)
                            .bold()
                            .padding()
                        
                        // Text field for entering file name
                        TextField("Enter file name", text: $fileName)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                            .padding(.horizontal)
                        
                        // Button to save the file
                        Button(action: {
                            // Set the saveFileName based on user input
                            saveFileName = fileName
                            
                            // Perform the file-saving operation
                            createSaveFile()
                            
                            // Hide the save file creation sheet
                            showSaveFileCreation = false
                        }) {
                            Text("Save")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                        .padding()
                    }
                }
                
                // Button to show sliders sheet
                Button(action: {
                    // Set the flag to show the sliders sheet
                    isShowingSliders = true
                }) {
                    // Display an icon for sliders
                    Image(systemName: "slider.horizontal.3")
                }
                .sheet(isPresented: $isShowingSliders) {
                    VStack {
                        // Slider for voltage limit
                        Text("Voltage Limit")
                            .foregroundColor(.orange)
                            .font(.system(size: 24, weight: .bold))
                        
                        // Display the upper and lower bound of slider1Range with two decimal places in orange
                        Text("Upper Limit: \(String(format: "%.2f", slider1Range.upperBound))")
                            .foregroundColor(.orange)
                        Text("Lower Limit: \(String(format: "%.2f", slider1Lower.upperBound))")
                            .foregroundColor(.orange)
                        
                        // Slider for adjusting the voltage upper bound between 0 and 1000 with a step of 1
                        Slider(value: Binding(
                            get: { slider1Range.upperBound },
                            set: { newValue in slider1Range = slider1Range.lowerBound...newValue }
                        ), in: 0...1000, step: 1)
                        .accentColor(.green)
                        // Slider for adjusting the voltage lower bound between 0 and 1000 with a step of 1
                        Slider(value: Binding(
                            get: { slider1Lower.upperBound },
                            set: { newValue in slider1Lower = slider1Lower.lowerBound...newValue }
                        ), in: 0...1000, step: 1)
                        .accentColor(.red)
                        
                        Text("X Axis Range")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.orange)
                        
                        Text("Upper Limit: \(String(format: "%.2f", slider2Range.upperBound))")
                            .foregroundColor(.orange)
                        Text("Lower Limit: \(String(format: "%.2f", slider2Lower.upperBound))")
                            .foregroundColor(.orange)
                        
                        Slider(value: Binding(
                            get: { slider2Range.upperBound },
                            set: { newValue in slider2Range = slider2Range.lowerBound...newValue }
                        ), in: 0...180, step: 1)
                        .accentColor(.green)
                        Slider(value: Binding(
                            get: { slider2Lower.upperBound },
                            set: { newValue in slider2Lower = slider2Lower.lowerBound...newValue }
                        ), in: 0...180, step: 1)
                        .accentColor(.red)

                        Text("Y Axis Range")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.orange)
                        
                        Text("Upper Limit: \(String(format: "%.2f", slider3Range.upperBound))")
                            .foregroundColor(.orange)
                        Text("Lower Limit: \(String(format: "%.2f", slider3Lower.upperBound))")
                            .foregroundColor(.orange)
                        
                        Slider(value: Binding(
                            get: { slider3Range.upperBound },
                            set: { newValue in slider3Range = slider3Range.lowerBound...newValue }
                        ), in: 0...180, step: 1)
                        .accentColor(.green)
                        Slider(value: Binding(
                            get: { slider3Lower.upperBound },
                            set: { newValue in slider3Lower = slider3Lower.lowerBound...newValue }
                        ), in: 0...180, step: 1)
                        .accentColor(.red)

                        Text("Z Axis Range")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.orange)
                        
                        Text("Upper Limit: \(String(format: "%.2f", slider4Range.upperBound))")
                            .foregroundColor(.orange)
                        Text("Lower Limit: \(String(format: "%.2f", slider4Lower.upperBound))")
                            .foregroundColor(.orange)
                        
                        Slider(value: Binding(
                            get: { slider4Range.upperBound },
                            set: { newValue in slider4Range = slider4Range.lowerBound...newValue }
                        ), in: 0...180, step: 1)
                        .accentColor(.green)
                        Slider(value: Binding(
                            get: { slider4Lower.upperBound },
                            set: { newValue in slider4Lower = slider4Lower.lowerBound...newValue }
                        ), in: 0...180, step: 1)
                        .accentColor(.red)
                        
                        Text("Threshold Range")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.orange)
                        
                        Text("Upper Limit: \(String(format: "%.2f", slider5Range.upperBound))")
                            .foregroundColor(.orange)
                        Text("Lower Limit: \(String(format: "%.2f", slider5Lower.upperBound))")
                            .foregroundColor(.orange)
                        
                        Slider(value: Binding(
                            get: { slider5Range.upperBound },
                            set: { newValue in slider5Range = slider5Range.lowerBound...newValue }
                        ), in: 0...15, step: 1)
                        .accentColor(.green)
                        Slider(value: Binding(
                            get: { slider5Lower.upperBound },
                            set: { newValue in slider5Lower = slider5Lower.lowerBound...newValue }
                        ), in: 0...15, step: 1)
                        .accentColor(.red)
                    }
                    .padding()
                }
            }
            )
        
        
            .onReceive(timer) { _ in
                if isStarting {
                    /*
                    if let lastValueLabel = bluetoothDataHandler.receivedData.last?.label {
                        if lastValueLabel == "order" {
                            if let lastValue = bluetoothDataHandler.receivedData.last?.value {
                                gaugeorder.append(lastValue)
                            }
                        } else {
                            switch gaugeorder.last {
                            case 0:
                                if !bluetoothDataHandler.receivedData.isEmpty {
                                    // Convert the received data to Double and update the gauge values
                                    let newData = bluetoothDataHandler.receivedData.map { Double($0) ?? 0.0 }
                                    gauge1Values.append(newData[0])
                                }
                            case 1:
                                if !bluetoothDataHandler.receivedData.isEmpty {
                                    // Convert the received data to Double and update the gauge values
                                    let newData = bluetoothDataHandler.receivedData.map { Double($0) ?? 0.0 }
                                    gauge2Values.append(newData[0])
                                }
                            case 2:
                                if !bluetoothDataHandler.receivedData.isEmpty {
                                    // Convert the received data to Double and update the gauge values
                                    let newData = bluetoothDataHandler.receivedData.map { Double($0) ?? 0.0 }
                                    gauge3Values.append(newData[0])
                                }
                            case 3:
                                if !bluetoothDataHandler.receivedData.isEmpty {
                                    // Convert the received data to Double and update the gauge values
                                    let newData = bluetoothDataHandler.receivedData.map { Double($0) ?? 0.0 }
                                    gauge4Values.append(newData[0])
                                }
                            case 4:
                                if !bluetoothDataHandler.receivedData.isEmpty {
                                    // Convert the received data to Double and update the gauge values
                                    let newData = bluetoothDataHandler.receivedData.map { Double($0) ?? 0.0 }
                                    gauge5Values.append(newData[0])
                                }
                            default:
                                Text("error")
                            }
                        }
                    }
                    */
                    // Append random values to arrays for each gauge within their specified ranges
                    gauge1Values.append(Double(String(format: "%.2f", Double.random(in: gauge1Range)))!)
                    gauge2Values.append(Double(String(format: "%.2f", Double.random(in: gauge2Range)))!)
                    gauge3Values.append(Double(String(format: "%.2f", Double.random(in: gauge3Range)))!)
                    gauge4Values.append(Double(String(format: "%.2f", Double.random(in: gauge4Range)))!)
                    gauge5Values.append(Double(String(format: "%.2f", Double.random(in: gauge5Range)))!)
                    
                    //Calls for feedback to the user checking the most recent guage values
                    //checkGaugeValue(gaugeValue: gauge1Values, sliderValue: [slider1Range.upperBound], sliderLower: [slider1Lower.upperBound], vibrationType: .success)
                    //playToneBasedOnGaugeValue(gaugeValue: gauge1Values, sliderValue: [slider1Range.upperBound], sliderLower: [slider1Lower.upperBound], toneIdentifier: 1016)
                    checkGaugeValue(gaugeValue: gauge2Values, sliderValue: [slider2Range.upperBound], sliderLower: [slider2Lower.upperBound], vibrationType: .success)
                    playToneBasedOnGaugeValue(gaugeValue: gauge2Values, sliderValue: [slider2Range.upperBound], sliderLower: [slider2Lower.upperBound], toneIdentifier: 1057)
                    checkGaugeValue(gaugeValue: gauge3Values, sliderValue: [slider3Range.upperBound], sliderLower: [slider3Lower.upperBound], vibrationType: .warning)
                    playToneBasedOnGaugeValue(gaugeValue: gauge3Values, sliderValue: [slider3Range.upperBound], sliderLower: [slider3Lower.upperBound], toneIdentifier: 1100)
                    checkGaugeValue(gaugeValue: gauge4Values, sliderValue: [slider4Range.upperBound], sliderLower: [slider4Lower.upperBound], vibrationType: .error)
                    playToneBasedOnGaugeValue(gaugeValue: gauge4Values, sliderValue: [slider4Range.upperBound], sliderLower: [slider4Lower.upperBound], toneIdentifier: 1105)
                    checkGaugeValue(gaugeValue: gauge5Values, sliderValue: [slider5Range.upperBound], sliderLower: [slider5Lower.upperBound], vibrationType: .success)
                    playToneBasedOnGaugeValue(gaugeValue: gauge5Values, sliderValue: [slider5Range.upperBound], sliderLower: [slider5Lower.upperBound], toneIdentifier: 1106)
                }
                if isTesting {
                   
                }
        }
    }
}
struct NewProjectView_Previews: PreviewProvider {
    static var previews: some View {
        NewProjectView()
        
    }
}
