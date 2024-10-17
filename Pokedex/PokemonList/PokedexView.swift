//
//  PokedexView.swift
//  Pokedex
//
//  Created by HB Liang on 2024/10/16.
//

import Foundation
import SwiftUI

struct PokedexView: View {
    @ObservedObject var viewModel = PokemonViewModel()

    let columns = [
        GridItem(.adaptive(minimum: 100))
    ]

    var body: some View {
        VStack(spacing: 0) {
            if let errorMessage = viewModel.errorMessage {
                // Display error message
                Text(errorMessage)
                    .font(.headline)
                    .foregroundColor(.red)
                    .padding()
                    .multilineTextAlignment(.center)
            } else {
                // Show the selected Pokémon at the top center
                if let selectedPokemonImage = viewModel.selectedPokemonImage {
                    AsyncImage(url: URL(string: selectedPokemonImage)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 3)
                    } placeholder: {
                        ProgressView()
                            .frame(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 3)
                    }
                } else {
                    // If no image is available, show loading icon
                    ProgressView()
                        .frame(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 3)
                }

                if let selectedPokemon = viewModel.selectedPokemon {
                    Text(selectedPokemon.name.capitalized)
                        .font(.title)
                        .padding()
                }

                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(viewModel.pokemons) { pokemon in
                            VStack(spacing: 0) {
                                if let imageUrl = pokemon.imageURL {
                                    CachedAsyncImage(urlString: imageUrl, placeholder: {
                                        AnyView(
                                            ProgressView().frame(width: 100, height: 100)
                                        )
                                    })
                                } else {
                                    // For some images, server response error, use placeholder to make the grid proper
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(.gray)
                                }

                                Text(pokemon.name.capitalized)
                                    .padding()
                                    .frame(height: 24)
                                    .truncationMode(.tail)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                            }
                            .onTapGesture {
                                viewModel.selectPokemon(pokemon: pokemon)
                            }
                            if pokemon.id == viewModel.pokemons.last?.id, viewModel.nextURL != nil {
                                ProgressView()
                                    .onAppear {
                                        viewModel.fetchPokemons()
                                    }
                            }
                        }
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
            }
        }
        .onAppear { viewModel.fetchPokemons() }
    }
}
