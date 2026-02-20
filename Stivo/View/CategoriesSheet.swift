//
//  CategoriesSheet.swift
//  Stivo
//
//  Created by Yasmin Alhabib on 09/02/2026.
//
import SwiftUI

// MARK: - CategoriesSheet
struct CategoriesSheet: View {
    @EnvironmentObject var viewModel: DashboardViewModel

    var body: some View {
        CategoriesSheetView()
            .environmentObject(viewModel)
            .presentationDetents([.height(430)])
            .presentationDragIndicator(.visible)
    }
}

// MARK: - Navigation Route
enum CategoryRoute: Hashable {
    case sport, work, care, finance
}

// ✅ Identifiable conformance needed for fullScreenCover(item:)
extension CategoryRoute: Identifiable {
    var id: Self { self }
}

// MARK: - Sheet Body View
struct CategoriesSheetView: View {
    @EnvironmentObject var viewModel: DashboardViewModel

    // ✅ selectedRoute drives fullScreenCover — nil means closed
    @State private var selectedRoute: CategoryRoute? = nil

    private let cardW: CGFloat = 153
    private let sportH: CGFloat = 206
    private let financeH: CGFloat = 139
    private let workH: CGFloat = 136
    private let careH: CGFloat = 198
    private let sidePadding: CGFloat = 24
    private let spacing: CGFloat = 16

    var body: some View {
        VStack(spacing: 14) {

            HStack(alignment: .bottom, spacing: spacing) {

                // Left column: Sport (tall) + Work (short)
                VStack(spacing: spacing) {
                    CategoryCardView(item: .sport, size: CGSize(width: cardW, height: sportH))
                        .onTapGesture { selectedRoute = .sport }

                    CategoryCardView(item: .work, size: CGSize(width: cardW, height: workH))
                        .onTapGesture { selectedRoute = .work }
                }
                .frame(width: cardW)

                // Right column: Finance (short) + Care (tall)
                VStack(spacing: spacing) {
                    CategoryCardView(item: .finance, size: CGSize(width: cardW, height: financeH))
                        .onTapGesture { selectedRoute = .finance }

                    CategoryCardView(item: .care, size: CGSize(width: cardW, height: careH))
                        .onTapGesture { selectedRoute = .care }
                }
                .frame(width: cardW)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, sidePadding)
            .padding(.top, 10)

            Spacer(minLength: 8)
        }
        .padding(.top, 6)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(.systemGray6).ignoresSafeArea(edges: .bottom))
        // ✅ fullScreenCover truly covers the whole screen — fixes the partial-open bug
        .fullScreenCover(item: $selectedRoute) { route in
            NavigationStack {
                destinationView(for: route)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                selectedRoute = nil
                            } label: {
                                HStack(spacing: 4) {
                                    Image(systemName: "chevron.left")
                                    Text("Back")
                                }
                                .foregroundColor(Color("Color"))
                            }
                        }
                    }
            }
            .environmentObject(viewModel)
        }
    }

    @ViewBuilder
    func destinationView(for route: CategoryRoute) -> some View {
        switch route {
        case .sport:   SportView()
        case .work:    WorkView()
        case .care:    CareView()
        case .finance: FinanceView()
        }
    }
}

// MARK: - Category Card
struct CategoryCardView: View {
    let item: CategoryItem
    let size: CGSize

    var body: some View {
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
        .contentShape(Rectangle())
    }
}

// MARK: - Category Data
struct CategoryItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let bg: Color

    static let sport   = CategoryItem(title: "Sport",   icon: "figure.run",    bg: Color(red: 0.76, green: 0.79, blue: 0.72))
    static let finance = CategoryItem(title: "Finance", icon: "creditcard.fill", bg: Color(red: 0.98, green: 0.74, blue: 0.62))
    static let work    = CategoryItem(title: "Work",    icon: "case.fill",     bg: Color(red: 0.98, green: 0.74, blue: 0.62))
    static let care    = CategoryItem(title: "Care",    icon: "camera.macro",  bg: Color(red: 0.76, green: 0.79, blue: 0.72))
}

#Preview {
    CategoriesSheet()
        .environmentObject(DashboardViewModel())
}











