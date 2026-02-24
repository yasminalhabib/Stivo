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
                
                Color("background").ignoresSafeArea()
                
                // 🖼 الخلفية ثابتة
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
                        
                        DashboardCard(
                            progress: calculatedProgress,
                            title: selectedPeriod
                        )
                        
                        // PeriodSelector على اليمين وأوسع شوي
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
                                    .padding(.horizontal)
                                
                                LazyVStack(spacing: 18) {
                                    ForEach(goalsForProgress) { goal in
                                        goalRow(goal: goal)
                                    }
                                }
                                
                                // ✅ زر Add more goals على اليمين باللون الرمادي
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
            
            // Toast عند الإنجاز
            .overlay(toastView)
            
            // MemorySection أسفل الشاشة
            .safeAreaInset(edge: .bottom) {
                MemorySection()
                    .background(Color("background").ignoresSafeArea())
            }
            
            .sheet(isPresented: $showCategoriesSheet) {
                CategoriesSheet()
            }
        }
    }
}

//////////////////////////////////////////////////////////////
// MARK: - Goal Row (Timeline Style)
//////////////////////////////////////////////////////////////

extension MainDashboardView {
    
    private func goalRow(goal: Goal) -> some View {
        
        let currentGoals = goalsForProgress
        let index = currentGoals.firstIndex(where: { $0.id == goal.id }) ?? 0
        
        return HStack(alignment: .top, spacing: 15) {
            
            // Timeline مع التشيك وخط عمودي
            VStack(spacing: 0) {
                
                Button {
                    withAnimation(.easeInOut) { toggleGoal(goal) }
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
                        .frame(width: 2, height: 45)
                }
            }
            
            // Card
            VStack(alignment: .leading, spacing: 4) {
                
                Text(goal.title)
                    .font(.system(size: 15, weight: .medium))
                    .strikethrough(goal.isCompleted, color: .gray)
                    .foregroundColor(goal.isCompleted ? .gray : .primary)
                
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
            
            Spacer()
        }
        .padding(.horizontal)
        .modifier(SwipeModifier(goal: goal, deleteAction: deleteGoal))
    }
}

//////////////////////////////////////////////////////////////
// MARK: - Logic
//////////////////////////////////////////////////////////////

extension MainDashboardView {
    
    private func toggleGoal(_ goal: Goal) {
        
        if let index = viewModel.sportGoals.firstIndex(where: { $0.id == goal.id }) {
            viewModel.sportGoals[index].isCompleted.toggle()
            if viewModel.sportGoals[index].isCompleted { triggerToast() }
        }
        if let index = viewModel.workGoals.firstIndex(where: { $0.id == goal.id }) {
            viewModel.workGoals[index].isCompleted.toggle()
            if viewModel.workGoals[index].isCompleted { triggerToast() }
        }
        if let index = viewModel.financeGoals.firstIndex(where: { $0.id == goal.id }) {
            viewModel.financeGoals[index].isCompleted.toggle()
            if viewModel.financeGoals[index].isCompleted { triggerToast() }
        }
        if let index = viewModel.careGoals.firstIndex(where: { $0.id == goal.id }) {
            viewModel.careGoals[index].isCompleted.toggle()
            if viewModel.careGoals[index].isCompleted { triggerToast() }
        }
    }
    
    private func deleteGoal(_ goal: Goal) {
        viewModel.sportGoals.removeAll { $0.id == goal.id }
        viewModel.workGoals.removeAll { $0.id == goal.id }
        viewModel.financeGoals.removeAll { $0.id == goal.id }
        viewModel.careGoals.removeAll { $0.id == goal.id }
    }
    
    private func triggerToast() {
        showToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation { showToast = false }
        }
    }
    
    private func categoryName(for goal: Goal) -> String {
        if viewModel.sportGoals.contains(where: { $0.id == goal.id }) { return "Sport" }
        if viewModel.workGoals.contains(where: { $0.id == goal.id }) { return "Work" }
        if viewModel.financeGoals.contains(where: { $0.id == goal.id }) { return "Finance" }
        if viewModel.careGoals.contains(where: { $0.id == goal.id }) { return "Care" }
        return ""
    }
}

//////////////////////////////////////////////////////////////
// MARK: - Data
//////////////////////////////////////////////////////////////

extension MainDashboardView {
    
    private var allGoals: [Goal] {
        viewModel.sportGoals
        + viewModel.workGoals
        + viewModel.financeGoals
        + viewModel.careGoals
    }
    
    private var goalsForProgress: [Goal] {
        switch selectedPeriod {
        case "Weekly Actions": return allGoals.filter { $0.frequency == .weekly }
        case "Monthly Actions": return allGoals.filter { $0.frequency == .monthly }
        default: return allGoals.filter { $0.frequency == .daily }
        }
    }
    
    private var calculatedProgress: Double {
        let completed = goalsForProgress.filter { $0.isCompleted }.count
        return goalsForProgress.isEmpty ? 0 :
        Double(completed) / Double(goalsForProgress.count)
    }
}

//////////////////////////////////////////////////////////////
// MARK: - Toast
//////////////////////////////////////////////////////////////

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

//////////////////////////////////////////////////////////////
// MARK: - Swipe Delete (السحب لليسار)
//////////////////////////////////////////////////////////////

struct SwipeModifier: ViewModifier {
    
    let goal: Goal
    let deleteAction: (Goal) -> Void
    
    func body(content: Content) -> some View {
        content
            .swipeActions(edge: .trailing) {   // السحب لليسار
                Button(role: .destructive) {
                    deleteAction(goal)
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
    }
}

#Preview {
    MainDashboardView()
        .environmentObject(DashboardViewModel())
}
#Preview {
    MainDashboardView()
        .environmentObject(DashboardViewModel())
}
