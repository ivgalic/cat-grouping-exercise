//
//  CatGrouping.swift
//  Cat Grouping Coding Exercise
//
//  Created by Ivan Galic on 11/6/18.
//  Copyright © 2018 Ivan Galic. All rights reserved.
//

import Foundation
import ReactiveSwift

struct CatGrouping {
  static let endpoint = URL(string: "http://agl-developer-test.azurewebsites.net/people.json")!
  typealias Grouping = [Gender: [Pet]]
  static func catPeopleByGender(url: URL = endpoint, session: URLSession = URLSession.shared) -> SignalProducer<Grouping, NSError> {
    let peopleProducer: SignalProducer<[Person], NSError> = url.makeRequest(session: session)
    return peopleProducer
      .take(first: 1)
      .observe(on: UIScheduler())
      .map { (people: [Person]) -> Grouping in
        let result: Grouping = [:]
        return people
          .reduce(into: result) { (acc, person) in
            let allPets = person.pets?.filter { $0.type.lowercased() == "cat" }
            guard let pets = allPets, pets.count > 0 else { return }
            acc[person.gender] = acc[person.gender] ?? []
            acc[person.gender]?.append(contentsOf: pets)
          }
          .mapValues { (pets) -> [Pet] in
            pets.sorted(by: { $0.name < $1.name })
        }
    }
  }
}
