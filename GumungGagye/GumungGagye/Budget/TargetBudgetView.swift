//
//  TargetBudgetView.swift
//  GumungGagye
//
//  Created by Lee Juwon on 2023/07/10.
//

import SwiftUI

struct TargetBudgetView: View {
    public let goalBill: Int
    public let spendBill: Int
    
    var body: some View {
       
        VStack(alignment: .leading, spacing: 0) {
            
            // 목표 예산 알림
            Text("이번 달 목표 예산이 \(goalBill)원 남았어요!")
                .modifier(H2SemiBold())
                .padding(.bottom, 16)
            
            VStack(spacing: 8) {
                // 목표 예산 진행바
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: 335, height: 24)
                        .cornerRadius(9)
                        .foregroundColor(Color("Light30"))
                    Rectangle()
                        .frame(width: 75, height: 24)
                        .cornerRadius(9)
                        .foregroundColor(Color("Main"))
                }
                
                
                HStack {
                    // 쓴 금액 표시
                    HStack(spacing: 0) {
                        Text("오늘까지 ")
                            .modifier(Cap1())
                            .foregroundColor(Color("Gray2"))
                        Text("\(spendBill)")
                            .modifier(Num5())
                            .foregroundColor(Color("Main"))
                    }
                    Spacer()
                    // 총 목표 금액
                    HStack(spacing: 0) {
                        Text("목표 예산 ")
                            .modifier(Cap1())
                        Text("\(goalBill)원")
                            .modifier(Num5())
                    }
                    .foregroundColor(Color("Gray2"))
                }
            }
            
            
        }
        .padding(.horizontal, 20)
    }
}

struct TargetBudgetView_Previews: PreviewProvider {
    static var previews: some View {
        TargetBudgetView(goalBill: 10000000, spendBill: 1000)
    }
}
