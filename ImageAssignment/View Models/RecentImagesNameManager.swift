//
//  RecentImageNameManager.swift
//  ImageAssignment
//
//  Created by Vikas sharma on 22/02/21.
//

import Foundation

class RecentImagesNameManager {
    
    private var listOfSearchedImage: [String]?
    private let maxRecentImagesName = 10
    
    var numberOfRecentImagesName: Int {
        return listOfSearchedImage?.count ?? 0
    }
    
    func add(name: String) {
        if let list = listOfSearchedImage, !(list.contains(name)) {
            listOfSearchedImage?.insert(name, at: 0)
            if list.count > maxRecentImagesName {
                listOfSearchedImage = Array(list.prefix(maxRecentImagesName))
            }
        }else if listOfSearchedImage == nil {
            listOfSearchedImage = [name]
        }
    }
    
    func getRecentSearchedImageName(forIndex index: Int) -> String {
        return listOfSearchedImage?[index] ?? ""
    }
}
