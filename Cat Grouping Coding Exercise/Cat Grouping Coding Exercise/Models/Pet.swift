//
//  Pet.swift
//  Cat Grouping Coding Exercise
//
//  Created by Ivan Galic on 11/6/18.
//  Copyright © 2018 Ivan Galic. All rights reserved.
//

import Foundation

struct Pet: Codable, Equatable {
  let name: String
  let type: String // Normally, this would be an enum, but using string here because the service doesn't specify possible pet types
}
