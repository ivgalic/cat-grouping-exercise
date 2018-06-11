//
//  Person.swift
//  Cat Grouping Coding Exercise
//
//  Created by Ivan Galic on 11/6/18.
//  Copyright © 2018 Ivan Galic. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift


enum Gender: String, Codable {
  case Male
  case Female
  
  static var all: [Gender] {
    return [.Male, .Female]
  }
}

struct Person: Codable, Equatable {
  let name: String
  let gender: Gender
  let pets: [Pet]
}

extension Person {
  static func catPeopleByGender(url: URL, session: URLSession = URLSession.shared) -> SignalProducer<[Gender: [Pet]], NSError> {
    let peopleProducer: SignalProducer<[Person], NSError> = url.makeRequest(session: session)
    return peopleProducer
      .take(first: 1)
      .observe(on: UIScheduler())
      .map { (people: [Person]) -> [Gender: [Pet]] in
        let result: [Gender: [Pet]] = [:]
        return people
          .reduce(into: result) { (acc, person) in
            let allPets = person.pets.filter { $0.type.lowercased() == "cat" }
            guard allPets.count > 0 else { return }
            acc[person.gender] = acc[person.gender] ?? []
            acc[person.gender]?.append(contentsOf: allPets)
          }
          .mapValues { (pets) -> [Pet] in
            pets.sorted(by: { $0.name < $1.name })
          }
      }
  }
}
