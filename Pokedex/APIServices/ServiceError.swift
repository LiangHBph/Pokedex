//
//  ServiceError.swift
//  Pokedex
//
//  Created by HB Liang on 2024/10/16.
//

import Foundation

enum ServiceError: Error, LocalizedError {
    case fetchError(String)
    case decodingError(String)
    case noDataError(String)

    var errorDescription: String? {
        switch self {
        case .fetchError(let message):
            return "Fetch Error: \(message)"
        case .decodingError(let message):
            return "Decoding Error: \(message)"
        case .noDataError(let message):
            return "No Data Error: \(message)"
        }
    }
}
