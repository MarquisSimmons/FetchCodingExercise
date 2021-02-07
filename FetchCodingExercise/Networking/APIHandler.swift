//
//  APIHandler.swift
//  FetchCodingExercise
//
//  Created by Marquis Simmons on 2/6/21.
//

import Foundation
protocol APIHandler {
    associatedtype ResponseDataType
    func createRequest(using path: URL) -> URLRequest
    func parseResponse(data: Data, completion: @escaping (_ result: Result<ResponseDataType,NetworkError>) -> Void)
}

extension APIHandler {
    func createRequest(using path: URL) -> URLRequest {
        var urlRequest = URLRequest(url: path)
        urlRequest.httpMethod = "GET"
        return urlRequest
        
    }
}
