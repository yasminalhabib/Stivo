//
//  DashboardViewModel.swift
//  Stivo
//
//  Created by aisha alh on 23/08/1447 AH.
//

import SwiftUI
import Combine

struct ActionItem: Identifiable, Equatable {
    let id = UUID()
    var title: String
    var isCompleted: Bool
    var goalID: UUID?
}

final class DashboardViewModel: ObservableObject {
    @Published var sportGoals: [Goal] = []
    @Published var workGoals: [Goal] = []
    @Published var financeGoals: [Goal] = []
    @Published var careGoals: [Goal] = []
    func addGoal(_ goal: Goal, type: String) {
           switch type {
           case "Sport":
               sportGoals.append(goal)
           case "Work":
               workGoals.append(goal)
           case "Finance":
               financeGoals.append(goal)
           case "Care":
               careGoals.append(goal)
           default:
               break
           }
        let action = ActionItem(title: goal.title,
         isCompleted: goal.isCompleted,
            goalID: goal.id)
           
           switch goal.frequency {
           case .daily:
               dailyActions.append(action)
           case .weekly:
               weeklyActions.append(action)
           case .monthly:
               monthlyActions.append(action)
           }
       
       }
    var sportCompletionPercentage: Int {
           guard !sportGoals.isEmpty else { return 0 }
           let done = sportGoals.filter { $0.isCompleted }.count
           return Int((Double(done) / Double(sportGoals.count)) * 100)
       }

       var workCompletionPercentage: Int {
           guard !workGoals.isEmpty else { return 0 }
           let done = workGoals.filter { $0.isCompleted }.count
           return Int((Double(done) / Double(workGoals.count)) * 100)
       }

       var financeCompletionPercentage: Int {
           guard !financeGoals.isEmpty else { return 0 }
           let done = financeGoals.filter { $0.isCompleted }.count
           return Int((Double(done) / Double(financeGoals.count)) * 100)
       }

       var careCompletionPercentage: Int {
           guard !careGoals.isEmpty else { return 0 }
           let done = careGoals.filter { $0.isCompleted }.count
           return Int((Double(done) / Double(careGoals.count)) * 100)
       }
    var isNewUser: Bool {
        dailyActions.isEmpty &&
        weeklyActions.isEmpty &&
        monthlyActions.isEmpty
    }
    var hasAnyActions: Bool {
        !dailyActions.isEmpty || !weeklyActions.isEmpty || !monthlyActions.isEmpty
    }
    @Published var dailyActions: [ActionItem] = []

    @Published var weeklyActions: [ActionItem] = []

    @Published var monthlyActions: [ActionItem] = []

    // Default progress (used by the dashboard card). Currently based on Daily Actions.
    var completionPercentage: Int {
        let actions = dailyActions
        guard !actions.isEmpty else { return 0 }
        let done = actions.filter { $0.isCompleted }.count
        return Int((Double(done) / Double(actions.count)) * 100)
    }

    func toggle(_ action: ActionItem, category: String) {
        switch category {
        case "Weekly Actions":
            if let index = weeklyActions.firstIndex(where: { $0.id == action.id }) {
                weeklyActions[index].isCompleted.toggle()
            }
        case "Monthly Actions":
            if let index = monthlyActions.firstIndex(where: { $0.id == action.id }) {
                monthlyActions[index].isCompleted.toggle()
            }
        default:
            if let index = dailyActions.firstIndex(where: { $0.id == action.id }) {
                dailyActions[index].isCompleted.toggle()
            }
        }
    }
    func addAction(title: String, category: String) {
        let item = ActionItem(title: title, isCompleted: false)
        switch category {
        case "Weekly Actions":
            weeklyActions.append(item)
        case "Monthly Actions":
            monthlyActions.append(item)
        default:
            dailyActions.append(item)
        }
    }

    func completionPercentage(for category: String) -> Int {
        let actions: [ActionItem]
        switch category {
        case "Weekly Actions":
            actions = weeklyActions
        case "Monthly Actions":
            actions = monthlyActions
        default:
            actions = dailyActions
        }

        guard !actions.isEmpty else { return 0 }
        let done = actions.filter { $0.isCompleted }.count
        return Int((Double(done) / Double(actions.count)) * 100)
    }

    @Published var memories: [Data] = [] {
        didSet {
            saveMemories()
        }
    }

    init() {
        loadMemories()
    }

    private func saveMemories() {
        UserDefaults.standard.set(memories, forKey: "savedMemories")
    }

    private func loadMemories() {
        if let saved = UserDefaults.standard.object(forKey: "savedMemories") as? [Data] {
               memories = saved
           }
       }
    func addMemory(image: UIImage) {
        if let data = image.jpegData(compressionQuality: 0.8) {
            memories.append(data)
        }
    }
}
