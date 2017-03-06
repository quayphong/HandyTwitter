//
//  TwitterClient.swift
//  HandyTwitter
//
//  Created by Phong on 2/3/17.
//  Copyright © 2017 Phong. All rights reserved.
//

import UIKit
import BDBOAuth1Manager


let baseUrl = URL(string: "https://api.twitter.com/")
let consumerKey = "dZXJRS9iwMUBqReaxZQBp5Kbi" //"oecUuV0VSomXkKoLlRysUBx9f"
let consumerSecret = "JBEI0P2EColGb4GiXTKz146p3frw8BeRhREE0tNSYFAHjP2k7E" //"YREG9x6YL93WhrSIyxWK9fSzkoV0gYeMZGnFDrbsB1LaBZBXdm"

class TwitterClient: BDBOAuth1SessionManager {
    static var sharedInstance = TwitterClient(baseURL: baseUrl, consumerKey: consumerKey, consumerSecret: consumerSecret)
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()){
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance?.deauthorize()
        
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "POST", callbackURL: URL(string: "handytwitter2017://"), scope: nil, success: { (response: BDBOAuth1Credential?) in
            
            if let response = response {
                let authURL = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(response.token!)")
                UIApplication.shared.open(authURL!, options: [:], completionHandler: nil)
            }
            
        }, failure: { (error: Error?) in
            print("\(error?.localizedDescription)")
            self.loginFailure?(error!)
        })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        // Define identifier
        let notificationName = Notification.Name(User.userDidLogoutNotification)
        
        // Post notification
        NotificationCenter.default.post(name: notificationName, object: nil)
        
        // Register to receive notification
        //NotificationCenter.default.addObserver(self, selector: #selector(YourClassName.methodOfReceivedNotification), name: notificationName, object: nil)
        
        
        
        // Stop listening notification
        //NotificationCenter.default.removeObserver(self, name: notificationName, object: nil);

    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (response: BDBOAuth1Credential?) in
            self.getUserInfo(success: { (user: User) ->() in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error:Error) -> () in
                self.loginFailure?(error)
            })
        }, failure: { (error: Error?) in
            print("\(error?.localizedDescription)")
            self.loginFailure?(error!)
        })
    }
    
    func getUserInfo(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        _ = get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (_: URLSessionDataTask, response: Any?) in
            if let response = response  {
                let user = User(dictionary: response as! NSDictionary)
                success(user)
                print(user.name!)
                print(user.screenName!)
                print(user.profileImageUrl!)
            }
            
        }, failure: { (_: URLSessionDataTask?, error: Error) in
            print("\(error.localizedDescription)")
            failure(error)
        })
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        _ = get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (_: URLSessionDataTask, response: Any?) in
            if let response = response  {
                let dictionaries = response as! [NSDictionary]
                let tweets = Tweet.tweetsWithArray(dictionaries)
                success(tweets)
            }
            
        }, failure: { (_: URLSessionDataTask?, error: Error) in
            failure(error)
            print("\(error.localizedDescription)")
        })
    }
    
    func updateStatus(status: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        var parameter = [String: String]()
        parameter["status"] = status
        
        _ = post("1.1/statuses/update.json", parameters: parameter, progress: nil, success: { (_: URLSessionDataTask, response: Any?) in
            success()
        }) { (_: URLSessionDataTask?, error: Error) in
            failure(error)
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func replyStatus(originalId: String, status: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        var parameter = [String: String]()
        parameter["in_reply_to_status_id"] = originalId
        parameter["status"] = status
        
        _ = post("1.1/statuses/update.json", parameters: parameter, progress: nil, success: { (_: URLSessionDataTask, response: Any?) in
            success()
        }) { (_: URLSessionDataTask?, error: Error) in
            failure(error)
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func createFavorite(id: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        var parameter = [String: String]()
        parameter["id"] = id
        
        _ = post("1.1/favorites/create.json", parameters: parameter, progress: nil, success: { (_: URLSessionDataTask, response: Any?) in
            if let response = response  {
                let dictionary = response as! NSDictionary
                let tweet = Tweet(dictionary: dictionary)
                success(tweet)
            }
        }) { (_: URLSessionDataTask?, error: Error) in
            failure(error)
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func destroyFavorite(id: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        var parameter = [String: String]()
        parameter["id"] = id
        
        _ = post("1.1/favorites/destroy.json", parameters: parameter, progress: nil, success: { (_: URLSessionDataTask, response: Any?) in
            if let response = response  {
                let dictionary = response as! NSDictionary
                let tweet = Tweet(dictionary: dictionary)
                success(tweet)
            }
        }) { (_: URLSessionDataTask?, error: Error) in
            failure(error)
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func createRetweet(id: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        let url = "1.1/statuses/retweet/\(id).json"
        _ = post(url, parameters: nil, progress: nil, success: { (_: URLSessionDataTask, response: Any?) in
            if let response = response  {
                let dictionary = response as! NSDictionary
                let tweet = Tweet(dictionary: dictionary)
                success(tweet)
            }
        }) { (_: URLSessionDataTask?, error: Error) in
            failure(error)
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func destroyRetweet(id: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        let url = "1.1/statuses/unretweet/\(id).json"
        _ = post(url, parameters: nil, progress: nil, success: { (_: URLSessionDataTask, response: Any?) in
            if let response = response  {
                let dictionary = response as! NSDictionary
                let tweet = Tweet(dictionary: dictionary)
                success(tweet)
            }
        }) { (_: URLSessionDataTask?, error: Error) in
            failure(error)
            print("Error: \(error.localizedDescription)")
        }
    }

}
