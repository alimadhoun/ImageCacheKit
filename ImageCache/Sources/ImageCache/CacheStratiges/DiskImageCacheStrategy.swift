//
//  DiskImageCacheStrategy.swift
//  ImageCache
//
//  Created by Ali Madhoun on 27/07/2025.
//

import Foundation
import UIKit

// Used Actors For Thread safety
public actor DiskImageCacheStrategy: ImageCacheStrategy {
    
    private let fileManager = FileManager.default

    public init() {
        
    }
    
    public func loadImage(for url: URL) async throws -> UIImage {
        let filePath = diskPath(for: url)

        let image: UIImage?

        if let data = try? Data(contentsOf: filePath) {
            image = UIImage(data: data)
        } else {
            image = try await self.download(url: url)
            
            if let image = image {
                // Save Image
                try saveImage(image: image, to: filePath)
            }
        }
        
        guard let image else {
            throw CacheImageError.imageNotFound
        }
        
        return image
    }

    private func download(url: URL) async throws -> UIImage? {
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let image = UIImage(data: data)
            
            return image
        } catch {
            throw CacheImageError.networkError(error)
        }
    }
    
    private func saveImage(image: UIImage, to path: URL) throws {
        
        do {
            if let pngData = image.pngData() {
                try pngData.write(to: path)
            }
        } catch {
            throw CacheImageError.invalidData
        }
    }

    private func diskPath(for url: URL) -> URL {
        let caches = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let fileName = url.lastPathComponent
        return caches.appendingPathComponent(fileName)
    }
}

// For Test purposes only, to store images in the cache directory.
#if DEBUG
extension DiskImageCacheStrategy {
    func store(image: UIImage, for url: URL) async {
        let path = diskPath(for: url)
        if let data = image.pngData() {
            try? data.write(to: path)
        }
    }
}
#endif
