//
//  URL+ReactiveTests.swift
//  Cat Grouping Coding ExerciseTests
//
//  Created by Ivan Galic on 11/6/18.
//  Copyright © 2018 Ivan Galic. All rights reserved.
//

import XCTest
import ReactiveCocoa
import ReactiveSwift
import Result
@testable import Cat_Grouping_Coding_Exercise

class URL_ReactiveTests: XCTestCase {
  struct SampleObject: Codable, Equatable {
    let key: String
  }

  var mockSession: MockURLSession! = nil
  var url: URL! = nil
  var sampleObject: SampleObject! = nil
  var sampleObjectData: Data! = nil
  
  override func setUp() {
    super.setUp()
    url = URL(string: "http://test.com")!
    mockSession = MockURLSession()
    sampleObject = SampleObject(key: "test value")
    sampleObjectData = try! JSONEncoder().encode(sampleObject)
  }
  
  override func tearDown() {
    url = nil
    mockSession = nil
    sampleObject = nil
    sampleObjectData = nil
    super.tearDown()
  }
  
  func testURLRequestSuccess() {
    mockSession.responses[url] = (
      sampleObjectData,
      URLResponse(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil),
      nil
    )

    let expectation = XCTestExpectation(description: "Receiving correct data from URL request")
    let producer: SignalProducer<SampleObject, NSError> = url.makeRequest(session: mockSession)
    producer
    .observe(on: UIScheduler())
      .startWithResult { (result) in
        if let error = result.error {
          XCTFail("Unexpected error: \(error)")
        } else if let obj = result.value {
          if obj == self.sampleObject {
            return expectation.fulfill()
          }
          XCTFail("Invalid data")
        } else {
          XCTFail("Data not received")
        }
    }
    wait(for: [expectation], timeout: 1)
  }
  
  func testURLRequestFailure() {
    let error = NSError(domain: "test_domain", code: 1, userInfo: nil)
    mockSession.responses[url] = (
      nil,
      URLResponse(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil),
      error
    )
    
    let expectation = XCTestExpectation(description: "Error should be correctly forwarded")
    let producer: SignalProducer<String, NSError> = url.makeRequest(session: mockSession)
    producer
      .observe(on: UIScheduler())
      .startWithResult { (result) in
        if let receivedError = result.error {
          XCTAssertEqual(receivedError, error)
          return expectation.fulfill()
        }
        XCTFail("Didn't receive error")
    }
    wait(for: [expectation], timeout: 1)
  }
}
