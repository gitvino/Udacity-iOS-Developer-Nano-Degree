//
//  HomeViewController.swift
//  TwitterFly
//
//  Created by Vinoth on 26/7/18.
//  Copyright © 2018 Vinoth. All rights reserved.
//

import UIKit
import SDWebImage

class HomeViewController: BaseViewController, UITextViewDelegate {

    @IBOutlet weak var tweetsTableView: UITableView!
    var tweetsDatasource: [Tweet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Home"
        //1. Setup Table View
        self.setupTableView()

    }
    override func viewWillAppear(_ animated: Bool) {
        //2. Get Tweets
        
        TimelineManager.shared.getHomeTimelineTweets(successHandler: { (tweets) in
            self.tweetsDatasource = tweets
         DispatchQueue.main.async {
             self.tweetsTableView.reloadData()
            }
        }) { (error) in
            self.displayError(error: error)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTableView() -> Void {
        tweetsTableView.dataSource = self
        tweetsTableView.delegate = self
        tweetsTableView.register(UINib(nibName: "TweetCell", bundle: nil), forCellReuseIdentifier: "TweetCell")
        tweetsTableView.estimatedRowHeight = 100
       
    }
    
}
extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetsDatasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //1. Dequeue Table View Cell
        let tweetCell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        //2. Set User Name, Display name, Image URL
        let userName = tweetsDatasource[indexPath.row].twitterUser.userName
        let displayName = "@\(tweetsDatasource[indexPath.row].twitterUser.userScreenName)"
        let imageURL = URL(string: tweetsDatasource[indexPath.row].twitterUser.userProfileImageUrl!)
        
        tweetCell.userName.text = userName
        tweetCell.displayName.text = displayName
        tweetCell.userImage.sd_setImage(with: imageURL, completed: nil)
        
        //3. Prepare the tweet Text
        let attributedTweetText = NSMutableAttributedString(string: tweetsDatasource[indexPath.row].text)
        
        //3.1 Add User Mentions
        let userMentions = tweetsDatasource[indexPath.row].entities.userMentions!
        let hashtags = tweetsDatasource[indexPath.row].entities.hashtags!
        let urlsInTweet = tweetsDatasource[indexPath.row].entities.urlsInTweet!
        
      
        for eachUserMention in userMentions {
            attributedTweetText.addAttribute(NSAttributedStringKey.link,
                                             value: "TwitterFly://OpenProfile/\(eachUserMention.screenName)",
                range: NSRange(location: eachUserMention.indices[0].startIndex,
                               length: eachUserMention.indices[0].endIndex - eachUserMention.indices[0].startIndex))
           
        }
        
        for eachHashtag in hashtags {
            attributedTweetText.addAttribute(NSAttributedStringKey.link,
                                             value: "TwitterFly://OpenHashtag/\(eachHashtag.text)",
                range: NSRange(location: eachHashtag.indices[0].startIndex,
                               length: eachHashtag.indices[0].endIndex - eachHashtag.indices[0].startIndex))
        }
        
        for eachUrlsInTweet in urlsInTweet {
            attributedTweetText.addAttribute(NSAttributedStringKey.link,
                                             value: eachUrlsInTweet.shortenUrl,
                                             range: NSRange(location: eachUrlsInTweet.indices[0].startIndex,
                                                            length: eachUrlsInTweet.indices[0].endIndex - eachUrlsInTweet.indices[0].startIndex))
        }
        
        attributedTweetText.addAttribute(NSAttributedStringKey.font,
                                         value: UIFont(name: "Helvetica Neue", size: 16) as Any,
                                         range: NSRange(location: 0, length: attributedTweetText.length))

        
        tweetCell.tweetTextView.attributedText = attributedTweetText
        let boundingBox =  attributedTweetText.boundingRect(with: CGSize(width: UIScreen.main.bounds.width - 108, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        tweetCell.tweetTextViewHeightConstraint.constant = boundingBox.height + 5
       tweetCell.tweetTextView.delegate = self
        
        return tweetCell
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        print(URL)
        return false
    }

    
}


extension HomeViewController: UITableViewDelegate {
    
}
