//
//  GameController.swift
//  minventure
//
//  Created by Andy Sherwood on 9/25/14.
//  Copyright (c) 2014 Andy Sherwood. All rights reserved.
//

import UIKit

class GameController: UIViewController {

    private let _gameState:GameState
    private let _move:Moving
    private let _fight:Fighting
    private let _rest:Resting
    private let _encounters:[String:Encounter]
    
    private let _blueColor:UIColor
    private let _timer:dispatch_source_t
    
    @IBOutlet weak var _lblHealth: UILabel!
    @IBOutlet weak var _lblLevel: UILabel!
    @IBOutlet weak var _lblExperience: UILabel!
    @IBOutlet weak var _lblGold: UILabel!
    @IBOutlet weak var _lblLocation: UILabel!
    @IBOutlet weak var _btnMove: UIButton!
    @IBOutlet weak var _btnFight: UIButton!
    @IBOutlet weak var _btnRest: UIButton!
    @IBOutlet weak var _tlvStory: TextLogView!

    required init(coder aDecoder: NSCoder) {
        
        _gameState = GameState()
        _move = Moving()
        _fight = Fighting()
        _rest = Resting()
        
        _encounters = [
            "swamp": Location(name: "Swamp!", minLimit: 2, maxLimit: 8),
            "prarie": Location(name: "Prarie!", minLimit: 2, maxLimit: 7),
            "hills": Location(name: "Hills!", minLimit: 2, maxLimit: 8),
            "mountains": Location(name: "Mountains!", minLimit: 2, maxLimit: 5),
            "desert": Location(name: "Desert!", minLimit: 2, maxLimit: 8),
            "coastline": Location(name: "Coastline!", minLimit: 2, maxLimit: 5),
            "jungle": Location(name: "Jungle!", minLimit: 2, maxLimit: 8),
            "tundra": Location(name: "Tundra!", minLimit: 2, maxLimit: 6),
            "forest": Location(name: "Forest!", minLimit: 2, maxLimit: 8),
            "savana": Location(name: "Savana!", minLimit: 2, maxLimit: 8),
            "ruins": Ruins(),
            "town": Town(),
            "city": City(),
            "monster": Monster()
        ]
        
        _blueColor = UIColor(red: 0, green: (122.0/255.0), blue: 1, alpha: 1)
        
        let nsecInterval = 1.0 * Double(NSEC_PER_SEC)
        let nsecLeeway = 0.1 * Double(NSEC_PER_SEC)
        let mainQueue:dispatch_queue_t = dispatch_get_main_queue()
        let queue:dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue)
        
        super.init(coder: aDecoder)

        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(nsecInterval))
        dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, Int64(nsecInterval)), UInt64(nsecInterval), UInt64(nsecLeeway))
        dispatch_source_set_event_handler(_timer, { () -> Void in
            dispatch_async(mainQueue, self.tick)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        _gameState.level = 1
        _gameState.health = 25
        _gameState.experience = 0
        _gameState.money = 0
        _gameState.nextLevelAt = 72
        _gameState.encounter = _encounters["forest"]
        _gameState.playerState = _rest
        
        dispatch_resume(_timer)
    }

    func tick() {

        _gameState.playerState?.action()
        _gameState.encounter?.action()
        
//        _tlvStory.addLine(line)
    }
    
    @IBAction func tappedMove(sender: UIButton) {
        _gameState.playerState = _move

        _btnMove.setTitle(_move.kinetic, forState: UIControlState.Normal)
        _btnMove.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        _btnMove.backgroundColor = _blueColor
        
        _btnFight.setTitle(_fight.potential, forState: UIControlState.Normal)
        _btnFight.setTitleColor(_blueColor, forState: UIControlState.Normal)
        _btnFight.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        _btnRest.setTitle(_rest.potential, forState: UIControlState.Normal)
        _btnRest.setTitleColor(_blueColor, forState: UIControlState.Normal)
        _btnRest.backgroundColor = UIColor.groupTableViewBackgroundColor()
    }

    @IBAction func tappedFight(sender: UIButton) {
        _gameState.playerState = _fight

        _btnMove.setTitle(_move.potential, forState: UIControlState.Normal)
        _btnMove.setTitleColor(_blueColor, forState: UIControlState.Normal)
        _btnMove.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        _btnFight.setTitle(_fight.kinetic, forState: UIControlState.Normal)
        _btnFight.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        _btnFight.backgroundColor = _blueColor
        
        _btnRest.setTitle(_rest.potential, forState: UIControlState.Normal)
        _btnRest.setTitleColor(_blueColor, forState: UIControlState.Normal)
        _btnRest.backgroundColor = UIColor.groupTableViewBackgroundColor()
    }

    @IBAction func tappedRest(sender: UIButton) {
        _gameState.playerState = _rest

        _btnMove.setTitle(_move.potential, forState: UIControlState.Normal)
        _btnMove.setTitleColor(_blueColor, forState: UIControlState.Normal)
        _btnMove.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        _btnFight.setTitle(_fight.potential, forState: UIControlState.Normal)
        _btnFight.setTitleColor(_blueColor, forState: UIControlState.Normal)
        _btnFight.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        _btnRest.setTitle(_rest.kinetic, forState: UIControlState.Normal)
        _btnRest.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        _btnRest.backgroundColor = _blueColor
    }
}
