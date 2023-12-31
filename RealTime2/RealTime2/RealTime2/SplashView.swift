import SwiftUI

struct SplashView: View {
    @Binding var showSplash: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .background(Color.black)
            Image("logo2")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
                .onAppear {
                    // Simulate a 2-second delay and then transition
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showSplash = false
                        }
                    }
                }
        }
    }
}
