//
//  SplashView.swift
//  Login Flow
//
//  Created by Israel Manzo on 5/5/26.
//

import SwiftUI

/// Simple splash screen shown while `AppCoordinator` decides the initial route.
///
/// This view is purely visual; the actual routing happens in `AppCoordinator.checkAuthState()`.
struct SplashView: View {
    @State var scale: CGFloat = 0.7
    @State var opacity: CGFloat = 0.0
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 72))
                    .foregroundStyle(.blue)
                    .scaleEffect(scale)
                    .opacity(opacity)
                
                Text("The Chalkboard")
                    .font(.largeTitle.bold())
                    .opacity(opacity)
                
                Text("Stay organized. Stay ahead.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
