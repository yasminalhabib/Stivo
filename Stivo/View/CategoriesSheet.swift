//
//  CategoriesSheet.swift
//  Stivo
//
//  Created by Yasmin Alhabib on 09/02/2026.
//
import SwiftUI

// MARK: - CategoriesSheet (Main)
struct CategoriesSheet: View {
    @State public var showSheet = true
    @State public var selectedRoute: CategoryRoute?

    var body: some View {
        ZStack {
            Color.black.opacity(0.15).ignoresSafeArea()
        }
       
        CategoriesSheetView { category in
            selectedRoute = CategoryRoute(from: category)
            
        }
        .presentationDetents([.height(400)])
              .presentationDragIndicator(.hidden)
        .fullScreenCover(item: $selectedRoute) { route in
            switch route {
            case .sport:
                SportView()
            case .work:
                WorkView()
            case .care:
                CareView()
            case .finance:
                FinanceView()
            }
        }
    }
}

// MARK: - Navigation Route
enum CategoryRoute: Identifiable {
    case sport, work, care, finance
    var id: String { String(describing: self) }

    init?(from item: CategoryItem) {
        switch item.title {
        case "Sport": self = .sport
        case "Work": self = .work
        case "Care": self = .care
        case "Finance": self = .finance
        default: return nil
        }
    }
}

// MARK: - Sheet View
struct CategoriesSheetView: View {
    let onSelect: (CategoryItem) -> Void

    private let cardW: CGFloat = 153
    private let sportH: CGFloat = 206
    private let financeH: CGFloat = 139
    private let workH: CGFloat = 136
    private let careH: CGFloat = 198

    private let sidePadding: CGFloat = 24
    private let spacing: CGFloat = 20

    var body: some View {
        VStack(spacing: 14) {

            Image(systemName: "chevron.down")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.gray.opacity(0.8))
                .padding(.top, 10)

            HStack(alignment: .bottom, spacing: spacing) {

                VStack(spacing: spacing) {
                    CategoryCard(item: .sport,
                                 size: CGSize(width: cardW, height: sportH),
                                 onSelect: onSelect)

                    CategoryCard(item: .work,
                                 size: CGSize(width: cardW, height: workH),
                                 onSelect: onSelect)
                }
                .frame(width: cardW)

                VStack(spacing: spacing) {
                    CategoryCard(item: .finance,
                                 size: CGSize(width: cardW, height: financeH),
                                 onSelect: onSelect)

                    CategoryCard(item: .care,
                                 size: CGSize(width: cardW, height: careH),
                                 onSelect: onSelect)
                }
                .frame(width: cardW)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, sidePadding)
            .padding(.top, 6)
        }
        .padding(.top, 6)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(
            Color(.systemGray6)
                .ignoresSafeArea(edges: .bottom)
        )
    }
}

// MARK: - Category Card
struct CategoryCard: View {
    let item: CategoryItem
    let size: CGSize
    let onSelect: (CategoryItem) -> Void

    var body: some View {
        Button {
            onSelect(item)
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(item.bg)

                Text(item.title)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(.white)

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
                }
                .padding(14)
            }
            .frame(width: size.width, height: size.height)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Category Data
struct CategoryItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let bg: Color

    static let sport = CategoryItem(
        title: "Sport",
        icon: "figure.run",
        bg: Color(red: 0.76, green: 0.79, blue: 0.72)
    )

    static let finance = CategoryItem(
        title: "Finance",
        icon: "creditcard.fill",
        bg: Color(red: 0.98, green: 0.74, blue: 0.62)
    )

    static let work = CategoryItem(
        title: "Work",
        icon: "case.fill",
        bg: Color(red: 0.98, green: 0.74, blue: 0.62)
    )

    static let care = CategoryItem(
        title: "Care",
        icon: "camera.macro",
        bg: Color(red: 0.76, green: 0.79, blue: 0.72)
    )
}

// MARK: - Preview
#Preview {
    CategoriesSheet()
}


