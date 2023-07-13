//
//  CategoryHistoryView.swift
//  GumungGagye
//
//  Created by jeongyun on 2023/07/11.
//

import SwiftUI

struct CategoryHistoryView: View {
    var body: some View {
        ScrollView{
            VStack(spacing: 76.0) {
                
                // - MARK: - 카테고리 요약
                HStack(alignment: .top, spacing: 0.0) {
                    VStack(alignment: .leading, spacing: 12.0) {
                        VStack(alignment: .leading, spacing: 8.0){
                            HStack(spacing: 4.0) {
                                Text("2023년 7월")
                                Text("식비")
                                Text("총 금액")
                            }
                            .foregroundColor(Color("Black"))
                            .modifier(Cap1())
                            
                            Text("200,000원")
                                .modifier(Num1())
                        }
                        
                        Text("총 8회")
                            .foregroundColor(Color("Main"))
                            .modifier(Cap1Bold())
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color("Light"))
                            .cornerRadius(5)
                    }
                    
                    Spacer()
                    // 카테고리 아이콘
                    Circle()
                        .frame(width: 80, height: 80)
                }
                .padding(.top, 48.0)
                
                // - MARK: - 카테고리 내역 리스트
                Text("(아마)리나가 만든 내역뷰...")
                    .frame(maxWidth: .infinity, minHeight: 80, maxHeight: 80)
                    .background(Color("Gray3"))
            }
            .padding(.horizontal, 20.0)
        }
        .background(Color("background"))
        .foregroundColor(Color("Black"))
        .navigationBarTitle("식비 내역",  displayMode: .inline)
    }
}

struct CategoryHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryHistoryView()
    }
}
