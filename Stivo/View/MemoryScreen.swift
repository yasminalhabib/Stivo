//
//  MemoryScreen.swift
//  Stivo
//
//  Created by dina alswailem on 20/08/1447 AH.
//

import SwiftUI
import UIKit

// MARK: - Main Screen
struct MemoryScreen: View {

    @StateObject private var vm = MemoryViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                // Background color
                Color(red: 0.956, green: 0.956, blue: 0.956)
                    .ignoresSafeArea()

                // Bottom plant image
                VStack {
                    Spacer()
                    Image("pp")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 160)
                        .padding(.bottom, -35)
                }

                VStack(spacing: 0) {
                    // Top bar
                    HStack {
                        Button {
                            // لاحقًا لو فيه رجوع
                        } label: {
                            Image("back_arrow")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)

                    // Use List to support swipe actions cleanly
                    List {
                        ForEach(vm.memories) { memory in
                            MemoryCard(
                                image: memory.image,
                                onEdit: {
                                    vm.editingMemory = memory
                                }
                            )
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .padding(.vertical, 6)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    vm.memoryToDelete = memory
                                    vm.showDeleteAlert = true
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                .tint(.orange)
                            }
                        }

                        // كرت إضافة صورة
                        Button {
                            // Show chooser: Camera or Photo Library
                            vm.showAddSourceDialog = true
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 28)
                                    .fill(Color.white)
                                    .frame(height: 180)

                                Image(systemName: "photo.badge.plus")
                                    .font(.system(size: 36))
                                    .foregroundColor(.orange)
                            }
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .padding(.vertical, 10)
                        .confirmationDialog("Choose Source", isPresented: $vm.showAddSourceDialog, titleVisibility: .visible) {
                            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                                Button("Camera") {
                                    vm.addPickerSource = .camera
                                    vm.showPicker = true
                                }
                            }
                            Button("Photo Library") {
                                vm.addPickerSource = .photoLibrary
                                vm.showPicker = true
                            }
                            Button("Cancel", role: .cancel) { }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
        }
        // تنبيه الحذف
        .alert("Delete Memory?", isPresented: $vm.showDeleteAlert, presenting: vm.memoryToDelete) { memory in
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let index = vm.memories.firstIndex(of: memory) {
                    vm.memories.remove(at: index)
                }
            }
        } message: { _ in
            Text("Are you sure you want to delete this memory?")
        }

        // اختيار صورة جديدة (Add flow) with chosen source
        .sheet(isPresented: $vm.showPicker) {
            ImagePicker(image: $vm.selectedImage, sourceType: vm.addPickerSource)
        }
        // إضافة ذاكرة جديدة
        .fullScreenCover(item: $vm.selectedImage) { selected in
            AddMemoryView(image: selected.image) { memory in
                vm.memories.append(memory)
            }
        }
        // تعديل ذاكرة
        .fullScreenCover(item: $vm.editingMemory) { memory in
            EditMemoryView(memory: memory) { updated in
                if let index = vm.memories.firstIndex(where: { $0.id == updated.id }) {
                    vm.memories[index] = updated
                }
            }
        }
    }
}

// MARK: - Memory Card
struct MemoryCard: View {
    let image: UIImage
    let onEdit: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 28))
                .clipped()

            // Edit icon
            Button {
                onEdit()
            } label: {
                Circle()
                    .fill(Color.orange)
                    .frame(width: 30, height: 30)
                    .overlay(
                        Image(systemName: "pencil")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                    )
            }
            .padding(10)
        }
    }
}

// MARK: - Add Memory Screen
struct AddMemoryView: View {

    let image: UIImage
    let onSave: (Memory) -> Void

    @State private var note = ""
    @Environment(\.dismiss) var dismiss

    var body: some View {
        MemoryEditorView(
            title: "Save Memory",
            image: image,
            note: note,
            onPickImage: nil,
            onCancel: { dismiss() },
            onSave: { newImage, newNote in
                onSave(Memory(image: newImage, note: newNote))
                dismiss()
            }
        )
    }
}

// MARK: - Edit Memory Screen
struct EditMemoryView: View {

    let memory: Memory
    let onSave: (Memory) -> Void

    @State private var note: String
    @State private var image: UIImage

    // Picker state for Edit flow
    @State private var showEditSourceDialog = false
    @State private var editPickerSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var showEditPicker = false

    @Environment(\.dismiss) var dismiss

    init(memory: Memory, onSave: @escaping (Memory) -> Void) {
        self.memory = memory
        self.onSave = onSave
        _note = State(initialValue: memory.note)
        _image = State(initialValue: memory.image)
    }

    var body: some View {
        MemoryEditorView(
            title: "Save Changes",
            image: image,
            note: note,
            onPickImage: {
                // Show chooser (Camera / Photo Library)
                showEditSourceDialog = true
            },
            onCancel: { dismiss() },
            onSave: { newImage, newNote in
                var updated = memory
                updated.image = newImage
                updated.note = newNote
                onSave(updated)
                dismiss()
            }
        )
        .confirmationDialog("Choose Source", isPresented: $showEditSourceDialog, titleVisibility: .visible) {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                Button("Camera") {
                    editPickerSource = .camera
                    showEditPicker = true
                }
            }
            Button("Photo Library") {
                editPickerSource = .photoLibrary
                showEditPicker = true
            }
            Button("Cancel", role: .cancel) { }
        }
        .sheet(isPresented: $showEditPicker) {
            ImagePicker(
                image: Binding(
                    get: { nil },
                    set: { newValue in
                        if let img = newValue?.image {
                            image = img
                        }
                    }
                ),
                sourceType: editPickerSource
            )
        }
    }
}

// MARK: - Shared Editor UI
struct MemoryEditorView: View {

    let title: String
    let image: UIImage
    @State var note: String

    var onPickImage: (() -> Void)? = nil
    let onCancel: () -> Void
    let onSave: (UIImage, String) -> Void

    var body: some View {
        ZStack {
            Color(red: 0.99, green: 0.94, blue: 0.9)
                .ignoresSafeArea()

            VStack(spacing: 20) {

                ZStack(alignment: .topTrailing) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 70))
                        .padding(.top)

                    if let onPickImage {
                        Button {
                            onPickImage()
                        } label: {
                            Circle()
                                .fill(Color.orange)
                                .frame(width: 34, height: 34)
                                .overlay(
                                    Image(systemName: "photo")
                                        .foregroundColor(.white)
                                )
                        }
                        .padding()
                    }
                }

                ZStack(alignment: .topLeading) {
                    TextEditor(text: $note)
                        .padding(.top, 24)
                        .padding(.horizontal, 20)
                        .background(Color.white.opacity(0.7))
                        .clipShape(RoundedRectangle(cornerRadius: 28))

                    if note.isEmpty {
                        Text("Write a short note ...")
                            .foregroundColor(.gray)
                            .padding(.top, 32)
                            .padding(.leading, 28)
                    }
                }
                .padding(.horizontal)

                HStack(spacing: 16) {
                    Button("Cancel") {
                        onCancel()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .clipShape(Capsule())

                    Button(title) {
                        onSave(image, note)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - Image Picker
struct ImagePicker: UIViewControllerRepresentable {

    @Binding var image: SelectedImage?
    let sourceType: UIImagePickerController.SourceType

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator

        // Use requested source if available, otherwise fall back to photo library
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            picker.sourceType = sourceType
        } else {
            picker.sourceType = .photoLibrary
        }
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {
            let picked = info[.originalImage] as? UIImage
            picker.dismiss(animated: true) {
                if let img = picked {
                    // Set after dismissal to avoid presentation conflicts
                    DispatchQueue.main.async {
                        self.parent.image = SelectedImage(image: img)
                    }
                }
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

#Preview {
    MemoryScreen()
}
