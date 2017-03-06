//
//  Twitter.swift
//  HandyTwitter
//
//  Created by Phong on 2/3/17.
//  Copyright © 2017 Phong. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: Date?
    var timeSinceCreated: String?
    var fullCreatedAtString: String?
    
    var retweetCount = 0
    var favCount = 0
    var id: String?
    var favorited: Bool?
    var retweeted: Bool?
    
    var isRetweeted: Bool?
    var retweetedBy: String?
    
    init(dictionary: NSDictionary) {
        
        var originalDictionary = dictionary
        let retweetDictionary = dictionary["retweeted_status"] as? NSDictionary
        if let retweetDictionary = retweetDictionary {
            originalDictionary = retweetDictionary
            isRetweeted = true
            
            let retweetedUser = User(dictionary: dictionary["user"] as! NSDictionary)
            retweetedBy = retweetedUser.screenName
        }
        
        user = User(dictionary: originalDictionary["user"] as! NSDictionary)
        text = originalDictionary["text"] as? String
        createdAtString = originalDictionary["created_at"] as? String
        retweetCount = (originalDictionary["retweet_count"] as? Int)!
        favCount = (originalDictionary["favorite_count"] as? Int)!
        favorited = (originalDictionary["favorited"] as? Bool)!
        retweeted = (originalDictionary["retweeted"] as? Bool)!
        id = originalDictionary["id_str"] as? String
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.date(from: createdAtString!)
        
        formatter.dateFormat = "dd/MM/yy"
        let shortCreatedAt = formatter.string(from: createdAt!)
        
        formatter.dateFormat = "dd/MM/yy HH:mm:ss"
        fullCreatedAtString = formatter.string(from: createdAt!)
        
        let elapsedTime = Date().timeIntervalSince(createdAt!)
        if elapsedTime < 60 {
            timeSinceCreated = String(Int(elapsedTime)) + "s"
        } else if elapsedTime < 3600 {
            timeSinceCreated = String(Int(elapsedTime / 60)) + "m"
        } else if elapsedTime < 24*3600 {
            timeSinceCreated = String(Int(elapsedTime / 60 / 60)) + "h"
        } else {
            //if(elapsedTime > 24*3600*2){
                timeSinceCreated = shortCreatedAt
//            }
//            else{
//                timeSinceCreated = String(Int(elapsedTime / 60 / 60 / 24)) + "d"
//            }
        }
        
    }
    
    class func tweetsWithArray(_ array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dict in array {
            tweets.append(Tweet(dictionary: dict))
        }
        return tweets
    }
}

