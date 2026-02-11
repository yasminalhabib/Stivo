//
//  MainDashboardView.swift
//  Stivo
//
//  Created by aisha alh on 23/08/1447 AH.
//
import SwiftUI

struct MainDashboardView: View {
    
    @StateObject private var viewModel = DashboardViewModel()
    @State private var selectedPeriod: String = "Daily Actions"
    @State private var showCategoriesSheet = false
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                
                Color("background")
                    .ignoresSafeArea()
                
                // الخلفية يسار
                VStack {
                    Spacer()
                    
                    HStack {
                        Image("pp")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 140)
                            .opacity(0.6)
                            .padding(.bottom, 170)
                        
                        Spacer()
                    }
                    .padding(.bottom, 40)
                }
                
                // الخلفية يمين
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Image("Image1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 140)
                            .opacity(0.6)
                    }
                    .padding(.bottom, 400)
                }
                
                ScrollView {
                    
                    VStack(alignment: .center, spacing: 20) {
                        
                        DashboardCard(
                            progress: Double(viewModel.completionPercentage(for: selectedPeriod)) / 100,
                            title: selectedPeriod
                        )
                        
                        PeriodSelector(selectedPeriod: $selectedPeriod)
                            .frame(width: 100)
                            .frame(maxWidth: 289, alignment: .leading)
                        
                        let actions = {
                            switch selectedPeriod {
                            case "Weekly Actions":
                                return viewModel.weeklyActions
                            case "Monthly Actions":
                                return viewModel.monthlyActions
                            default:
                                return viewModel.dailyActions
                            }
                        }()
                        
                        if actions.isEmpty {
                            
                            Image("girl")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                            
                            Text("Start your goals journey!")
                                .font(.system(size: 16, weight: .bold))
                                .padding(.top, 10)
                            
                            Text("All your goals, organized in one place. We’re here to help you stay on track and grow ✨")
                                .font(.custom("Helvetica", size: 12))
                                .foregroundColor(Color(red: 138/255, green: 136/255, blue: 136/255))
                                .frame(width: 306)
                                .multilineTextAlignment(.center)
                                .lineLimit(5)
                            
                            Button {
                                showCategoriesSheet = true
                            } label: {
                                Text("Add your goals")
                                    .frame(width: 150, height: 50)
                                    .background(Color("Color"))
                                    .foregroundColor(.white)
                                    .cornerRadius(22)
                                    .shadow(color: .black.opacity(0.15), radius: 5, y: 4)
                            }
                        }
                        
                        MemorySection(viewModel: viewModel)
                    }
                }
            }
            
            // 🔥 استدعاء الشيت هنا
            .sheet(isPresented: $showCategoriesSheet) {
                CategoriesSheetView { category in
                    print(category.title)
                }
                .presentationDetents([.height(400)])
                .presentationDragIndicator(.hidden)
            }
        }
    }
}
#Preview {
    MainDashboardView()
}
