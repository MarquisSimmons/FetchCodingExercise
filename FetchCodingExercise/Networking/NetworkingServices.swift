//
//  EventsAPI.swift
//  FetchCodingExercise
//
//  Created by Marquis Simmons on 2/6/21.
//

import Foundation
import UIKit
public class NetworkingServices {
    let EVENTS_ENDPOINT = "https://api.seatgeek.com/2/events?client_id=MjE1MzI3Mjh8MTYxMjYxNDUzOS45MDM3MjE2"
    let imageMemoryCache = NSCache<NSString, UIImage>()
    
    /// This function retrieves an Image from a URL
    /// - Parameters:
    ///   - url: The url that contains the image we want to retrieve
    ///   - completion: Our completion handler
    ///   - result: The Image retrieved from the URL or a NetworkError enum we get back incase we run into an error
    func getEventPhoto(from url: URL, completion: @escaping (_ result: Result<UIImage?,Error>) -> Void){
            if let cachedImage = self.imageMemoryCache.object(forKey: url.absoluteString as NSString){
                completion(.success(cachedImage))
                return
            }
            else {
                let photosApi = EventPhotosAPI()
                let apiLoader = APILoader(with: photosApi)
                apiLoader.makeAPIRequest(to: url.absoluteString) { result in
                    switch result {
                    case .success(let image):
                        self.imageMemoryCache.setObject(image, forKey: url.absoluteString as NSString)
                        completion(.success(image))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        
    }
    
    /// This function parses the Json Object containing the list of Events and uses that data to create Event Objects
    /// - Parameters:
    ///     - completion: The completion handler
    ///     - result: A list of the converted Event objects or the returned NetworkError enum
    func getEvents(completion: @escaping (_ result: Result<[EventList.Event], NetworkError>) -> Void) {
        let eventsApi = EventsAPI()
        let apiLoader = APILoader(with: eventsApi)
        apiLoader.makeAPIRequest(to: EVENTS_ENDPOINT) { result in
            switch result {
            case .success(let list):
                completion(.success(list))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    
        
    }
}
