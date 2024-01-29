//
//  GalleriesTableViewControllerTests.swift
//  ImageGalleryTests
//
//  Created by Саша Восколович on 30.01.2024.
//

import XCTest
@testable import ImageGallery

final class GalleriesTableViewControllerTests: XCTestCase {

    private var sut: GalleriesTableViewController!
    private var defaults: FakeUserDefaults!
    
    
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Name", bundle: nil)
        sut = storyboard.instantiateViewController(identifier: String(describing: GalleriesTableViewController.self))
        defaults = FakeUserDefaults()
        sut.defaults = defaults
    }
    
    override func tearDown() {
        sut = nil
        defaults = nil
        super.tearDown()
    }
    
}
