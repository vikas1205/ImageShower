//
//  NetworkRouter.swift
//  ImageAssignment
//
//  Created by Vikas sharma on 21/02/21.
//

import Foundation
import Alamofire

enum NetworkRouter: URLRequestConvertible {
    
    case searchImage(name: String, page: Int)
    
    var baseURL: String {
        return "https://pixabay.com/api/"
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchImage(_,_):
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .searchImage(_,_):
            return ""
        }
    }
    
    var headers: [String: String] {
        var headerDict = [String: String]()
        headerDict["Content-Type"] = "application/json; charset=utf-8"
        switch self {
        case .searchImage(_,_):
            return headerDict
        }
    }
    
    enum RequestParameters {
        case url(_: Parameters)
        case body(_: Parameters)
    }
    
    var parameters: RequestParameters {
        switch self {
        case .searchImage(let imageName,let pageNumber):
            return .url(["key": "20345236-14522f8dde45aa8d5e11fd114",
                         "q": imageName,
                         "image_type": "photo",
                         "page": pageNumber])
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        
        switch parameters {
        case .url(let params):
            let queryParams = params.map { pair in
                return URLQueryItem(name: pair.key, value: "\(pair.value)")
            }
            var components = URLComponents(string: url.appendingPathComponent(path).absoluteString)
            components?.queryItems = queryParams
            urlRequest.url = components?.url
            
        case .body(let data):
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: data, options: [])
        }
        
        return urlRequest
    }
    
    
}
