//
//  AllEventsAPI.swift
//  FetchCodingExercise
//
//  Created by Marquis Simmons on 2/6/21.
//

import Foundation
struct EventsAPI: APIHandler {
    func parseResponse(data: Data) -> [EventList.Event] {
        var events = [EventList.Event]()
        do {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            let eventObjects = try jsonDecoder.decode(EventList.self, from: data).events
            events = eventObjects
            return events
            
        }
        catch let jsonError {
            print("There was an error decoding the Employees: \(jsonError)")
            return events

        }
    }
}
