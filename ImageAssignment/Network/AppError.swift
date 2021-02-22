//
//  AppError.swift
//  ImageAssignment
//
//  Created by Vikas sharma on 21/02/21.
//

import Foundation

enum AppError: Error {
    case invalidURL
    case noImage
    case responseError(String)
    case parsingError(String)
    case networkUnavailable
}
