//
//  GameController.swift
//  minventure
//
//  Created by Andy Sherwood on 9/25/14.
//  Copyright (c) 2014 Andy Sherwood. All rights reserved.
//

import UIKit

class GameController: UIViewController {

    private var _tick:Int = 0
    private var _timer:dispatch_source_t!
    
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
        
        let nsecInterval = 1.0 * Double(NSEC_PER_SEC)
        let nsecLeeway = 0.1 * Double(NSEC_PER_SEC)
        let mainQueue:dispatch_queue_t = dispatch_get_main_queue()
        let queue:dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue)
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(nsecInterval))
        dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, Int64(nsecInterval)), UInt64(nsecInterval), UInt64(nsecLeeway))
        dispatch_source_set_event_handler(_timer, { () -> Void in
            dispatch_async(mainQueue, self.tick)
        })
        dispatch_resume(_timer)
        
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
