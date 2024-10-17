//
//  PokemonModel.swift
//  Pokedex
//
//  Created by HB Liang on 2024/10/16.
//

import Foundation

struct PokemonEntry: Identifiable, Codable {
    var id: String {
            let urlParts = url.split(separator: "/")
        return String(urlParts.last ?? "")
        }
        
    let name: String
    let url: String
    var rawData: Data? // Store raw data as Data

    // Computed property to get the imageURL from rawData
    var imageURL: String? {
        guard let rawData = rawData else { return nil }
        do {
            if let json = try JSONSerialization.jsonObject(with: rawData, options: []) as? [String: Any],
               let sprites = json["sprites"] as? [String: Any],
               let imageUrl = sprites["front_default"] as? String {
                return imageUrl
            }
        } catch {
            print("Error parsing rawData: \(error)")
        }
        return nil
    }
}
