//
//  MainView.swift
//  DailyActionsApp
//
//  Main view displaying daily actions and progress
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = DailyActionsViewModel()
    
    var body: some View {
        ZStack {
            // Background color
            Color(red: 0.98, green: 0.92, blue: 0.92)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                   
                    
                    // Greeting
                   
                    
                    // Daily Actions Card
                    DailyActionsCard(progress: viewModel.completionPercentage)
                        .padding(.vertical, 10)
                    
                    // Dropdown
                    Menu {
                        Button("Daily Actions") {
                            viewModel.selectedCategory = "Daily Actions"
                        }
                        
                        Button("Weekly Actions") {
                            viewModel.selectedCategory = "Weekly Actions"
                        }
                        
                        Button("Monthly Actions") {
                            viewModel.selectedCategory = "Monthly Actions"
                        }
                    } label: {
                        HStack {
                            Text(viewModel.selectedCategory)
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.down")
                                .foregroundColor(.black)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    // Today's Actions Section
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Today's Actions")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            // Decorative leaf
                            LeafDecoration()
                        }
                        .padding(.horizontal)
                        
                        ForEach(viewModel.todayActions) { action in
                            ActionRow(action: action) {
                                viewModel.toggleAction(action)
                            }
                        }
                    }
                    
                    // Tomorrow's Actions Section
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Tomorrow's Actions")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            Text("see all goals")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal)
                        
                        ForEach(viewModel.tomorrowActions) { action in
                            ActionRow(action: action) {
                                viewModel.toggleAction(action)
                            }
                        }
                    }
                    .padding(.top, 10)
                    
                    // Decorative leaf at bottom left
                    HStack {
                        LeafDecoration()
                            .rotationEffect(.degrees(45))
                        Spacer()
                    }
                    .padding(.leading)
                    
                    // Memory Section
                    MemorySection(memories: viewModel.memories)
                    
                    Spacer(minLength: 30)
                }
            }
        }
    }
}

#Preview {
    MainView()
}


