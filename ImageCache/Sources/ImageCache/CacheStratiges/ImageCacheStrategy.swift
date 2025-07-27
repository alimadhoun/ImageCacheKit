//
//  ImageCacheStrategy.swift
//  ImageCacheStrategy
//
//  Created by Ali Madhoun on 27/07/2025.
//

import Foundation
import UIKit

public protocol ImageCacheStrategy {
    func loadImage(for url: URL) async throws -> UIImage
}
