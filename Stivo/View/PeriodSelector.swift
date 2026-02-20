import SwiftUI

struct PeriodSelector: View {
    
    @Binding var selectedPeriod: String
    let periods = ["Daily Actions", "Weekly Actions", "Monthly Actions"]
    
    var body: some View {
        Menu {
            ForEach(periods, id: \.self) { period in
                Button(period) {
                    selectedPeriod = period
                }
            }
        } label: {
            HStack(spacing: 0) {
                
                Text(selectedPeriod)
                    .foregroundColor(.black)
                    .padding(.horizontal, 16)
                
               
                
                Rectangle()
                    .frame(width: 1)
                    .foregroundColor(.gray.opacity(0.3))
                
                Image(systemName: "chevron.down")
                    .foregroundColor(.black)
                    
            }
            .frame(height: 40)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.05), radius: 3)
        }
        .frame(width: 190)
        
    }
    
}
#Preview {
    MainDashboardView()
        .environmentObject(DashboardViewModel())

}
