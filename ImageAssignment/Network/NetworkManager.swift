//
//  NetworkManager.swift
//  ImageAssignment
//
//  Created by Vikas sharma on 21/02/21.
//

import Foundation
import Alamofire

struct NetworkManager {
    
    static let shared = NetworkManager()
    
    private var sessionManager: Session?
    
    private init() {
        sessionManager = Session()
    }
    
    func request<T: Codable>(request: NetworkRouter, completionHandler: @escaping ((Result<T,AppError>) -> ())) {
        if let _ = NetworkReachabilityManager()?.isReachable {
            guard let urlRequest = try? request.asURLRequest() else {
                return completionHandler(.failure(.invalidURL))
            }
            
            self.sessionManager?.request(urlRequest).responseData(completionHandler: { (response) in
                self.displayRequestResponse(response)
                
                switch response.result {
                case .success(let data):
                    do {
                        let jsonData = try JSONDecoder().decode(T.self, from: data)
                        completionHandler(.success(jsonData))
                    }catch {
                        completionHandler(.failure(.parsingError(error.localizedDescription)))
                    }
                case .failure(let error):
                    completionHandler(.failure(.responseError(error.localizedDescription)))
                }
            })
        }
    }
    
    private func displayRequestResponse(_ response: AFDataResponse<Data>) {
        if let request = response.request {
            if let url = request.url {
                print("\n\nURL: \(url)")
            }
            if let headers = request.allHTTPHeaderFields {
                print("Header: \(headers)")
            }
            if let body = response.data, let jsonContent = String(data: body, encoding: .utf8) {
                print("Body: \(jsonContent)\n\n")
            }
        }
    }
}
