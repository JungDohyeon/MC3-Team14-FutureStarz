//
//  CurrentAssetView.swift
//  GumungGagye
//
//  Created by Lee Juwon on 2023/07/10.
//

import SwiftUI

struct CurrentAssetView: View {
    public let spendBill: Int
    public let incomeBill: Int
    
    @StateObject var userData = InputUserData.shared
    
    var body: some View {
        
        // 현재 자산 표시
        VStack(alignment: .leading, spacing: 0) {
            Text("\(userData.nickname ?? "") 님의 자산")
                .modifier(H2SemiBold())
                .padding(.bottom, 20)
            
            VStack(spacing: 6) {
                // 지출
                HStack {
                    Text("지출")
                        .modifier(Body2())
                        .foregroundColor(Color("Gray1"))
                    Spacer()
                    Text("\(spendBill)원")
                        .modifier(Num3())
                }
             
                // 수입
                HStack {
                    Text("수입")
                        .modifier(Body2())
                        .foregroundColor(Color("Gray1"))
                    Spacer()
                    Text("\(incomeBill)원")
                        .modifier(Num3())
                }
             
                // 남은 금액 (수입-지출)
                HStack {
                    Text("남은 금액")
                        .modifier(Body2())
                        .foregroundColor(Color("Gray1"))
                    Spacer()
                    Text("\(incomeBill-spendBill)원")
                        .modifier(Num3Bold())
                        .foregroundColor(Color("Main"))
                }
            }
        }
        .padding(.horizontal, 20)
        
    }
}

struct CurrentAssetView_Previews: PreviewProvider {
    static var previews: some View {
        let spendBill = 50000
        let incomeBill = 1000000
        let userData = InputUserData.shared
        userData.nickname = "리나" // 예시로 사용할 사용자 닉네임
        
        return CurrentAssetView(spendBill: spendBill, incomeBill: incomeBill)
            .environmentObject(userData) // CurrentAssetView에 userData 환경 객체 전달
    }
}
