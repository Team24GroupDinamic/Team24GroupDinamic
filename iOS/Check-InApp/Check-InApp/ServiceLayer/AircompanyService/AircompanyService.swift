//
//  AircompanyService.swift
//  CheckInApp
//
//  Created by Тимур on 20/02/2019.
//  Copyright © 2019 Тимур. All rights reserved.
//

import Foundation

protocol IAircompanyService {
    func loadServices(completion: @escaping (Result<AircompanyContainer>) -> Void)
}

class AircompanySerivce: IAircompanyService {

    let storage = Locator.shared.storage
    let requestManager = Locator.shared.requestManager()

    func  loadServices(completion: @escaping (Result<AircompanyContainer>) -> Void) {
        let airRequest = AircompanyRequest()
        requestManager.loadModel(request: airRequest, completion: completion)
    }
}
