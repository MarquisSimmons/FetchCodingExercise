//
//  APILoader.swift
//  FetchCodingExercise
//
//  Created by Marquis Simmons on 2/6/21.
//

import Foundation
class APILoader<T: APIHandler> {
    let api: T
    let urlSession: URLSession
    
    
    /// Loads an API with a URL Session
    /// - Parameters:
    ///   - api: The API we are loading (this varies based on the requests being made)
    ///   - urlSession: URL session being used to make the request, default to  URLSession.shared
    init(with api: T, urlSession: URLSession = .shared){
        self.api = api
        self.urlSession = urlSession
    }
    
    /// This function is used to make our network GET Requests
    /// - Parameters:
    ///   - url: The URL we want to make the GET Request to
    ///   - completion: Our completion handler
    ///   - result: The data we get from the request or a NetworkError enum we get based on the response code
    func makeAPIRequest(to path: String, completion: @escaping (_ result: Result<T.ResponseDataType,NetworkError>) -> Void) {
        guard let urlPath = URL(string: path) else {
            completion(.failure(.malformedURL(url: path)))
            return
        }
        let urlRequest = api.createRequest(using: urlPath)
        urlSession.dataTask(with: urlRequest) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else { return }
            
            if error != nil {
                switch httpResponse.statusCode {
                case 400:
                    completion(.failure(.badRequest(url: urlPath.absoluteString)))
                    return
                case 404:
                    completion(.failure(.notFound(url: urlPath.absoluteString)))
                    return
                case 408:
                    completion(.failure(.timeOut))
                    return
                case 500:
                    completion(.failure(.serverError))
                    return
                default:
                    completion(.failure(.failedRequest))
                    return
                }
            }
            else if let returnedData = data {
                completion(.success(self.api.parseResponse(data: returnedData)))
            }
        }.resume()
        
    }
    
}
