//
//  ActionItem.swift
//  Stivo
//
//  Created by aisha alh on 16/08/1447 AH.
//

//
//  ActionItem.swift
//  DailyActionsApp
//
//  Model for daily action items
//

import Foundation

struct ActionItem: Identifiable {
    let id = UUID()
    let title: String
    var isCompleted: Bool
    let category: ActionCategory
}

enum ActionCategory {
    case today
    case tomorrow
}
