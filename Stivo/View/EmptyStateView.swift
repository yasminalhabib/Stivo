//
//  EmptyStateView.swift
//  Stivo
//
//  Created by aisha alh on 23/08/1447 AH.
//
import SwiftUI

struct EmptyStateView: View {
    
    var body: some View {
        VStack(spacing: 20) {
            
            Spacer()
            
            Image("girl")
                .resizable()
                .scaledToFit()
                .frame(height: 220)
            
            Text("Start your goals journey!")
                .font(.system(size: 20, weight: .bold))
            
            Text("All your goals organized in one place. We’re here to help you stay on track and grow ✨")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            
            NavigationLink {
                CategoriesSheet()
            } label: {
                Text("Add your goals")
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                    .frame(width: 200, height: 50)
                    .background(Color("Color"))
                    .cornerRadius(18)
            }

            
            Spacer()
        }
    }
}
