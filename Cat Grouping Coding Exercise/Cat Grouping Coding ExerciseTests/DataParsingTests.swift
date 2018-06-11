//
//  DataParsingTests.swift
//  Cat Grouping Coding ExerciseTests
//
//  Created by Ivan Galic on 11/6/18.
//  Copyright © 2018 Ivan Galic. All rights reserved.
//

import XCTest
import ReactiveSwift
@testable import Cat_Grouping_Coding_Exercise

class DataParsingTests: XCTestCase {
  var mockSession: MockURLSession! = nil
  var url: URL! = nil
  var people: [Person]! = nil
  var peopleData: Data! = nil
  var fish1 = Pet(name: "Fish1", type: "Fish")
  var fish2 = Pet(name: "Fish2", type: "Fish")
  var dog1 = Pet(name: "Dog1", type: "Dog")
  var dog2 = Pet(name: "Dog2", type: "Dog")
  var cat1 = Pet(name: "Cat1", type: "Cat")
  var cat2 = Pet(name: "Cat2", type: "Cat")
  var cat3 = Pet(name: "Cat3", type: "Cat")
  var cat4 = Pet(name: "ACat4", type: "Cat")
  var cat5 = Pet(name: "ZCat5", type: "Cat")
  
  override func setUp() {
    super.setUp()
    url = URL(string: "http://test.com")!
    mockSession = MockURLSession()
  }
  
  override func tearDown() {
    url = nil
    mockSession = nil
    people = nil
    peopleData = nil
    super.tearDown()
  }
  
  func testCatsByOwnerGenderGrouping() {
    people = [
      Person(name: "Person1",
             gender: .Male,
             pets: [fish1, cat1]),
      Person(name: "Person2",
             gender: .Female,
             pets: [dog1, cat2]),
      ]
    peopleData = try! JSONEncoder().encode(people)
    mockSession.responses[url] = (peopleData,
                                  URLResponse(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil),
                                  nil)
    
    let expectation = XCTestExpectation(description: "Cats are grouped by owner gender")
    let expectedData: [Gender: [Pet]] = [.Male: [cat1], .Female: [cat2]]
    Person.catPeopleByGender(url: url, session: mockSession)
      .take(first: 1)
      .observe(on: UIScheduler())
      .startWithResult { result in
        if let error = result.error {
          XCTFail("Unexpected error: \(error)")
        } else if let value = result.value {
          XCTAssertEqual(value, expectedData)
          expectation.fulfill()
        } else {
          XCTFail("No data received")
        }
    }
    wait(for: [expectation], timeout: 1)
  }
  
  func testCatsByOwnerSkipsEmptySets() {
    people = [
      Person(name: "Person1",
             gender: .Male,
             pets: [fish1, cat1, cat2]),
      Person(name: "Person2",
             gender: .Female,
             pets: [dog1, fish1]),
    ]
    peopleData = try! JSONEncoder().encode(people)
    mockSession.responses[url] = (peopleData,
                                  URLResponse(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil),
                                  nil)
    
    let expectation = XCTestExpectation(description: "Cats are grouped by owner gender")
    let expectedData: [Gender: [Pet]] = [.Male: [cat1, cat2]]
    Person.catPeopleByGender(url: url, session: mockSession)
      .take(first: 1)
      .observe(on: UIScheduler())
      .startWithResult { result in
        if let error = result.error {
          XCTFail("Unexpected error: \(error)")
        } else if let value = result.value {
          XCTAssertEqual(value, expectedData)
          expectation.fulfill()
        } else {
          XCTFail("No data received")
        }
    }
    wait(for: [expectation], timeout: 1)
  }

  func testCatsByOwnerSortsCats() {
    people = [
      Person(name: "Person1",
             gender: .Male,
             pets: [cat2, cat1, fish1, cat3]),
      Person(name: "Person2",
             gender: .Female,
             pets: [dog1, cat5, fish1, cat4]),
    ]
    peopleData = try! JSONEncoder().encode(people)
    mockSession.responses[url] = (peopleData,
                                  URLResponse(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil),
                                  nil)
    
    let expectation = XCTestExpectation(description: "Cats are grouped by owner gender")
    let expectedData: [Gender: [Pet]] = [.Male: [cat1, cat2, cat3], .Female: [cat4, cat5]]
    Person.catPeopleByGender(url: url, session: mockSession)
      .take(first: 1)
      .observe(on: UIScheduler())
      .startWithResult { result in
        if let error = result.error {
          XCTFail("Unexpected error: \(error)")
        } else if let value = result.value {
          XCTAssertEqual(value, expectedData)
          expectation.fulfill()
        } else {
          XCTFail("No data received")
        }
    }
    wait(for: [expectation], timeout: 1)
  }

}
