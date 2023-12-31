//
//  ContentView.swift
//  RealTime2
//
//  Created by Alex Rhodes on 11/2/23.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView { // Use a navigation view to enable navigation functionality
            ZStack { // Stack views on top of each other
                Color.black.ignoresSafeArea() // Set the background color to black and ignore safe area insets
                
                VStack(spacing: 20) { // Vertical stack of views with spacing of 20
                    Image("logo2") // Display an image named "logo2"
                        .resizable()
                        .scaledToFit()
                    Text("Welcome to RealTime.\nYour Welding Assistant")
                                           .font(.title) // Set the font to title size
                                           .multilineTextAlignment(.center) // Center-align the text
                                           .foregroundColor(Color(white: 90)) // Set the text color to a light gray
                    
                    // Use NavigationLink directly for navigation
                    NavigationLink(destination: BluetoothDeviceListView()) { // Create a navigation link that leads to the BluetoothDeviceListView
                        RectangleButton(color: Color.orange, title: " New Project ") // Display a rectangular button with orange color and title "New Project"
                    }
                    
                    NavigationLink(destination: SavedProjectView()) { // Create a navigation link that leads to the SavedProjectView
                        RectangleButton(color: Color.orange, title: "Saved Project") // Display a rectangular button with orange color and title "Saved Project"
                    }
                    NavigationLink(destination: AIView()) { // Create a navigation link that leads to the AIView
                        RectangleButton(color: Color.orange, title: "AI Assistant") // Display a rectangular button with orange color and title "AI Assistant"
                    }
                }
                .padding() // Add padding around the VStack
                .cornerRadius(10) // Round the corners of the VStack
                .shadow(radius: 5) // Add a shadow to the VStack
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center) // Set the frame size and alignment of the VStack
            }
        }
    }
}

struct RectangleButton: View {
    var color: Color
    var title: String
    
    var body: some View {
        Text(title) // Display the button title
            .foregroundColor(.black) // Set the text color to black
            .padding() // Add padding around the button title
            .background(color) // Set the background color of the button
            .cornerRadius(10) // Round the corners of the button
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView() // Preview the ContentView
    }
}
