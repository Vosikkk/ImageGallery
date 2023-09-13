//
//  ImageCollectionViewCell.swift
//  ImageGallery
//
//  Created by Саша Восколович on 12.09.2023.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageGallery: UIImageView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var imageURL: URL? {
        didSet { updateUI() }
    }
    
    private func updateUI() {
        if let url = imageURL {
            imageGallery.image = nil
            spinner?.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async {
                let urlContents = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let imageData = urlContents, url == self.imageURL, let image = UIImage(data: imageData) {
                        self.imageGallery.image = image
                    }
                    self.spinner?.stopAnimating()
                }
            }
        }
    }
}
