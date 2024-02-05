//
//  TestHelpers.swift
//  ImageGalleryTests
//
//  Created by Саша Восколович on 03.02.2024.
//

import UIKit
@testable import ImageGallery


func numberOfRows(in tableView: UITableView, section: Int = 0) -> Int? {
    tableView.dataSource?.tableView(tableView, numberOfRowsInSection: section)
}

func numberOfSections(in tableView: UITableView) -> Int? {
    tableView.dataSource?.numberOfSections?(in: tableView)
}

func cellForRowCustomCell(in tableView: UITableView, row: Int, section: Int) -> GallaryTableViewCell? {
   let cell = tableView.dataSource?.tableView(tableView, cellForRowAt: IndexPath(row: row, section: section)) as? GallaryTableViewCell
   return cell
}

func cellForRow(in tableView: UITableView, row: Int, section: Int) -> UITableViewCell? {
  tableView.dataSource?.tableView(tableView, cellForRowAt: IndexPath(row: row, section: section))
  
}

func titleHeader(in tableView: UITableView, section: Int = 0) -> String? {
    tableView.dataSource?.tableView?(tableView, titleForHeaderInSection: section)
}

func didSelectRow(in tableView: UITableView, row: Int, section: Int = 0) {
    tableView.delegate?.tableView?(tableView, didSelectRowAt: IndexPath(row: row, section: section))
}


func executeRunLoop() {
    RunLoop.current.run(until: Date())
}

func leadingSwipeActionsConfigurationForRow(in tableView: UITableView, row: Int, section: Int) -> UISwipeActionsConfiguration? {
    tableView.delegate?.tableView?(tableView, leadingSwipeActionsConfigurationForRowAt: IndexPath(row: row, section: section))
}


func editingRow(in tableView: UITableView, commitForEdit: UITableViewCell.EditingStyle, row: Int = 0, section: Int = 0) {
    tableView.dataSource?.tableView?(tableView, commit: commitForEdit, forRowAt: IndexPath(row: row, section: section))
    
}

extension UITableViewCell {
    var textFromContext: String? {
        (self.contentConfiguration as? UIListContentConfiguration)?.text
    }
}


func putInWindow(_ vc: UIViewController) {
    let window = UIWindow()
    window.rootViewController = vc
    window.isHidden = false
}

func tap(_ button: UIBarButtonItem) {
    _ = button.target?.perform(button.action, with: nil)
}

func createGalleries(in storage: UserDefaultsProtocol, amount: Int, section: Int) {
    var res: [ImageGallery] = []
    for _ in 0..<amount {
        let testGallery = ImageGallery()
        res.append(testGallery)
    }
    
    storage.sett([res], forKey: "SavedGalleries")
}
