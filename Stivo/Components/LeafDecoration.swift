//
//  LeafDecoration.swift
//  Stivo
//
//  Created by aisha alh on 16/08/1447 AH.
//

import Foundation
//
//  LeafDecoration.swift
//  DailyActionsApp
//
//  Decorative leaf component
//

import SwiftUI

struct LeafDecoration: View {
    var body: some View {
        Image(systemName: "leaf.fill")
            .font(.system(size: 60))
            .foregroundColor(Color(red: 1.0, green: 0.8, blue: 0.6))
            .opacity(0.5)
            .rotationEffect(.degrees(-25))
    }
}
