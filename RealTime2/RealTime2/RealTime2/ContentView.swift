//
//  ContentView.swift
//  RealTime2
//
//  Created by Alex Rhodes on 11/2/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.gray, Color.black]), startPoint: .top, endPoint: .bottom) // Add a linear gradient from gray to black
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Image("logo2")
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .mask(LinearGradient(gradient: Gradient(stops: [
                            .init(color: .clear, location: 0),
                            .init(color: .white, location: 0.5),
                            .init(color: .clear, location: 1)
                        ]), startPoint: .top, endPoint: .bottom))
                        .opacity(0.7)// Set the opacity to fade the image
                    Text("Welcome to RealTime.\nYour Welding Assistant")
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(white: 0.9))
                    
                    
                    NavigationLink(destination: BluetoothDeviceListView()) {
                        RectangleButton(color: Color.orange, title: "New Project")
                    }
                   
                    
                    NavigationLink(destination: SavedProjectView()) {
                        RectangleButton(color: Color.orange, title: "Saved Project")
                    }
                    
                    NavigationLink(destination: AIView()) {
                        RectangleButton(color: Color.orange, title: "AI Assistant")
                    }
                }
                .padding()
                .cornerRadius(10)
                .shadow(radius: 5)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            }
        }
    }
}

struct RectangleButton: View {
    var color: Color
    var title: String
    
    var body: some View {
        Text(title)
            .bold()
            .foregroundColor(.black)
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 7)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [color.opacity(0.8), color.opacity(0.5)]), // Use more orange colors in the gradient
                            startPoint: .top,
                            endPoint: .bottom // Fade from top to bottom
                        )
                    )
                    .shadow(color: .gray, radius: 3, x: 0, y: 2)
            )
            .cornerRadius(10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView() // Preview the ContentView
    }
}
