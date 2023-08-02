//
//  UserNoSpendView.swift
//  SSOAP
//
//  Created by 정도현 on 2023/08/01.
//

import SwiftUI

// MARK: 소비 내역이 없을 때
struct UserNoSpendView: View {
    var date: String
    var day: String
    
    var body: some View {
        ZStack {
            Color("background").ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                Text("\(date)일 \(day)")
                    .modifier(Body2())
                    .foregroundColor(.black)
                    .padding(.bottom, 20)
                
                HStack {
                    VStack(alignment:. leading, spacing: 8) {
                        Text("오늘은 소비 내역이 없어요")
                            .modifier(Body2Bold())
                        
                        Text("작성하지 않은 친구를 콕 찔러볼까요?")
                            .modifier(Cap1())
                    }
                    .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        MainColorBtn(inputText: "콕 찌르기")
                    }
                }
            }
        }
    }
}
