//
//  FakeUserDefaults.swift
//  ImageGalleryTests
//
//  Created by Саша Восколович on 30.01.2024.
//

import Foundation
@testable import ImageGallery



class FakeUserDefaults: UserDefaultsProtocol {
    
    var results: [String: [[ImageGallery]]] = [:]
    
    
    func galleries(forKey key: String) -> [[ImageGallery]] {
        results[key] ?? []
    }
    
    func sett(_ galleries: [[ImageGallery]], forKey key: String) {
        results[key] = galleries
    }
}
