//
//  Event.swift
//  FetchCodingExercise
//
//  Created by Marquis Simmons on 2/6/21.
//

import Foundation

public struct EventList: Codable {
    let events: [Event]
}
// MARK: - Event Object
extension EventList {
    class Event: Codable {
        let id: Int
        let title: String
        let datetimeUtc: String
        let venue: EventLocation
        let performers: [Performer]
        
        var favorited: Bool?
        
        func formatDate() -> String? {
            var convertedDateString = datetimeUtc
            let utcDateFormatter = DateFormatter()
            utcDateFormatter.locale = Locale(identifier: "en_US_POSIX")
            utcDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            if let dateToTimeInterval = utcDateFormatter.date(from: datetimeUtc)?.timeIntervalSinceReferenceDate {
                let newDate = Date(timeIntervalSinceReferenceDate: dateToTimeInterval)
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .full
                dateFormatter.timeStyle = .short
                dateFormatter.locale = Locale(identifier: "en_US")
                convertedDateString = dateFormatter.string(from: newDate)
                
            }
            return convertedDateString
            
        }
    }
}
// MARK: - Location object using the Venue JSON field
extension EventList {
    struct EventLocation: Codable {
        let displayLocation: String
    }
}
// MARK: - Performer object using the Performers JSON field
extension EventList {
    struct Performer: Codable {
        let image: String
    }
}

// MARK: - Favorite Toggle Delegate
protocol FavoriteToggleHandler {
    func handleFavoriteToggle(for event: EventList.Event)
}

