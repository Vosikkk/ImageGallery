//
//  ImageGalleryCollectionViewController.swift
//  ImageGallery
//
//  Created by Саша Восколович on 12.09.2023.
//

import UIKit



class ImageGalleryCollectionViewController: UICollectionViewController {

    var scale: CGFloat = 1 {
        didSet {
            collectionView?.collectionViewLayout.invalidateLayout()
        }
    }
    
    var gapItems: CGFloat {
        return (flowLayout?.minimumInteritemSpacing)! * CGFloat((Constants.columnCount - 1.0))
    }
    var gapSection: CGFloat {
        return (flowLayout?.sectionInset.right)! * 2.0
    }
    
    var boundsColectionWidth: CGFloat {
        return (collectionView?.bounds.width)!
    }
    
    var imageCollection = [ImageModel]()
   
    var flowLayout: UICollectionViewFlowLayout? {
           return collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
    }
    var predefinedWidth: CGFloat {
        let width = floor((boundsColectionWidth - gapItems - gapSection) / CGFloat(Constants.columnCount)) * scale
        return min(max(width, boundsColectionWidth * Constants.minWidthRation), boundsColectionWidth)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageCollection = [
            ImageModel(url:URL(string:"https://h5p.org/sites/default/files/h5p/content/1209180/images/file-6113d5f8845dc.jpeg")!, aspectRatio: 0.76),
            ImageModel(url: URL(string: "https://miro.medium.com/v2/resize:fit:1400/1*YMJDp-kqus7i-ktWtksNjg.jpeg")!, aspectRatio: 0.76)
        ]
        
        collectionView?.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(zoom)))
        collectionView.dropDelegate = self
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        flowLayout?.invalidateLayout()
    }
    
    @objc private func zoom(_ gesture: UIPinchGestureRecognizer) {
        if gesture.state == .changed {
            scale *= gesture.scale
            gesture.scale = 1.0
        }
    }
    
    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "Show Image":
                if let imageCell = sender as? ImageCollectionViewCell,
                   let indexPath = collectionView.indexPath(for: imageCell),
                   let imageMVC = segue.destination as? ImageViewController {
                    imageMVC.imageURL = imageCollection[indexPath.item].url
                }
            default: break
            }
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return imageCollection.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Image Cell", for: indexPath)
        if let imageCell = cell as? ImageCollectionViewCell {
            imageCell.imageURL = imageCollection[indexPath.item].url
        }
    
        return cell
    }
    
    struct Constants {
        static let columnCount = 3.0
        static let minWidthRation = CGFloat(0.03)
    }
}

extension ImageGalleryCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = predefinedWidth
        let aspectRatio = CGFloat(imageCollection[indexPath.item].aspectRatio)
        return CGSize(width: width, height: width / aspectRatio)
    }
}

extension ImageGalleryCollectionViewController: UICollectionViewDropDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let isSelf = session.localDragSession?.localContext as? UICollectionView == collectionView
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        let isSelf = session.localDragSession?.localContext as? UICollectionView == collectionView
        if isSelf {
            return session.canLoadObjects(ofClass: UIImage.self)
        } else {
            return session.canLoadObjects(ofClass: UIImage.self) && session.canLoadObjects(ofClass: URL.self)
        }
    }

    
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destanationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath {
                // local drag
            } else {
                // drag from outside
                let placeHolderContext = coordinator.drop(item.dragItem, to: UICollectionViewDropPlaceholder(insertionIndexPath: destanationIndexPath, reuseIdentifier: "PlaceHolderCell"))
                var imageURLLocal: URL?
                var aspectRatioLocal: Double?
                //Load image
                item.dragItem.itemProvider.loadObject(ofClass: UIImage.self) { provider, error in
                    DispatchQueue.main.async {
                        if let image = provider as? UIImage {
                            aspectRatioLocal = Double(image.size.width) / Double(image.size.height)
                        }
                    }
                }
                // Load URL
                item.dragItem.itemProvider.loadObject(ofClass: NSURL.self) { provider, error in
                    DispatchQueue.main.async {
                        if let url = provider as? URL {
                            imageURLLocal = url.imageURL
                        }
                        if imageURLLocal != nil, aspectRatioLocal != nil {
                            placeHolderContext.commitInsertion { insertionIndexPath in
                                self.imageCollection.insert(ImageModel(url: imageURLLocal!, aspectRatio: aspectRatioLocal!), at: insertionIndexPath.item)
                            }
                        } else {
                            placeHolderContext.deletePlaceholder()
                        }
                    }
                }
            }
        }
    }
}
