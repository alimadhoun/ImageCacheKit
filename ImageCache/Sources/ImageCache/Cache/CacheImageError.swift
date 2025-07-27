//
//  CacheImageError.swift
//  ImageCache
//
//  Created by Ali Madhoun on 27/07/2025.
//

import Foundation

public enum CacheImageError: Error {
    case invalidData
    case networkError(Error)
    case imageNotFound
    case unknown
}
