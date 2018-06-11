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
  let pets: [Pet]?
}

