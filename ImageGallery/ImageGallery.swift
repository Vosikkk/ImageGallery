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

struct ImageGallery: Codable {
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    var images = [ImageModel]()
    
    mutating func add(image: ImageModel) {
        images.append(image)
    }
}
