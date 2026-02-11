//
//  MemoryModel.swift
//  Stivo
//
//  Created by dina alswailem on 20/08/1447 AH.
//

import SwiftUI
import UIKit

// MARK: - Models
struct Memory: Identifiable, Equatable {
    let id = UUID()
    var image: UIImage
    var note: String
}

struct SelectedImage: Identifiable {
    let id = UUID()
    let image: UIImage
}
enum Frequency: String, CaseIterable, Identifiable, Codable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"

    var id: String { rawValue }
}



struct Goal: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String
    var description: String
    var startDate: Date
    var endDate: Date
    var frequency: Frequency
    var isCompleted: Bool = false
}



