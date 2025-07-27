//
//  Test.swift
//  ImageCache
//
//  Created by Ali Madhoun on 27/07/2025.
//

import Foundation
import UIKit
import XCTest
@testable import ImageCache

final class TestImageCache: XCTestCase {

    func test_memoryCache_storesAndRetrievesImage() async throws {
        let memoryCache = MemoryImageCacheStrategy()
        let url = URL(string: "https://fastly.picsum.photos/id/44/200/200")!
        let image = UIImage(systemName: "star.fill")!

        // 1- Simulate manual insert
        await memoryCache.store(image: image, for: url)
        
        // 2- Load Image by it's URL
        let cachedImage = try await memoryCache.loadImage(for: url)
        
        // 3- Verify that the image loaded is the same as the one manually stored
        XCTAssertNotNil(cachedImage)
        XCTAssertEqual(cachedImage.pngData()!.count, image.pngData()!.count)
    }
    
    func test_diskCache_savesAndLoadsImage() async throws {
        let diskCache = DiskImageCacheStrategy()
        let url = URL(string: "https://fastly.picsum.photos/id/44/200/200")!
        let image = UIImage(systemName: "heart.fill")!

        // 1- Simulate manual insert
        await diskCache.store(image: image, for: url)
        
        // 2- Load Image by it's URL
        let cachedImage = try await diskCache.loadImage(for: url)
        
        // 3- Verify that the image loaded is the same as the one manually stored
        XCTAssertNotNil(cachedImage)
        XCTAssertEqual(cachedImage.pngData()!.count, image.pngData()!.count)
    }
    
    func test_asyncLoad_isThreadSafe() async {
        let memory = DiskImageCacheStrategy()
        let url = URL(string: "https://fastly.picsum.photos/id/44/200/200")!
        
        let images: [UIImage] = [
            UIImage(systemName: "sun.max.fill")!,
            UIImage(systemName: "carbon.dioxide.cloud.fill")!,
            UIImage(systemName: "cloud.bolt.circle")!,
            UIImage(systemName: "cloud.bolt")!
        ]

        let taskCount = 100
        await withTaskGroup(of: Void.self) { group in
            for _ in 0..<taskCount {
                group.addTask {
                    do {
                        
                        // 1- Pick random image to store
                        let image = images.randomElement()!
                        
                        // 2- Store image in memory
                        await memory.store(image: image, for: url)
                        
                        // 3- Load image by it's URL
                        let img = try await memory.loadImage(for: url)
                        
                        // 4- Verify that the image loaded is the same as the one manually stored
                        XCTAssertEqual(img.pngData()!.count, image.pngData()!.count)
                    } catch {
                        XCTFail("Failed with error: \(error)")
                    }
                }
            }
        }
    }
    
    func test_imageCache_throwsErrorOnInvalidURL() async {
        let memoryCache = MemoryImageCacheStrategy()
        let invalidURL = URL(string: "invalid_url")!

        do {
            _ = try await memoryCache.loadImage(for: invalidURL)
            XCTFail("Expected to throw an error for invalid URL")
        } catch {
            // Expected error
            XCTAssertTrue(error is CacheImageError)
        }
    }

}
