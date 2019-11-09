//
//  TweetCellTableViewCell.swift
//  Twitter
//
//  Created by Tai Smith on 10/31/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class TweetCellTableViewCell: UITableViewCell {

    @IBOutlet weak var profileimageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var rtButton: UIButton!
    
    @IBOutlet weak var favButton: UIButton!
    var favorite:Bool = false
    var tweetId:Int = -1
    
    
    
    
    
    @IBAction func favoriteTweet(_ sender: Any) {
        let tobeFav = !favorite
        if(tobeFav) {
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
                self.setFavorite(true)
            }, failure: { (error) in
             print("Favorite did not succeed: \(error)")
        })
        } else {
            TwitterAPICaller.client?.unfavoriteTweet(tweetId: tweetId, success: {
                 self.setFavorite(false)
            }, failure: { (error) in
                print("Unfavorite did not succeed: \(error)")
            })
        }
}
    
    @IBAction func retweetButton(_ sender: Any) {
        TwitterAPICaller.client?.retweetTweet(tweetId: tweetId, success:{
            self.setRetweeted(true)
        }, failure: { (error) in
            print("Error while retweeting \(error)")
        })
    }
    
    func setRetweeted(_ isRetweeted:Bool){
        if(isRetweeted){
            rtButton.setImage(UIImage(named: "retweet-icon-green"), for:
            UIControl.State.normal)
            rtButton.isEnabled = false
        } else{
            rtButton.setImage(UIImage(named: "retweet-icon"), for:
                UIControl.State.normal)
            rtButton.isEnabled = true
        }
    }
    
    func setFavorite(_ isFavorited:Bool){
        favorite = isFavorited
        if(favorite) {
            favButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
        } else {
            favButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
