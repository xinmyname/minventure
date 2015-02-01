//
//  GameController.swift
//  minventure
//
//  Created by Andy Sherwood on 9/25/14.
//  Copyright (c) 2014 Andy Sherwood. All rights reserved.
//

import UIKit

@objc(GameController)
class GameController: UIViewController {

    private var _tick:Int = 0
    
    @IBOutlet weak var _lblHealth: UILabel!
    @IBOutlet weak var _lblLevel: UILabel!
    @IBOutlet weak var _lblExperience: UILabel!
    @IBOutlet weak var _lblGold: UILabel!
    @IBOutlet weak var _lblLocation: UILabel!
    @IBOutlet weak var _btnMove: UIButton!
    @IBOutlet weak var _btnFight: UIButton!
    @IBOutlet weak var _btnRest: UIButton!
    @IBOutlet weak var _tlvStory: TextLogView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("tick"), userInfo: nil, repeats: true)
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        NSLog("Did scroll.")
    }
    
    func tick() {
        
        _tick++

        var line:String = ""
        
        if (_tick & 1) == 1 {
            line = "The village elder looks you up and down and says: "
        }
        
        line += "This is tick \(_tick)!"
        
        
        _tlvStory.addLine(line)
    }
}
