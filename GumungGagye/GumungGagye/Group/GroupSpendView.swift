//
//  GroupSpendView.swift
//  GumungGagye
//
//  Created by 정도현 on 2023/07/10.
//

import SwiftUI

// 그룹 지출 내역 뷰
struct GroupSpendView: View {
    var body: some View {
        ZStack {
            Color("background").ignoresSafeArea()
            VStack(spacing: 0) {
                Rectangle()
                    .frame(height: 92)
                    .padding(.top, 24)
                    .padding(.bottom, 36)
                    .foregroundColor(.red)
                
                VStack(spacing: 40) {
                    ForEach(1..<5) { _ in
                        GroupUserSpendView()
                    }
                }
                .padding(.bottom, 36)
            }
        }
    }
}

// 아직 기입 안한사람 리스트
struct GroupNotSpendView: View {
    var userName: String
    
    var body: some View {
        ZStack {
            Color("background").ignoresSafeArea()
            VStack(spacing: 24) {
                VStack(spacing: 4) {
                    HStack {
                        Text("아직 오늘 내역을 작성하지 않았어요")
                            .modifier(Body1Bold())
                        Spacer()
                    }
                    
                    HStack {
                        Text("작성하지 않은 친구를 콕 찔러볼까요?")
                            .modifier(Body2())
                            .foregroundColor(Color("Gray1"))
                        Spacer()
                    }
                }
                
                VStack(spacing: 37) {
                    ForEach(1..<4) { _ in
                        GroupNotSpendList(userName: userName)
                    }
                }
            }
            .padding(.vertical, 36)
        }
    }
}

struct GroupNotSpendList: View {
    var userName: String
    
    var body: some View {
        HStack {
            Text(userName)
                .modifier(Body1())
            
            Spacer()
            
            Button {
                
            } label: {
                MainColorBtn(inputText: "콕 찌르기")
            }
            
        }
    }
}


struct GroupSpendView_Previews: PreviewProvider {
    static var previews: some View {
        GroupSpendView()
    }
}
