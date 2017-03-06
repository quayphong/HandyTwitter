//
//  User.swift
//  HandyTwitter
//
//  Created by Phong on 2/3/17.
//  Copyright © 2017 Phong. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var screenName: String?
    var profileImageUrl: URL?
    var tagline: String?
    var dictionary: NSDictionary
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        tagline = dictionary["description"] as? String
        
        let profileImageURLString = dictionary["profile_image_url_https"] as? String
        if let profileImageURLString = profileImageURLString {
            profileImageUrl = URL(string: profileImageURLString)!
        }
    }
    static let userDidLogoutNotification = "UserDidLogout"
    static var _currentUser: User?
    class var currentUser: User?{
        get{
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.value(forKey:"currentUserData") as? Data
                if let userData = userData {
                    let dictionary = try? JSONSerialization.jsonObject(with: userData, options: []) as? NSDictionary
                    if let dictionary = dictionary {
                        _currentUser = User(dictionary: dictionary!)
                    }else{
                        _currentUser = nil
                    }
                }
            }
            
            return _currentUser
        }
        set(user){
            _currentUser = user
            
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary, options: [])
                defaults.set(data, forKey: "currentUserData")
            }
            else{
                defaults.set(nil, forKey: "currentUserData")
            }
            
            defaults.synchronize()
            
        }
    }
}
