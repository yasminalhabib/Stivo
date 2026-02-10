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
        NavigationStack{
            ZStack {
                
                // الخلفية من Assets
                Color("background")
                    .ignoresSafeArea()
                VStack {
                    Spacer()
                    
                    HStack {
                        Image("pp")   // اسم الصورة في Assets
                            .resizable()
                            .scaledToFit()
                            .frame(width: 140)
                            .opacity(0.6)   // عشان تصير خفيفة
                            .padding(.bottom, 170)
                        
                        Spacer()
                    }
                    .padding(.bottom, 40)   // تنزلها تحت شوي
                }
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
                ScrollView{
                    
                    
                    VStack(alignment: .center, spacing: 20) {
                        DashboardCard(
                            progress: Double(viewModel.completionPercentage(for: selectedPeriod)) / 100, title: "daily actions"
                        )
                        PeriodSelector(selectedPeriod: $selectedPeriod)
                            .frame(width:100,alignment: .init(horizontal: .center, vertical: .center))
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
                                    .shadow(color: .black.opacity(0.15), radius: 5, y: 4)
                                    .cornerRadius(22)
                                    .shadow(radius: 5, x: 0, y: 5)
                            }
                            
                            
                        }
                        
                        MemorySection(viewModel: viewModel)
                        
                    }
                    
                }
                
                // Floating Plus Button
                VStack {
                    Spacer()

                    Button {
                        showCategoriesSheet = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 55, height: 55)
                            .background(Color("Color"))
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.15), radius: 5, y: 3)
                    }
                    .padding(.bottom, 25)
                }
                
            }
            .sheet(isPresented: $showCategoriesSheet) {
                CategoriesSheetView { selectedCategory in
                    print(selectedCategory)
                }
                
            }
        }
    }
    
}
#Preview {
    MainDashboardView()
}
