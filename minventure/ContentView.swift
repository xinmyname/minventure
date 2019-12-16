//
//  ContentView.swift
//  minventure
//
//  Created by Andy Sherwood on 12/15/19.
//  Copyright © 2019 Andy Sherwood. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
    
        VStack(alignment: .leading) {
            
            Text("minventure").font(.largeTitle)
            
            Divider()
            
            HStack() {

                VStack(alignment: .leading) {
                    Text("health")
                    Text("level")
                    Text("experience")
                    Text("gold")
                }
                .padding(.trailing)

                VStack(alignment: .leading) {
                    Text("32/32")
                    Text("1")
                    Text("0")
                    Text("0")
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
            
            VStack(alignment: .leading, spacing: 16) {
            
                Button(action: {}) {
                    Text("move!")
                        .foregroundColor(Color.pink)
                        .background(Color.clear)
                        .padding(12)
                }
                .frame(maxWidth: .infinity)
                .overlay(
                           RoundedRectangle(cornerRadius: 8)
                           .stroke(Color.pink, lineWidth: 4)
                )
                
                Button(action: {}) {
                    Text("fight!")
                        .foregroundColor(Color.pink)
                        .padding(12)
                }
                .frame(maxWidth: .infinity)
                .overlay(
                           RoundedRectangle(cornerRadius: 8)
                           .stroke(Color.pink, lineWidth: 4)
                )

                Button(action: {}) {
                    Text("rest!")
                        .foregroundColor(Color.pink)
                        .padding(12)
                }
                .frame(maxWidth: .infinity)
                .overlay(
                           RoundedRectangle(cornerRadius: 8)
                           .stroke(Color.pink, lineWidth: 4)
                )
            }
            .frame(maxWidth: .infinity)
            
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
