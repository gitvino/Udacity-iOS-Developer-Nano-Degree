//
//  ProfileViewController.swift
//  TwitterFly
//
//  Created by Vinoth on 26/7/18.
//  Copyright © 2018 Vinoth. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileViewController: BaseViewController{

    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var profileDescription: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var dateJoined: UILabel!
    @IBOutlet weak var following: UILabel!
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var segmentControl: CustomSegmentedControl!
    
    
    var twitterUser: TwitterUser?
    var tweetsTableView: UITableView?
    var likesTableView: UITableView?
    
    var dataSource1: [Tweet]?
    var dataSource2: [Tweet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                // Do any additional setup after loading the view.
        
        tweetsTableView = UITableView(frame: CGRect(x: 0, y: segmentControl.frame.maxY+30, width: self.view.frame.width, height: view.frame.height), style: .plain)
        likesTableView = UITableView(frame: CGRect(x: 0, y: segmentControl.frame.maxY+30, width: self.view.frame.width, height: view.frame.height), style: .plain)
        
        tweetsTableView?.register(UINib(nibName: "TweetCell", bundle: nil), forCellReuseIdentifier: "TweetCell")
        
        tweetsTableView?.dataSource = self
        likesTableView?.dataSource = self
        
        self.view.addSubview(tweetsTableView!)
    }

    override func viewWillAppear(_ animated: Bool) {
        ProfileManager.shared.getUserDetails(successHandler: { (user) in
            self.twitterUser = user
            self.bannerImage.sd_setImage(with: URL(string:self.twitterUser!.userProfileBannerImageUrl!)!, completed: nil)
            self.profileImage.sd_setImage(with: URL(string:self.twitterUser!.userProfileImageUrl!)!, completed: nil)
            DispatchQueue.main.async {
                self.title = self.twitterUser!.userName
                self.profileDescription.text = self.twitterUser!.userDescription
                self.location.text = self.twitterUser!.userLocation
                self.userName.text = self.twitterUser!.userName
                self.screenName.text = self.twitterUser!.userScreenName
                let createdDateFormat = DateFormatter()
                createdDateFormat.dateFormat = "dd MMM YYYY"
                let createdDateString = createdDateFormat.string(from: self.twitterUser!.createdDate!)
                self.dateJoined.text = "Joined \(createdDateString)"
                
                self.followers.text = "\(self.twitterUser!.followersCount!) followers"
                self.following.text = "\(self.twitterUser!.followingCount!) following"
            }
            ProfileManager.shared.getuserTweets(successHandler: { (myTweets) in
                //print(myTweets)
                self.dataSource1 = myTweets
                 DispatchQueue.main.async {
                self.tweetsTableView?.reloadData()
                }
                
            }) { (error) in
                self.displayError(error: error)
            }
            ProfileManager.shared.getFavoriteTweets(successHandler: { (favoriteTweets) in
                self.dataSource2 = favoriteTweets
                DispatchQueue.main.async {
                    self.likesTableView?.reloadData()
                }
                
            }) { (error) in
                self.displayError(error: error)
            }

            
            
        }) { (error) in
            self.displayError(error: error)
        }
    }
    
    @IBAction func valueChanged(_ sender: CustomSegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            likesTableView?.removeFromSuperview()
            self.view.addSubview(tweetsTableView!)
        case 1:
            tweetsTableView?.removeFromSuperview()
            self.view.addSubview(likesTableView!)
        default:
            return
        }
    }
    

}
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension ProfileViewController: UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tweetsTableView {
           
            guard let cell = tweetsTableView?.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetCell? else{
                let cell = TweetCell()
                cell.userName.text = dataSource1![indexPath.row].twitterUser.userName
                cell.displayName.text = dataSource1![indexPath.row].twitterUser.userScreenName
                cell.tweetTextView.text = dataSource1![indexPath.row].text
                cell.userImage.sd_setImage(with: URL(string: (dataSource1![indexPath.row].twitterUser.userProfileImageUrl)!), placeholderImage: nil, options: SDWebImageOptions.highPriority, completed: nil)
                return cell
            }
            //cell = cell as! TweetCell
            cell.userName.text = dataSource1![indexPath.row].twitterUser.userName
            cell.displayName.text = dataSource1![indexPath.row].twitterUser.userScreenName
            cell.tweetTextView.text = dataSource1![indexPath.row].text
            cell.userImage.sd_setImage(with: URL(string: (dataSource1![indexPath.row].twitterUser.userProfileImageUrl)!), placeholderImage: nil, options: SDWebImageOptions.highPriority, completed: nil)
            return cell
        }
        else {
            guard let cell = tweetsTableView?.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetCell? else{
                let cell = TweetCell()
                cell.userName.text = dataSource2![indexPath.row].twitterUser.userName
                cell.displayName.text = dataSource2![indexPath.row].twitterUser.userScreenName
                cell.tweetTextView.text = dataSource2![indexPath.row].text
                cell.userImage.sd_setImage(with: URL(string: (dataSource1![indexPath.row].twitterUser.userProfileImageUrl)!), placeholderImage: nil, options: SDWebImageOptions.highPriority, completed: nil)
                return cell
            }
            //cell = cell as! TweetCell
            cell.userName.text = dataSource2![indexPath.row].twitterUser.userName
            cell.displayName.text = dataSource2![indexPath.row].twitterUser.userScreenName
            cell.tweetTextView.text = dataSource2![indexPath.row].text
            cell.userImage.sd_setImage(with: URL(string: (dataSource2![indexPath.row].twitterUser.userProfileImageUrl)!), placeholderImage: nil, options: SDWebImageOptions.highPriority, completed: nil)
            return cell
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tweetsTableView {
            guard let count = dataSource1?.count else {
                return 0
            }
            return  count
        }
        else {
            guard let count = dataSource2?.count else {
                return 0
            }
            return  count
        }
    }
}
