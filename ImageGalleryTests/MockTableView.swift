//
//  MockTableView.swift
//  ImageGalleryTests
//
//  Created by Саша Восколович on 05.02.2024.
//

import UIKit
@testable import ImageGallery

class MockTableView: UITableView {
    
    var didCallSelectRow: Bool = false
    var selectedIndexPath: IndexPath?
    
    
    override func selectRow(at indexPath: IndexPath?, animated: Bool, scrollPosition: UITableView.ScrollPosition) {
        didCallSelectRow = true
        selectedIndexPath = indexPath
    }
}

