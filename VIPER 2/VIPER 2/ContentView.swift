//
//  ContentView.swift
//  VIPER 2
//
//  Created by Israel Manzo on 10/2/23.
//

import SwiftUI

// "https://pokeapi.co/api/v2/pokemon?limit=20"

enum APIError: Error {
    case wrongAPIAddress
    case badResponse
    case noData
    case errorPresenter(_ error: String)
}

struct PokemonList: Decodable {
    let results: [Pokemon]
}

struct Pokemon: Decodable, Identifiable {
    var id: String {
        UUID().uuidString
    }
    let name: String
}

// MARK: - View
struct ContentView: View {
    
    @StateObject var presenter = PokemonPresenter()
    
    var body: some View {
        NavigationView {
            List(presenter.pokemon) { pokemon in
                Button {
                    presenter.showPokemonDetail(pokemon: pokemon)
                } label: {
                    Text(pokemon.name)
                }
            }
            .onAppear {
                Task {
                    await presenter.fetchData()
                    self.presenter.router = PokemonRouter()
                }
            }
            .navigationTitle("VIPER")
        }
    }
}

#Preview {
    ContentView()
}

struct PokemonDetail: View {
    var pokemon: Pokemon
    
    var body: some View {
        VStack {
            Text("Name: \(pokemon.name)")
        }
        .navigationBarTitle("Pokemon Detail", displayMode: .inline)
    }
}

// MARK: - INTERACTOR
final class PokemonInteractor {
    func fetchData() async throws -> [Pokemon] {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=20") else {
            fatalError("DEBUG: Bad url address: \(APIError.wrongAPIAddress)")
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard !data.isEmpty else {
            fatalError("DEBUG: - \(APIError.noData)")
        }
        
        guard let response = response as? HTTPURLResponse, (200...300).contains(response.statusCode) else {
            fatalError("DEBUG: Bad response with \(APIError.badResponse)")
        }
        
        return try JSONDecoder().decode(PokemonList.self, from: data).results
    }
}

// MARK: - PRESENTER
@MainActor
final class PokemonPresenter: ObservableObject {
    
    @Published var pokemon = [Pokemon]()
    private var interactor = PokemonInteractor()
    var router: PokemonRouter?
    
    func fetchData() async {
        do {
            pokemon = try await interactor.fetchData()
        } catch {
            print("\(APIError.errorPresenter(error.localizedDescription))")
        }
    }
    
    func showPokemonDetail(pokemon: Pokemon) {
        router?.navigate(to: pokemon)
    }
}

// MARK: - ROUTE
final class PokemonRouter {
    
    func navigate(to pokemon: Pokemon) {
        let detailView = PokemonDetail(pokemon: pokemon)
        let hostingController = UIHostingController(rootView: detailView)
        
        let application = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive })
        
        if let keyWindow = application as? UIWindowScene {
            keyWindow.keyWindow?.rootViewController?.present(hostingController, animated: true)
        }
    }
}

