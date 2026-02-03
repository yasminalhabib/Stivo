//
//  DailyActionsCard.swift
//  Stivo
//
//  Created by aisha alh on 16/08/1447 AH.
//

import Foundation
import SwiftUI

struct DailyActionsCard: View {

    var progress: Double   // من 0 إلى 1

    var body: some View {
        HStack(spacing: 20) {

            VStack(alignment: .leading, spacing: 6) {
                Text("Daily")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)

                Text("Actions")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }

            Spacer()

            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .frame(width: 90, height: 90)

                CircularProgressView(progress: progress)
            }
        }
        .padding()
        .background(Color(red: 0.82, green: 0.84, blue: 0.74))
        .cornerRadius(24)
        .padding(.horizontal)
    }
}
