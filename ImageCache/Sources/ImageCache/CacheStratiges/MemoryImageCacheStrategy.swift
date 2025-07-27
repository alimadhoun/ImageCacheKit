//
//  MemoryImageCacheStrategy.swift
//  ImageCache
//
//  Created by Ali Madhoun on 27/07/2025.
//

import Foundation
import UIKit

public actor MemoryImageCacheStrategy: ImageCacheStrategy {
    private let memoryCache = NSCache<NSString, UIImage>()

    public init() {}
    
    public func loadImage(for url: URL) async throws -> UIImage {
        let key = url.absoluteString as NSString
        
        if let image = memoryCache.object(forKey: key) {
            return image
        }
        
        // Download image
        let downloadedImage = try await download(url: url)
        
        guard let downloadedImage = downloadedImage else {
            throw CacheImageError.imageNotFound
        }
        
        saveImage(image: downloadedImage, to: key)
        return downloadedImage
    }
    
    private func saveImage(image: UIImage, to key: NSString) {
        memoryCache.setObject(image, forKey: key)
    }

    private func download(url: URL) async throws -> UIImage? {
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            return UIImage(data: data)
        } catch {
            throw CacheImageError.networkError(error)
        }
    }
}

// For Test purposes Only
#if DEBUG
extension MemoryImageCacheStrategy {
    func store(image: UIImage, for url: URL) async {
        memoryCache.setObject(image, forKey: url.absoluteString as NSString)
    }
}
#endif
