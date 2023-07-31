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
    
    @State var categorySpendSum: Int // 카테고리별 총 금액
    @State var categorySpendNum: Int // 카테고리별 총 횟수
    
    let today = Calendar.current.component(.day, from: Date())
    let dateFormatter = DateFormatter()
    
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
                            
                            Text("\(categorySpendSum)원")
                                .modifier(Num1())
                        }
                        
                        Text("총 \(categorySpendNum)회")
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
                    ForEach((1...today).reversed(), id:\.self) { day in
                        BudgetPostView(year: getYear(day: day), month: getMonth(day: day), date: getDate(day: day), day: getDay(day: day)) //CategoryPostView로 바꿀 것.
                    }
                }
            }
            .padding(.horizontal, 20.0)
        }
        .background(Color("background"))
        .foregroundColor(Color("Black"))
        .navigationBarTitle("식비 내역",  displayMode: .inline)
    }
    
    func getYear(day: Int) -> String {
        let components = DateComponents(year: Calendar.current.component(.year, from: Date()), month: Calendar.current.component(.month, from: Date()), day: day)
        if let date = Calendar.current.date(from: components) {
            dateFormatter.dateFormat = "YYYY"
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    
    func getMonth(day: Int) -> String {
        let components = DateComponents(year: Calendar.current.component(.year, from: Date()), month: Calendar.current.component(.month, from: Date()), day: day)
        if let date = Calendar.current.date(from: components) {
            dateFormatter.dateFormat = "MM"
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    func getDate(day: Int) -> String {
        let components = DateComponents(year: Calendar.current.component(.year, from: Date()), month: Calendar.current.component(.month, from: Date()), day: day)
        if let date = Calendar.current.date(from: components) {
            dateFormatter.dateFormat = "dd"
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    func getDay(day: Int) -> String {
        let components = DateComponents(year: Calendar.current.component(.year, from: Date()), month: Calendar.current.component(.month, from: Date()), day: day)
        if let date = Calendar.current.date(from: components) {
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: date)
        }
        return ""
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
