//
//  DashboardViewModel.swift
//  Stivo
//
//  Created by aisha alh on 23/08/1447 AH.
//

import SwiftUI
import Combine
import UserNotifications

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

    // MARK: - Goals (auto-save + notifications on every change)
    @Published var sportGoals: [Goal] = [] {
        didSet {
            save(sportGoals, forKey: "savedSportGoals")
            handleNotifications(new: sportGoals, old: oldValue)
        }
    }
    @Published var workGoals: [Goal] = [] {
        didSet {
            save(workGoals, forKey: "savedWorkGoals")
            handleNotifications(new: workGoals, old: oldValue)
        }
    }
    @Published var financeGoals: [Goal] = [] {
        didSet {
            save(financeGoals, forKey: "savedFinanceGoals")
            handleNotifications(new: financeGoals, old: oldValue)
        }
    }
    @Published var careGoals: [Goal] = [] {
        didSet {
            save(careGoals, forKey: "savedGoals")
            handleNotifications(new: careGoals, old: oldValue)
        }
    }

    // MARK: - Notification Handling
    private func handleNotifications(new newGoals: [Goal], old oldGoals: [Goal]) {
        // Cancel notifications for deleted goals
        oldGoals
            .filter { old in !newGoals.contains(where: { $0.id == old.id }) }
            .forEach { NotificationManager.shared.cancelNotification(for: $0.id) }

        // Schedule for new goals, reschedule for edited goals
        for goal in newGoals {
            if let old = oldGoals.first(where: { $0.id == goal.id }) {
                NotificationManager.shared.rescheduleIfNeeded(newGoal: goal, oldGoal: old)
            } else {
                NotificationManager.shared.scheduleNotification(for: goal)
            }
        }
    }

    // MARK: - Toggle
    func toggleGoal(id: UUID) {
        if let i = sportGoals.firstIndex(where: { $0.id == id })   { sportGoals[i].isCompleted.toggle(); return }
        if let i = workGoals.firstIndex(where: { $0.id == id })    { workGoals[i].isCompleted.toggle(); return }
        if let i = financeGoals.firstIndex(where: { $0.id == id }) { financeGoals[i].isCompleted.toggle(); return }
        if let i = careGoals.firstIndex(where: { $0.id == id })    { careGoals[i].isCompleted.toggle(); return }
    }

    // MARK: - Delete
    func deleteGoal(id: UUID) {
        sportGoals.removeAll   { $0.id == id }
        workGoals.removeAll    { $0.id == id }
        financeGoals.removeAll { $0.id == id }
        careGoals.removeAll    { $0.id == id }
    }

    // MARK: - Add Goal
    func addGoal(_ goal: Goal, type: String) {
        switch type {
        case "Sport":   sportGoals.append(goal)
        case "Other":   workGoals.append(goal)
        case "Finance": financeGoals.append(goal)
        case "Care":    careGoals.append(goal)
        default: break
        }

        let action = ActionItem(title: goal.title, isCompleted: goal.isCompleted, goalID: goal.id)
        switch goal.frequency {
        case .daily:   dailyActions.append(action)
        case .weekly:  weeklyActions.append(action)
        case .monthly: monthlyActions.append(action)
        }
    }

    // MARK: - Completion Percentages
    var sportCompletionPercentage: Int   { percentage(of: sportGoals) }
    var workCompletionPercentage: Int    { percentage(of: workGoals) }
    var financeCompletionPercentage: Int { percentage(of: financeGoals) }
    var careCompletionPercentage: Int    { percentage(of: careGoals) }

    private func percentage(of goals: [Goal]) -> Int {
        guard !goals.isEmpty else { return 0 }
        return Int((Double(goals.filter { $0.isCompleted }.count) / Double(goals.count)) * 100)
    }

    // MARK: - Actions
    @Published var dailyActions: [ActionItem] = []
    @Published var weeklyActions: [ActionItem] = []
    @Published var monthlyActions: [ActionItem] = []

    var isNewUser: Bool     { dailyActions.isEmpty && weeklyActions.isEmpty && monthlyActions.isEmpty }
    var hasAnyActions: Bool { !dailyActions.isEmpty || !weeklyActions.isEmpty || !monthlyActions.isEmpty }

    var completionPercentage: Int {
        guard !dailyActions.isEmpty else { return 0 }
        return Int((Double(dailyActions.filter { $0.isCompleted }.count) / Double(dailyActions.count)) * 100)
    }

    func completionPercentage(for category: String) -> Int {
        let actions: [ActionItem]
        switch category {
        case "Weekly Actions":  actions = weeklyActions
        case "Monthly Actions": actions = monthlyActions
        default:                actions = dailyActions
        }
        guard !actions.isEmpty else { return 0 }
        return Int((Double(actions.filter { $0.isCompleted }.count) / Double(actions.count)) * 100)
    }

    func toggle(_ action: ActionItem, category: String) {
        switch category {
        case "Weekly Actions":
            if let i = weeklyActions.firstIndex(where: { $0.id == action.id })  { weeklyActions[i].isCompleted.toggle() }
        case "Monthly Actions":
            if let i = monthlyActions.firstIndex(where: { $0.id == action.id }) { monthlyActions[i].isCompleted.toggle() }
        default:
            if let i = dailyActions.firstIndex(where: { $0.id == action.id })   { dailyActions[i].isCompleted.toggle() }
        }
    }

    func addAction(title: String, category: String) {
        let item = ActionItem(title: title, isCompleted: false)
        switch category {
        case "Weekly Actions":  weeklyActions.append(item)
        case "Monthly Actions": monthlyActions.append(item)
        default:                dailyActions.append(item)
        }
    }

    // MARK: - Memories
    @Published var memories: [StoredMemory] = [] {
        didSet { saveMemories() }
    }

    init() {
        loadMemories()
        loadAllGoals()
    }

    private let memoriesKey = "savedMemories_v2"

    private func saveMemories() {
        if let data = try? JSONEncoder().encode(memories) {
            UserDefaults.standard.set(data, forKey: memoriesKey)
        }
    }

    private func loadMemories() {
        guard let data = UserDefaults.standard.data(forKey: memoriesKey) else {
            if let oldArray = UserDefaults.standard.object(forKey: "savedMemories") as? [Data] {
                self.memories = oldArray.map { StoredMemory(imageData: $0, note: "") }
                saveMemories()
                UserDefaults.standard.removeObject(forKey: "savedMemories")
            }
            return
        }
        self.memories = (try? JSONDecoder().decode([StoredMemory].self, from: data)) ?? []
    }

    func addMemory(image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        memories.append(StoredMemory(imageData: data, note: ""))
    }

    func addMemory(from memory: Memory) {
        guard let data = memory.image.jpegData(compressionQuality: 0.8) else { return }
        memories.append(StoredMemory(id: memory.id, imageData: data, note: memory.note))
    }

    func updateMemory(from memory: Memory) {
        guard let data = memory.image.jpegData(compressionQuality: 0.8) else { return }
        if let i = memories.firstIndex(where: { $0.id == memory.id }) {
            memories[i].imageData = data
            memories[i].note = memory.note
        }
    }

    func deleteMemory(id: UUID) {
        memories.removeAll { $0.id == id }
    }

    // MARK: - Persistence
    private func save(_ goals: [Goal], forKey key: String) {
        if let data = try? JSONEncoder().encode(goals) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func loadAllGoals() {
        sportGoals   = loadGoals(forKey: "savedSportGoals")
        workGoals    = loadGoals(forKey: "savedWorkGoals")
        financeGoals = loadGoals(forKey: "savedFinanceGoals")
        careGoals    = loadGoals(forKey: "savedGoals")
    }

    private func loadGoals(forKey key: String) -> [Goal] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([Goal].self, from: data)
        else { return [] }
        return decoded
    }
}
