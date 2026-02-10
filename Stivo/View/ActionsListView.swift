//
//  ActionsListView.swift
//  Stivo
//
//  Created by aisha alh on 23/08/1447 AH.
//

import SwiftUI


struct ActionsListView: View {
    
    var actions: [String]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                ForEach(actions, id: \.self) { action in
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        
                        Text(action)
                            .font(.system(size: 16))
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                }
            }
        }
    }
}
