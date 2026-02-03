//
//  CircularProgressView.swift
//  Stivo
//
//  Created by aisha alh on 16/08/1447 AH.
//

//
//  CircularProgressView.swift
//  DailyActionsApp
//
//  Circular progress indicator component
//

import SwiftUI

struct CircularProgressView: View {
    let progress: Double
    let lineWidth: CGFloat = 12
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(Color.white.opacity(0.3), lineWidth: lineWidth)
            
            // Progress circle
            Circle()
                .trim(from: 0, to: progress / 100)
                .stroke(
                    Color(red: 1.0, green: 0.6, blue: 0.5),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: progress)
            
            // Percentage text
            Text("\(Int(progress))%")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.black)
        }
        .frame(width: 100, height: 100)
    }
}
