//
//  CategoryListView.swift
//  GumungGagye
//
//  Created by jeongyun on 2023/07/11.
//

import SwiftUI

struct CategoryListView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24.0) {
                ForEach(Array(CategoryInfo.shared.category_info[0]), id: \.key) { category in
                    if let categoryTitle = category.value[0], let categoryLocalTitle = category.value[1] {
                        CategorySumView(category: category.key, categoryTitle: categoryTitle, categoryLocalTitle: categoryLocalTitle)
                    }
                }
            }
            .padding(.horizontal, 20.0)
            .padding(.top, 48)
        }
        .background(Color("background"))
        .navigationBarTitle("카테고리별 소비", displayMode: .inline)
    }
}



struct CategorySumView: View {
    let category: Int
    let categoryTitle: String
    let categoryLocalTitle: String

    @StateObject var userData = InputUserData.shared
    @State private var spendData: ReadSpendData?
    @State private var incomeData: ReadIncomeData?
    
    var body: some View {
        HStack {
            HStack(alignment: .center, spacing: 12.0) {
               
                CategoryIcon(size: .constant(.small), accountType: 0, categoryIndex: category)
                
                VStack(alignment: .leading, spacing: 4.0) {
                    Text(categoryLocalTitle)
                        .modifier(Cap1())
                        .foregroundColor(Color("Gray1"))
                    
                    Text("51.6% | 163,500원") // 여기에 진행률과 금액을 표시하는 로직을 추가해주세요.
                        .modifier(Body1())
                        .foregroundColor(Color("Black"))
                }
            }
            
            Spacer()
            Image("Chevron.right.light.gray2")
        }
        .onAppear {
            fetchSpendData()
        }
    }
    
    func fetchSpendData() {
        // Convert category Int to String
        let categoryString = String(category)
        
        // Use BudgetFirebaseManager to fetch spendData for this category
        BudgetFirebaseManager.shared.fetchAccountData(forAccountID: categoryString) { (spendData, _) in
            self.spendData = spendData
        }
    }
}


struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListView()
    }
}
