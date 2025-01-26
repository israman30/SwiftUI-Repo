//
//  ContentView.swift
//  Custom Segemented Picker
//
//  Created by Israel Manzo on 1/25/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            CustomSegmentedPicker(selectedOption: .constant(.iOS))
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

enum Options: String, CaseIterable {
    case iOS = "iOS"
    case android = "Android"
    
    
    func backgroundColor() -> Color {
        switch self {
        case .iOS:
            return .blue
        case .android:
            return .green
        }
    }
}

struct CustomSegmentedPicker: View {
    @Binding var selectedOption: Options
    @Environment(\.colorScheme) var colorScheme
    
    var backgroundColorSegemntedControl: Color {
        colorScheme == .dark ? .gray.opacity(0.4) : .gray.opacity(0.14)
    }
    
    var selectedButtonBackgroundColor: Color {
        colorScheme == .dark ? .white.opacity(0.4) : .white
    }
    
    var body: some View {
        HStack {
            ForEach(Options.allCases, id: \.self) { option in
                Button {
                    
                } label: {
                    Text("\(option.rawValue)")
                }
                .bold(selectedOption == option)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
                .font(.system(size: 13))
                .foregroundStyle(.primary)
                .background(selectedOption == option ? selectedButtonBackgroundColor : .clear)
                .clipShape(RoundedRectangle(cornerRadius: 7))
                .padding(.vertical, 2)
                .padding(.horizontal, 2)
                .shadow(color: selectedOption == option ? .secondary : .clear, radius: 2, y: 1)
            }
        }
        .background(backgroundColorSegemntedControl)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
