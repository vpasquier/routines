//
//  Topic.swift
//  routines
//
//  Created by V on 5/31/20.
//  Copyright © 2020 V. All rights reserved.
//

import SwiftUI
import CoreLocation

struct Topic: Hashable, Codable, Identifiable {
    var id = UUID()
    var name: String
    var count: Int
}
