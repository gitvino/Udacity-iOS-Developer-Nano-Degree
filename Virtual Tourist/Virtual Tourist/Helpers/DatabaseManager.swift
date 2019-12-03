//
//  DatabaseManager.swift
//  Virtual Tourist
//
//  Created by Vinoth kumar on 28/5/18.
//  Copyright © 2018 Vinoth kumar. All rights reserved.
//

import Foundation
import CoreData

class DatabaseManager  {
    static let sharedInstance = DatabaseManager()
    var dataController: DataController?
    
    private init() {
        
    }
    
    // 1
    func saveImage(pin: Pin, photoUrl: String, imageData: Data) -> Void {
        let photoObject = Photo(context: (dataController?.viewContext)!)
        photoObject.imageData = imageData
        photoObject.imageURL = photoUrl
        photoObject.location = pin
        try? dataController?.viewContext.save()
    }
    
    // 2
    func retrieveImageFromURL(urlString: String) -> Data? {
        let photos = fetchPhotosFromDB(urlString: urlString )
        if !photos.isEmpty {
            return photos.first?.imageData
        } else {
            return nil
        }
    }
    // 3
    func fectchImageURLs(pin: Pin) -> [String] {
        var photoURLs: [String] = []
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Photo.fetchRequest()
        fetchRequest.propertiesToFetch = ["imageURL"]
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.predicate = NSPredicate(format: "location == %@", pin)
        if let result = try? dataController!.viewContext.fetch(fetchRequest) {
            for eachResult in result as! [[String: Any]] {
                photoURLs.append(eachResult["imageURL"]! as! String)
            }
        }
        return photoURLs
    }
    // 4
    func fetchPhotosFromDB(urlString: String) -> [Photo] {
        var photos: [Photo] = []
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "imageURL == %@", urlString)
        if let result = try? dataController!.viewContext.fetch(fetchRequest) {
            photos = result
        }
        return photos
        
    }
    // 5
    func deletePhotosFromDB(urlString: String) -> Void {
        let photosToDelete = fetchPhotosFromDB(urlString: urlString)
        for eachPhoto in photosToDelete {
            dataController?.viewContext.delete(eachPhoto)
        }
        do {
            try dataController?.viewContext.save()
        } catch {
            print(error)
        }
    }
    // 6
    func deleteAllPhotos(pin: Pin) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        deleteFetch.predicate = NSPredicate(format: "location == %@", pin)
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        deleteRequest.resultType = .resultTypeObjectIDs
        
        do {
            let result = try dataController!.viewContext.execute(deleteRequest) as? NSBatchDeleteResult
            let objectIDArray = result!.result as! [NSManagedObjectID]
            let changes = [NSDeletedObjectsKey : objectIDArray]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [dataController!.viewContext])
            do {
                dataController?.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
                try dataController?.viewContext.save()
                
            }
            catch {
                print("Error: \(error)")
                
            }
        } catch {
            print("Error: \(error)")
        }
    }

}
