//
//  ExpenseCategorySheetView.swift
//  GumungGagye
//
//  Created by 신상용 on 2023/07/28.
//

import SwiftUI

struct ExpenseCategorySheetView: View {
    // MARK: - PROPERTY
    @Binding var isCategoryPickerVisible: Bool
    @Binding var spend_category: Int?
    @Binding var account_type: Int
    let category_info = CategoryInfo.shared
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    // MARK: - BODY
    var body: some View {
        VStack(spacing: 0) {
            if account_type == 0 {
                HStack {
                    Text("카테고리")
                        .modifier(Body1Bold())
                        .padding(.bottom, 16)
                        .padding(.top, 20)
                        .padding(.leading, 20)
                    Spacer()
                }
                ScrollView {
                    LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
                        LazyVGrid(columns: columns) {
                            ForEach(1...category_info.category_info[0].count, id: \.self) { index in
                                DetailCategoryView(categoryIndex: index, spend_category: $spend_category, account_type: $account_type, isCategoryPickerVisible: $isCategoryPickerVisible)
                            }
                            
                        }
                    }
                    
                }
                .padding(.bottom, 16)
                
                
            }
            
            if account_type == 1 {
                HStack {
                    Text("카테고리")
                        .modifier(Body1Bold())
                        .padding(.bottom, 16)
                        .padding(.top, 20)
                        .padding(.leading, 20)
                    Spacer()
                }
                ScrollView {
                    LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
                        LazyVGrid(columns: columns) {
                            ForEach(1...category_info.category_info[1].count, id: \.self) { index in
                                DetailCategoryView(categoryIndex: index, spend_category: $spend_category, account_type: $account_type, isCategoryPickerVisible: $isCategoryPickerVisible)
                            }
                            
                        }
                    }
                    
                }
                .padding(.bottom, 16)
                
                
            }
            
            
        }
    }
}

struct ExpenseCategorySheetView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseCategorySheetView(isCategoryPickerVisible: .constant(true), spend_category: .constant(1), account_type: .constant(0))
            .previewLayout(.sizeThatFits)
    }
}
