//
//  WorkView.swift
//  Stivo
//
//  Created by noura on 10/02/2026.
//
import SwiftUI

struct WorkView: View {

    @State private var showAddGoal = false
    @State private var goals: [Goal] = []
    @State private var selectedGoal: Goal? = nil
    @AppStorage("hasOpenedWorkBefore") private var hasOpenedWorkBefore = false
    @EnvironmentObject var viewModel: DashboardViewModel

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                Color("background").ignoresSafeArea()

                decorativeImages
                    .frame(width: geo.size.width)
                    .allowsHitTesting(false)

                        Color.clear
                            .frame(height: geo.size.width * 0.55)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Work")
                                .font(.system(size: 26, weight: .bold))
                                .foregroundColor(Color("Color"))
                            Text("Work-care starts with small actions that create meaningful change")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                                .fixedSize(horizontal: false, vertical: true)
                            Text("Every check ✔️ is a step toward choosing yourself")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.leading, 40)
                        .padding(.trailing, 20)
                        .padding(.top, geo.size.width * 0.55 + 20)
                        .zIndex(1)
                
                        ScrollView {
                            VStack(alignment: .leading, spacing: 10) {

                                // مساحة شفافة تعادل (ارتفاع الصور + ارتفاع النص الثابت)
                                // عشان البطاقات تبدأ من تحت الكلام ولا تغطيه في البداية
                                Color.clear
                                    .frame(height: geo.size.width * 0.55 + 160)

                                if goals.isEmpty {
                                    emptyStateView
                                } else {
                                    checklistView
                                        .padding(.bottom, 120)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showAddGoal) {
            AddGoal(goals: $goals, showSheet: $showAddGoal, editingGoal: $selectedGoal)
                .presentationDetents([.large])
        }
        .onAppear { loadGoals() }
        .onChange(of: goals) { _ in saveGoals(); syncGoalsToDashboard() }
    }

    var decorativeImages: some View {
        ZStack {
            Image("Image1").scaledToFit().offset(x: -165, y: -330)
            Image("Image2").scaledToFit().offset(x: 165, y: -130)
            Image("blur1").scaledToFit().offset(y: -220)
            Image("Work")
                .resizable()
                .scaledToFit()
                .frame(width: 330)
                .cornerRadius(16)
                .offset(y: -230)
            Image("Image3").scaledToFit().offset(x: -120, y: 400)
        }
    }

    var emptyStateView: some View {
        VStack(spacing: 16) {
            Image("girl").scaledToFit().frame(maxWidth: 280)
            VStack(spacing: 8) {
                Text("Start your goals journey!")
                    .font(.system(size: 23, weight: .bold))
                Text("All your goals, organized in one place. We're here to help you stay on track and grow ✨")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 20)
            Button("Add your goals") { selectedGoal = nil; showAddGoal = true }
                .frame(width: 167, height: 50)
                .background(Color("Color"))
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.top, 8)
        }
        .padding(.bottom, 80)
    }

    var checklistView: some View {
        VStack(alignment: .leading, spacing: 24) {
            goalSection(title: "Daily", frequency: .daily)
            goalSection(title: "Weekly", frequency: .weekly)
            goalSection(title: "Monthly", frequency: .monthly)
        }
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    func goalSection(title: String, frequency: Frequency) -> some View {
        let filteredGoals = goals.filter { $0.frequency == frequency }
        if !filteredGoals.isEmpty {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(title).font(.system(size: 20, weight: .bold)).foregroundColor(.gray)
                    Spacer()
                    Button { selectedGoal = nil; showAddGoal = true } label: {
                        Text("Add more goals").font(.system(size: 14)).foregroundColor(.gray.opacity(0.8))
                    }
                }
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
                            .font(.system(size: 17))
                            .foregroundColor(.black.opacity(0.8))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                            .onTapGesture { selectedGoal = goal; showAddGoal = true }
                    }
                    .padding(.bottom, 10)
                    .swipeActions {
                        Button(role: .destructive) { withAnimation { deleteGoal(goal) } } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .padding(.bottom, 10)
        }
    }

    func toggleGoal(_ goal: Goal) {
        if let i = goals.firstIndex(where: { $0.id == goal.id }) { goals[i].isCompleted.toggle() }
    }
    func deleteGoal(_ goal: Goal) { goals.removeAll { $0.id == goal.id } }
    func saveGoals() {
        if let e = try? JSONEncoder().encode(goals) { UserDefaults.standard.set(e, forKey: "savedWorkGoals") }
    }
    func loadGoals() {
        if let d = UserDefaults.standard.data(forKey: "savedWorkGoals"),
           let decoded = try? JSONDecoder().decode([Goal].self, from: d) {
            goals = decoded; if !decoded.isEmpty { hasOpenedWorkBefore = true }
        }
    }
    func syncGoalsToDashboard() { viewModel.workGoals = goals }
}

#Preview { WorkView().environmentObject(DashboardViewModel()) }




