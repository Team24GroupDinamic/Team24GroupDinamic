//
//  CoreDataStack.swift
//  CheckInApp
//
//  Created by Тимур on 17/12/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import CoreData

typealias ComletionSaveHandler = (Error?) -> Void

protocol IStorage {

    /// Асинхронное сохранение
    func save(_ block: @escaping (_ localContext: NSManagedObjectContext) -> Void,
              completion: ((_ error: Error?) -> Void)?)

    /// Удаление всех сущностей из таблицы
    func removeAllObjects(ofEntity entity: String, in context: NSManagedObjectContext)

    /// Удаление всех сущностей из таблицы по предикату
    func removeAllObjects(ofEntity entity: String, with predicate: NSPredicate?, in context: NSManagedObjectContext)

    /// Запрос моделей
    func executeModels<DBModel: NSManagedObject>(predicate: NSPredicate?) -> [DBModel]
}

final class Storage: IStorage {

    private let storeURL: URL = {
        var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        url.appendPathComponent("UserModel.sqlite")
        return url
    }()

    private lazy var managedModel: NSManagedObjectModel = {
        guard let mom = Bundle.main.url(forResource: "UserModel",
                                        withExtension: "momd") else { fatalError("Can't get model url") }
        guard let model = NSManagedObjectModel(contentsOf: mom) else { fatalError("Can't get model by url \(mom)") }
        return model
    }()

    private lazy var persistanceStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedModel)
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil, at: storeURL, options: nil)
        } catch let error {
            assertionFailure("Error due try to add store at \(storeURL) with description \(error.localizedDescription)")
        }
        return coordinator
    }()

    private lazy var masterContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistanceStoreCoordinator
        context.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        context.undoManager = nil
        return context
    }()

    private lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = masterContext
        context.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        context.undoManager = nil
        return context
    }()

    private lazy var workerContext: NSManagedObjectContext = {
        let workerContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        workerContext.parent = mainContext
        workerContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        workerContext.undoManager = nil
        return workerContext
    }()

    private func performSave(with context: NSManagedObjectContext, completion: ComletionSaveHandler?) {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                completion?(error)
                return
            }
            guard let parent = context.parent else { completion?(nil); return }
            self.performSave(with: parent, completion: completion)
        }
        completion?(nil)
    }

    func contextFromCurrentThread() -> NSManagedObjectContext {
        if Thread.isMainThread {
            return mainContext
        }
        return workerContext
    }

    func save(_ block: @escaping (NSManagedObjectContext) -> Void, completion: ((Error?) -> Void)?) {
        let currentContext = contextFromCurrentThread()

        currentContext.perform {
            block(currentContext)
            self.performSave(with: currentContext, completion: completion)
        }
    }

    func removeAllObjects(ofEntity entity: String, in context: NSManagedObjectContext) {
        removeAllObjects(ofEntity: entity, with: nil, in: context)
    }

    func removeAllObjects(ofEntity entity: String, with predicate: NSPredicate?, in context: NSManagedObjectContext) {
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.predicate = predicate
        request.entity = NSEntityDescription.entity(forEntityName: entity, in: context)

        context.performAndWait {
            do {
                if let results = try context.fetch(request) as? [NSManagedObject] {
                    results.forEach { context.delete($0) }
                }
            } catch let error {
                fatalError("Cannot remove objects with error \(error.localizedDescription)")
            }
        }
    }

    func executeModels<DBModel: NSManagedObject>(predicate: NSPredicate? = nil) -> [DBModel] {
        let request: NSFetchRequest<DBModel> = NSFetchRequest<DBModel>(entityName: String(describing: DBModel.self))
        request.predicate = predicate
        print(String(describing: DBModel.self))
        var results = [DBModel]()
        do {
            results = try contextFromCurrentThread().fetch(request)
        } catch let error {
            print("Cannot fetchs objects with error \(error.localizedDescription)")
        }
        return results
    }
}
