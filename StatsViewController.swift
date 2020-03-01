//
//  StatsViewController.swift
//  FlappyTina
//
//  Created by Emily Weyda on 7/30/16.
//  Copyright © 2016 Emily Weyda. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {
    @IBOutlet weak var lblStats: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = NSUserDefaults.standardUserDefaults()
        let highestScore = defaults.integerForKey("HighestScore")
        let currentScore = defaults.integerForKey("CurrentScore")
        let numberOfGames = defaults.integerForKey("NumberOfGames")
        let lowestScore = defaults.integerForKey("LowestScore")
        // 2. update the label text with the message
        var message = "Highest Score = \(highestScore) \n"
        message.appendContentsOf("Current Score = \(currentScore) \n")
//        message.appendContentsOf("Number of Games Played = \(numberOfGames) \n")
//        message.appendContentsOf("Lowest Score = \(lowestScore) \n")
        lblStats.text = message
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
}
