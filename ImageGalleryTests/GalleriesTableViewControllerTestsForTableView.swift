//
//  GalleriesTableViewControllerTestsForTableView.swift
//  ImageGalleryTests
//
//  Created by Саша Восколович on 04.02.2024.
//

import XCTest
@testable import ImageGallery

final class GalleriesTableViewControllerTestsForTableView: XCTestCase {

    
    private var sut: GalleriesTableViewController!
    private var defaults: FakeUserDefaults!
    private var testGallery: ImageGallery!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(identifier: String(describing: GalleriesTableViewController.self))
        defaults = FakeUserDefaults()
        sut.defaults = defaults
        testGallery = ImageGallery()
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        sut = nil
        defaults = nil
        testGallery = nil
        super.tearDown()
    }
    
    
    func test_tableViewDelegates_shouldBeConnected() {
        XCTAssertNotNil(sut.tableView.delegate, "delegate")
        XCTAssertNotNil(sut.tableView.dataSource, "dataSource")
    }

    
    
    func test_numberOfSection_shouldBe1() {
        defaults.results = ["SavedGalleries": [[testGallery]]]
        sut.viewDidLoad()
        let galleriesInDefaults = sut.imageGalleriesJSON.count
        XCTAssertEqual(numberOfSections(in: sut.tableView), galleriesInDefaults)
    }
    
    
    
    func test_numberOfRowsInSection0_shouldBe2() {
        defaults.results = ["SavedGalleries": [[testGallery, testGallery]]]
        let galleriesInDefaults = sut.imageGalleriesJSON[0].count
        sut.viewDidLoad()
        
        XCTAssertEqual(numberOfRows(in: sut.tableView, section: 0), galleriesInDefaults)
    }
    
    func test_numberOfRowsSection1_shouldBe1() {
        defaults.results = ["SavedGalleries": [[testGallery], [testGallery]]]
        sut.viewDidLoad()
        let galleriesInDefaults = sut.imageGalleriesJSON[1].count
        
        XCTAssertEqual(numberOfRows(in: sut.tableView, section: 1), galleriesInDefaults)
    }
    
    func test_cellForRowAt_withRow0Section0WithEmptyDefaults_shouldSetCellNameTextFieldToGalleryone() {
       
        XCTAssertEqual(sut.imageGalleriesJSON.count, 0, "precondition")
        sut.viewDidLoad()
        
        let cell = cellForRowCustomCell(in: sut.tableView, row: 0, section: 0)
        
        XCTAssertEqual(cell?.nameTextField.text, "Gallery one")
        
    }
    
    func test_cellForRowAt_withRow0Section0_shouldSetCellNameTextFieldToOne() {
        
        testGallery.name = "One"
        
        defaults.results = ["SavedGalleries": [[testGallery]]]
        
        XCTAssertEqual(sut.imageGalleriesJSON[0].count, 1, "precondition")
        
        sut.viewDidLoad()
        
        let cell = cellForRowCustomCell(in: sut.tableView, row: 0, section: 0)
        
        XCTAssertEqual(cell?.nameTextField.text, "One")
    }
    
    
    func test_cellForRowAt_withRow1Section0_shouldSetCellNameTextFieldToTwo() {
        
        let secondGallery = ImageGallery()
        secondGallery.name = "Two"
        
        defaults.results = ["SavedGalleries": [[testGallery, secondGallery]]]
        
        XCTAssertEqual(sut.imageGalleriesJSON[0].count, 2, "precondition")
        
        sut.viewDidLoad()
        
        let cell = cellForRowCustomCell(in: sut.tableView, row: 1, section: 0)
        
        XCTAssertEqual(cell?.nameTextField.text, "Two")
    }
    
    func test_cellForRowAt_withRow2Section0_shouldSetCellNameTextFieldToThree() {
       
        let thirdGallery = ImageGallery()
        thirdGallery.name = "Three"
        
        defaults.results = ["SavedGalleries": [[testGallery, testGallery, thirdGallery]]]
        
        XCTAssertEqual(sut.imageGalleriesJSON[0].count, 3, "precondition")
        
        sut.viewDidLoad()
        
        let cell = cellForRowCustomCell(in: sut.tableView, row: 2, section: 0)
        
        XCTAssertEqual(cell?.nameTextField.text, "Three")
    }
    
    
    func test_cellForRowAt_withRow0Section1_shouldSetCellNameTextFieldToDeleted() {
        
        let deletedGallery = ImageGallery()
        
        deletedGallery.name = "Deleted"
        
        defaults.results = ["SavedGalleries": [[testGallery], [deletedGallery]]]
        
        XCTAssertEqual(sut.imageGalleriesJSON.count, 2, "precondition")
        
        sut.viewDidLoad()
        
        let cell = cellForRow(in: sut.tableView, row: 0, section: 1)
        
        XCTAssertEqual(cell?.textFromContext, "Deleted")
    }
    
}
