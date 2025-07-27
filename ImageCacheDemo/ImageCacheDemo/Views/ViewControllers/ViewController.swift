//
//  ViewController.swift
//  ImageCacheDemo
//
//  Created by Ali Madhoun on 27/07/2025.
//

import UIKit
import ImageCache

class ViewController: UIViewController {

    private var urls: [URL] = []
    
    private lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width / 3 - 1, height: view.bounds.width / 3 - 1) // 3 Rows in each Row with 1px spacing between each.
        layout.minimumInteritemSpacing = 0.5
        layout.minimumLineSpacing = 0.5
        
        let cv = UICollectionView(frame: .init(), collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.ID)
        cv.backgroundColor = .white
        
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupCollectionView()
        generateImageURLs()
    }

    func setupCollectionView() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func generateImageURLs() {
        
        // Generate 100 Images.
        for id in 0..<100 {
            if let url = URL(string: "https://picsum.photos/id/\(id)/200/200") {
                urls.append(url)
            }
        }
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.ID, for: indexPath) as! ImageCell

        let url = urls[indexPath.item]
        cell.startLoading()

        Task {
            do {
                let image = try await ImageCache.image(for: url, strategy: .memory)

                // Make sure the cell hasn't been reused
                if let currentIndex = collectionView.indexPath(for: cell), currentIndex == indexPath {
                    cell.stopLoading(with: image)
                }
            } catch {
                debugPrint("Error loading image: \(error)")
                // Fallback, load xmark.icloud.fill image as placeholder.
                let placeholderImage = UIImage(systemName: "xmark.icloud.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
                cell.stopLoading(with: placeholderImage)
            }
        }

        return cell
    }
}
