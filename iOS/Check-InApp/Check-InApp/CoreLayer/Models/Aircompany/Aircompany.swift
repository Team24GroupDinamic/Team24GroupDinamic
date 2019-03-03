//
//  Aircompany.swift
//  CheckInApp
//
//  Created by Тимур on 17/01/2019.
//  Copyright © 2019 Тимур. All rights reserved.
//

import Foundation

struct Aircompany: Codable {
    var name: String
    var id: String
    var logoURL: String
}

struct AircompanyContainer: Codable {
    var aircompanies: [Aircompany]
}
