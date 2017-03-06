//
//  TweetsViewController.swift
//  HandyTwitter
//
//  Created by Phong on 3/3/17.
//  Copyright © 2017 Phong. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {

    var tweets: [Tweet]!
    
    @IBOutlet weak var timelineTableView: UITableView!
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        timelineTableView.dataSource = self
        timelineTableView.delegate = self
        timelineTableView.estimatedRowHeight = 150
        timelineTableView.rowHeight = UITableViewAutomaticDimension
        
        // Initialize a UIRefreshControl
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshHomeTimelines(_:)), for: UIControlEvents.valueChanged)
        timelineTableView.insertSubview(refreshControl, at: 0)
        
        // Do any additional setup after loading the view.
        getHometimeline()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutButton(_ sender: UIBarButtonItem) {
        TwitterClient.sharedInstance?.logout()
    }

    func refreshHomeTimelines(_ refreshControl: UIRefreshControl) {
        getHometimeline()
    }
    
    func getHometimeline() {
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets:[Tweet]) -> () in
            self.tweets = tweets
            self.timelineTableView.reloadData()
            // Tell the refreshControl to stop spinning movies list
            self.refreshControl.endRefreshing()
            
        }, failure: { (error: Error) -> () in
            print("Error:\(error.localizedDescription)")
        })
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "newTweetSegue" {
            let navVC = segue.destination as! UINavigationController
            let newTweetVC = navVC.topViewController as! NewTweetViewController
            newTweetVC.delegate = self
        } else if segue.identifier == "detailTweetSegue" {
            let cell = sender as! UITableViewCell
            let indexPath = timelineTableView.indexPath(for: cell)
            let tweet = tweets![indexPath!.row]
            
            let detailTweetViewController = segue.destination as! DetailTweetViewController
            detailTweetViewController.tweet = tweet
        }
        
        
    }
}

extension TweetsViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
}

extension TweetsViewController: NewTweetViewControllerDelegate{
    func newTweetViewController(newTweetViewController: NewTweetViewController, didUpdateStatus isSuccess: Bool?) {
        if isSuccess != nil && isSuccess == true {
            getHometimeline()
        }
    }
}
