//
//  ContentView.swift
//  Pokedex
//
//  Created by HB Liang on 2024/10/16.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to the Pokedex!")
                    .font(.title)
                    .padding()

                NavigationLink(destination: PokedexView()) {
                    Text("Enter the Pokedex")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
    }
}

#Preview {
    ContentView()
}
