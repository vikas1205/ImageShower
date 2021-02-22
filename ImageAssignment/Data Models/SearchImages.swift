//
//  SearchImages.swift
//  ImageAssignment
//
//  Created by Vikas sharma on 21/02/21.
//

import Foundation

struct SearchImages: Codable {
    var total: Int
    var totalHits: Int
    var hits: [ImageDetails]?
}

struct ImageDetails: Codable {
    var id: Int
    var previewURL: String
    var imageURL: String?
    var largeImageURL: String
    var fullHDURL: String?
}
