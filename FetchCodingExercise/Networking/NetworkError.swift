//
//  NetworkError.swift
//  FetchCodingExercise
//
//  Created by Marquis Simmons on 1/31/21.
//

import Foundation
enum NetworkError: Error, Equatable {
    case malformedURL(url: String?)
    case badRequest (url: String)
    case timeOut
    case serverError
    case notFound(url: String)
    case failedRequest
    case malformedJSON
    case badData(dataType: String)
    
}
extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .malformedURL(let url):
            return "The provided URL is invalid: \(String(describing: url))"
        case .badRequest(let url):
            return "The request at: \(url) could not be recognized."
        case .timeOut:
            return "The request to the server has timed out. Try again later."
        case .serverError:
            return "There was an internal server error. Try again later"
        case .notFound(let url):
            return "Nothing was found at the provided URL: \(url)"
        case .malformedJSON:
            return "An error occurred while trying to parse the JSON Object"
        case .badData(let dataType):
            return "An error occured while trying to process the \(dataType) Data"
        default:
            return "Network request failed."
        }
    }
}

