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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(identifier: String(describing: GalleriesTableViewController.self))
        defaults = FakeUserDefaults()
        sut.defaults = defaults
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        sut = nil
        defaults = nil
        super.tearDown()
    }
    
    
    func test_viewDidLoad_withEmptyDefaults_shouldBeImageGalleriesJSONCount0() {
        XCTAssertEqual(sut.imageGalleriesJSON.count, 0)
       
    }
    
    func test_viewDidLoad_withEmptyDefaults_imageGalleriesShouldHaveCount1_andHasNameGalleryOne() {
        XCTAssertEqual(sut.imagesGalleries.count, 1)
        XCTAssertEqual(sut.imagesGalleries[0].first?.name, "Gallery one", "Should have default name but \(String(describing: sut.imagesGalleries[0].first?.name))")
    }
    
    func test_viewDidLoad_withOneGalleryInDefaults_shouldBeImageGalleriesJSONCount1() {
        let gallery = ImageGallery()
        defaults.results = ["SavedGalleries": [[gallery]]]
        XCTAssertEqual(sut.imageGalleriesJSON.count, 1)
    }
    
    func test_viewDidLoad_withFourGalleriesInDefaults_shouldBeImageGalleriesJSONCount4() {
        let gallery = ImageGallery()
        defaults.results = ["SavedGalleries": [[gallery, gallery, gallery, gallery]]]
        XCTAssertEqual(sut.imageGalleriesJSON[0].count, 4)
    }
    
    func test_viewDidLoad_withOneGalleryInDefault_imageGalleriesShouldHaveCount1() {
        let gallery = ImageGallery()
        defaults.results = ["SavedGalleries": [[gallery]]]
        sut.viewDidLoad()
        XCTAssertEqual(sut.imagesGalleries[0].count, 1)
    }
    
    func test_viewDidLoad_withFourGalleryInDefaults_imagesGalleriesShouldHaveCount4() {
        let gallery = ImageGallery()
        defaults.results = ["SavedGalleries": [[gallery, gallery, gallery, gallery]]]
        sut.viewDidLoad()
        XCTAssertEqual(sut.imagesGalleries[0].count, 4)
    }
    
    func test_viewDidLoad_withOneGalleryNamedTestInDefaults_imagesGalleriesShouldHaveGalleryWithNameTest() {
        let gallery = ImageGallery(name: "Test")
        defaults.results = ["SavedGalleries": [[gallery]]]
        
        XCTAssertEqual(sut.imageGalleriesJSON[0].first?.name, "Test", "Precondition")
        
        XCTAssertEqual(sut.imagesGalleries[0].first?.name, "Gallery one", "Should have default name but: \(String(describing: sut.imagesGalleries[0].first?.name))")
        
        sut.viewDidLoad()
        
        XCTAssertEqual(sut.imagesGalleries[0].first?.name, "Test", "Named - \(String(describing: sut.imagesGalleries[0].first?.name))")
        
    }
    
    func test_viewWillDisAppear_withChangedNameInImageGalleriesOnChanged_ImageGalleriesJSONShouldHaveGalleryWithChanged() {
        let gallery = ImageGallery(name: "Test")
        defaults.results = ["SavedGalleries": [[gallery]]]
        
        XCTAssertEqual(sut.imageGalleriesJSON.count, 1, "Precondition")
        XCTAssertEqual(sut.imageGalleriesJSON[0].first?.name, "Test", "Precondition")
        
        XCTAssertEqual(sut.imagesGalleries.count, 1, "Precondition")
        XCTAssertEqual(sut.imagesGalleries[0].first?.name, "Gallery one", "Precondition")
        
        sut.viewDidLoad()
        
        XCTAssertEqual(sut.imagesGalleries[0].first?.name, "Test", "Precondition")
        
        sut.imagesGalleries[0].first?.new("Changed")
        
        XCTAssertEqual(sut.imagesGalleries[0].first?.name, "Changed", "Current name \(String(describing: sut.imagesGalleries[0].first?.name))")
        
        sut.viewWillDisappear(false)
        
        XCTAssertEqual(sut.imageGalleriesJSON[0].first?.name, "Changed", "Current name is \(String(describing: sut.imageGalleriesJSON[0].first?.name))")
    }
    
    
    func test_viewDidLoad_withOneGalleryOneImageModelInDefaults_imageGalleriesJSONShouldHaveGalleryImagesCount1() {
        let gallery = ImageGallery(name: "Test")
    
        defaults.results = ["SavedGalleries": [[gallery]]]
        
        XCTAssertEqual(sut.imageGalleriesJSON.count, 1, "Precondition")
        XCTAssertEqual(sut.imageGalleriesJSON[0].first?.images.count, 0)
        
        gallery.add(ImageModel(url: URL(string: "http://DUMMY")!, aspectRatio: 1), at: 0)
        
        XCTAssertEqual(sut.imageGalleriesJSON[0].first?.images.count, 1)
        
        
    }
    
    func test_viewDidLoad_withOneGalleryOneImageModelInDefaults_imageGalleriesShouldHaveGalleryImagesCount1() {
        
        let gallery = ImageGallery(name: "Test")
       
        
        defaults.results = ["SavedGalleries": [[gallery]]]
        
        XCTAssertEqual(sut.imageGalleriesJSON.count, 1, "Precondition")
        
        sut.viewDidLoad()
        
        XCTAssertEqual(sut.imagesGalleries[0].first?.images.count, 0)
        
        gallery.add(ImageModel(url: URL(string: "http://DUMMY")!, aspectRatio: 1), at: 0)
        
        XCTAssertEqual(sut.imagesGalleries[0].first?.images.count, 1)
        
    }
}
