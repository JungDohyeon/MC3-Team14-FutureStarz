//
//  DetailCategoryView.swift
//  GumungGagye
//
//  Created by 신상용 on 2023/07/28.
//

import SwiftUI


struct DetailCategoryView: View {
    // MARK: - PROPERTY
    
    @State var categoryIndex: Int
    @Binding var spend_category: Int?
    @Binding var account_type: Int
    @Binding var isCategoryPickerVisible: Bool
    let category_info = CategoryInfo.shared
    
    

    // MARK: - BODY
    var body: some View {
        VStack (spacing: 0) {
            Image("\(category_info.category_info[account_type][categoryIndex]![1])_S")
                .resizable()
                .frame(width: 48, height: 48)
                .padding(.bottom, 4)
            Text(category_info.category_info[account_type][categoryIndex]![0])
                .modifier(Cap1())
                .foregroundColor(Color("Black"))
                .multilineTextAlignment(.center)
        }
        .frame(width: 72, height: 90)
        .onTapGesture {
            spend_category = categoryIndex
            isCategoryPickerVisible = false 
        }
    }
}

struct DetailCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        DetailCategoryView(categoryIndex: 1, spend_category: .constant(1), account_type: .constant(0), isCategoryPickerVisible: .constant(true))
            .previewLayout(.sizeThatFits)
    }
}
