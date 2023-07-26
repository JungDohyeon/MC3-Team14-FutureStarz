//
//  CategorySheet.swift
//  GumungGagye
//
//  Created by 손서연 on 2023/07/11.
//

import SwiftUI

struct ExpenseCategoryButton: View {
    var expenseCategoryName: String
    var isSelected: Bool
    var action: () -> Void
    var expenseCategoryIcon: String
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack(alignment: .center, spacing: 4) {
                CategoryIcon(size: .small, category: expenseCategoryIcon)
                Text(expenseCategoryName)
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

enum ExpenseCategoryList: String, CaseIterable {
    case food = "식비"
    case cafe = "카페"
    case alcohol = "술∙유흥"
    case vehicle = "교통∙차량"
    case leisure = "문화∙여가"
    case traffic = "주거∙통신"
    case store = "마트∙편의점∙잡화"
    case fashion = "패션∙미용"
    case living = "생활"
    case health = "의료∙건강"
    case education = "교육"
    case congratulation = "경조사∙회비"
    case etc = "기타"
    
    var expenseCategoryListIcon: String {
        switch self {
        case .food: return "Food"
        case .cafe: return "Cafe"
        case .alcohol: return "Alcohol"
        case .vehicle: return "Vehicle"
        case .leisure: return "Leisure"
        case .traffic: return "Traffic"
        case .store: return "Store"
        case .fashion: return "Fashion"
        case .living: return "Living"
        case .health: return "Health"
        case .education: return "Education"
        case .congratulation: return "Congratulation"
        case .etc: return "Etc"
        }
    }
}

struct ExpenseCategorySheet: View {
    
    @Binding var tappedExpenseCategory: String
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
                    ForEach(ExpenseCategoryList.allCases, id: \.self) { expenseCategory in
                        let expenseCategoryName = expenseCategory.rawValue
                        
                        ExpenseCategoryButton(
                            expenseCategoryName: expenseCategory.rawValue,
                            isSelected: expenseCategory.rawValue == tappedExpenseCategory,
                            action: {
                                isCategorySheetVisible = false
                                DividerSelect = false
                                tappedExpenseCategory = expenseCategory.rawValue
                            },
                            expenseCategoryIcon: expenseCategory.expenseCategoryListIcon)
                        .onTapGesture {
                            tappedExpenseCategory = expenseCategoryName
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 20)
    }
}

//struct ExpenseCategorySheet_Previews: PreviewProvider {
//    static var previews: some View {
//        ExpenseCategorySheet()
//    }
//}
