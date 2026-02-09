//
//  CategoriesSheet.swift
//  Stivo
//
//  Created by Yasmin Alhabib on 09/02/2026.
//
import SwiftUI

// MARK: - Categories Sheet
struct CategoriesSheet: View {

    // ✅ optional (so no connection is required now)
    let onSelect: ((CategoryItem) -> Void)?

    private let columns = [
        GridItem(.flexible(), spacing: 18),
        GridItem(.flexible(), spacing: 18)
    ]

    var body: some View {
        VStack(spacing: 14) {

            // drag indicator
            Capsule()
                .fill(Color.gray.opacity(0.35))
                .frame(width: 44, height: 5)
                .padding(.top, 10)

            LazyVGrid(columns: columns, spacing: 18) {
                CategoryCard(item: .sport, height: 150, onSelect: onSelect)
                CategoryCard(item: .finance, height: 120, onSelect: onSelect)
                CategoryCard(item: .work, height: 120, onSelect: onSelect)
                CategoryCard(item: .care, height: 150, onSelect: onSelect)
            }
            .padding(.horizontal, 22)

            Spacer(minLength: 8)
        }
        .padding(.top, 6)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color(.systemGray6)
                .ignoresSafeArea()
        )
    }
}

// MARK: - Card Button
struct CategoryCard: View {
    let item: CategoryItem
    let height: CGFloat

    // ✅ optional
    let onSelect: ((CategoryItem) -> Void)?

    var body: some View {
        Button {
            onSelect?(item) // ✅ only runs if provided
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(item.bg)

                VStack {
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(Color.white.opacity(0.95))
                                .frame(width: 44, height: 36)

                            Image(systemName: item.icon)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(Color.black.opacity(0.75))
                        }
                        Spacer()
                    }

                    Spacer()

                    Text(item.title)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundStyle(.white)
                        .padding(.bottom, 10)
                }
                .padding(14)
            }
            .frame(height: height)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Data
struct CategoryItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let bg: Color

    static let sport = CategoryItem(
        title: "Sport",
        icon: "figure.run",
        bg: Color(red: 0.76, green: 0.79, blue: 0.72) // sage
    )

    static let finance = CategoryItem(
        title: "Finance",
        icon: "creditcard.fill",
        bg: Color(red: 0.98, green: 0.74, blue: 0.62) // peach
    )

    static let work = CategoryItem(
        title: "Work",
        icon: "case.fill",
        bg: Color(red: 0.98, green: 0.74, blue: 0.62) // peach
    )

    static let care = CategoryItem(
        title: "Care",
        icon: "camera.macro",
        bg: Color(red: 0.76, green: 0.79, blue: 0.72) // sage
    )
}

// MARK: - Preview
#Preview {
    CategoriesSheet(onSelect: nil) // ✅ no connection for now
}

