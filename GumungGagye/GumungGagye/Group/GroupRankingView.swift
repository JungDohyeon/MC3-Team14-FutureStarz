//
//  GroupRankingView.swift
//  GumungGagye
//
//  Created by 정도현 on 2023/07/29.
//

import SwiftUI

struct GroupRankingView: View {
    var ranking: Int
    let userName: String
    let spendMoney: Int
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(ranking.description)
                    .modifier(Num5())
                    .padding(.trailing, 18)
                
                Image("SeletingPictureIcon")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .shadow(color: Color(red: 0.31, green: 0.32, blue: 0.63).opacity(0.2), radius: 5, x: 0, y: 2)
                    .padding(.trailing, 12)
                
                Text(userName)
                    .modifier(Body2())
                
                Spacer()
                
                Text("-\(spendMoney.description)원")
                    .modifier(Num4SemiBold())
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 8)
            
            Divider()
                .frame(height: 1)
                .background(Color("Gray4"))
        }
    }
}
