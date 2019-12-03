//
//  DraftsViewController.swift
//  TwitterFly
//
//  Created by Vinoth on 4/9/18.
//  Copyright © 2018 Vinoth. All rights reserved.
//

import UIKit

protocol DraftsViewDelegate {
    func didSelectDraft(selectedDraft draftString: String) -> Void
}
class DraftsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var delegate: DraftsViewDelegate?
    let databaseInstance = DatabaseManager.sharedInstance
    var dataSource: [TweetDraft] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = databaseInstance.readTweetDrafts()
        tableView.dataSource = self
        tableView.delegate  = self

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = dataSource[indexPath.row].tweetText
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tweetString = dataSource[indexPath.row].tweetText
        self.delegate!.didSelectDraft(selectedDraft: tweetString!)
        self.dismiss(animated: true, completion: nil)
    }


    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
