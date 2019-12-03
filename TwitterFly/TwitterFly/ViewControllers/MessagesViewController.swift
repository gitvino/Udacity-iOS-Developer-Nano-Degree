//
//  MessagesViewController.swift
//  TwitterFly
//
//  Created by Vinoth on 26/7/18.
//  Copyright © 2018 Vinoth. All rights reserved.
//

import UIKit
import SDWebImage

class MessagesViewController: BaseViewController {

    @IBOutlet weak var messageTableView: UITableView!
    var messageDataSource: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Messages"
        
        //1. Setup Table View
        self.setupTableView()
        
        }
    override func viewWillAppear(_ animated: Bool) {
        MessageManager.shared.getMessages(successHandler: { (messages) in
            
            self.messageDataSource = messages
            DispatchQueue.main.async {
                self.messageTableView.reloadData()
            }
            
        }) { (error) in
            self.displayError(error: error)
        }

    }

    func setupTableView() -> Void {
        messageTableView.dataSource = self
        messageTableView.delegate = self
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "MessageCell")
        messageTableView.estimatedRowHeight = 300
        
    }
}

extension MessagesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as! MessageCell
        cell.senderScreenName.text = messageDataSource[indexPath.row].senderScreenName
        cell.senderUserName.text = messageDataSource[indexPath.row].senderUserName
        cell.messageText.text = messageDataSource[indexPath.row].messageData
        cell.senderImage.sd_setImage(with: URL(string: messageDataSource[indexPath.row].senderImageURL)!, completed: nil	)
        return cell
        
    }
    
}
extension MessagesViewController: UITableViewDelegate {
    
}
