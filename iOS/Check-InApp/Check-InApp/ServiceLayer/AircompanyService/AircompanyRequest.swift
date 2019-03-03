//
//  AircompanyRequest.swift
//  CheckInApp
//
//  Created by Тимур on 20/02/2019.
//  Copyright © 2019 Тимур. All rights reserved.
//

import Foundation

class AircompanyRequest: BaseRequest, IModelRequest {
    typealias Model = AircompanyContainer

    override func service() -> String {
        return "/getcompanies"
    }
}
