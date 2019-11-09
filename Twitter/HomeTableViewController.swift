//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Tai Smith on 10/30/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    var tweetArray = [NSDictionary]()
    var numberofTweet: Int!
    
    let myRefreshControl = UIRefreshControl()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberofTweet = 20
        myRefreshControl.addTarget(self, action: #selector(loadTweet), for: .valueChanged)
        self.tableView.refreshControl = myRefreshControl
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 150
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         self.loadTweet()
    }
    
    @objc func loadTweet(){
        
        let myURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParam = ["count": numberofTweet]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myURL, parameters: myParam, success: { (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
                self.tableView.reloadData()
                self.myRefreshControl.endRefreshing()
            
        }, failure: { (Error) in
            print("Could not retrieve tweets!")
        })
        
    }
    
    func loadMoreTweets(){
        let myURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberofTweet = numberofTweet + 20
        let myParam = ["count": numberofTweet]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myURL, parameters: myParam, success: { (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
            
        }, failure: { (Error) in
            print("Could not retrieve tweets!")
        })
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        cell.usernameLabel.text = user["name"] as? String
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        
        let imageURL = URL(string: (user["profile_image_url_https"] as? String)!)
        let data =  try? Data(contentsOf: imageURL!)
        
        if let imageData = data {
            cell.profileimageView.image = UIImage(data: imageData)
            
        }
        
        cell.setFavorite(tweetArray[indexPath.row]["favorited"] as! Bool)
        cell.tweetId = (tweetArray[indexPath.row]["id"] as! Int)
        cell.setRetweeted(tweetArray[indexPath.row]["retweeted"] as! Bool)
        
        return cell
    }
    
    
    
    @IBAction func onLogout(_ sender: Any) {
    TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userloggedIn")
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }

   
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count{
            loadMoreTweets()
        }
    
    }


   
 
}
