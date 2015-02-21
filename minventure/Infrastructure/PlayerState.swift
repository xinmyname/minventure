//
//  PlayerState.swift
//  minventure
//
//  Created by Andy Sherwood on 2/6/15.
//  Copyright (c) 2015 Andy Sherwood. All rights reserved.
//

import Foundation

public class PlayerState {
    
    public var potential:String = ""
    public var kinetic:String = ""
    
    init(potential:String, kinetic:String) {
        self.potential = potential
        self.kinetic = kinetic
    }

    public func action(gameState:GameState) {
        NSLog(kinetic)
    }
}

public class Moving : PlayerState {
    init() {
        super.init(potential:"move!", kinetic:"moving!")
    }
}

public class Fighting : PlayerState {
    init() {
        super.init(potential:"fight!", kinetic:"fighting!")
    }
}

public class Resting : PlayerState {
    init() {
        super.init(potential:"rest!", kinetic:"resting!")
    }
}

