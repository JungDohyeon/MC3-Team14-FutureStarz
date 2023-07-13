//
//  AddModalView.swift
//  GumungGagye
//
//  Created by 손서연 on 2023/07/10.
//

import SwiftUI

struct AddModalView: View {
    @State var text: String = ""
    @State var currentDate: Date = Date()
    @State var number: String = ""
    @State var selectButton: SelectedButtonType = .expense
    @State var tappedExpenseCategory: String = ""
    @State var tappedIncomeCategory: String = ""
    @State var tappedDate: String = ""
    
    @State private var isCheckedExpense = false
    @State private var isCheckedShare = true
    
    var bankApp: String = "토스"
    var bankAppScheme: String = "supertoss://"
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("내역 추가하기")
                    .modifier(H1Bold())
                    .foregroundColor(Color("Black"))
                
                Spacer()
                
                SmallButton(text: "\(bankApp) 열기"){
                    let app = bankAppScheme
                    let appURL = NSURL(string: app)
                    if (UIApplication.shared.canOpenURL(appURL! as URL)) {
                        UIApplication.shared.open(appURL! as URL)
                    }
                    else {
                        print("No App installed.")
                    }
                }
            }
            // MARK: - 거래 유형
            VStack(alignment: .leading) {
                HStack(spacing: 24) {
                    Text("거래 유형")
                        .modifier(Body2())
                        .foregroundColor(Color("Gray1"))
                        .frame(width: 52, alignment: .leading)
                    
                    HStack(spacing: 12) {
                        MoneyTypeButton(moneyType: "지출", isSelected: selectButton == .expense) {
                            selectButton = .expense
                        }
                        
                        MoneyTypeButton(moneyType: "수입", isSelected: selectButton == .income) {
                            selectButton = .income
                        }
                    }
                }
                .padding(.vertical, 15)
                .padding(.leading, 12)
                
                // MARK: - 구분선
                Divider()
                    .frame(height: 1)
                    .overlay(Color("Gray4"))
            }
            
            // MARK: - 지출일 경우
            if selectButton == .expense {
                BreakdownWriting(isDatePickerVisible: false, number: _number, selectedButton: $selectButton, text: $text, currentDate: $currentDate, tappedExpenseCategory: $tappedExpenseCategory, tappedIncomeCategory: $tappedIncomeCategory, tappedDate: $tappedDate, item: .date, icon: .chevronRight, placeholder: "날짜를 선택하세요")
                
                BreakdownWriting(isDatePickerVisible: false, number: _number, selectedButton: $selectButton, text: $text, currentDate: $currentDate, tappedExpenseCategory: $tappedExpenseCategory, tappedIncomeCategory: $tappedIncomeCategory, tappedDate: $tappedDate, item: .money, icon: .pencil, placeholder: "금액을 입력하세요")
                
                BreakdownWriting(isDatePickerVisible: false, number: _number, selectedButton: $selectButton, text: $text, currentDate: $currentDate, tappedExpenseCategory: $tappedExpenseCategory, tappedIncomeCategory: $tappedIncomeCategory, tappedDate: $tappedDate, item: .category, icon: .chevronRight, placeholder: "카테고리를 선택하세요")
                
                BreakdownWriting(isDatePickerVisible: false, number: _number, selectedButton: $selectButton, text: $text, currentDate: $currentDate, tappedExpenseCategory: $tappedExpenseCategory, tappedIncomeCategory: $tappedIncomeCategory, tappedDate: $tappedDate,  item: .content, icon: .pencil, placeholder: "내용을 남겨주세요")
                
                VStack(spacing: 24) {
                    
                    Button {
                        isCheckedExpense.toggle()
                    } label: {
                        HStack {
                            Text("이번에 과소비를 했어요.")
                                .modifier(Body1())
                                .foregroundColor(Color("Black"))
                            
                            Spacer()
                            
                            Image(systemName: isCheckedExpense ? "checkmark.square.fill" : "checkmark.square")
                                .foregroundColor(isCheckedExpense ? Color("Main") : Color("Gray2"))
                        }
                    }
                    .padding(.top, 18)
                    
                    Button {
                        isCheckedShare.toggle()
                    } label: {
                        HStack {
                            Text("이번 지출 내역을 그룹원에게 공개할게요.")
                                .modifier(Body1())
                                .foregroundColor(Color("Black"))
                            
                            Spacer()
                            
                            Image(systemName: isCheckedShare ? "checkmark.square.fill" : "checkmark.square")
                                .foregroundColor(isCheckedShare ? Color("Main") : Color("Gray2"))
                        }
                    }
                }
                
                Spacer()
                
                Nextbutton(title: "추가하기", isAbled: !(number.isEmpty) && !(text.isEmpty) && !(tappedExpenseCategory.isEmpty)) {
                    print("plus")
                }
                .padding(.bottom, 71)
            }
            // MARK: - 수입일 경우
            else if selectButton == .income {
                BreakdownWriting(isDatePickerVisible: false, number: _number, selectedButton: $selectButton, text: $text, currentDate: $currentDate, tappedExpenseCategory: $tappedExpenseCategory, tappedIncomeCategory: $tappedIncomeCategory, tappedDate: $tappedDate, item: .date, icon: .chevronRight, placeholder: "날짜를 선택하세요")
                
                BreakdownWriting(isDatePickerVisible: false, number: _number, selectedButton: $selectButton, text: $text, currentDate: $currentDate, tappedExpenseCategory: $tappedExpenseCategory, tappedIncomeCategory: $tappedIncomeCategory, tappedDate: $tappedDate, item: .money, icon: .pencil, placeholder: "금액을 입력하세요")
                
                BreakdownWriting(isDatePickerVisible: false, number: _number, selectedButton: $selectButton, text: $text, currentDate: $currentDate, tappedExpenseCategory: $tappedExpenseCategory, tappedIncomeCategory: $tappedIncomeCategory, tappedDate: $tappedDate, item: .category, icon: .chevronRight, placeholder: "카테고리를 선택하세요")
                
                BreakdownWriting(isDatePickerVisible: false, number: _number, selectedButton: $selectButton, text: $text, currentDate: $currentDate, tappedExpenseCategory: $tappedExpenseCategory, tappedIncomeCategory: $tappedIncomeCategory, tappedDate: $tappedDate, item: .content, icon: .pencil, placeholder: "내용을 남겨주세요")
                
                Spacer()
                
                VStack {
                    Text("수입은 그룹원에게 공개되지 않아요.")
                        .modifier(Body2())
                        .foregroundColor(Color("Gray2"))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 12)
                    
                    Nextbutton(title: "추가하기", isAbled: !(number.isEmpty) && !(text.isEmpty) && !(tappedExpenseCategory.isEmpty)) {
                        print("plus")
                    }
                }
                .padding(.bottom, 71)
            }
        }
        .padding(.top, 50)
        .padding(.horizontal, 20)
        .ignoresSafeArea()
    }
}

struct AddModalView_Previews: PreviewProvider {
    static var previews: some View {
        AddModalView()
    }
}
