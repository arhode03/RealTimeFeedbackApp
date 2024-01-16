//
//  RealTime2App.swift
//  RealTime2
//
//  Created by Alex Rhodes on 11/2/23.
//

import SwiftUI
import CoreBluetooth
import UIKit

@main
struct RealTime2App: App {
    @State private var showSplash = true // State variable to control whether to show the splash screen
    private let bluetoothManager = BluetoothManager() // Instance of BluetoothManager to manage Bluetooth functionality
    
    init() {
        bluetoothManager.startScanning() // Start scanning for peripherals when the app launches
        bluetoothManager.displayAvailableDevices() // Display the list of available devices
    }

    var body: some Scene {
        WindowGroup {
            if showSplash { // Check if the splash screen should be shown
                SplashView(showSplash: $showSplash)
                    .transition(.scale)// Show the SplashView
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            // Code to be executed after a delay of 1 second
                        }
                    }
            } else {
                ContentView() // Show the ContentView
            }
        }
    }
}
