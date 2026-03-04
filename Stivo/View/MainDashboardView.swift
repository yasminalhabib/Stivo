//
//  MainDashboardView.swift
//  Stivo
//
//  Created by aisha alh on 23/08/1447 AH.
//
import SwiftUI

struct MainDashboardView: View {

    @EnvironmentObject private var viewModel: DashboardViewModel
    @State private var selectedPeriod: String = "Daily Actions"
    @State private var showCategoriesSheet = false
    @State private var showToast = false
    @State private var showAddGoal = false
    @State private var selectedGoal: Goal? = nil

    private var currentGoalsBinding: Binding<[Goal]> {
        Binding(
            get: {
                guard let goal = selectedGoal else { return viewModel.sportGoals }
                if viewModel.workGoals.contains(where: { $0.id == goal.id })    { return viewModel.workGoals }
                if viewModel.financeGoals.contains(where: { $0.id == goal.id }) { return viewModel.financeGoals }
                if viewModel.careGoals.contains(where: { $0.id == goal.id })    { return viewModel.careGoals }
                return viewModel.sportGoals
            },
            set: { newValue in
                guard let goal = selectedGoal else { viewModel.sportGoals = newValue; return }
                if viewModel.workGoals.contains(where: { $0.id == goal.id })    { viewModel.workGoals = newValue; return }
                if viewModel.financeGoals.contains(where: { $0.id == goal.id }) { viewModel.financeGoals = newValue; return }
                if viewModel.careGoals.contains(where: { $0.id == goal.id })    { viewModel.careGoals = newValue; return }
                viewModel.sportGoals = newValue
            }
        )
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color("background").ignoresSafeArea()

                // Background decorative images
                VStack {
                    Spacer()
                    HStack {
                        Image("pp")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 140)
                            .opacity(0.6)
                            .padding(.bottom, 180)
                        Spacer()
                    }
                    .padding(.bottom, 40)
                }

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image("Image1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 140)
                            .opacity(0.6)
                    }
                    .padding(.bottom, 300)
                }

                ScrollView {
                    VStack(spacing: 20) {

                        DashboardCard(progress: calculatedProgress, title: selectedPeriod)

                        HStack {
                            PeriodSelector(selectedPeriod: $selectedPeriod)
                                .frame(width: 100)
                                .frame(maxWidth: 289, alignment: .leading)
                        }
                        .padding(.horizontal)

                        if !allGoals.isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Your Goals")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.black)
                                    .padding(.horizontal)

                                LazyVStack(spacing: 18) {
                                    ForEach(goalsForProgress) { goal in
                                        goalRow(goal: goal)
                                    }
                                }

                                HStack {
                                    Spacer()
                                    Button(action: { showCategoriesSheet = true }) {
                                        Text("Add more goals")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.gray)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 10)
                                            .background(Color.gray.opacity(0.10))
                                            .cornerRadius(12)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }

                        if allGoals.isEmpty {
                            Image("girl")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)

                            Text("Start your goals journey!")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.black)

                            Button {
                                showCategoriesSheet = true
                            } label: {
                                Text("Add your goals")
                                    .frame(width: 150, height: 50)
                                    .background(Color("Color"))
                                    .foregroundColor(.white)
                                    .cornerRadius(22)
                            }
                        }
                    }
                    .padding(.top, 10)
                }
            }
            .overlay(toastView)
            .safeAreaInset(edge: .bottom) {
                MemorySection()
                    .background(Color("background").ignoresSafeArea())
            }
            .sheet(isPresented: $showCategoriesSheet) {
                CategoriesSheet()
                    .environmentObject(viewModel)
                    .preferredColorScheme(.light)
            }
            .sheet(isPresented: $showAddGoal, onDismiss: { selectedGoal = nil }) {
                AddGoal(goals: currentGoalsBinding, showSheet: $showAddGoal, editingGoal: $selectedGoal)
                    .environmentObject(viewModel)
            }
        }
    }
}

// MARK: - Goal Row
extension MainDashboardView {

    private func goalRow(goal: Goal) -> some View {
        let currentGoals = goalsForProgress
        let index = currentGoals.firstIndex(where: { $0.id == goal.id }) ?? 0

        return HStack(alignment: .top, spacing: 15) {
            VStack(spacing: 0) {
                Button {
                    withAnimation(.easeInOut) {
                        viewModel.toggleGoal(id: goal.id)
                        if !goal.isCompleted { triggerToast() }
                    }
                } label: {
                    Circle()
                        .fill(goal.isCompleted ? Color.green : Color.gray.opacity(0.2))
                        .frame(width: 35, height: 35)
                        .overlay(
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                                .opacity(goal.isCompleted ? 1 : 0)
                        )
                }

                if index < currentGoals.count - 1 {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 2)
                        .frame(maxHeight: .infinity)
                }
            }
            .frame(width: 35)

            Button {
                selectedGoal = goal
                showAddGoal = true
            } label: {
                VStack(alignment: .leading, spacing: 4) {
                    Text(goal.title)
                        .font(.system(size: 15, weight: .medium))
                        .strikethrough(goal.isCompleted, color: .gray)
                        .foregroundColor(goal.isCompleted ? .gray : .black)

                    Text(categoryName(for: goal))
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(14)
                .shadow(color: Color.black.opacity(0.05), radius: 5)
            }
            .buttonStyle(.plain)

            Spacer()
        }
        .padding(.horizontal)
        .contentShape(Rectangle())
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                viewModel.deleteGoal(id: goal.id)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

// MARK: - Logic
extension MainDashboardView {

    private func triggerToast() {
        showToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation { showToast = false }
        }
    }

    private func categoryName(for goal: Goal) -> String {
        if viewModel.sportGoals.contains(where: { $0.id == goal.id })   { return "Sport" }
        if viewModel.workGoals.contains(where: { $0.id == goal.id })    { return "Other" }
        if viewModel.financeGoals.contains(where: { $0.id == goal.id }) { return "Finance" }
        if viewModel.careGoals.contains(where: { $0.id == goal.id })    { return "Care" }
        return ""
    }
}

// MARK: - Data
extension MainDashboardView {

    private var allGoals: [Goal] {
        viewModel.sportGoals + viewModel.workGoals + viewModel.financeGoals + viewModel.careGoals
    }

    private var goalsForProgress: [Goal] {
        switch selectedPeriod {
        case "Weekly Actions":  return allGoals.filter { $0.frequency == .weekly }
        case "Monthly Actions": return allGoals.filter { $0.frequency == .monthly }
        default:                return allGoals.filter { $0.frequency == .daily }
        }
    }

    private var calculatedProgress: Double {
        let completed = goalsForProgress.filter { $0.isCompleted }.count
        return goalsForProgress.isEmpty ? 0 : Double(completed) / Double(goalsForProgress.count)
    }
}

// MARK: - Toast
extension MainDashboardView {

    private var toastView: some View {
        VStack {
            if showToast {
                Text("Completed 🎉")
                    .font(.system(size: 14, weight: .semibold))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.black.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .padding(.top, 60)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
            Spacer()
        }
        .animation(.easeInOut, value: showToast)
    }
}

#Preview {
    MainDashboardView()
        .environmentObject(DashboardViewModel())
}
