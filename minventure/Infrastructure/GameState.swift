//
//  GameState.swift
//  minventure
//
//  Created by Andy Sherwood on 2/6/15.
//  Copyright (c) 2015 Andy Sherwood. All rights reserved.
//

import Foundation

public class GameState {
    public var health:Int = 0
    public var level:Int = 0
    public var experience:Int = 0
    public var money:Int = 0
    public var limit:Int = 0
    public var encounter:Encounter?
    public var playerState:PlayerState?
    public var nextLevelAt:Int = 0
    public var bounty:Int = 0
    public var godMode:Bool = false
}