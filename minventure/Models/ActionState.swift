//
//  GameState.swift
//  minventure
//
//  Created by Andy Sherwood on 12/16/19.
//  Copyright © 2019 Andy Sherwood. All rights reserved.
//

import Foundation

protocol ActionDescription  {
    var activeText: String { get }
    var inactiveText: String { get }
}

enum ActionState: ActionDescription,CaseIterable {
    
    case resting
    case moving
    case fighting
    
    var activeText: String {
        switch self {
        case .resting:
            return "resting!"
        case .moving:
            return "moving!"
        case .fighting:
            return "fighting!"
        }
    }
    
    var inactiveText: String {
        switch self {
        case .resting:
            return "rest"
        case .moving:
            return "move"
        case .fighting:
            return "fight"
        }
    }
}
