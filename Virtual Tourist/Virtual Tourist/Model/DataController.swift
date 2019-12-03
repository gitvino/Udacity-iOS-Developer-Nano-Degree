//
//  DataController.swift
//  Virtual Tourist
//
//  Created by Vinoth kumar on 3/5/18.
//  Copyright © 2018 Vinoth kumar. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion:(() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { (storeDescripton, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
}
