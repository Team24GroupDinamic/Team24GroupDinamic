//
//  Stored.swift
//  CheckInApp
//
//  Created by Тимур on 11/02/2019.
//  Copyright © 2019 Тимур. All rights reserved.
//

import CoreData

protocol IStored {
    associatedtype DBModel: NSManagedObject
    init(dbModel: DBModel)
    static func createAssociatedModelFrom(dbModel: DBModel) -> Self
    func dataBaseModel(in context: NSManagedObjectContext)
}
