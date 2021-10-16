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
        
        
        
        
        
    }

    @IBAction func predictPressed(_ sender: Any) {
        if let searchText = textField.text {
            swifter.searchTweet(using: searchText ,lang: "en", count: 100, tweetMode: .extended, success: { results, metadata in
                var tweets = [TweetSentimentClassifierInput]()
                
                for i in 0..<100 {
                    if let tweet = results[i]["full_text"].string {
                        let tweetForClassification = TweetSentimentClassifierInput(text: tweet)
                        tweets.append(tweetForClassification)
                    }
                }
                
                do {
                    let predictions = try self.sentimentClassifier.predictions(inputs: tweets)
                    
                    var sentimentScore = 0
                    
                    for pred in predictions {
                        let sentiment = pred.label
                        if sentiment == "Pos" {
                            sentimentScore += 1
                            
                        } else if sentiment == "Neg" {
                            sentimentScore -= 1
                        }
                    }
                    
                    if sentimentScore > 20 {
                        self.sentimentLabel.text = "🤩"
                    } else if sentimentScore > 10 {
                        self.sentimentLabel.text = "😄"
                    } else if sentimentScore > 0 {
                        self.sentimentLabel.text = "🙂"
                    } else if sentimentScore == 0 {
                        self.sentimentLabel.text = "😐"
                    } else if sentimentScore > -10 {
                        self.sentimentLabel.text = "😕"
                    } else if sentimentScore > -20 {
                        self.sentimentLabel.text = "😡"
                    } else {
                        self.sentimentLabel.text = "🤮"
                    }
                } catch {
                    print(error)
                }
                
            }) { error in
                print("There wa an error with the Twitter API Request")
            }
        }
        
        let prediction = try! sentimentClassifier.prediction(text: "@Apple is the best company")
        
        print(prediction.label)
    }
    
}

