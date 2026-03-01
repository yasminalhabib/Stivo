//
//  MemorySection.swift
//  Stivo
//
//  Created by aisha alh on 23/08/1447 AH.
//
import SwiftUI

struct MemorySection: View {
    @EnvironmentObject var viewModel: DashboardViewModel
    @State private var showMemoryScreen = false
    @State private var editingMemory: Memory? = nil
    
    // ألوان قريبة من التصميم بالصورة
    private let accent = Color(red: 255/255, green: 182/255, blue: 149/255) // برتقالي فاتح للزر
    private let titleColor = Color(red: 1.0, green: 0.55, blue: 0.30)       // لون عنوان Memory
    private let cardBackground = Color.white
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(cardBackground)
                .shadow(color: .black.opacity(0.08), radius: 10, y: 4)
            
            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .center) {
                    Text("Memory")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(titleColor)
                    
                    Spacer()
                }
                .padding(.horizontal, 6)
                
                if viewModel.memories.isEmpty {
                    VStack(spacing: 12) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.05), radius: 6, y: 3)
                                .frame(height: 110)
                            
                            Text("No memories yet")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                        }
                        
                        // زر إضافة يظهر عندما لا توجد ذكريات
                        Button {
                            showMemoryScreen = true
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "plus")
                                    .font(.system(size: 16, weight: .bold))
                                Text("Add your first memory")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(accent.opacity(0.95))
                            .clipShape(Capsule())
                            .shadow(color: .black.opacity(0.12), radius: 6, y: 3)
                        }
                        .padding(.top, 4)
                    }
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(viewModel.memories) { stored in
                                if let image = UIImage(data: stored.imageData) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 220, height: 140)
                                        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                                        .shadow(color: .black.opacity(0.10), radius: 8, y: 4)
                                        .onTapGesture {
                                            // افتحي شاشة التعديل مباشرة عند الضغط على الصورة
                                            editingMemory = Memory(id: stored.id, image: image, note: stored.note)
                                        }
                                }
                            }
                            
                            // زر إضافة صغير داخل السكرول
                            Button {
                                showMemoryScreen = true
                            } label: {
                                Circle()
                                    .fill(accent.opacity(0.9))
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Image(systemName: "plus")
                                            .foregroundColor(.white)
                                            .font(.system(size: 18, weight: .bold))
                                    )
                                    .shadow(color: .black.opacity(0.12), radius: 6, y: 3)
                            }
                            .padding(.leading, 4)
                        }
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                    }
                }
                
                // NavigationLink مخفي للتنقل
                NavigationLink(
                    destination: MemoryScreen(),
                    isActive: $showMemoryScreen
                ) {
                    EmptyView()
                }
                .hidden()
            }
            .padding(16)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 230)
        .padding(.horizontal, 16)
        // شاشة التعديل تظهر كـ fullScreenCover
        .fullScreenCover(item: $editingMemory) { memory in
            EditMemoryView(memory: memory) { updated in
                // حفظ التعديلات في الـ ViewModel
                viewModel.updateMemory(from: updated)
                // ما نحتاج نحدث شيء محلياً لأن القائمة تُبنى من viewModel.memories مباشرة
            }
            .environmentObject(viewModel)
        }
    }
}

#Preview {
    MemorySection()
        .environmentObject(DashboardViewModel())
        .padding()
        .background(Color.gray.opacity(0.1))
}

