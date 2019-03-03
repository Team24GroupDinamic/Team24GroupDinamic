//
//  RegisterInteractor.swift
//  CheckInApp
//
//  Created by Тимур on 17/01/2019.
//  Copyright © 2019 Тимур. All rights reserved.
//

import Foundation

protocol IRegisterInteractor {
    func loadAircompanies(completion: @escaping (Result<AircompanyContainer>) -> Void)
}

class RegisterInteractor: IRegisterInteractor {
    let aircompanyService: IAircompanyService

    init(aircompanyService: IAircompanyService) {
        self.aircompanyService = aircompanyService
    }

    func loadAircompanies(completion: @escaping (Result<AircompanyContainer>) -> Void) {
        aircompanyService.loadServices { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
