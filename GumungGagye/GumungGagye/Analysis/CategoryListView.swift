//
//  CategoryListView.swift
//  GumungGagye
//
//  Created by jeongyun on 2023/07/11.
//

import SwiftUI

struct CategoryListView: View {
    
    var body: some View {
        ScrollView{
            VStack(spacing: 24.0) {
                Image("FoodCategoryList")
                Image("FashionCategoryList")
                Image("HealthCategoryList")
                Image("TrafficCategoryList")
                Image("LivingCategoryList")
                Image("EducationCategoryList")
            }
            .padding(.horizontal, 20.0)
            .padding(.top, 48)
        }
        .background(Color("background"))
        .navigationBarTitle("카테고리별 소비", displayMode: .inline)
        
        
    }
}

struct CategorySumView: View {
    
    //    @State private var spendData: ReadSpendData
    
    var body: some View {
        //        NavigationLink(destination: CategoryHistoryView(spendData: spendData, size: .constant(.large))){
        HStack {
            HStack(alignment: .center, spacing: 12.0) {
                Circle()
                    .frame(width: 48, height: 48)
                    .foregroundColor(Color("Food"))
                
                VStack(alignment: .leading, spacing: 4.0) {
                    Text("식비")
                        .modifier(Cap1())
                        .foregroundColor(Color("Gray1"))
                    
                    Text("51.6% | 163,500원")
                        .modifier(Body1())
                        .foregroundColor(Color("Black"))
                }
            }
            
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(Color("Gray2"))
                .frame(width: 24, height: 24, alignment: .center)
        }
    }
}





struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListView()
    }
}
