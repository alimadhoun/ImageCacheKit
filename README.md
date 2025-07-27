# ImageCacheKit

**ImageCacheKit** is a lightweight and extensible Swift library for caching images using `in-memory` and `disk-based` strategies. It supports asynchronous loading, custom caching strategies, and thread-safe access patterns.

## ✨ Features

- ✅ In-Memory Image Caching
- ✅ Disk-Based Image Caching
- ✅ Strategy Pattern for Flexible Caching Logic
- ✅ Thread-Safe Asynchronous Image Loading
- ✅ Image Preloading & Manual Caching Support
- ✅ UIKit Example Demonstration
- ✅ Unit Tests for Core Components

## 📦 Installation

Simply drag and drop the `ImageCacheKit` folder into your Xcode project.

> Swift Package Manager support coming soon.

## 🚀 Getting Started

### Basic Usage

```swift
let image = await ImageCache.image(for: url, strategy: .memory)
```
