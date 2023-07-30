//
//  CategoryHistoryView.swift
//  GumungGagye
//
//  Created by jeongyun on 2023/07/11.
//

import SwiftUI

struct CategoryHistoryView: View {
    
    @State private var spendData: ReadSpendData
    
    @Binding var size: IconSize
    var accountType: Int  // 0
    var categoryIndex: Int // 4
    @ObservedObject var categoryInfo = CategoryInfo.shared
    
    let year: String    // 년도
    let month: String   // 월
    
    @Binding var categorySpendSum: Int
    
    var body: some View {
        ScrollView{
            VStack(spacing: 76.0) {
                
                // - MARK: - 카테고리 요약
                HStack(alignment: .top, spacing: 0.0) {
                    VStack(alignment: .leading, spacing: 12.0) {
                        VStack(alignment: .leading, spacing: 8.0){
                            HStack(spacing: 4.0) {
                                Text("\(year)년 \(month)월")
                                Text("\(categoryInfo.category_info[0][categoryIndex]![0])")
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
                    CategoryIcon(size: .constant(.large), accountType: 0, categoryIndex: spendData.category)
                }
                .padding(.top, 48.0)
                
                // - MARK: - 카테고리 내역 리스트
                VStack(spacing: 52.0) {
                    ForEach(1..<10) {_ in
//                        DateBreakdown()
                    }
                }
            }
            .padding(.horizontal, 20.0)
        }
        .background(Color("background"))
        .foregroundColor(Color("Black"))
        .navigationBarTitle("식비 내역",  displayMode: .inline)
    }
}

//struct CategoryHistoryView_Previews: PreviewProvider {
//
//    @State private var spendData: ReadSpendData
//
//    static var previews: some View {
//        CategoryHistoryView(spendData: , size: .constant(.large))
//    }
//}
