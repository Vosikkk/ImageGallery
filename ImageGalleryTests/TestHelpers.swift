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

//func editingRow(in tableView: UITableView, row: Int, section: Int = 0) {
//    tableView.delegate?.tableView?(tableView,)
//}
extension UITableViewCell {
    var textFromContext: String? {
        (self.contentConfiguration as? UIListContentConfiguration)?.text
    }
}


