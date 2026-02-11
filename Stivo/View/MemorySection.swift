//
//  MemorySection.swift
//  Stivo
//
//  Created by aisha alh on 23/08/1447 AH.
//
import SwiftUI

struct MemorySection: View {
    @ObservedObject var viewModel: DashboardViewModel
    @State private var showMemoryScreen = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            
            HStack {
                Text("Memory")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.horizontal,10)
                Spacer()
                
                Button {
                    showMemoryScreen = true
                } label: {
                    Image(systemName: "plus")
                    
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 38, height: 38)
                        .background((Color(red: 255/255, green: 182/255, blue: 149/255)))
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.15), radius: 5, y: 3)
                }
            }
            
            if viewModel.memories.isEmpty {
                Text("No memories yet")
                    .foregroundColor(.gray)
                    .font(.subheadline)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.memories, id: \.self) { data in
                            if let image = UIImage(data: data) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .padding(.horizontal, 30)
                            }
                        }

                    }
                }
            }
            //        .padding(.horizontal, 20)
            //        .background(
            // Navigation مخفي يشتغل عند الضغط
            NavigationLink(
                destination: MemoryScreen(viewModel: viewModel),
                isActive: $showMemoryScreen
            ) {
                EmptyView()
            }
            
        }
    }
}
#Preview {
    MemorySection(viewModel: DashboardViewModel())
        .padding()
        .background(Color.gray.opacity(0.1))
}
