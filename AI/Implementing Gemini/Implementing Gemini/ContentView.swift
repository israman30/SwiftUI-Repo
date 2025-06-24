//
//  ContentView.swift
//  Implementing Gemini
//
//  Created by Israel Manzo on 6/24/25.
//

import SwiftUI
import GoogleGenerativeAI

struct ContentView: View {
    let model = GenerativeModel(name: "gemini-pro", apiKey: APIKey.key)
    @State var userprompt: String = ""
    @State var response: LocalizedStringKey = "How can I help you?"
    @State var isLoading: Bool = false
    
    var body: some View {
        VStack {
            Text("Gemini AI")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.indigo)
            
            ZStack {
                ScrollView {
                    Text(response)
                        .font(.title)
                }
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .indigo))
                        .scaleEffect(4)
                }
            }
            
            TextField("Ask for something..", text: $userprompt, axis: .vertical)
                .lineLimit(5)
                .padding()
                .font(.title)
                .background(Color.indigo.opacity(0.2), in: Capsule())
                .onSubmit {
                    responsePrompt()
                }
        }
        .padding()
    }
    
    func responsePrompt() {
        isLoading = true
        response = ""
        Task {
            do {
                let result = try await model.generateContent(userprompt)
                isLoading = false
                response = LocalizedStringKey(result.text ?? "No response found.")
                userprompt = ""
            } catch {
                response = "An error occurred: \(error.localizedDescription)"
                isLoading = false
            }
        }
    }
}

#Preview {
    ContentView()
}
