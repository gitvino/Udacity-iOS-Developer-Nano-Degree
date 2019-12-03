//
//  DatabaseManager.swift
//  TwitterFly
//
//  Created by Vinoth on 5/9/18.
//  Copyright © 2018 Vinoth. All rights reserved.
//

import Foundation
import Foundation
import CoreData

class DatabaseManager  {
    static let sharedInstance = DatabaseManager()
    var dataController: DataController?
    
    private init() {
    }
    
    func saveTweetDraft(tweetText: String) -> Void {
        let tweetDraftObject = TweetDraft(context: (dataController?.viewContext)!)
        tweetDraftObject.tweetText = tweetText
        try? dataController?.viewContext.save()
        
    }
    func readTweetDrafts() -> [TweetDraft] {
        var tweetDrafts: [TweetDraft] = []
        let tweetDraftRequest: NSFetchRequest<TweetDraft> = TweetDraft.fetchRequest()
        if let result = try? dataController!.viewContext.fetch(tweetDraftRequest) {
            tweetDrafts = result
        }
        return tweetDrafts
        
        
    }
}
