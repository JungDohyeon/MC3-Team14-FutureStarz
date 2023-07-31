//
//  TargetBudgetView.swift
//  GumungGagye
//
//  Created by Lee Juwon on 2023/07/10.
//

import SwiftUI

struct TargetBudgetView: View {
    
    @Binding var spendBill: Int
    @StateObject var userData = InputUserData.shared
    @State private var sumGraphWidth: CGFloat = 0.0
    @State private var isOver: Bool = false // 목표 예산을 넘었는지 확인
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            if let userGoal = userData.goal {
                if userGoal - spendBill < 0 {
                    Text("이번 달 목표 예산을 \n\(abs(userGoal-spendBill))원 넘었어요!")
                        .modifier(H2SemiBold())
                        .padding(.bottom, 16)
                        .onAppear {
                            isOver = true
                        }
                } else {
                    Text("이번 달 목표 예산이 \n\(userGoal-spendBill)원 남았어요!")
                        .modifier(H2SemiBold())
                        .padding(.bottom, 16)
                        .onAppear {
                            isOver = false
                        }
                }
            } else {
                Text("목표 예산을 설정해주세요!")
                    .modifier(H2SemiBold())
            }
            
            
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
                            .foregroundColor(isOver ? Color("OverPurchasing") : Color("Main"))
                    }
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.7)) {
                            sumGraphWidth = Int(spendBill) > Int(userData.goal ?? 0) ? (geometry.size.width) : CGFloat(Double(spendBill)/Double(userData.goal ?? 0)) * (geometry.size.width)
                        }
                    }
                    .onChange(of: spendBill) { newValue in
                        withAnimation(.easeInOut(duration: 0.7)) {
                            sumGraphWidth = Int(newValue) > Int(userData.goal ?? 0) ? (geometry.size.width) : CGFloat(Double(newValue)/Double(userData.goal ?? 0)) * (geometry.size.width)
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
                            .foregroundColor(isOver ? Color("OverPurchasing") : Color("Main"))
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

//struct TargetBudgetView_Previews: PreviewProvider {
//    static var previews: some View {
//        let spendBill = 50000 // 예시로 사용할 쓴 금액
//        let userData = InputUserData.shared
//        userData.goal = 100000 // 예시로 사용할 목표 예산
//
//        return TargetBudgetView(spendBill: spendBill)
//            .environmentObject(userData) // TargetBudgetView에 userData 환경 객체 전달
//            .previewLayout(.sizeThatFits)
//    }
//}
