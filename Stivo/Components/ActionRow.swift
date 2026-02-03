//
//  ActionRow.swift
//  Stivo
//
//  Created by aisha alh on 16/08/1447 AH.
//

import Foundation
//
//  ActionRow.swift
//  DailyActionsApp
//
//  Action item row component
//

import SwiftUI

struct ActionRow: View {
    let action: ActionItem
    let onToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 15) {
            // Checkmark circle
            ZStack {
                Circle()
                    .fill(action.isCompleted ? Color.green : Color.gray.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                if action.isCompleted {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .bold))
                }
            }
            .onTapGesture {
                onToggle()
            }
            
            // Action title
            Text(action.title)
                .font(.system(size: 16))
                .foregroundColor(.black)
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}
