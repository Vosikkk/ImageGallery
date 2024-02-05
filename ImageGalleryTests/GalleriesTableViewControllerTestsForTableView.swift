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
        createGalleries(in: defaults, numerOfSection: 1, galleriesInSection: 1)
        sut.viewDidLoad()
        let galleriesInDefaults = sut.imageGalleriesJSON.count
        XCTAssertEqual(numberOfSections(in: sut.tableView), galleriesInDefaults)
    }
    
    func test_numberOfSection_shouldBe2() {
        createGalleries(in: defaults, numerOfSection: 2, galleriesInSection: 1)
        sut.viewDidLoad()
        let galleriesInDefaults = sut.imageGalleriesJSON.count
        XCTAssertEqual(numberOfSections(in: sut.tableView), galleriesInDefaults)
    }
    
    
    func test_numberOfRowsInSection0_shouldBe2() {
        createGalleries(in: defaults, numerOfSection: 1, galleriesInSection: 2)
        
        let galleriesInDefaults = sut.imageGalleriesJSON[0].count
        sut.viewDidLoad()
        
        XCTAssertEqual(numberOfRows(in: sut.tableView, section: 0), galleriesInDefaults)
    }
    
    func test_numberOfRowsSection1_shouldBe1() {
        createGalleries(in: defaults, numerOfSection: 2, galleriesInSection: 1)

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
    
    
    func test_titleForHeader_shouldBeRecentlyDeletedInSection1AndNilInSection0() {
        
        XCTAssertEqual(titleHeader(in: sut.tableView), nil)
        createGalleries(in: defaults, numerOfSection: 2, galleriesInSection: 1)
        sut.viewDidLoad()
        
        let header = titleHeader(in: sut.tableView, section: 1)
        
        XCTAssertEqual(titleHeader(in: sut.tableView, section: 0), nil)
        XCTAssertEqual(header, "Recently deleted")
    }
    
    func test_didSelectRow__withRow0() {
        createGalleries(in: defaults, numerOfSection: 2, galleriesInSection: 1)
        sut.viewDidLoad()
        didSelectRow(in: sut.tableView, row: 0)
    }
    
    func test_editingStyle_forSection0GalleryDeleteStyle_shouldBeRow0InSection0() {
        
        createGalleries(in: defaults, numerOfSection: 1, galleriesInSection: 1)
        
        sut.viewDidLoad()
        
        XCTAssertEqual(numberOfRows(in: sut.tableView, section: 0), 1, "precondition")
    
        editingRow(in: sut.tableView, commitForEdit: .delete, section: 0)
        
        XCTAssertEqual(numberOfRows(in: sut.tableView, section: 0), 0)
        
        
    }
    
    func test_editingStyle_checkingCountOfGalleriesInSection1With1GalleryAfterDeleting1GalleryFromSection0_shouldBe2RowsInSection1() {
       
        createGalleries(in: defaults, numerOfSection: 2, galleriesInSection: 1)
       
        sut.viewDidLoad()
        
        XCTAssertEqual(numberOfRows(in: sut.tableView, section: 0), 1, "precondition")
        XCTAssertEqual(numberOfRows(in: sut.tableView, section: 1), 1, "precondition")
        
        editingRow(in: sut.tableView, commitForEdit: .delete, section: 0)
        
        XCTAssertEqual(numberOfRows(in: sut.tableView, section: 0), 0)
        XCTAssertEqual(numberOfRows(in: sut.tableView, section: 1), 2)
    }
    
    
    func test_editingStyleDeleteRowFromSection1_shouldBe0RowInSection1() {
       
        createGalleries(in: defaults, numerOfSection: 2, galleriesInSection: 1)
        sut.viewDidLoad()
        
        XCTAssertEqual(numberOfRows(in: sut.tableView, section: 1), 1, "precondition")
        
        editingRow(in: sut.tableView, commitForEdit: .delete, section: 1)
        
        XCTAssertEqual(numberOfRows(in: sut.tableView, section: 1), 0)
    }
    
    func test_leadingSwipeActionsConfigurationForRowAtSection1_shouldBeNotNilAndActionCount1() {
        
        createGalleries(in: defaults, numerOfSection: 2, galleriesInSection: 1)
        sut.viewDidLoad()
        
        let configuration = leadingSwipeActionsConfigurationForRow(in: sut.tableView, row: 0, section: 1)
        
        XCTAssertNotNil(configuration)
        
        XCTAssertEqual(configuration?.actions.count, 1, "Should be 1 but \(String(describing: configuration?.actions.count))")
        
        
        XCTAssertEqual(configuration?.actions.first?.title, "Undelete", "The title should be Undelete but \(String(describing: configuration?.actions.first?.title))")
        
        XCTAssertEqual(configuration?.actions.first?.backgroundColor, .blue)
        
    }
    
    
    func test_leadingSwipeActionForRowAtSection1_shouldHaveSection1Row0Section0Rows2() {
        
        createGalleries(in: defaults, numerOfSection: 2, galleriesInSection: 1)
        sut.viewDidLoad()
        
        let configuration = leadingSwipeActionsConfigurationForRow(in: sut.tableView, row: 0, section: 1)
        
        XCTAssertNotNil(configuration, "something wrong there is no \(String(describing: configuration))")
        
        XCTAssertEqual(numberOfRows(in: sut.tableView, section: 0), 1, "precondition")
        XCTAssertEqual(numberOfRows(in: sut.tableView, section: 1), 1, "precondition")
        
        let expectation = expectation(description: "Swipe action performed")
        
        configuration?.actions.first?.handler(configuration!.actions.first!, sut.tableView, { success in
            XCTAssertTrue(success, "Handler should complete successfully")
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 0.1)
        
        XCTAssertEqual(numberOfRows(in: sut.tableView, section: 1), 0)
        XCTAssertEqual(numberOfRows(in: sut.tableView, section: 0), 2)
    }
    
    func test_selectRow_shouldCallSelectRowTrueAndSelectedRow0Section0() {
        
        sut.viewDidLoad()
        
        let tableView = MockTableView()
        sut.tableView = tableView
        let expectation = XCTestExpectation(description: "Select Row Expectation")
        let indexPath = IndexPath(row: 0, section: 0)
        sut.selectRow(at: indexPath)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(tableView.didCallSelectRow)
            XCTAssertEqual(tableView.selectedIndexPath, indexPath)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        
    }
    
    func test_showCollection() {
        
        sut.viewDidLoad()
        
        
        
        let indexPath = IndexPath(row: 0, section: 0)
        
        sut.showCollection(at: indexPath)
        
        
        
        
        
    }
    
    
}


