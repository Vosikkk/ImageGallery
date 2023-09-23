//
//  GalleriesTableViewController.swift
//  ImageGallery
//
//  Created by Саша Восколович on 14.09.2023.
//

import UIKit

class GalleriesTableViewController: UITableViewController {
    
    private var splitViewDetailCollectionController: ImageGalleryCollectionViewController? {
        let navController = splitViewController?.viewControllers.last as? UINavigationController
        return navController?.viewControllers.first as? ImageGalleryCollectionViewController
    }
    
    let defaults = UserDefaults.standard
    
    var imageGalleriesJSON: [[ImageGallery]]? {
        get {
            if let savedGalleriesData = defaults.object(forKey: "SavedGalleries") as? Data {
                let decoder = JSONDecoder()
                if let loadedGalleries = try? decoder.decode([[ImageGallery]].self, from: savedGalleriesData) {
                    return loadedGalleries
                }
            }
            return nil
        }
        set {
            if newValue != nil {
                let encoder = JSONEncoder()
                if let json = try? encoder.encode(newValue) {
                    defaults.set(json, forKey: "SavedGalleries")
                }
            }
        }
    }
    
    var imagesGalleries = [[ImageGallery]]()
    
    private var lastIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let loadedGalleriesFromJSON = imageGalleriesJSON {
            imagesGalleries = loadedGalleriesFromJSON
        } else {
            imagesGalleries = [[ImageGallery(name: "Gallery one")]]
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let currentIndex = lastIndexPath != nil ? lastIndexPath! : IndexPath(row: 0, section: 0)
        selectRow(at: currentIndex)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        imageGalleriesJSON = imagesGalleries
    }
//
//    override func viewWillLayoutSubviews() {
//          super.viewWillLayoutSubviews()
//        if splitViewController?.preferredDisplayMode != .oneOverSecondary {
//              splitViewController?.preferredDisplayMode = .oneOverSecondary
//          }
//      }
//
//
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return imagesGalleries.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return imagesGalleries[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        var cell: UITableViewCell
        
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "Gallery Cell", for: indexPath)
            if let galleryCell = cell as? GallaryTableViewCell {
                galleryCell.nameTextField.text = galleryName(at: indexPath)
                
                // Edit text(name of gallery) and set new name
                galleryCell.registrationHandler = { [weak self, unowned galleryCell] in
                    if let name = galleryCell.nameTextField.text {
                        self?.imagesGalleries[indexPath.section][indexPath.row].name = name
                        self?.tableView.reloadData()
                        self?.selectRow(at: indexPath)
                    }
                }
            }
            
        } else {
             cell = tableView.dequeueReusableCell(withIdentifier: "Title Cell", for: indexPath)
             if #available(iOS 14, *) {
                var content = cell.defaultContentConfiguration()
                content.text = galleryName(at: indexPath)
                cell.contentConfiguration = content
                 
             } else {
                cell.textLabel?.text = galleryName(at: indexPath)
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return imagesGalleries[section].count > 0 ? "Recently deleted" : nil
        default: return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showCollection(at: indexPath)
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            switch indexPath.section {
            case 0:
                if imagesGalleries.count < 2 {
                    let removedRow = imagesGalleries[0].remove(at: indexPath.row)
                    imagesGalleries.insert([removedRow], at: 1)
                    tableView.reloadData()
                    self.selectRow(at: IndexPath(row: 0, section: 1))
                } else {
                    tableView.performBatchUpdates {
                        imagesGalleries[1].insert(imagesGalleries[0].remove(at: indexPath.row), at: 0)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                        tableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
                    } completion: { finished in
                        self.selectRow(at: IndexPath(row: 0, section: 1), after: 0.6)
                    }
                }
            case 1:
                tableView.performBatchUpdates {
                    imagesGalleries[1].remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                } completion: { finished in
                    self.selectRow(at: IndexPath(row: 0, section: 0))
                }
            default: break
                
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 1 {
            let lastIndexOfFirstSection = self.imagesGalleries[0].count
            let undelete = UIContextualAction(style: .normal,
                                              title: "Undelete") { contentAction , sourceView, completionHandler in
                tableView.performBatchUpdates {
                    self.imagesGalleries[0].insert(self.imagesGalleries[1].remove(at: indexPath.row), at: lastIndexOfFirstSection)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.insertRows(at: [IndexPath(row: lastIndexOfFirstSection, section: 0)], with: .automatic)
                } completion: { finished in
                    self.selectRow(at: IndexPath(row: lastIndexOfFirstSection, section: 0), after: 0.5)
                }
                completionHandler(true)
            }
            undelete.backgroundColor = .blue
            return UISwipeActionsConfiguration(actions: [undelete])
            
        } else {
            return nil
        }
    }

    @IBAction func addNewGallery(_ sender: UIBarButtonItem) {
        imagesGalleries[0] += [
            ImageGallery(name: "New Gallery".madeUnique(withRespectTo: imagesGalleries.flatMap{$0}.map{$0.name}))
        ]
        tableView.reloadData()
        selectRow(at: IndexPath(row: imagesGalleries[0].count - 1, section: 0))
    }

    
    // MARK: - Navigation
    private func showCollection(at indexPath: IndexPath) {
        if let vc = splitViewDetailCollectionController {
            lastIndexPath = indexPath
            if indexPath.section != 1 {
                vc.imageCollection = imagesGalleries[indexPath.section][indexPath.row]
                vc.title = imagesGalleries[indexPath.section][indexPath.row].name
                vc.collectionView.isUserInteractionEnabled = true
            } else {
                let newName = "Recentrly deleted ' " + imagesGalleries[indexPath.section][indexPath.row].name + " '"
                vc.imageCollection = ImageGallery(name: newName)
                vc.title = newName
                vc.collectionView.isUserInteractionEnabled = false
            }
        }
    }
  
    private func selectRow(at indexPath: IndexPath, after timeDelay: TimeInterval = 0.0) {
        if tableView(self.tableView, numberOfRowsInSection: indexPath.section) > indexPath.row {
            Timer.scheduledTimer(withTimeInterval: timeDelay, repeats: false) { [weak self] timer in
                self?.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                self?.showCollection(at: indexPath)
            }
        }
    }
   
    private func galleryName(at indexPath: IndexPath) -> String {
        return imagesGalleries[indexPath.section][indexPath.row].name
    }
  
}
