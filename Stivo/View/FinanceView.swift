//
//  FinanceView.swift
//  Stivo
//
//  Created by noura on 10/02/2026.
//

import SwiftUI

// ========================
// MARK: - FinanceView
// ========================
struct FinanceView: View {

    @State private var showAddGoal = false
    @State private var goals: [Goal] = []
    @State private var selectedGoal: Goal? = nil
    @AppStorage("hasOpenedFinanceBefore") private var hasOpenedFinanceBefore = false

    var body: some View {
        ZStack(alignment: .top) {
            Color("background").ignoresSafeArea()

            // الصور العلوية
            ZStack {
                Image("Image1").scaledToFit().offset(x: -165, y: -330)
                Image("Image2").scaledToFit().offset(x: 165, y: -130)
                Image("blur1").scaledToFit().offset(y: -220)
                Image("Finance").resizable().scaledToFit().frame(width: 330).cornerRadius(16).offset(y: -230)
                Image("Image3").scaledToFit().offset(x: -120, y: 400)
            }.allowsHitTesting(false)

            // النصوص العلوية
            VStack(alignment: .leading, spacing: 8) {
                Text("Finance").font(.system(size: 26, weight: .bold)).foregroundColor(Color("Color"))
                Text("Finance-care starts with small actions that create meaningful change")
                    .font(.system(size: 16)).foregroundColor(.gray)
                    .frame(maxWidth: 360, alignment: .leading)
                Text("Every check ✔️ is a step toward choosing yourself")
                    .font(.system(size: 16)).foregroundColor(.gray)
                    .frame(maxWidth: 360, alignment: .leading)
            }.padding(.leading, 20).padding(.top, 220)

            VStack {
                if goals.isEmpty && !hasOpenedFinanceBefore {
                    Spacer().frame(height: 400)
                    Image("girl").scaledToFit().padding(.top, -25)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Start your goals journey!")
                            .font(.system(size: 23, weight: .bold))
                        Text("All your goals, organized in one place. We’re here to help you stay on track and grow ✨")
                            .font(.system(size: 16)).foregroundColor(.gray)
                            .frame(maxWidth: 360, alignment: .leading)
                    }.padding(.leading, 20)

                    Spacer()

                    Button("Add your goals") {
                        selectedGoal = nil
                        showAddGoal = true
                    }
                    .frame(width: 167, height: 50)
                    .background(Color("Color"))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.bottom, 70)
                } else {
                    ScrollView {
                        checklistView.padding(.top, 400).padding(.bottom, 120)
                    }
                }
            }
        }
        .sheet(isPresented: $showAddGoal) {
            AddGoal(
                goals: $goals,
                showSheet: $showAddGoal,
                editingGoal: $selectedGoal
            )
            .presentationDetents([.large])
        }
        .onAppear { loadGoals() }
        .onChange(of: goals) { _ in saveGoals() }
    }

    var checklistView: some View {
        VStack(alignment: .leading, spacing: 24) {
            goalSection(title: "Daily", frequency: .daily)
            goalSection(title: "Weekly", frequency: .weekly)
            goalSection(title: "Monthly", frequency: .monthly)
        }.padding(.horizontal, 20)
    }

    func goalSection(title: String, frequency: Frequency) -> some View {
        let filteredGoals = goals.filter { $0.frequency == frequency }

        return Group {
            if !filteredGoals.isEmpty {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text(title).font(.system(size: 20, weight: .bold)).foregroundColor(.gray)
                        Spacer()
                        Button { selectedGoal = nil; showAddGoal = true } label: {
                            Text("Add more goals").font(.system(size: 14)).foregroundColor(.gray.opacity(0.8))
                        }
                    } .padding(.horizontal, 150)
                        .padding(.bottom, 15)


                    ForEach(Array(filteredGoals.enumerated()), id: \.element.id) { index, goal in
                        HStack(alignment: .top, spacing: 15) {
                            VStack(spacing: 0) {
                                Circle()
                                    .fill(goal.isCompleted ? Color.green : Color.gray.opacity(0.2))
                                    .frame(width: 35, height: 35)
                                    .overlay(
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(.white)
                                            .opacity(goal.isCompleted ? 1 : 0)
                                    )
                                    .onTapGesture { toggleGoal(goal) }

                                if index < filteredGoals.count - 1 {
                                    Rectangle().fill(Color.gray.opacity(0.3)).frame(width: 2, height: 35)
                                }
                            }

                            Text(goal.title)
                                .font(.system(size: 17)).foregroundColor(.black.opacity(0.8))
                                .padding(.horizontal, 16).padding(.vertical, 12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white).cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                                .onTapGesture { selectedGoal = goal; showAddGoal = true }
                        }
                        .padding(.horizontal, 150)
                        .padding(.bottom, 10)
                        .padding(.bottom, index < filteredGoals.count - 1 ? 0 : 10)
                        .swipeActions {
                            Button(role: .destructive) { deleteGoal(goal) } label: { Label("Delete", systemImage: "trash") }
                        }
                    }
                }.padding(.bottom, 10)
            }
        }
    }

    func toggleGoal(_ goal: Goal) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) { goals[index].isCompleted.toggle() }
    }

    func deleteGoal(_ goal: Goal) { goals.removeAll { $0.id == goal.id } }

    func saveGoals() {
        if let encoded = try? JSONEncoder().encode(goals) { UserDefaults.standard.set(encoded, forKey: "savedFinanceGoals") }
    }

    func loadGoals() {
        if let data = UserDefaults.standard.data(forKey: "savedFinanceGoals"),
           let decoded = try? JSONDecoder().decode([Goal].self, from: data) {
            goals = decoded
            if !decoded.isEmpty { hasOpenedFinanceBefore = true }
        }
    }
}

#Preview { FinanceView() }
