//
//  TweetCell.swift
//  HandyTwitter
//
//  Created by Phong on 4/3/17.
//  Copyright © 2017 Phong. All rights reserved.
//

import UIKit
import AFNetworking

class TweetCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var retweetImage: UIImageView!
    
    @IBOutlet weak var retweetIcon: UIImageView!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteIcon: UIImageView!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    @IBOutlet weak var profileImgTopConstraint: NSLayoutConstraint!
    
    var tweet: Tweet! {
        didSet{
            if tweet.user?.profileImageUrl != nil {
                profileImage.setImageWith((tweet.user?.profileImageUrl!)!)
            }
            userNameLabel.text = tweet.user?.name
            screenNameLabel.text = "@\(tweet.user!.screenName!)"
            timeStampLabel.text = tweet.timeSinceCreated
            tweetTextLabel.text = tweet.text
            
            retweetCountLabel.text = String(tweet.retweetCount)
            favoriteCountLabel.text = String(tweet.favCount)
            
            if tweet.favorited != nil && tweet.favorited == true{
                favoriteIcon.image = UIImage(named: "like_on")
            }
            else{
                favoriteIcon.image = UIImage(named: "like_off")
            }
            
            if tweet.retweeted != nil && tweet.retweeted == true{
                retweetIcon.image = UIImage(named: "retweet_on")
            }else{
                retweetIcon.image = UIImage(named: "retweet_off")
            }
            
            if tweet.isRetweeted != nil && tweet.isRetweeted == true {
                retweetLabel.text = "\(tweet.retweetedBy!) retweeted"
                retweetImage.isHidden = false
                profileImgTopConstraint.constant = 28
            }
            else{
                retweetLabel.text = ""
                retweetImage.isHidden = true
                profileImgTopConstraint.constant = 8
                //self.view.layoutIfNeeded()
            }
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
