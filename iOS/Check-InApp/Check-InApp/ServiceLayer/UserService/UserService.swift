//
//  UserService.swift
//  CheckInApp
//
//  Created by Тимур on 23/02/2019.
//  Copyright © 2019 Тимур. All rights reserved.
//

import Foundation
import CoreData

protocol IUserService {
    func saveUser(user: User)
    func loadUser(completion: @escaping (User?) -> Void)
}

class UserService: IUserService {
    private let storage = Locator.shared.storage

    func saveUser(user: User) {
        storage.save({ context in
            self.storage.removeAllObjects(ofEntity: String(describing: User.DBModel.self), in: context)
            user.dataBaseModel(in: context)
        }) { error in
            if let error = error {
                print("Error when save user: \(error.localizedDescription)")
            }
        }
    }

    func loadUser(completion: @escaping (User?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let usersResult: [DBUser] = self.storage.executeModels(predicate: nil)
            guard usersResult.count < 2 else { fatalError("Users count id data base more 1") }
            if let dbUser = usersResult.first {
                let user = User(dbModel: dbUser)
                completion(user)
            } else {
                completion(nil)
            }
        }
    }
}
