//
//  dailyactions.swift
//  stivo
//
//  Created by s on 17/08/1447 AH.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var viewModel: DashboardViewModel
    @Environment(\.dismiss) private var dismiss

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
                            .foregroundColor(.black)

                        ForEach(["Sport", "Other", "Finance", "Care"], id: \.self) { title in
                            NavigationLink(destination: destinationView(for: title)) {
                                ActionCard(title: title, progress: progress(for: title))
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 90)
                    .padding(.bottom, 50)
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button { dismiss() } label: {
                        Image("back_arrow")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                            .contentShape(Rectangle())
                    }
                }
            }
        }
    }

    @ViewBuilder
    func destinationView(for title: String) -> some View {
        switch title {
        case "Sport":   SportView()
        case "Other":   WorkView()
        case "Finance": FinanceView()
        case "Care":    CareView()
        default:        Text("No View")
        }
    }

    func progress(for title: String) -> Double {
        let goals: [Goal]
        switch title {
        case "Sport":   goals = viewModel.sportGoals
        case "Other":   goals = viewModel.workGoals
        case "Finance": goals = viewModel.financeGoals
        case "Care":    goals = viewModel.careGoals
        default:        goals = []
        }
        guard !goals.isEmpty else { return 0 }
        return Double(goals.filter { $0.isCompleted }.count) / Double(goals.count)
    }
}

// MARK: - Card
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

// MARK: - Progress Ring
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
                    .stroke(Color.orange, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .bold()
                    .foregroundColor(.black)
            }
            .frame(width: 60, height: 60)
        }
    }
}

#Preview {
    DashboardView()
        .environmentObject(DashboardViewModel())
}
