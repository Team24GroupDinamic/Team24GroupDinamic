//
//  CoreAssembly.swift
//  CheckInApp
//
//  Created by Тимур on 05/01/2019.
//  Copyright © 2019 Тимур. All rights reserved.
//

protocol ICoreAssembly {
    var coreDataStack: IStorage { get }
}

class CoreAssembly: ICoreAssembly {
    lazy var coreDataStack: IStorage = Storage()
}
