//
//  GameManager.swift
//  minventure
//
//  Created by Andy Sherwood on 12/16/19.
//  Copyright © 2019 Andy Sherwood. All rights reserved.
//

import Foundation
import SwiftUI

class GameManager {
    public static let shared = GameManager()
    @State var state = GameState()

    var timer: Timer?
    
    public func start() {
        
        if self.timer != nil {
            return
        }
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true, block: tick)
        
        NSLog("Started!")
    }
    
    public func stop() {

        if self.timer == nil {
            return
        }
        
        self.timer?.invalidate()
        self.timer = nil

        NSLog("Stopped!")
    }

    private func tick(timer: Timer) {
        state.turn += 1
    }
}
