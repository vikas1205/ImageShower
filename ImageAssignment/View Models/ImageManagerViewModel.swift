//
//  ImageManagerViewModel.swift
//  ImageAssignment
//
//  Created by Vikas sharma on 21/02/21.
//

import Foundation


class ImageManagerViewModel {
    
    // MARK:- Variables and Constants
    private var totalNumberOfImages: Int?
    private var numberOfImagesPerPage = 20
    private var imagesList: [ImageDetails]?
    private var maxCurrentIndexOfImage = 0
    private var downloadingPageStatus = false
    var reloadContent: ((Bool,AppError?) -> Void)?
    var selectedImageIndex: Int?
    var searchedImageName: String?
    
    var numberOfImages: Int {
        return imagesList?.count ?? 0
    }
    
    private var currentPageValue: Int {
        return (numberOfImages / numberOfImagesPerPage)
    }
    
    func getImageURL(forIndex index: Int) -> String? {
        if isNextPageRequired(withIndex: index) {
            downloadImages(ofName: searchedImageName ?? "", forPage: currentPageValue + 1)
        }
        return imagesList?[index].previewURL
    }
    
    private func isNextPageRequired(withIndex index: Int) -> Bool {
        let range = (numberOfImages - 10)..<numberOfImages
        let allDownloaded = range.contains((totalNumberOfImages ?? 0) - 1)
        if range.contains(index) && !downloadingPageStatus && !allDownloaded {
            downloadingPageStatus = true
            return true
        }
        return false
    }
    
    func getLargeImageURL(forIndex index: Int) -> String? {
        return imagesList?[index].largeImageURL
    }
    
    func downloadImages(ofName name: String, forPage pageNumber: Int = 1) {
        self.searchedImageName = name
        NetworkManager.shared.request(request: .searchImage(name: name, page: pageNumber) ) { (response: Result<SearchImages,AppError>) in
            switch response {
            case.success(let response):
                if pageNumber > 1 {
                    self.imagesList = (self.imagesList ?? []) + response.hits! 
                }else {
                    self.imagesList = response.hits
                }
                self.totalNumberOfImages = response.total
                self.downloadingPageStatus = false
                self.reloadContent?(true,nil)
            case.failure(let error):
                self.reloadContent?(false,error)
            }
        }
    }
    
}
