//
//  NetworkingMocks.swift
//  Cat Grouping Coding ExerciseTests
//
//  Created by Ivan Galic on 11/6/18.
//  Copyright © 2018 Ivan Galic. All rights reserved.
//

import Foundation

class MockURLSessionDataTask: URLSessionDataTask {
  typealias voidCompletionHandler = () -> ()
  var completionHandler: voidCompletionHandler? = nil
  
  override func resume() {
    completionHandler?()
  }
}

class MockURLSession: URLSession {
  var responses: [URL: (Data?, URLResponse?, Error?)] = [:]
  var tasks: [URL: MockURLSessionDataTask] = [:]
  override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
    if let tuple = responses[url] {
      let task = MockURLSessionDataTask()
      task.completionHandler = { completionHandler(tuple.0, tuple.1, tuple.2) }
      return task
    }
    // Not specified to be overridden
    return super.dataTask(with: url, completionHandler: completionHandler)
  }
}
