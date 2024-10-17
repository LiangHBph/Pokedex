//
//  Services.swift
//  Pokedex
//
//  Created by HB Liang on 2024/10/16.
//

import Foundation

struct PokemonListRequest {
    var limit: Int = 20
    var offset: Int = 0

    // Function to generate the API URL based on current parameters
    func url() -> URL? {
        return URL(string: "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)")
    }
}

struct PokemonListResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonEntry]
}

struct PokemonDetailRequest {
    var id: String

    // generate the detail URL for a specific Pokémon with ID
    func url() -> URL? {
        return URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)/")
    }
}

struct PokemonDetailResponse {
    let rawData: [String: Any]
    
    // Computed property to extract imageURL from rawData
    var imageURL: String? {
        guard let sprites = rawData["sprites"] as? [String: Any],
              let imageUrl = sprites["front_default"] as? String else {
            return nil
        }
        return imageUrl
    }
}
