//
//  AllEventsAPI.swift
//  FetchCodingExercise
//
//  Created by Marquis Simmons on 2/6/21.
//

import Foundation
struct EventsAPI: APIHandler {
    func parseResponse(data: Data, completion: @escaping (_ result: Result<[EventList.Event],NetworkError>) -> Void) {
        let userDefaults = UserDefaults.standard
        var events = [EventList.Event]()
        do {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let eventObjects = try jsonDecoder.decode(EventList.self, from: data).events
            
            // Assigns the favorited flag to the events upon initialization
            let favoritedData = userDefaults.object(forKey: "favorited-events") as? Data
            guard let favoriteEvents = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(favoritedData!) as? Set<Int> else { return }
            
            events = eventObjects.map({ (event) -> EventList.Event in
                event.favorited = favoriteEvents.contains(event.id)
                return event
            })
            completion(.success(events))
            
        }
        catch let jsonError {
            print("There was an error decoding the Events: \(jsonError)")
            completion(.failure(.malformedJSON))
            
        }
    }
}
