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
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                
                Color("background")
                    .ignoresSafeArea()
                
                // الخلفية يسار
                VStack {
                    Spacer()
                    
                    HStack {
                        Image("pp")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 140)
                            .opacity(0.6)
                            .padding(.bottom, 170)
                        
                        Spacer()
                    }
                    .padding(.bottom, 40)
                }
                
                // الخلفية يمين
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
                    .padding(.bottom, 400)
                }
                
                ScrollView {
                    VStack(alignment: .center, spacing: 20) {
                        
                        let progressValue = calculatedProgress

                        DashboardCard(
                            progress: progressValue,
                            title: selectedPeriod
                        )
                        .animation(.easeInOut(duration: 0.6), value: progressValue)
                        
                        PeriodSelector(selectedPeriod: $selectedPeriod)
                            .frame(width: 100)
                            .frame(maxWidth: 289, alignment: .leading)
                        
                        if !allGoals.isEmpty {
                            VStack(alignment: .leading, spacing: 24) {

                                Text("Your Goals")
                                    .font(.system(size: 18, weight: .bold))
                                    .padding(.horizontal)

                                LazyVStack(spacing: 16) {
                                    ForEach(goalsForProgress.filter { !$0.isCompleted }) { goal in
                                        goalRow(goal: goal)
                                    }
                                }
                                .animation(.easeInOut(duration: 0.35), value: allGoals)
                            }
                            .padding(.vertical)
                        }
                        
                        if allGoals.isEmpty {
                            
                            Image("girl")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                            
                            Text("Start your goals journey!")
                                .font(.system(size: 16, weight: .bold))
                                .padding(.top, 10)
                            
                            Text("All your goals, organized in one place. We’re here to help you stay on track and grow ✨")
                                .font(.custom("Helvetica", size: 12))
                                .foregroundColor(Color(red: 138/255, green: 136/255, blue: 136/255))
                                .frame(width: 306)
                                .multilineTextAlignment(.center)
                                .lineLimit(5)
                            
                            Button {
                                showCategoriesSheet = true
                            } label: {
                                Text("Add your goals")
                                    .frame(width: 150, height: 50)
                                    .background(Color("Color"))
                                    .foregroundColor(.white)
                                    .cornerRadius(22)
                                    .shadow(color: .black.opacity(0.15), radius: 5, y: 4)
                            }
                        }
                        
                        // شلّينا MemorySection من هنا عشان ما تتحرك مع السكrol
                    }
                    .padding(.bottom, 0) // ما نحتاج padding لأن safeAreaInset يضبط المساحة
                }
            }
            
            // Toast Overlay
            .overlay(
                VStack {
                    if showToast {
                        Text("Completed 🎉")
                            .font(.system(size: 14, weight: .semibold))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.black.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .transition(.move(edge: .top).combined(with: .opacity))
                            .padding(.top, 60)
                    }
                    Spacer()
                }
            )
            .animation(.easeInOut(duration: 0.3), value: showToast)
            
            // تثبيت الميموري تحت
            .safeAreaInset(edge: .bottom) {
                MemorySection()
                    .background(
                        Color("background")
                            .ignoresSafeArea()
                    )
            }
            .sheet(isPresented: $showCategoriesSheet) {
                CategoriesSheet()
            }
        }
    }
    
    private func toggleGoal(_ goal: Goal) {
        if let index = viewModel.sportGoals.firstIndex(where: { $0.id == goal.id }) {
            viewModel.sportGoals[index].isCompleted.toggle()
            if viewModel.sportGoals[index].isCompleted {
                triggerToast()
            }
        }
        if let index = viewModel.workGoals.firstIndex(where: { $0.id == goal.id }) {
            viewModel.workGoals[index].isCompleted.toggle()
            if viewModel.workGoals[index].isCompleted {
                triggerToast()
            }
        }
        if let index = viewModel.financeGoals.firstIndex(where: { $0.id == goal.id }) {
            viewModel.financeGoals[index].isCompleted.toggle()
            if viewModel.financeGoals[index].isCompleted {
                triggerToast()
            }
        }
        if let index = viewModel.careGoals.firstIndex(where: { $0.id == goal.id }) {
            viewModel.careGoals[index].isCompleted.toggle()
            if viewModel.careGoals[index].isCompleted {
                triggerToast()
            }
        }
    }
    private func triggerToast() {
        showToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                showToast = false
            }
        }
    }

    private func deleteGoal(_ goal: Goal) {
        viewModel.sportGoals.removeAll { $0.id == goal.id }
        viewModel.workGoals.removeAll { $0.id == goal.id }
        viewModel.financeGoals.removeAll { $0.id == goal.id }
        viewModel.careGoals.removeAll { $0.id == goal.id }
    }

    private func categoryName(for goal: Goal) -> String {
        if viewModel.sportGoals.contains(where: { $0.id == goal.id }) {
            return "Sport"
        }
        if viewModel.workGoals.contains(where: { $0.id == goal.id }) {
            return "Work"
        }
        if viewModel.financeGoals.contains(where: { $0.id == goal.id }) {
            return "Finance"
        }
        if viewModel.careGoals.contains(where: { $0.id == goal.id }) {
            return "Care"
        }
        return ""
    }
    
    @ViewBuilder
    private func goalRow(goal: Goal) -> some View {
        HStack(spacing: 12) {
            Button {
                withAnimation(.easeInOut) {
                    toggleGoal(goal)
                }
            } label: {
                Circle()
                    .stroke(Color.gray, lineWidth: 2)
                    .frame(width: 26, height: 26)
                    .overlay(
                        goal.isCompleted ?
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                        : nil
                    )
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(goal.title)
                    .font(.system(size: 15, weight: .medium))
                    .strikethrough(goal.isCompleted, color: .gray)
                    .foregroundColor(goal.isCompleted ? .gray : .primary)

                Text(categoryName(for: goal))
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.95))
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black.opacity(0.03), lineWidth: 1)
        )
        .padding(.horizontal)
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .modifier(SwipeModifier(goal: goal, deleteAction: deleteGoal))
    }
    
    private var allGoals: [Goal] {
        viewModel.sportGoals
        + viewModel.workGoals
        + viewModel.financeGoals
        + viewModel.careGoals
    }

    private var goalsForProgress: [Goal] {
        switch selectedPeriod {
        case "Weekly Actions":
            return allGoals.filter { $0.frequency == .weekly }
        case "Monthly Actions":
            return allGoals.filter { $0.frequency == .monthly }
        default:
            return allGoals.filter { $0.frequency == .daily }
        }
    }

    private var calculatedProgress: Double {
        let completed = goalsForProgress.filter { $0.isCompleted }.count
        return goalsForProgress.isEmpty ? 0 : Double(completed) / Double(goalsForProgress.count)
    }
}

struct SwipeModifier: ViewModifier {
    let goal: Goal
    let deleteAction: (Goal) -> Void

    func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content
                .swipeActions {
                    Button(role: .destructive) {
                        deleteAction(goal)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
        } else {
            content
        }
    }
}

#Preview {
    MainDashboardView()
        .environmentObject(DashboardViewModel())
}
