//
//  MainBudgetView.swift
//  GumungGagye
//
//  Created by Lee Juwon on 2023/07/10.
//

import SwiftUI

struct MainBudgetView: View {
    var body: some View {
        
        VStack(alignment: .leading) {
            // 월(날짜) 이동
            MoveMonth(month: "7월", size: .Big) // 숫자 데이터로 받아오기
                .padding(.top, 30)
                .padding(.horizontal, 20)
            
            ScrollView {
                VStack(spacing: 36) {
                    
                    TargetBudgetView()
                    SectionBar()
                    CurrentAssetView()
                    SectionBar()
                    
                    LazyVStack( alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
                        Section(header: Header()) {
                            
                            ForEach(1..<10) {_ in
                                DateBreakdown()
                                    .padding(.top, 32)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
            .clipped()
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct Header: View {
    var body: some View {
        HStack {
            Text("내역")
                .modifier(H2SemiBold())
            Spacer()
            SmallButton(text: "+ 추가")
        }
        .padding(.bottom, 10) // 전꺼 36
        .background(.white)
        
    }
}

struct MainBudgetView_Previews: PreviewProvider {
    static var previews: some View {
        MainBudgetView()
    }
}
