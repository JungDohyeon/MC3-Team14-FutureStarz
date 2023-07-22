//
//  IncomeCategorySheet.swift
//  GumungGagye
//
//  Created by 손서연 on 2023/07/13.
//

import SwiftUI

struct IncomeCategoryButton: View {
    var incomeCategoryName: String
    var isSelected: Bool
    var action: () -> Void
    var incomeCategoryColor: Color
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack(alignment: .center, spacing: 4) {
                CategoryIcon(size: .small, color: incomeCategoryColor)
                Text(incomeCategoryName)
                    .modifier(Cap1())
                    .foregroundColor(Color("Black"))
                    .multilineTextAlignment(.center)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 12)
        }
        .background(isSelected ? Color("Light30") : Color.clear)
        .cornerRadius(12)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color("Main") : Color.clear, lineWidth: isSelected ? 2 : 0)
        }
    }
}

enum IncomeCategoryList: String, CaseIterable {
    case pay = "급여"
    case allowance = "용돈"
    case business = "사업∙수입"
    case financial = "금융∙수입"
    case extra = "부수입"
    case etc = "기타"
    
    var incomeCategoryListColor: Color {
        switch self {
        case .pay: return Color("Food")
        case .allowance: return Color("Cafe")
        case .business: return Color("Alcohol")
        case .financial: return Color("Vehicle")
        case .extra: return Color("Leisure")
        case .etc: return Color("Etc")
        }
    }
}

struct IncomeCategorySheet: View {
    
    @Binding var tappedIncomeCategory: String
    @Binding var isCategorySheetVisible: Bool
    @Binding var DividerSelect: Bool
    
    let gridLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    
    var body: some View {
        VStack {
            // MARK: - 상단
            HStack {
                Text("내역 추가하기")
                    .modifier(Body1Bold())
                    .foregroundColor(Color("Black"))
                
                Spacer()
                
                Button {
                    isCategorySheetVisible = false
                    DividerSelect = false
                    
                } label: {
                    Image(systemName: "xmark")
                        .modifier(Body1Bold())
                        .foregroundColor(Color("Gray2"))
                }
                .frame(width: 20, height: 20)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
            
            ScrollView {
                LazyVGrid(columns: gridLayout, spacing: 0) {
                    ForEach(IncomeCategoryList.allCases, id: \.self) { incomeCategory in
                        let incomeCategoryName = incomeCategory.rawValue
                        
                        IncomeCategoryButton(
                            incomeCategoryName: incomeCategory.rawValue,
                            isSelected: incomeCategory.rawValue == tappedIncomeCategory,
                            action: {
                                isCategorySheetVisible = false
                                DividerSelect = false
                                tappedIncomeCategory = incomeCategory.rawValue
                            },
                            incomeCategoryColor: incomeCategory.incomeCategoryListColor)
                        .onTapGesture {
                            tappedIncomeCategory = incomeCategoryName
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 20)
    }
}

//struct IncomeCategorySheet_Previews: PreviewProvider {
//    static var previews: some View {
//        IncomeCategorySheet()
//    }
//}
