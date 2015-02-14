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
    
    init(name:String, minLimit:Int, maxLimit:Int) {
        _name = name
        _minLimit = minLimit
        _maxLimit = maxLimit
    }
    
    func setup() {
        
    }
    
    func action() {
        
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
        super.init(name: "Monster!", minLimit: 0, maxLimit: 0)
    }
    
    override func setup() {
        
        super.setup()
        maxHealth = self.nextLimit()
        experience = maxHealth/2
    }
}

public class Ruins : Encounter {

    init() {
        super.init(name: "Ruins!", minLimit: 2, maxLimit: 4)
    }

}

public class City : Encounter {
    
    init() {
        super.init(name: "City!", minLimit: 4, maxLimit: 6)
    }
    
}

public class Town : Encounter {
    
    init() {
        super.init(name: "Town!", minLimit: 2, maxLimit: 4)
    }
    
}






