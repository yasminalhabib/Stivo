//
//  DailyActionsViewModel.swift
//  Stivo
//
//  Created by aisha alh on 16/08/1447 AH.
//


//
//  DailyActionsViewModel.swift
//  DailyActionsApp
//
//  ViewModel for managing daily actions and memories
//
import Combine
import Foundation
import SwiftUI

class DailyActionsViewModel: ObservableObject {
    @Published var selectedCategory: String = "Daily Actions"
    @Published var todayActions: [ActionItem] = []
    @Published var weeklyActions: [ActionItem] = []
    @Published var monthlyActions: [ActionItem] = []
    @Published var tomorrowActions: [ActionItem] = []
    @Published var memories: [MemoryItem] = []
   
   
    init() {
        loadData()
    }
    
    private func loadData() {
        // Today's actions
        todayActions = [
            ActionItem(title: "Read 8 pages of Quraan", isCompleted: true, category: .today),
            ActionItem(title: "Walk 8000 steps", isCompleted: true, category: .today)
        ]
        
        // Tomorrow's actions
        tomorrowActions = [
            ActionItem(title: "Hair care", isCompleted: false, category: .tomorrow)
        ]
        
        // Memories
        memories = [
            MemoryItem(imageName: "memory1"),
            MemoryItem(imageName: "memory2")
        ]
    }
    
    var completionPercentage: Double {
        switch selectedCategory {
               case "Daily Actions":
                   return progress(for: todayActions)
               case "Weekly Actions":
                   return progress(for: weeklyActions)
               case "Monthly Actions":
                   return progress(for: monthlyActions)
               default:
                   return 0
               }
           

    }
    
    private func progress(for actions: [ActionItem]) -> Double {
        guard !actions.isEmpty else { return 0 }
        let completed = actions.filter { $0.isCompleted }.count
        return Double(completed) / Double(actions.count)
    }
    
    
    func toggleAction(_ action: ActionItem) {
        if let index = todayActions.firstIndex(where: { $0.id == action.id }) {
            todayActions[index].isCompleted.toggle()
        } else if let index = tomorrowActions.firstIndex(where: { $0.id == action.id }) {
            tomorrowActions[index].isCompleted.toggle()
        }
    }
}
