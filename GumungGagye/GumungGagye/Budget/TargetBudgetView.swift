//
//  TargetBudgetView.swift
//  GumungGagye
//
//  Created by Lee Juwon on 2023/07/10.
//

import SwiftUI

struct TargetBudgetView: View {
    
    public let spendBill: Int
    @StateObject var userData = InputUserData.shared
    @State private var sumGraphWidth: CGFloat = 0.0
    
    var body: some View {
       
        VStack(alignment: .leading, spacing: 0) {
            
            // 목표 예산 알림
            Text("이번 달 목표 예산이 \n\(formatNumber((userData.goal ?? 0)-spendBill))원 남았어요!")
                .modifier(H2SemiBold())
                .padding(.bottom, 16)
            
            VStack(spacing: 8) {
                // 목표 예산 진행바
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .frame(maxWidth: .infinity, minHeight: 24, maxHeight: 24)
                            .cornerRadius(9)
                            .foregroundColor(Color("Light30"))
                        Rectangle()
                            .frame(width: sumGraphWidth, height: 24)
                            .cornerRadius(9)
                            .foregroundColor(Color("Main"))
                    }
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1.0)) {
                            sumGraphWidth = Int(spendBill) > Int(userData.goal ?? 0) ? (geometry.size.width) : CGFloat(Double(spendBill)/Double(userData.goal ?? 09)) * (geometry.size.width)
                        }
                    }
                }.frame(height: 24)
                
                
                HStack {
                    // 쓴 금액 표시
                    HStack(spacing: 0) {
                        Text("오늘까지 ")
                            .modifier(Cap1())
                            .foregroundColor(Color("Gray2"))
                        Text("\(formatNumber(spendBill))")
                            .modifier(Num5())
                            .foregroundColor(Color("Main"))
                    }
                    Spacer()
                    // 총 목표 금액
                    HStack(spacing: 0) {
                        Text("목표 예산 ")
                            .modifier(Cap1())
                        Text("\(formatNumber(userData.goal))원")
                            .modifier(Num5())
                    }
                    .foregroundColor(Color("Gray2"))
                }
            }
            
            
        }
        .padding(.horizontal, 20)
    }
    
    // 세자리마다 쉼표를 추가하는 함수
    private func formatNumber(_ number: Int?) -> String {
        guard let number = number else {
            return ""
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number)) ?? ""
    }
}

struct TargetBudgetView_Previews: PreviewProvider {
    static var previews: some View {
        let spendBill = 50000 // 예시로 사용할 쓴 금액
        let userData = InputUserData.shared
        userData.goal = 100000 // 예시로 사용할 목표 예산
        
        return TargetBudgetView(spendBill: spendBill)
            .environmentObject(userData) // TargetBudgetView에 userData 환경 객체 전달
            .previewLayout(.sizeThatFits)
    }
}
