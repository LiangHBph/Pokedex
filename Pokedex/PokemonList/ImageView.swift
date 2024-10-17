//
//  ImageView.swift
//  Pokedex
//
//  Created by HB Liang on 2024/10/16.
//

import Foundation
import SwiftUI
import CryptoKit

struct CachedAsyncImage: View {
    let urlString: String
    let placeholder: () -> AnyView
    
    @State private var image: UIImage?
    
    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
        } else {
            placeholder()
                .onAppear {
                    loadImage()
                }
        }
    }
    
    // Load image with caching
    private func loadImage() {
        let cacheKey = urlString.sha256() // Use a hash as the cache key
        
        if let cachedImage = ImageCacheManager.shared.getCachedImage(forKey: cacheKey) {
            self.image = cachedImage
        } else {
            downloadImage(from: urlString, cacheKey: cacheKey)
        }
    }
    
    private func downloadImage(from urlString: String, cacheKey: String) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let downloadedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = downloadedImage
                    ImageCacheManager.shared.cacheImage(downloadedImage, forKey: cacheKey) // Cache the image
                }
            }
        }.resume()
    }
}

extension String {
    func sha256() -> String {
        let inputData = Data(self.utf8)
        let hashedData = SHA256.hash(data: inputData)
        return hashedData.compactMap { String(format: "%02x", $0) }.joined()
    }
}
