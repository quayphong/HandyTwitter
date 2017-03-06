//
//  DetailTweetViewController.swift
//  HandyTwitter
//
//  Created by Phong on 5/3/17.
//  Copyright © 2017 Phong. All rights reserved.
//

import UIKit

class DetailTweetViewController: UIViewController {

    var tweet : Tweet!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if tweet.user?.profileImageUrl != nil {
            userImage.setImageWith((tweet.user?.profileImageUrl!)!)
        }
        nameLabel.text = tweet.user?.name
        screenNameLabel.text = "@\(tweet.user!.screenName!)"
        dateLabel.text = tweet.fullCreatedAtString
        tweetLabel.text = tweet.text
        retweetCountLabel.text = String(tweet.retweetCount)
        favoriteCountLabel.text = String(tweet.favCount)
        
        if tweet.favorited != nil && tweet.favorited == true{
            favoriteButton.setImage(UIImage(named: "like_on"), for: UIControlState.normal)
        }
        
        if tweet.retweeted != nil && tweet.retweeted == true{
            retweetButton.setImage(UIImage(named: "retweet_on"), for: UIControlState.normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onReply(_ sender: UIButton) {
        
    }
    @IBAction func onRetweet(_ sender: UIButton) {
        if tweet.retweeted == nil || tweet.retweeted == false {
            TwitterClient.sharedInstance?.createRetweet(id: tweet.id!, success: { (newTweet: Tweet) -> () in
                if newTweet.retweeted != nil && newTweet.retweeted == true{
                    self.tweet = newTweet
                    self.retweetButton.setImage(UIImage(named: "retweet_on"), for: UIControlState.normal)
                    self.retweetCountLabel.text = String(newTweet.retweetCount)
                }
            }, failure: { (error: Error) -> () in
                print("Error: \(error.localizedDescription)")
            })
        } else if tweet.retweeted != nil && tweet.retweeted == true {
            TwitterClient.sharedInstance?.destroyRetweet(id: tweet.id!, success: { (newTweet: Tweet) -> () in
                self.tweet.retweeted = false
                self.retweetButton.setImage(UIImage(named: "retweet_off"), for: UIControlState.normal)
                self.retweetCountLabel.text = String(newTweet.retweetCount-1)
            }, failure: { (error: Error) -> () in
                print("Error: \(error.localizedDescription)")
            })
        }

    }
    
    @IBAction func onFavorite(_ sender: UIButton) {
        if tweet.favorited == nil || tweet.favorited == false {
            TwitterClient.sharedInstance?.createFavorite(id: tweet.id!, success: { (newTweet: Tweet) -> () in
                if newTweet.favorited != nil && newTweet.favorited == true{
                    self.tweet = newTweet
                    self.favoriteButton.setImage(UIImage(named: "like_on"), for: UIControlState.normal)
                    self.favoriteCountLabel.text = String(newTweet.favCount)
                }
            }, failure: { (error: Error) -> () in
                print("Error: \(error.localizedDescription)")
            })
        } else if tweet.favorited != nil && tweet.favorited == true {
            TwitterClient.sharedInstance?.destroyFavorite(id: tweet.id!, success: { (newTweet: Tweet) -> () in
                if newTweet.favorited != nil && newTweet.favorited == false{
                    self.tweet = newTweet
                    self.favoriteButton.setImage(UIImage(named: "like_off"), for: UIControlState.normal)
                    self.favoriteCountLabel.text = String(newTweet.favCount)
                }
            }, failure: { (error: Error) -> () in
                print("Error: \(error.localizedDescription)")
            })
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
