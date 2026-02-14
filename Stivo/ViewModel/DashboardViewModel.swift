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

struct StoredMemory: Identifiable, Codable, Equatable {
    var id: UUID
    var imageData: Data
    var note: String

    init(id: UUID = UUID(), imageData: Data, note: String) {
        self.id = id
        self.imageData = imageData
        self.note = note
    }
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

    // MARK: - Memories
    @Published var memories: [StoredMemory] = [] {
        didSet {
            saveMemories()
        }
    }

    init() {
        loadMemories()
    }

    private let memoriesKey = "savedMemories_v2"

    private func saveMemories() {
        do {
            let data = try JSONEncoder().encode(memories)
            UserDefaults.standard.set(data, forKey: memoriesKey)
        } catch {
            print("Failed to save memories: \(error)")
        }
    }

    private func loadMemories() {
        guard let data = UserDefaults.standard.data(forKey: memoriesKey) else {
            // Migrate from older storage if existed (array of Data)
            if let oldArray = UserDefaults.standard.object(forKey: "savedMemories") as? [Data] {
                self.memories = oldArray.map { StoredMemory(imageData: $0, note: "") }
                saveMemories()
                UserDefaults.standard.removeObject(forKey: "savedMemories")
            }
            return
        }
        do {
            let decoded = try JSONDecoder().decode([StoredMemory].self, from: data)
            self.memories = decoded
        } catch {
            print("Failed to load memories: \(error)")
            self.memories = []
        }
    }

    // Convenience for legacy callers: stores image with empty note
    func addMemory(image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        let stored = StoredMemory(imageData: data, note: "")
        memories.append(stored)
    }

    // New APIs used by MemoryScreen
    func addMemory(from memory: Memory) {
        guard let data = memory.image.jpegData(compressionQuality: 0.8) else { return }
        let stored = StoredMemory(id: memory.id, imageData: data, note: memory.note)
        memories.append(stored)
    }

    func updateMemory(from memory: Memory) {
        guard let data = memory.image.jpegData(compressionQuality: 0.8) else { return }
        if let index = memories.firstIndex(where: { $0.id == memory.id }) {
            memories[index].imageData = data
            memories[index].note = memory.note
        }
    }

    func deleteMemory(id: UUID) {
        memories.removeAll { $0.id == id }
    }
}
