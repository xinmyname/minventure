//
//  ContentView.swift
//  minventure
//
//  Created by Andy Sherwood on 12/15/19.
//  Copyright © 2019 Andy Sherwood. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var gameState = GameManager.shared.state
    
    var body: some View {
    
        VStack(alignment: .leading) {
            
            Text("minventure").font(.largeTitle)
            
            Divider()
            
            HStack() {

                VStack(alignment: .leading) {
                    Text("turn")
                    Text("health")
                    Text("max health")
                    Text("level")
                    Text("experience")
                    Text("gold")
                }
                .padding(.trailing)

                VStack(alignment: .leading) {
                    Text("\(self.gameState.turn)")
                    Text("\(self.gameState.health)")
                    Text("\(self.gameState.maxHealth)")
                    Text("\(self.gameState.level)")
                    Text("\(self.gameState.experience)")
                    Text("\(self.gameState.gold)")
                }
            }
            .padding(.top)

            VStack() {
                VStack() {
                    HStack() {
                        Text("forest!")
                        Spacer()
                        Text("3")
                    }
                }
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0, green: 1, blue: 0.3), Color(red: 0.6, green: 0.5, blue: 0.4)]), startPoint: .top, endPoint: .bottom))
            }
            .padding(.vertical)
  
            ActionPickerView(selectedAction: $gameState.actionState)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
