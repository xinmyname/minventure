//
//  ActionPickerView.swift
//  minventure
//
//  Created by Andy Sherwood on 12/16/19.
//  Copyright © 2019 Andy Sherwood. All rights reserved.
//

import SwiftUI

struct ActionPickerView: View  {

    @Binding var selectedAction: ActionState
    
    var body: some View {

        VStack(alignment: .leading, spacing: 16) {

            ForEach(ActionState.allCases, id: \.self) { (action: ActionState) in

                Button(action: { self.selectedAction = action }) {
                    Text(self.actionText(self.selectedAction, action))
                        .foregroundColor(self.foregroundColor(self.selectedAction, action))
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(self.backgroundColor(self.selectedAction, action))
                }
                .overlay(
                           RoundedRectangle(cornerRadius: 6)
                           .stroke(Color.pink, lineWidth: 4)
                )
            }
        }
         .frame(maxWidth: .infinity)
    }
    
    private func actionText(_ selectedAction: ActionState, _ action: ActionState) -> String {
        return selectedAction == action ? action.activeText : action.inactiveText
    }

    private func foregroundColor(_ selectedAction: ActionState, _ action: ActionState) -> Color {
        return selectedAction == action ? Color.white : Color.pink
    }

    private func backgroundColor(_ selectedAction: ActionState, _ action: ActionState) -> Color {
        return selectedAction == action ? Color.pink : Color.white
    }
}
