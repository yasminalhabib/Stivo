//
//  MemoryViewModel.swift
//  Stivo
//
//  Created by dina alswailem on 20/08/1447 AH.
//

import SwiftUI
import UIKit
import Combine

final class MemoryViewModel: ObservableObject {

    @Published var memories: [Memory] = []
    @Published var showPicker = false
    @Published var selectedImage: SelectedImage?

    // New: picker source selection for Add flow
    @Published var showAddSourceDialog = false
    @Published var addPickerSource: UIImagePickerController.SourceType = .photoLibrary

    // للتعديل
    @Published var editingMemory: Memory?

    // للحذف مع تنبيه
    @Published var memoryToDelete: Memory?
    @Published var showDeleteAlert = false
}
