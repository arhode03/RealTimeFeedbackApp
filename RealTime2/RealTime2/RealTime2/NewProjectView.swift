//
//  NewProjectView.swift
//  Real_time
//
//  Created by Alex Rhodes on 9/2/23.
//

import SwiftUI
import CoreData
import AVFoundation


struct GaugeView: View {
    var value: Double
    var label: String
    var range: ClosedRange<Double> // Declare a property `range` of type ClosedRange<Double>.
    @Binding private var slider1Range: ClosedRange<Double> // Declare a private property `slider1Range` of type Binding<ClosedRange<Double>>.
    @Binding private var slider2Range: ClosedRange<Double> // Declare a private property `slider2Range` of type Binding<ClosedRange<Double>>.
    @Binding private var slider3Range: ClosedRange<Double> // Declare a private property `slider3Range` of type Binding<ClosedRange<Double>>.
    @Binding private var slider4Range: ClosedRange<Double> // Declare a private property `slider4Range` of type Binding<ClosedRange<Double>>.
    @Binding private var slider5Range: ClosedRange<Double> // Declare a private property `slider5Range` of type Binding<ClosedRange<Double>>.
    
    init(value: Double, label: String, range: ClosedRange<Double>, slider1Range: Binding<ClosedRange<Double>>, slider2Range: Binding<ClosedRange<Double>>, slider3Range: Binding<ClosedRange<Double>>, slider4Range: Binding<ClosedRange<Double>>, slider5Range: Binding<ClosedRange<Double>>) {
        self.value = value // Assign the value parameter to the `value` property.
        self.label = label // Assign the label parameter to the `label` property.
        self.range = range // Assign the range parameter to the `range` property.
        _slider1Range = slider1Range // Assign the slider1Range parameter to the `slider1Range` property.
        _slider2Range = slider2Range // Assign the slider2Range parameter to the `slider2Range` property.
        _slider3Range = slider3Range // Assign the slider3Range parameter to the `slider3Range` property.
        _slider4Range = slider4Range // Assign the slider4Range parameter to the `slider4Range` property.
        _slider5Range = slider5Range // Assign the slider5Range parameter to the `slider5Range` property.
    }
    
    var body: some View {
        VStack {
            Text(label)
                .font(.headline)
            Gauge(value: value, in: range) { // Create a Gauge view with the `value` and `range` properties.
                Text(String(format: "%.2f", value)) // Display the formatted value of the `value` property in a text view.
                    .font(.system(size: 28, weight: .bold, design: .rounded))
            }
            .overlay( // Apply an overlay to the Gauge view.
                GeometryReader { geometry in // Use a GeometryReader to access the view's size and position.
                    ZStack { // Create a ZStack to overlay multiple shapes.
                        if label == "Current" { // Check if the `label` property is equal to "Current".
                            Path { path in // Create a path for drawing the line.
                                let x = CGFloat(valueToPercentage(slider1Range.upperBound, range: range)) * geometry.size.width // Calculate the x-coordinate of the line based on the slider range.
                                path.move(to: CGPoint(x: x, y: 0)) // Move the starting point of the line.
                                path.addLine(to: CGPoint(x: x, y: geometry.size.height)) // Add a line to the specified point.
                            }
                            .stroke(Color.red, lineWidth: 2) // Set the stroke color and line width.
                        } else if label == "X Axis Angle" { // Check if the `label` property is equal to "X Axis Angle".
                            Path { path in // Create a path for drawing the line.
                                let x = CGFloat(valueToPercentage(slider2Range.upperBound, range: range)) * geometry.size.width // Calculate the x-coordinate of the line based on the slider range.
                                path.move(to: CGPoint(x: x, y: 0)) // Move the starting point of the line.
                                path.addLine(to: CGPoint(x: x, y: geometry.size.height)) // Add a line to the specified point.
                            }
                            .stroke(Color.red, lineWidth: 2) // Set the stroke color and line width.
                        } else if label == "Y Axis Angle" { // Check if the `label` property is equal to "Y Axis Angle".
                            Path { path in // Create a path for drawing the line.
                                let x = CGFloat(valueToPercentage(slider3Range.upperBound, range: range)) * geometry.size.width // Calculate the x-coordinate of the line based on the slider range.
                                path.move(to: CGPoint(x: x, y: 0)) // Move the starting point of the line.
                                path.addLine(to: CGPoint(x: x, y: geometry.size.height)) // Add a line to the specified point.
                            }
                            .stroke(Color.red, lineWidth: 2) // Set the stroke color and line width.
                        } else if label == "Z Axis Angle" { // Check if the `label` property is equal to "Z Axis Angle".
                            Path { path in // Create a path for drawing the line.
                                let x = CGFloat(valueToPercentage(slider4Range.upperBound, range: range)) * geometry.size.width // Calculate the x-coordinate of the line based on the slider range.
                                path.move(to: CGPoint(x: x, y: 0)) // Move the starting point of the line.
                                path.addLine(to: CGPoint(x: x, y: geometry.size.height)) // Add a line to the specified point.
                            }
                            .stroke(Color.red, lineWidth: 2) // Set the stroke color and line width.
                        } else if label == "Rod Left" { // Check if the `label` property is equal to "Rod Left".
                           Path { path in // Create a path for drawing the line.
                               let x = CGFloat(valueToPercentage(slider5Range.upperBound, range: range)) * geometry.size.width // Calculate the x-coordinate of the line based on the slider range.
                               path.move(to: CGPoint(x: x, y: 0)) // Move the starting point of the line.
                               path.addLine(to: CGPoint(x: x, y: geometry.size.height)) // Add a line to the specified point.
                           }
                           .stroke(Color.red, lineWidth: 2) // Set the stroke color and line width.
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
func checkGaugeValue(gaugeValue: [Double], sliderValue: [Double], vibrationType: UINotificationFeedbackGenerator.FeedbackType) {
    if let latestValue = gaugeValue.last {
        for value in sliderValue {
            if latestValue > value {
                let feedbackGenerator = UINotificationFeedbackGenerator()
                feedbackGenerator.prepare()
                feedbackGenerator.notificationOccurred(vibrationType)
                break
            }
        }
    }
}

struct GaugeData: Codable {
    var gauge1Values: [Double] // Array to store the values for gauge 1
    var gauge2Values: [Double] // Array to store the values for gauge 2
    var gauge3Values: [Double] // Array to store the values for gauge 3
    var gauge4Values: [Double] // Array to store the values for gauge 4
    var gauge5Values: [Double] // Array to store the values for gauge 5
}


struct NewProjectView: View {
    
    @State private var gauge1Values: [Double] = [] // Array to store the values for gauge 1..5
    @State private var gauge2Values: [Double] = []
    @State private var gauge3Values: [Double] = []
    @State private var gauge4Values: [Double] = []
    @State private var gauge5Values: [Double] = []
    
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
    @State private var bluetoothDataHandler = BluetoothDataHandler()
    @State private var fileName = "" // Name of the file
    @State private var showSaveFileCreation = false // Boolean flag to control whether to show the save file creation view
    @State private var saveFileName = "" // Name of the file to be saved
    @State private var isShowingSliders = false // Boolean flag to control whether to show the sliders
    @State private var timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect() // Timer that publishes values every 1 second
    
    func createSaveFile() {
        // Retrieve the first values from each gauge values array
        let _ = gauge1Values[0]
        let _ = gauge2Values[0]
        let _ = gauge3Values[0]
        let _ = gauge4Values[0]
        let _ = gauge5Values[0]
        
        // Create an instance of GaugeData with the gauge values
        let gaugeData = GaugeData(gauge1Values: gauge1Values,
                                  gauge2Values: gauge2Values,
                                  gauge3Values: gauge3Values,
                                  gauge4Values: gauge4Values,
                                  gauge5Values: gauge5Values)
        
        do {
            // Encode the gaugeData instance into JSON data
            let jsonData = try JSONEncoder().encode(gaugeData)
            
            // Get the file URL for saving the JSON data
            let fileURL = getDocumentsDirectory().appendingPathComponent("\(fileName).json")
            
            // Write the JSON data to the file URL
            try jsonData.write(to: fileURL)
            
            // Print success message
            print("Data saved successfully!")
        } catch {
            // Print error message if an error occurs
            print("Error saving data: \(error.localizedDescription)")
        }
    }
    func playAudioTone(gaugeValues: [Double], sliderValues: [Double]) {
        // Check if the gauge values exceed the corresponding slider values
        let latestGaugeValue = gaugeValues.last ?? 0 // Get the latest gauge value
        
        for sliderValue in sliderValues {
            if latestGaugeValue > sliderValue {
                // Play the sound on a background queue
                DispatchQueue.global().async {
                    // Play the sound
                    guard let soundURL = Bundle.main.url(forResource: "tone", withExtension: "mp3") else {
                        // If the sound file is not found, print an error message and return
                        print("Error: Sound file not found")
                        return
                    }
                    
                    do {
                        // Create an AVAudioPlayer instance with the sound URL
                        let player = try AVAudioPlayer(contentsOf: soundURL)
                        // Play the audio
                        player.play()
                    } catch {
                        // If an error occurs while playing the sound, print the error message
                        print("Error playing sound: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    
    // Returns the URL of the document directory.
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    Spacer()
                    GaugeView(value: gauge1Values.last ?? 0, label: "Current", range: gauge1Range, slider1Range: $slider1Range, slider2Range: $slider2Range, slider3Range: $slider3Range, slider4Range: $slider4Range, slider5Range: $slider5Range)
                    GaugeView(value: gauge2Values.last ?? 0, label: "X Axis Angle", range: gauge2Range, slider1Range: $slider1Range, slider2Range: $slider2Range, slider3Range: $slider3Range, slider4Range: $slider4Range, slider5Range: $slider5Range)
                    GaugeView(value: gauge3Values.last ?? 0, label: "Y Axis Angle", range: gauge3Range, slider1Range: $slider1Range, slider2Range: $slider2Range, slider3Range: $slider3Range, slider4Range: $slider4Range, slider5Range: $slider5Range)
                    GaugeView(value: gauge4Values.last ?? 0, label: "Z Axis Angle", range: gauge4Range, slider1Range: $slider1Range, slider2Range: $slider2Range, slider3Range: $slider3Range, slider4Range: $slider4Range, slider5Range: $slider5Range)
                    GaugeView(value: gauge5Values.last ?? 0, label: "Rod Left", range: gauge5Range, slider1Range: $slider1Range, slider2Range: $slider2Range, slider3Range: $slider3Range, slider4Range: $slider4Range, slider5Range: $slider5Range)
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
                            .font(.headline)
                        
                        // Display the upper bound of slider1Range with two decimal places in blue
                        Text("\(String(format: "%.2f", slider1Range.upperBound))")
                            .foregroundColor(.blue)
                        
                        // Slider for adjusting the voltage limit between 0 and 1000 with a step of 1
                        Slider(value: Binding(
                            get: { slider1Range.upperBound },
                            set: { newValue in slider1Range = slider1Range.lowerBound...newValue }
                        ), in: 0...1000, step: 1)
                        
                        // Slider for X Axis range
                        Text("X Axis Range")
                            .font(.headline)
                        
                        // Display the upper bound of slider2Range with two decimal places in blue
                        Text("\(String(format: "%.2f", slider2Range.upperBound))")
                            .foregroundColor(.blue)
                        
                        // Slider for adjusting the X-axis range between 0 and 180 with a step of 1
                        Slider(value: Binding(
                            get: { slider2Range.upperBound },
                            set: { newValue in slider2Range = slider2Range.lowerBound...newValue }
                        ), in: 0...180, step: 1)
                        
                        // Add sliders and corresponding Text views for other gauges here
                        
                        // Text view for Y Axis Range
                        Text("Y Axis Range")
                            .font(.headline)
                        
                        // Display the upper bound of slider3Range for Y-axis range with two decimal places in blue
                        Text("\(String(format: "%.2f", slider3Range.upperBound))")
                            .foregroundColor(.blue)
                        
                        // Slider for adjusting the Y-axis range between 0 and 180 with a step of 1
                        Slider(value: Binding(
                            get: { slider3Range.upperBound },
                            set: { newValue in slider3Range = slider3Range.lowerBound...newValue }
                        ), in: 0...180, step: 1)
                        
                        // Text view for Z Axis Range
                        Text("Z Axis Range")
                            .font(.headline)
                        
                        // Display the upper bound of slider4Range for Z-axis range with two decimal places in blue
                        Text("\(String(format: "%.2f", slider4Range.upperBound))")
                            .foregroundColor(.blue)
                        
                        // Slider for adjusting the Z-axis range between 0 and 180 with a step of 1
                        Slider(value: Binding(
                            get: { slider4Range.upperBound },
                            set: { newValue in slider4Range = slider4Range.lowerBound...newValue }
                        ), in: 0...180, step: 1)
                        
                        // Text view for Threshold Range
                        Text("Threshold Range")
                            .font(.headline)
                        
                        // Display the upper bound of slider5Range for the threshold range with two decimal places in blue
                        Text("\(String(format: "%.2f", slider5Range.upperBound))")
                            .foregroundColor(.blue)
                        
                        // Slider for adjusting the threshold range between 0 and 15 with a step of 1
                        Slider(value: Binding(
                            get: { slider5Range.upperBound },
                            set: { newValue in slider5Range = slider5Range.lowerBound...newValue }
                        ), in: 0...15, step: 1)
                    }
                    
                    .padding()
                    
                }
                
                
            }
            )
            
        }
        
        .onReceive(timer) { _ in
            // Append random values to arrays for each gauge within their specified ranges
            if !bluetoothDataHandler.receivedData.isEmpty {
                // Convert the received data to Double and update the gauge values
                let newData = bluetoothDataHandler.receivedData.map { Double($0) ?? 0.0 }
                gauge1Values.append(newData[0])
            }
            gauge2Values.append(Double(String(format: "%.2f", Double.random(in: gauge2Range)))!)
            gauge3Values.append(Double(String(format: "%.2f", Double.random(in: gauge3Range)))!)
            gauge4Values.append(Double(String(format: "%.2f", Double.random(in: gauge4Range)))!)
            gauge5Values.append(Double(String(format: "%.2f", Double.random(in: gauge5Range)))!)
            
            // Play an audio tone based on the values from gauge1 and the upper bound of slider1
            playAudioTone(gaugeValues: gauge1Values, sliderValues: [slider1Range.upperBound])
            checkGaugeValue(gaugeValue: gauge2Values, sliderValue: [slider2Range.upperBound], vibrationType: .success)
            checkGaugeValue(gaugeValue: gauge3Values, sliderValue: [slider3Range.upperBound], vibrationType: .warning)
            checkGaugeValue(gaugeValue: gauge4Values, sliderValue: [slider4Range.upperBound], vibrationType: .error)
            checkGaugeValue(gaugeValue: gauge5Values, sliderValue: [slider5Range.upperBound], vibrationType: .success)
        }
    }
}
struct NewProjectView_Previews: PreviewProvider {
    static var previews: some View {
        NewProjectView()
        
    }
}
