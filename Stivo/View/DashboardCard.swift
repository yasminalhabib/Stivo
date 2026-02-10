//
//  DashboardCard.swift
//  Stivo
//
//  Created by aisha alh on 23/08/1447 AH.
//
import SwiftUI

struct DashboardCard: View {
    
    var progress: Double
    var title: String
    
    var body: some View {
        NavigationLink {
            DashboardView()
        } label: {
            HStack {
                
                // Left Title
                Text(title)
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                // Progress Container
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.white)
                        .frame(width: 120, height: 120)
                    
                    ZStack {
                        Circle()
                            .stroke(Color.orange.opacity(0.3), lineWidth: 8)
                        
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(Color(red: 255/255, green: 182/255, blue: 149/255), lineWidth: 8)
                            .rotationEffect(.degrees(-90))
                        
                        Text("\(Int(progress * 100))%")
                            .font(.headline.bold())
                            .foregroundColor(.black)
                    }
                    .frame(width: 80, height: 80)
                }
            }
            .padding(25)
            .frame(maxWidth: .infinity)
            .frame(height: 188)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(red: 208/255, green: 210/255, blue: 192/255))
            )
            .padding(.horizontal, 20)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    DashboardCard(progress: 1, title: "Daily Actions")
}
