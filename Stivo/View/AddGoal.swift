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
    @Binding var editingGoal: Goal? // إذا موجود → تعديل

    @State private var goalTitle = ""
    @State private var description = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var frequency: Frequency = .daily

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {

            Capsule()
                .fill(Color.gray.opacity(0.28))
                .frame(width: 40, height: 4)
                .frame(maxWidth: .infinity)
                .padding(.top, 8)

            Text("Goal title")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.black)
            TextField("Enter goal title", text: $goalTitle)
                .padding(.vertical, 12)
                .padding(.horizontal, 14)
                .background(RoundedRectangle(cornerRadius: 18).fill(Color.white))

            Text("Frequency")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.black)
            Menu {
                ForEach(Frequency.allCases) { item in
                    Button { frequency = item } label: { Text(item.rawValue) }
                }
            } label: {
                HStack {
                    Spacer()
                    Text(frequency.rawValue).foregroundColor(.black)
                    Spacer()
                    Image(systemName: "chevron.down").foregroundColor(.black.opacity(0.65))
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 14)
                .background(RoundedRectangle(cornerRadius: 18).fill(Color.white))
            }

            Text("Description (optional)")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.black)
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

            HStack(spacing: 12) {
                Button {
                    if let editing = editingGoal,
                       let index = goals.firstIndex(where: { $0.id == editing.id }) {
                        // تحديث الهدف الحالي
                        goals[index].title = goalTitle
                        goals[index].description = description
                        goals[index].startDate = startDate
                        goals[index].endDate = endDate
                        goals[index].frequency = frequency
                    } else {
                        // إضافة هدف جديد
                        let newGoal = Goal(
                            title: goalTitle,
                            description: description,
                            startDate: startDate,
                            endDate: endDate,
                            frequency: frequency
                        )
                        goals.append(newGoal)
                    }
                    showSheet = false
                } label: {
                    Text(editingGoal == nil ? "Add goal" : "Save changes")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color("Color"))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(goalTitle.isEmpty)

                // زر حذف يظهر فقط إذا الهدف موجود للتعديل
                if editingGoal != nil {
                    Button(role: .destructive) {
                        if let editing = editingGoal,
                           let index = goals.firstIndex(where: { $0.id == editing.id }) {
                            goals.remove(at: index)
                        }
                        showSheet = false
                    } label: {
                        Text("Delete")
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.red.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
            }

            Spacer()
        }
        .padding(20)
        .background(Color(.systemGray6).ignoresSafeArea())
        .onAppear {
            // إذا الهدف موجود → حط القيم الحالية
            if let editing = editingGoal {
                goalTitle = editing.title
                description = editing.description
                startDate = editing.startDate
                endDate = editing.endDate
                frequency = editing.frequency
            }
        }
    }
}

#Preview {
    CareView()
}
