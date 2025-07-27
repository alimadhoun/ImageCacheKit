// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

private let memoryCacheStrategy = MemoryImageCacheStrategy()
private let diskCacheStrategy = DiskImageCacheStrategy()

public func image(for url: URL, strategy: CachType = .disk) async throws -> UIImage? {
    
    let strategyInstance: ImageCacheStrategy = {
        
        switch strategy {
        case .memory:
            return memoryCacheStrategy
        case .disk:
            return diskCacheStrategy
        }
    }()
    
    return try await strategyInstance.loadImage(for: url)
}
