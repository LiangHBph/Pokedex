//
//  PokemonViewModel.swift
//  Pokedex
//
//  Created by HB Liang on 2024/10/16.
//

import Foundation

class PokemonViewModel: ObservableObject {
    @Published var pokemons: [PokemonEntry] = []
    @Published var selectedPokemon: PokemonEntry?
    @Published var selectedPokemonImage: String?
    @Published var errorMessage: String?
    
    var nextURL: String? = "https://pokeapi.co/api/v2/pokemon?limit=20&offset=0"
    
    func fetchPokemons() {
        guard let nextURL = nextURL, let url = URL(string: nextURL) else { return }
        print("debug-\(nextURL)")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = ServiceError.fetchError(error.localizedDescription).errorDescription
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = ServiceError.noDataError("No data received.").errorDescription
                }
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(PokemonListResponse.self, from: data)
                DispatchQueue.main.async {
                    self.pokemons.append(contentsOf: decodedData.results)
                    
                    // Fetch details for all Pokémon
                    self.fetchAllPokemonDetails()
                    
                    // Select the first Pokémon by default
                    if self.selectedPokemon == nil, let firstPokemon = self.pokemons.first {
                        self.selectPokemon(pokemon: firstPokemon)
                    }

                    self.errorMessage = nil // Clear any previous error message
                    self.nextURL = decodedData.next
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = ServiceError.decodingError(error.localizedDescription).errorDescription
                }
            }
        }.resume()
    }

    // Fetch details for all Pokémon
    func fetchAllPokemonDetails() {
        for pokemon in pokemons {
            fetchPokemonDetails(for: pokemon)
        }
    }

    // Fetch details for the selected Pokémon (detail request)
    func fetchPokemonDetails(for pokemon: PokemonEntry) {
        guard let url = PokemonDetailRequest(id: pokemon.id).url() else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = ServiceError.fetchError(error.localizedDescription).errorDescription
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = ServiceError.noDataError("No data received for \(pokemon.name).").errorDescription
                }
                return
            }

            // Store the raw data as Data in the corresponding Pokémon entry
            DispatchQueue.main.async {
                if let index = self.pokemons.firstIndex(where: { $0.id == pokemon.id }) {
                    self.pokemons[index].rawData = data
                    
                    // Update the selected Pokémon's imageURL if it's currently selected
                    if self.selectedPokemon?.id == pokemon.id {
                        self.selectedPokemonImage = self.pokemons[index].imageURL
                    }
                }
            }
        }.resume()
    }

    // Select a Pokémon and set its imageURL for display
    func selectPokemon(pokemon: PokemonEntry) {
        selectedPokemon = pokemon
        selectedPokemonImage = pokemon.imageURL
    }
}
