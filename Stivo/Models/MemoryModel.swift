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
