//
//  NewTweetViewController.swift
//  HandyTwitter
//
//  Created by Phong on 4/3/17.
//  Copyright © 2017 Phong. All rights reserved.
//

import UIKit

import UIKit

protocol NewTweetViewControllerDelegate {
    func newTweetViewController(newTweetViewController: NewTweetViewController, didUpdateStatus isSuccess: Bool? )
}

class NewTweetViewController: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var messageText: UITextView!
    @IBOutlet weak var numberOfCharLabel: UILabel!
    
    var delegate: NewTweetViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        messageText.delegate = self
//        messageText.layer.cornerRadius = 5
//        messageText.layer.borderWidth = 1
//        messageText.layer.borderColor = UIColor(colorLiteralRed: 16/255, green: 17/255, blue: 235/255, alpha: 1).cgColor
        messageText.text = "What's happening"
        messageText.textColor = UIColor.lightGray
        
        if let navigationBar = self.navigationController?.navigationBar {
            numberOfCharLabel.frame = CGRect(x: navigationBar.frame.width - 90, y: 0, width: navigationBar.frame.width/2, height: navigationBar.frame.height)
            navigationBar.addSubview(numberOfCharLabel)
        }
        
        // Load current user
        if User.currentUser != nil {
            if User.currentUser?.profileImageUrl != nil {
                profileImage.setImageWith((User.currentUser?.profileImageUrl!)!)
            }
            nameLabel.text = User.currentUser?.name
            screenNameLabel.text = "@\(User.currentUser!.screenName!)"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onTweet(_ sender: UIBarButtonItem) {
        TwitterClient.sharedInstance?.updateStatus(status: messageText.text, success: {
            self.delegate?.newTweetViewController(newTweetViewController: self, didUpdateStatus: true)
            self.dismiss(animated: true, completion: nil)
        }, failure: { (error: Error?) in
            print("Error: \(error?.localizedDescription)")
            self.delegate?.newTweetViewController(newTweetViewController: self, didUpdateStatus: false)
        })
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

extension NewTweetViewController: UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newLength = (textView.text as NSString).length + (text as NSString).length - range.length
        let remainingChar = 140 - newLength
        numberOfCharLabel.text = "\(remainingChar)"
        return newLength > 140 ? false: true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "What's happening"
            textView.textColor = UIColor.lightGray
        }
    }
}
