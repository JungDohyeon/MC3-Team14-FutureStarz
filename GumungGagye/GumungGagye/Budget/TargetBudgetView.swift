//
//  TargetBudgetView.swift
//  GumungGagye
//
//  Created by Lee Juwon on 2023/07/10.
//

import SwiftUI

struct TargetBudgetView: View {
    var body: some View {
        
       
        VStack(alignment: .leading, spacing: 0) {
            
            // 목표 예산 알림
            Text("이번 달 목표 예산이 \n1,000,000원 남았어요!")
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
                        Text("56,000원")
                            .modifier(Num5())
                            .foregroundColor(Color("Main"))
                    }
                    Spacer()
                    // 총 목표 금액
                    HStack(spacing: 0) {
                        Text("목표 예산 ")
                            .modifier(Cap1())
                        Text("1,000,000원")
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
        TargetBudgetView()
    }
}
