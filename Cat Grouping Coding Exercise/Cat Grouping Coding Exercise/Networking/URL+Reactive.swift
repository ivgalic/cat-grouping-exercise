//
//  URL+Reactive.swift
//  Cat Grouping Coding Exercise
//
//  Created by Ivan Galic on 10/6/18.
//  Copyright © 2018 Ivan Galic. All rights reserved.
//

import ReactiveSwift


extension URL {
  func makeRequest<T: Decodable>(session: URLSession = URLSession.shared) -> SignalProducer<T, NSError> {
    return SignalProducer<T, NSError> { (observer, lifetime) in
      let dataTask = session.dataTask(with: self) { (data, response, error) in
        if let error = error {
            observer.send(error: error as NSError)
        } else if let data = data {
          let decoder = JSONDecoder()
          
          do {
            let result: T = try decoder.decode(T.self, from: data)
            observer.send(value: result)
            observer.sendCompleted()
          } catch {
            observer.send(error: error as NSError)
          }
        }
      }
      dataTask.resume()
    }
  }
}
