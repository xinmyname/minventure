//
//  Encounter.swift
//  minventure
//
//  Created by Andy Sherwood on 2/6/15.
//  Copyright (c) 2015 Andy Sherwood. All rights reserved.
//

import Foundation

public class Encounter {

    private var _name:String
    private var _minLimit:Int
    private var _maxLimit:Int
    
    init(name:String, minLimit:Int, maxLimit:Int, startColor:String, endColor:String, textColor:String) {
        _name = name
        _minLimit = minLimit
        _maxLimit = maxLimit
    }
    
    func setup() {
        
    }
    
    func action(gameState:GameState) {
        
    }
    
    func nextLimit() -> Int {
        let delta = _maxLimit - _minLimit
        return Int(arc4random_uniform(UInt32(delta))) + _minLimit
    }
}

public class Location : Encounter {
    
    
}

public class Monster : Encounter {
    
    public var maxHealth:Int = 0
    public var experience:Int = 0
    
    init() {
        super.init(name: "Monster!", minLimit: 0, maxLimit: 0, startColor:"#c44403", endColor:"#a83b09", textColor:"#ffffff")
    }
    
    override func setup() {
        
        super.setup()
        maxHealth = self.nextLimit()
        experience = maxHealth/2
    }
}

public class Ruins : Encounter {

    init() {
        super.init(name: "Ruins!", minLimit: 2, maxLimit: 4, startColor:"#AF9F97", endColor:"#474747", textColor:"#fff")
    }

}

public class City : Encounter {
    
    init() {
        super.init(name: "City!", minLimit: 4, maxLimit: 6, startColor:"#575650", endColor:"#BBB3AE", textColor:"#fff")
    }
    
}

public class Town : Encounter {
    
    init() {
        super.init(name: "Town!", minLimit: 2, maxLimit: 4, startColor:"#E9E8E2", endColor:"#9C9C96", textColor:"#000")
    }
    
}






