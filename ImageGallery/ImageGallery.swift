//
//  ImageGallery.swift
//  ImageGallery
//
//  Created by Саша Восколович on 12.09.2023.
//

import Foundation

struct ImageModel: Codable {
    var url: URL
    var aspectRatio: Double
    
}

class ImageGallery: Codable {
    
    var name: String
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    private(set) var images: [ImageModel] = []
    
    
    init(name: String) {
        self.name = name
    }
    
    func add(item: ImageModel, at index: Int) {
        images.insert(item, at: index)
    }
    
    func remove(at index: Int) -> ImageModel {
        images.remove(at: index)
    }
    
    func change(aspectRatio: Double, at index: Int) {
        images[index].aspectRatio = aspectRatio
    }
    
    func add(items: [ImageModel]) {
        images = items
    }
    func filterAndMapImages(using indices: [Int]) {
            images = images
                .enumerated()
                .filter { !indices.contains($0.offset) }
                .map { $0.element }
    }
}
