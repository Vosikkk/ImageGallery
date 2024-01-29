//
//  ImageGallery.swift
//  ImageGallery
//
//  Created by Саша Восколович on 12.09.2023.
//

import Foundation

struct ImageModel: Codable, Equatable {
    var url: URL
    var aspectRatio: Double
    
}

class ImageGallery: Codable, Equatable {
   
    var name: String
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    private(set) var images: [ImageModel] = []
    
    
    init(name: String = "") {
        self.name = name
    }
    
    func add(_ image: ImageModel, at index: Int) {
        images.insert(image, at: index)
    }
    
    func remove(at index: Int) -> ImageModel {
        images.remove(at: index)
    }
    
    func update(aspectRatio: Double, at index: Int) {
        images[index].aspectRatio = aspectRatio
    }
    
    func replace(by resImages: [ImageModel]) {
        images = resImages
    }
    func filterAndMapImages(using indices: [Int]) {
            images = images
                .enumerated()
                .filter { !indices.contains($0.offset) }
                .map { $0.element }
    }
    
    func new(_ name: String) {
        self.name = name
    }
    
    static func == (lhs: ImageGallery, rhs: ImageGallery) -> Bool {
        lhs.images == rhs.images && lhs.name == rhs.name
    }
}
