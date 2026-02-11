//
//  dailyactions.swift
//  stivo
//
//  Created by s on 17/08/1447 AH.
//

import SwiftUI

struct DashboardView: View {
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                Image("bk2")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        
                        Text("Daily Actions")
                            .font(.title)
                            .bold()
                            .padding(.top, 20)
                        
                        ForEach(["Sport", "Work", "Finance", "Care"], id: \.self) { title in
                            
                            NavigationLink(destination: destinationView(for: title)) {
                                ActionCard(title: title, progress: 1.00)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                        }
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 90)
                    .padding(.bottom, 50)
                }
            }
        }
    }
    
    @ViewBuilder
    func destinationView(for title: String) -> some View {
        switch title {
        case "Sport":
            SportView()
        case "Work":
            WorkView()
        case "Finance":
            FinanceView()
        case "Care":
            CareView()
        default:
            Text("No View")
        }
    }
}

//Card
struct ActionCard: View {
    
    var title: String
    var progress: Double
    
    var body: some View {
        HStack {
            
            Text(title)
                .font(.title2)
                .foregroundColor(.white)
            
            Spacer()
            
            ProgressRing(progress: progress)
        }
        .padding()
        .frame(height: 110)
        .background(Color(red: 0.72, green: 0.75, blue: 0.63))
        .cornerRadius(25)
    }
}

//Progress Ring
struct ProgressRing: View {
    
    var progress: Double
    
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .frame(width: 90, height: 90)
            
            ZStack {
                Circle()
                    .stroke(Color.orange.opacity(0.3), lineWidth: 12)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        Color.orange,
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                
                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .bold()
            }
            .frame(width: 60, height: 60)
        }
    }
}

#Preview {
    DashboardView()
}
