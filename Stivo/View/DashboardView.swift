//
//  dailyactions.swift
//  stivo
//
//  Created by s on 17/08/1447 AH.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var viewModel: DashboardViewModel
    @Environment(\.dismiss) private var dismiss
    
    // جلب البيانات من UserDefaults
    @State private var sportGoals: [Goal] = []
    @State private var workGoals: [Goal] = []
    @State private var financeGoals: [Goal] = []
    @State private var careGoals: [Goal] = []

    var body: some View {
        NavigationStack {
            ZStack {
                Image("bk2")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        Text("Daily Actions")
                            .font(.title)
                            .bold()
                            .padding(.top, 20)
                        
                        ForEach(["Sport", "Work", "Finance", "Care"], id: \.self) { title in
                            NavigationLink(destination: destinationView(for: title)) {
                                ActionCard(title: title, progress: progress(for: title))
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 90)
                    .padding(.bottom, 50)
                }
            }
            .navigationBarBackButtonHidden(true) // إخفاء زر الرجوع الافتراضي
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button { dismiss() } label: {
                        Image("back_arrow")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                            .contentShape(Rectangle())
                    }
                }
            }
        }
        .onAppear {
            loadAllGoals()
        }
    }
    
    // تحديد الـ View لكل نوع
    @ViewBuilder
    func destinationView(for title: String) -> some View {
        switch title {
        case "Sport":
            SportView()
        case "Work":
            WorkView()
        case "Finance":
            FinanceView()
        case "Care":
            CareView()
        default:
            Text("No View")
        }
    }
    
    // حساب النسبة لكل نوع
    func progress(for title: String) -> Double {
        let goals: [Goal]
        switch title {
        case "Sport": goals = sportGoals
        case "Work": goals = workGoals
        case "Finance": goals = financeGoals
        case "Care": goals = careGoals
        default: goals = []
        }
        
        guard !goals.isEmpty else { return 0 }
        let completed = goals.filter { $0.isCompleted }.count
        return Double(completed) / Double(goals.count)
    }
    
    // جلب كل البيانات من UserDefaults
    func loadAllGoals() {
        sportGoals = loadGoals(forKey: "savedSportGoals")
        workGoals = loadGoals(forKey: "savedWorkGoals")
        financeGoals = loadGoals(forKey: "savedFinanceGoals")
        careGoals = loadGoals(forKey: "savedGoals") // Care استخدم هذا المفتاح
    }
    
    func loadGoals(forKey key: String) -> [Goal] {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([Goal].self, from: data) {
            return decoded
        }
        return []
    }
}

// ====================
// Card
// ====================
struct ActionCard: View {
    
    var title: String
    var progress: Double
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title2)
                .foregroundColor(.white)
            
            Spacer()
            
            ProgressRing(progress: progress)
        }
        .padding()
        .frame(height: 110)
        .background(Color(red: 0.72, green: 0.75, blue: 0.63))
        .cornerRadius(25)
    }
}

// ====================
// Progress Ring
// ====================
struct ProgressRing: View {
    
    var progress: Double
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .frame(width: 90, height: 90)
            
            ZStack {
                Circle()
                    .stroke(Color.orange.opacity(0.3), lineWidth: 12)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        Color.orange,
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                
                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .bold()
            }
            .frame(width: 60, height: 60)
        }
    }
}

#Preview {
    DashboardView()
        .environmentObject(DashboardViewModel()) // مهم لتجنّب الكراش في الـ Preview
}
