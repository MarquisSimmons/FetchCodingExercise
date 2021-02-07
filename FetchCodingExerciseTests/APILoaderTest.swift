//
//  APILoaderTest.swift
//  FetchCodingExerciseTests
//
//  Created by Marquis Simmons on 1/31/21.
//

import XCTest
@testable import FetchCodingExercise


class APILoaderTest: XCTestCase {
    var apiLoader: APILoader<EventsAPI>!
    var urlSession: URLSession!
    var expectation: XCTestExpectation!
    var eventsApi: EventsAPI!


    
    override func setUpWithError() throws {
        super.setUp()
        let config = URLSessionConfiguration.default
        config.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: config)
        eventsApi = EventsAPI()
        apiLoader = APILoader(with: eventsApi, urlSession: urlSession)

    }

    override func tearDownWithError() throws {
        super.tearDown()
        apiLoader = nil
        urlSession = nil
    }
    
    
    /// This tests how the Events API responds to a malformed JSON file. This should fail when the JSON does
    /// not come back as we expect it
    /// - Throws: TestError if the JSON File is not found
    func testGetEventsMalformedJSON() throws {
        let urlString = "https://api.seatgeek.com/2/events"
        expectation = expectation(description: "Network request should fail while parsing the JSON")
        let data = try getData(fromJSON: "MalformedEvents")
        
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), data)
          }
        apiLoader.makeAPIRequest(to: urlString) { result in
            switch result {
            case .success(_):
                XCTFail("Success is not the expected outcome")
                self.expectation.fulfill()
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.malformedJSON)
                self.expectation.fulfill()
                
            }
            
        }
        wait(for: [expectation], timeout: 1)
    }
    
    /// This tests how the EventsAPI  response to an empty URL . It should immediately fail
    func testGetEventsMalformedURL(){
        let urlString = ""
        expectation = expectation(description: "Network request should fail immediately")
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), Data())
          }
        apiLoader.makeAPIRequest(to: urlString) { result in
            switch result {
            case .success(_):
                XCTFail("Success is not the expected outcome")
                self.expectation.fulfill()
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.malformedURL(url: ""))
                self.expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1)
    }
    


}
