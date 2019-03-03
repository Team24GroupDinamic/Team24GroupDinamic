//
//  Locator+Services.swift
//  CheckInApp
//
//  Created by Тимур on 23/02/2019.
//  Copyright © 2019 Тимур. All rights reserved.
//

import Foundation

extension Locator {
    func userService() -> IUserService {
        return UserService()
    }

    func aircompanyService() -> IAircompanyService {
        return AircompanySerivce()
    }
}
