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
                ForEach(Array(CategoryInfo.shared.category_info[0].values), id: \.self) { categoryTitles in
                    let categoryTitle = categoryTitles[0] ?? ""
                    let categoryLocalTitle = categoryTitles[1] ?? ""
                    CategorySumView(categoryTitle: categoryTitle, categoryLocalTitle: categoryLocalTitle)
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
    
    let categoryTitle: String
    let categoryLocalTitle: String

    @StateObject var userData = InputUserData.shared
    @State private var spendData: ReadSpendData?
    @State private var incomeData: ReadIncomeData?
    
    var body: some View {
//        NavigationLink(destination: CategoryHistoryView(spendData: spendData, size: .constant(.large))){
            HStack {
                HStack(alignment: .center, spacing: 12.0) {
                    Circle()
                        .frame(width: 48, height: 48)
                        .foregroundColor(Color(categoryTitle))
                        
                    VStack(alignment: .leading, spacing: 4.0) {
                        Text(categoryLocalTitle)
                            .modifier(Cap1())
                            .foregroundColor(Color("Gray1"))
                        
                        Text("51.6% | 163,500원")
                            .modifier(Body1())
                            .foregroundColor(Color("Black"))
                    }
                }
                
                Spacer()
                Image("Chevron.right.light.gray2")
            }
        }
    }
    
//}

struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListView()
    }
}
