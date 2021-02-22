//
//  ImageDisplayViewController.swift
//  ImageAssignment
//
//  Created by Vikas sharma on 21/02/21.
//

import UIKit

class ImageDisplayViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK:- Properties
    var imageViewModel: ImageManagerViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        addGestures()
        setImage()
    }
    
    func addGestures() {
        let leftSwipeGesture = getSwipeGesture(forDirection: .left)
        let rightSwipeGesture = getSwipeGesture(forDirection: .right)
        self.view.addGestureRecognizer(leftSwipeGesture)
        self.view.addGestureRecognizer(rightSwipeGesture)
    }
    
    func getSwipeGesture(forDirection direction: UISwipeGestureRecognizer.Direction) -> UISwipeGestureRecognizer {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeGesture.direction = direction
        return swipeGesture
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .right:
                getPrevImage()
            case .left:
                getNextImage()
            default:
                break
            }
        }
    }
    
    func getPrevImage() {
        if let selectedIndex = imageViewModel?.selectedImageIndex {
            let prevImageIndex = selectedIndex - 1
            if prevImageIndex >= 0 {
                imageViewModel?.selectedImageIndex = prevImageIndex
                setImage()
            }
        }
    }
    
    func getNextImage() {
        if let selectedIndex = imageViewModel?.selectedImageIndex {
            let nextImageIndex = selectedIndex + 1
            if nextImageIndex < (imageViewModel?.numberOfImages ?? 0) {
                imageViewModel?.selectedImageIndex = nextImageIndex
                setImage()
            }
        }
    }
    
    func setImage() {
        guard let imageURL = imageViewModel?.getLargeImageURL(forIndex: imageViewModel?.selectedImageIndex ?? 0) else { return }
        guard let url = URL(string: imageURL) else { return }
        self.imageView.kf.setImage(with: url)
    }

}
