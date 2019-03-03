//
//  DBUser.swift
//  CheckInApp
//
//  Created by Тимур on 16/02/2019.
//  Copyright © 2019 Тимур. All rights reserved.
//

import CoreData

class DBUser: NSManagedObject {
    @NSManaged var date: String
    @NSManaged var surname: String
}
