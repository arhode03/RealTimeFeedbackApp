//
//  BluetoothListView.swift
//  RealTime2
//
//  Created by Alex Rhodes on 11/19/23.
//

import SwiftUI
import CoreBluetooth

struct BluetoothDeviceListView: View { // Define a struct named BluetoothDeviceListView that conforms to the View protocol
    
    let bluetoothManager = BluetoothManager() // Create an instance of BluetoothManager
    
    @State private var isScanning = true // Declare a state property for tracking if scanning is in progress
    @State var isConnected = false // Declare a state property for tracking if a device is connected
    @State private var displayedDevices: Set<UUID> = [] // Declare a state property for storing the displayed devices
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                List(bluetoothManager.discoveredPeripherals, id: \.self) { peripheral in // Create a list of discovered peripherals from the BluetoothManager
                    
                    if !displayedDevices.contains(peripheral.identifier) { // Check if the peripheral has not been displayed
                        
                        Button(action: {
                            // Connect to the selected peripheral
                            bluetoothManager.connect(to: peripheral) // Call the connect method of the BluetoothManager
                            self.isConnected = true // Set the isConnected state to true
                            self.displayedDevices.insert(peripheral.identifier) // Add the peripheral identifier to the displayedDevices set
                        }) {
                            if let name = peripheral.name {
                                Text(name) // Display the peripheral name if available
                            } else {
                                Text(peripheral.identifier.uuidString) // Display the peripheral identifier if name is not available
                            }
                        }
                    }
                }
                
                if isConnected { // Check if a device is connected
                    NavigationLink(destination: NewProjectView()) { // Create a navigation link to the NewProjectView
                        Text("Connected") // Display the text "Connected"
                            .foregroundColor(.green) // Set the text color to green
                            .font(.headline) // Set the font to headline size
                    }
                }
            }
            .onAppear {
                // Start scanning for peripherals when the view appears
                bluetoothManager.startScanning() // Call the startScanning method of the BluetoothManager
            }
            .onDisappear {
                // Stop scanning for peripherals when the view disappears
                bluetoothManager.stopScanning() // Call the stopScanning method of the BluetoothManager
            }
            .onChange(of: bluetoothManager.discoveredPeripherals) { peripherals, _ in
                // Check if all available devices have been found
                if isScanning && peripherals.count > 0 { // Check if scanning is in progress and there are discovered peripherals
                    isScanning = false // Set isScanning to false
                    bluetoothManager.stopScanning() // Call the stopScanning method of the BluetoothManager
                }
            }
        }
    }
}
