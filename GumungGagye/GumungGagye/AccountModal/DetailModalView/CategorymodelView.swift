//
//  CategorymodelView.swift
//  GumungGagye
//
//  Created by 신상용 on 2023/07/27.
//

import SwiftUI

struct CategorymodelView: View {
    // MARK: - PROPERTY
    @State var isCategoryPickerVisible: Bool = false
    @Binding var account_type: Int
    @Binding var spend_category: Int?
    let category_info = CategoryInfo.shared
    // MARK: - BODY
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text("카테고리")
                        .modifier(Body2())
                        .foregroundColor(Color("Gray1"))
                        .padding(.trailing, 26)
                    ZStack(alignment: .leading){
                        HStack() {
                            if spend_category == nil {
                                Text("카테고리를 선택하세요")
                                    .modifier(Body1())
                                    .foregroundColor(Color("Gray2"))
                            } else {
                                Text(category_info.category_info[account_type][spend_category!]![0])
                                    .modifier(Body1Bold())
                                    
                                Spacer()
                            }
                            
                            
                            Spacer()
                        }
                        .padding(.vertical, 22)
                        
                        .sheet(isPresented: $isCategoryPickerVisible) {
                            if account_type == 0 {
                                ExpenseCategorySheetView(isCategoryPickerVisible: $isCategoryPickerVisible, spend_category: $spend_category, account_type: $account_type)
                                    .presentationDetents([.height(350)])
                                    .onChange(of: spend_category, perform: { newValue in
                                        print(spend_category)
                                    })
                            } else if account_type == 1 {
                                IncomeCategorySheetView(isCategoryPickerVisible: $isCategoryPickerVisible, spend_category: $spend_category)
                                    .presentationDetents([.medium])
                                //                                    .onChange(of: selectedOption, perform: { newValue in
                                //                                        self.tappedIncomeCategory = newValue
                                //                                        isCategorySheetVisible = false
                                //                                        DividerSelect = false
                                //                                    })
                            }
                        }
                        
                        HStack(spacing: 0) {
                            Spacer()
                            Image(systemName: "chevron.right")
                                .frame(width: 24, height: 24)
                                .foregroundColor(Color("Gray2"))
                                .fontWeight(.bold)
                                .padding(.trailing, 11)
                        }
                        
                    } //: HSTACK
                    .onTapGesture {
                        isCategoryPickerVisible = true
                    }
                    Spacer()
                }
            }
            .padding(.leading, 11)
            Divider()
                .frame(height: 1)
                .overlay(Color("Gray4"))
        }
        .padding(.horizontal, 20)
        
    }
}

struct CategorymodelView_Previews: PreviewProvider {
    static var previews: some View {
        CategorymodelView(account_type: .constant(0), spend_category: .constant(1))
            .previewLayout(.sizeThatFits)
    }
}
