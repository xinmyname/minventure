//
//  GameState.swift
//  minventure
//
//  Created by Andy Sherwood on 12/16/19.
//  Copyright © 2019 Andy Sherwood. All rights reserved.
//

import Foundation

class GameState: ObservableObject {

    @Published var turn: Int = 1
    @Published var health: Int = 42
    @Published var maxHealth: Int = 42
    @Published var level: Int = 0
    @Published var experience: Int = 0
    @Published var gold: Int = 0
    @Published var actionState: ActionState = .resting
}
