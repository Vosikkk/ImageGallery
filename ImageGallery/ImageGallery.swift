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
    var images = [ImageModel]()
    
    init(name: String) {
        self.name = name
    }
}
