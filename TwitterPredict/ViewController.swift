//
//  ViewController.swift
//  TwitterPredict
//
//  Created by Thomas Viana on 15/10/21.
//

import UIKit
import SwifteriOS
import CoreML
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    let sentimentClassifier = TweetSentimentClassifier();
    let swifter = Swifter(consumerKey: "6cTs5ps7q82E7Lm5tGUJ4EZ8p", consumerSecret: "Mn9l2RZUoEBNHLoteCHqZgz8KSP59U8PqYJzlZBXH1VNp0OcwE")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let prediction = try! sentimentClassifier.prediction(text: "@Apple is the best company")
        
        print(prediction.label)
        
        swifter.searchTweet(using: "@Apple",lang: "en", count: 100, tweetMode: .extended, success: { results, metadata in
            var tweets = [String]()
            
            for i in 0..<100 {
                if let tweet = results[i]["full_text"].string {
                    tweets.append(tweet)
                }
            }
            
            
        }) { error in
            print("There wa an error with the Twitter API Request")
        }
        
    }

    @IBAction func predictPressed(_ sender: Any) {
    }
    
}

