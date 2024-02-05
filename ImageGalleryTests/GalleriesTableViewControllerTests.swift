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
        createGalleries(in: defaults, numerOfSection: 1, galleriesInSection: 1)
        XCTAssertEqual(sut.imageGalleriesJSON.count, 1)
    }
    
    func test_viewDidLoad_withFourGalleriesInDefaults_shouldBeImageGalleriesJSONCount4() {
        createGalleries(in: defaults, numerOfSection: 1, galleriesInSection: 4)
        XCTAssertEqual(sut.imageGalleriesJSON[0].count, 4)
    }
    
    func test_viewDidLoad_withOneGalleryInDefault_imageGalleriesShouldHaveCount1() {
        createGalleries(in: defaults, numerOfSection: 1, galleriesInSection: 1)
        sut.viewDidLoad()
        XCTAssertEqual(sut.imagesGalleries[0].count, 1)
    }
    
    func test_viewDidLoad_withFourGalleryInDefaults_imagesGalleriesShouldHaveCount4() {
        createGalleries(in: defaults, numerOfSection: 1, galleriesInSection: 4)
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
    
    
    func test_saveBarButtonItem_shouldBeSizeCount1AlsoResaveExistGalleryHasNameTestInImageGalleriesJSON() {
        
        sut.viewDidLoad()
        
        XCTAssertEqual(sut.imageGalleriesJSON.count, 0)
        
        guard let saveButton = sut.navigationItem.rightBarButtonItems?.last else {
            XCTFail("Expected save button but there is no any button")
            return
        }
        
        tap(saveButton)
       
        XCTAssertEqual(sut.imageGalleriesJSON.count, 1, "Didn't save gallery into json data")
        
        XCTAssertEqual(sut.imageGalleriesJSON[0].first?.name, "Gallery one")
        
        sut.imagesGalleries[0].first?.name = "Test"
        
        XCTAssertEqual(sut.imagesGalleries[0].first?.name, "Test")
        
        tap(saveButton)
        
        XCTAssertEqual(sut.imageGalleriesJSON[0].first?.name, "Test")
        
    }
    
    func test_addNewGalleryBarButtonItem_shouldCreateNewGalleryWithNameNewGelleryAndImageGalleryStructureShouldHasCount2() {

        sut.viewDidLoad()
        
        guard let addNewGalleryButton = sut.navigationItem.rightBarButtonItems?.first else {
            XCTFail("Expected addNewGallery button but there is no any button")
            return
        }
        
        XCTAssertEqual(sut.imagesGalleries[0].count, 1)
        
        tap(addNewGalleryButton)
        
        XCTAssertEqual(sut.imagesGalleries[0].last?.name, "New Gallery")
        XCTAssertEqual(sut.imagesGalleries[0].count, 2)
        
    }
    
    
}
