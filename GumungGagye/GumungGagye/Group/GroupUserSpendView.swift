//
//  GroupUserSpendView.swift
//  GumungGagye
//
//  Created by 정도현 on 2023/07/10.
//

import SwiftUI

// 그룹 내부 유저 지출 내역 뷰
struct GroupUserSpendView: View {
    var body: some View {
        ZStack {
            
            Color("background").ignoresSafeArea()
            VStack(spacing: 16) {
                HStack {
                    Text("닉네임")
                        .modifier(Body1Bold())
                    Spacer()
                    Text("-15,000원")
                        .modifier(Num3Bold())
                }
                
                PurchasingContent(isOverPurchase: true)
                
                Divider()
                    .frame(height: 1)
                    .overlay(Color("Gray4"))
                
                NavigationLink {
                    PersonalDaySpendView()
                } label: {
                    SpendCommentDisplayView()
                }
            }
        }
        
    }
}

// 소비 내역 뷰
struct PurchasingContent: View {
    
    var isOverPurchase: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            // 소비 내역 icon 이미지
            Rectangle()
                .frame(width: 20, height: 20)
            
            Text("내용")
                .modifier(Body2())
            
            if isOverPurchase {
                Text("과소비")
                    .modifier(Cap2())
                    .foregroundColor(Color("OverPurchasing"))
                    .padding(.horizontal, 9)
                    .padding(.vertical, 4)
                    .background(
                        Rectangle()
                            .foregroundColor(Color("OverPurchasingLight"))
                            .cornerRadius(7)
                    )
            }
            
            Spacer()
            
            Text("-10,000원")
                .modifier(Num4())
        }
    }
}


struct SpendCommentDisplayView: View {
    var body: some View {
        HStack {
            HStack(spacing: 5) {
                Image(systemName: "bubble.left.fill")
                    .foregroundColor(Color("Gray2"))
                    .font(.system(size: 16))
                    .padding(.top, 3)
                
                Text("3")
                    .modifier(Body2())
                    .foregroundColor(Color("Gray1"))
            }
            
            Spacer()
            
            HStack(spacing: 6) {
                Text("3개 내역 더보기")
                    .modifier(Body2())
                    .foregroundColor(Color("Gray1"))
                
                Image(systemName: "chevron.right")
                    .foregroundColor(Color("Gray2"))
                    .font(.system(size: 16))
            }
        }
    }
}


struct GroupUserSpendView_Previews: PreviewProvider {
    static var previews: some View {
        GroupUserSpendView()
    }
}
