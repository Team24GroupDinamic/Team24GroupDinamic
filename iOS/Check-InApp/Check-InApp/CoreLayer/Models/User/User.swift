//
//  User.swift
//  CheckInApp
//
//  Created by Тимур on 16/02/2019.
//  Copyright © 2019 Тимур. All rights reserved.
//

import CoreData

struct User: IStored {

    typealias DBModel = DBUser

    let surname: String
    let date: String

    init(surname: String, date: String) {
        self.surname = surname
        self.date = date
    }

    init(dbModel: DBUser) {
        surname = dbModel.surname
        date = dbModel.date
    }

    func dataBaseModel(in context: NSManagedObjectContext) {
        context.performAndWait {
            guard let dbUser = NSEntityDescription.insertNewObject(forEntityName: "DB\(type(of: self))",
                into: context) as? DBUser else { fatalError("Can't cast to DBUser") }
            dbUser.surname = surname
            dbUser.date = date
        }
    }

    static func createAssociatedModelFrom(dbModel: DBUser) -> User {
        return User(surname: dbModel.surname, date: dbModel.date)
    }
}
