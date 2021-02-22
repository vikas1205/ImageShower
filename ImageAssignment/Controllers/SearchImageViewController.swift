//
//  SearchImageViewController.swift
//  ImageAssignment
//
//  Created by Vikas sharma on 21/02/21.
//

import UIKit

class SearchImageViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var searchImagesTextfiled: UITextField!
    @IBOutlet weak var lastSearchedImagesNameListTableView: UITableView!
    
    //MARK:- Properties
    private let imageViewModel = ImageManagerViewModel()
    private let recentImageViewModel = RecentImagesNameManager()
    private let imageListSegueIdentifier = "Photos List"
    
    //MARK:- IBActions
    @IBAction func searchImages(_ sender: UIButton) {
        startSearchingImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchImagesTextfiled.text = ""
        if recentImageViewModel.numberOfRecentImagesName > 0 {
            lastSearchedImagesNameListTableView.isHidden = false
            lastSearchedImagesNameListTableView.reloadData()
        }else {
            lastSearchedImagesNameListTableView.isHidden = true
        }
    }
    
    private func startSearchingImage() {
        if let imagesName = searchImagesTextfiled.text, imagesName.isEmpty == false {
            searchImages(withName: imagesName)
        }else {
            alert(title: "No Image", msg: "Image name is not entered yet", alertButtons: nil)
        }
    }
    
    func searchImages(withName name: String) {
        searchImagesTextfiled.resignFirstResponder()
        recentImageViewModel.add(name: name)
        imageViewModel.downloadImages(ofName: name)
        reloadContent()
    }
    
    func reloadContent() {
        imageViewModel.reloadContent = { [weak self] (updateContentStatus,error) in
            if updateContentStatus, (self?.imageViewModel.numberOfImages ?? 0) > 0 {
                // go to next controller because we have images
                self?.performSegue(withIdentifier: self?.imageListSegueIdentifier ?? "", sender: nil)
            }else {
                self?.alert(title: "", msg: error?.localizedDescription ?? "There are no image related to \(self?.imageViewModel.searchedImageName ?? "")", alertButtons: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let photosListVC = segue.destination as? ImageCollectionViewController {
            photosListVC.imageViewModel = imageViewModel
        }
    }
}

extension SearchImageViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        startSearchingImage()
        textField.resignFirstResponder()
        return true
    }
}

extension SearchImageViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentImageViewModel.numberOfRecentImagesName
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = recentImageViewModel.getRecentSearchedImageName(forIndex: indexPath.row)
        cell.selectionStyle = .none
        return cell
    }
}

extension SearchImageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let imageName = recentImageViewModel.getRecentSearchedImageName(forIndex: indexPath.row)
        searchImages(withName: imageName)
    }
}
