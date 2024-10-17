//
//  ImageCacheManager.swift
//  Pokedex
//
//  Created by HB Liang on 2024/10/16.
//

import Foundation
import SwiftUI

class ImageCacheManager {
    static let shared = ImageCacheManager()
    
    private let memoryCache = NSCache<NSString, UIImage>()
    
    // Directory for disk caching
    private var diskCacheDirectory: URL? {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return paths.first?.appendingPathComponent("PokemonImageCache")
    }
    
    private init() {
        createDiskCacheDirectory()
    }
    
    // Create the disk cache directory if it doesn't exist
    private func createDiskCacheDirectory() {
        guard let directory = diskCacheDirectory else { return }
        if !FileManager.default.fileExists(atPath: directory.path) {
            do {
                try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error creating disk cache directory: \(error)")
            }
        }
    }
    
    // Save an image to both memory and disk cache
    func cacheImage(_ image: UIImage, forKey key: String) {
        // In-memory cache
        memoryCache.setObject(image, forKey: key as NSString)
        
        // Disk cache
        if let data = image.pngData(), let directory = diskCacheDirectory {
            let fileURL = directory.appendingPathComponent(key)
            do {
                try data.write(to: fileURL)
            } catch {
                print("Error saving image to disk: \(error)")
            }
        }
    }
    
    // Retrieve an image from cache
    func getCachedImage(forKey key: String) -> UIImage? {
        // Check memory cache first
        if let image = memoryCache.object(forKey: key as NSString) {
            return image
        }
        
        // Check disk cache
        if let directory = diskCacheDirectory {
            let fileURL = directory.appendingPathComponent(key)
            if let imageData = try? Data(contentsOf: fileURL), let image = UIImage(data: imageData) {
                // Store the image back to memory cache for quicker access next time
                memoryCache.setObject(image, forKey: key as NSString)
                return image
            }
        }
        return nil
    }
}

