//
//  ImageGallery.swift
//  ImageGallery
//
//  Created by Саша Восколович on 12.09.2023.
//

import Foundation

struct ImageModel {
    
    var url: URL
    var aspectRatio: Double
    
}

class ImageGallery {
    var name: String
    var images = [ImageModel]()
    
    init(name: String) {
        self.name = name
    }
}

//final class ImageGalleryBox {
//    var imageGallery: ImageGallery
//    init(imageGallery: ImageGallery) {
//        self.imageGallery = imageGallery
//    }
//}
