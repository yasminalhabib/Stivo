//
//  AddGoal.swift
//  Stivo
//
//  Created by Yasmin Alhabib on 09/02/2026.
//
import SwiftUI

struct AddGoal: View {

    @Binding var goals: [Goal]
    @Binding var showSheet: Bool

    @State private var goalTitle = ""
    @State private var description = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var frequency: Frequency = .daily

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {

            Capsule().fill(Color.gray.opacity(0.28)).frame(width: 40, height: 4).frame(maxWidth: .infinity).padding(.top, 8)

            Text("Goal title").font(.system(size: 20, weight: .semibold)).foregroundStyle(.black)
            TextField("Enter goal title", text: $goalTitle)
                .padding(.vertical, 12)
                .padding(.horizontal, 14)
                .background(RoundedRectangle(cornerRadius: 18).fill(Color.white))

            Text("Frequency").font(.system(size: 20, weight: .semibold)).foregroundStyle(.black)
            Menu {
                ForEach(Frequency.allCases) { item in
                    Button { frequency = item } label: { Text(item.rawValue) }
                }
            } label: {
                HStack { Spacer(); Text(frequency.rawValue).foregroundColor(.black); Spacer(); Image(systemName: "chevron.down").foregroundColor(.black.opacity(0.65)) }
                    .padding(.vertical, 12).padding(.horizontal, 14)
                    .background(RoundedRectangle(cornerRadius: 18).fill(Color.white))
            }

            Text("Description (optional)").font(.system(size: 20, weight: .semibold)).foregroundStyle(.black)
            TextEditor(text: $description)
                .frame(height: 140)
                .padding(12)
                .background(RoundedRectangle(cornerRadius: 18).fill(Color.white))
                .scrollContentBackground(.hidden)

            HStack(spacing: 12) {
                VStack(alignment: .leading) {
                    Text("Start Date")
                    DatePicker("", selection: $startDate, displayedComponents: .date).labelsHidden()
                }
                VStack(alignment: .leading) {
                    Text("End Date")
                    DatePicker("", selection: $endDate, displayedComponents: .date).labelsHidden()
                }
            }

            Button {
                // ✅ إنشاء الهدف وربطه بالـBinding
                let newGoal = Goal(
                    title: goalTitle,
                    description: description,
                    startDate: startDate,
                    endDate: endDate,
                    frequency: frequency
                )
                goals.append(newGoal)
                showSheet = false
            } label: {
                Text("Add goal")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color("Color"))
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .disabled(goalTitle.isEmpty)

            Spacer()
        }
        .padding(20)
        .background(Color(.systemGray6).ignoresSafeArea())
    }
}
#Preview {
    HomeView()
}
