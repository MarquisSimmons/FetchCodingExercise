//
//  EVentsTest.swift
//  FetchCodingExerciseTests
//
//  Created by Marquis Simmons on 1/31/21.
//

import XCTest
@testable import FetchCodingExercise


class EventsTest: XCTestCase {
    var events: [EventList.Event]!

    override func setUpWithError() throws {
        super.setUp()
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let eventData = try getData(fromJSON: "Events")
        events = try decoder.decode(EventList.self, from: eventData).events
        
    }
    override func tearDownWithError() throws {
        events = nil
        super.tearDown()
    }
    
    
    /// This tests the JSON Parsing of a fully populated Event JSON Object. This should pass if all of the fields have been successfully parsed
    func testEventMapping(){
        let event = events[0]
        XCTAssertEqual(event.id, 5346061)
        XCTAssertEqual(event.title, "Texas Tech Red Raiders at Iowa State Cyclones Womens Basketball")
        XCTAssertEqual(event.datetimeUtc, "2021-02-06T09:30:00")
        XCTAssertEqual(event.venue.displayLocation, "Ames, IA")
        XCTAssertEqual(event.performers[0].image, "https://seatgeek.com/images/performers-landscape/iowa-state-cyclones-womens-basketball-554613/9628/huge.jpg")
        XCTAssertNil(event.favorited)

    }


}
