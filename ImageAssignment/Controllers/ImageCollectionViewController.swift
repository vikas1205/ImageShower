//
//  ImageCollectionViewController.swift
//  ImageAssignment
//
//  Created by Vikas sharma on 21/02/21.
//

import UIKit
import Kingfisher

private let reuseIdentifier = "photoCell"
private let showImageSegueIdentifier = "Show Image"

class ImageCollectionViewController: UICollectionViewController {
    
    //MARK:- Properties
    weak var imageViewModel: ImageManagerViewModel?
    
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
    private let itemsPerRow: CGFloat = 2


    override func viewDidLoad() {
        super.viewDidLoad()
        reloadContent()
    }
    
    func reloadContent() {
        imageViewModel?.reloadContent = { [weak self] (updateContentStatus,error) in
            if updateContentStatus {
                // go to next controller because we have images
                self?.collectionView.reloadData()
            }else {
                self?.alert(title: "Error", msg: error?.localizedDescription ?? "No More Images are not available.", alertButtons: nil)
            }
        }
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return imageViewModel?.numberOfImages ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
        guard let imageURL = imageViewModel?.getImageURL(forIndex: indexPath.row) else { return cell }
        guard let url = URL(string: imageURL) else { return cell }
        cell.imageView.kf.setImage(with: url)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        imageViewModel?.selectedImageIndex = indexPath.row
        self.performSegue(withIdentifier: showImageSegueIdentifier, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let imageShowerVC = segue.destination as? ImageDisplayViewController {
            imageShowerVC.imageViewModel = imageViewModel
        }
    }
    
}

extension ImageCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }

}
