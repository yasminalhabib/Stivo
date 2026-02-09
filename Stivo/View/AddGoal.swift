//
//  AddGoal.swift
//  Stivo
//
//  Created by Yasmin Alhabib on 09/02/2026.
//
import SwiftUI

struct AddGoal: View {

    @State private var goalTitle = ""
    @State private var description = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var frequency: Frequency = .daily

    enum Frequency: String, CaseIterable, Identifiable {
        case daily = "Daily"
        case weekly = "Weekly"
        case monthly = "Monthly"
        var id: String { rawValue }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {

            // drag handle
            Capsule()
                .fill(Color.gray.opacity(0.28))
                .frame(width: 40, height: 4)
                .frame(maxWidth: .infinity)
                .padding(.top, 8)

            // Goal title
            Text("Goal title")
                .font(.system(size: 26, weight: .semibold))
                .foregroundStyle(.black)

            TextField("Enter goal title", text: $goalTitle)
                .softField()

            // Frequency
            Text("Frequency")
                .font(.system(size: 26, weight: .semibold))
                .foregroundStyle(.black)

            Menu {
                ForEach(Frequency.allCases) { item in
                    Button {
                        frequency = item
                    } label: {
                        Text(item.rawValue)
                    }
                }
            } label: {
                HStack(spacing: 10) {
                    Spacer()
                    Text(frequency.rawValue)
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(.black)
                    Spacer()

                    Image(systemName: "chevron.down")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.black.opacity(0.65))
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 14)
                .softCard()
            }
            .tint(.black)

            // Description
            Text("Description (optional)")
                .font(.system(size: 26, weight: .semibold))
                .foregroundStyle(.black)

            TextEditor(text: $description)
                .frame(height: 140)
                .padding(12)
                .softCard()
                .scrollContentBackground(.hidden)
                .tint(.black)

            // Dates
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Start Date")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(.black.opacity(0.85))

                    DatePicker("", selection: $startDate, displayedComponents: .date)
                        .labelsHidden()
                        .padding(.vertical, 10)
                        .padding(.horizontal, 12)
                        .softCard()
                        .tint(.black)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("End Date")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(.black.opacity(0.85))

                    DatePicker("", selection: $endDate, displayedComponents: .date)
                        .labelsHidden()
                        .padding(.vertical, 10)
                        .padding(.horizontal, 12)
                        .softCard()
                        .tint(.black)
                }
            }

            // Button
            Button {
                // add goal
            } label: {
                Text("Add goal")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(Color.orange.opacity(0.45))
                    )
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 52)
            .padding(.top, 4)

            //Spacer(minLength: 6)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
        .background(Color(.systemGray6).ignoresSafeArea())
    }
}

// MARK: - Soft styles
private extension View {
    func softCard() -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 5)
            )
    }

    func softField() -> some View {
        self
            .font(.system(size: 17, weight: .regular))
            .foregroundStyle(.black)
            .tint(.black)
            .padding(.vertical, 12)
            .padding(.horizontal, 14)
            .softCard()
    }
}


#Preview {
    AddGoal()
}
