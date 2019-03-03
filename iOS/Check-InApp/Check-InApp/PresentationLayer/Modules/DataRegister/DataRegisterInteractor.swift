//
//  DataRegisterInteractor.swift
//  CheckInApp
//
//  Created by Тимур on 23/02/2019.
//  Copyright © 2019 Тимур. All rights reserved.
//

import Foundation

protocol IDataRegisterInteractor {
    func saveData(surname: String, date: String)
    func loadData(completion: @escaping (User?) -> Void)
}

class DataRegisterInteractor: IDataRegisterInteractor {

    let userService = Locator.shared.userService()

    func saveData(surname: String, date: String) {
        let user = User(surname: surname, date: date)
        userService.saveUser(user: user)
    }

    func loadData(completion: @escaping (User?) -> Void) {
        userService.loadUser { user in
            DispatchQueue.main.async {
                completion(user)
            }
        }
    }
}
