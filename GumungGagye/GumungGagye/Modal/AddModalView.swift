//
//  AddModalView.swift
//  GumungGagye
//
//  Created by 손서연 on 2023/07/10.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct AddModalView: View {
    @State var text: String = ""
    @State var currentDate: Date = Date()
    @State var number: String = ""
    //    @State var selectButton: SelectedButtonType = .expense
    @State var selectedType: Int = 0 // default: 지출
    @State var tappedExpenseCategory: String = ""
    @State var tappedIncomeCategory: String = ""
    @State var tappedDate: String = ""
    
    @State private var isCheckedExpense = false
    @State private var isCheckedShare = true
    
    var bankApp: String = "토스"
    var bankAppScheme: String = "supertoss://"
    
//    @StateObject private var viewModel = AddModalViewModel()
//    private var accountManager = AccountManager()
    var accountManager2 = AccountManager2.shared
    
    func clearData() {
        text = ""
        currentDate = Date()
        number = ""
        tappedExpenseCategory = ""
        tappedIncomeCategory = ""
        tappedDate = ""
        isCheckedExpense = false
        isCheckedShare = true
        //        isSelectButton = false
        selectedType = 0
    }
    
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
                        MoneyTypeButton(moneyType: "지출", selectedType: $selectedType, accountType: 0) {
                            selectedType = 0
                        }
                        
                        
                        MoneyTypeButton(moneyType: "수입", selectedType: $selectedType, accountType: 1) {
                            selectedType = 1
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
            if selectedType == 0 {
                BreakdownWriting(isDatePickerVisible: false, number: _number, selectedType: $selectedType, text: $text, currentDate: $currentDate, tappedExpenseCategory: $tappedExpenseCategory, tappedIncomeCategory: $tappedIncomeCategory, tappedDate: $tappedDate, item: .date, icon: .chevronRight, placeholder: "날짜를 선택하세요")
                //                    .focused($focusedField, equals: .fixDate)
                
                BreakdownWriting(isDatePickerVisible: false, number: _number, selectedType: $selectedType, text: $text, currentDate: $currentDate, tappedExpenseCategory: $tappedExpenseCategory, tappedIncomeCategory: $tappedIncomeCategory, tappedDate: $tappedDate, item: .money, icon: .pencil, placeholder: "금액을 입력하세요")
                //                    .focused($focusedField, equals: .addPayment)
                
                BreakdownWriting(isDatePickerVisible: false, number: _number, selectedType: $selectedType, text: $text, currentDate: $currentDate, tappedExpenseCategory: $tappedExpenseCategory, tappedIncomeCategory: $tappedIncomeCategory, tappedDate: $tappedDate, item: .category, icon: .chevronRight, placeholder: "카테고리를 선택하세요")
                //                    .focused($focusedField, equals: .addCategory)
                
                BreakdownWriting(isDatePickerVisible: false, number: _number, selectedType: $selectedType, text: $text, currentDate: $currentDate, tappedExpenseCategory: $tappedExpenseCategory, tappedIncomeCategory: $tappedIncomeCategory, tappedDate: $tappedDate,  item: .content, icon: .pencil, placeholder: "내용을 남겨주세요")
                //                    .focused($focusedField, equals: .addContent)
                
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
                                .font(.system(size: 24))
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
                                .font(.system(size: 24))
                                .foregroundColor(isCheckedShare ? Color("Main") : Color("Gray2"))
                        }
                    }
                }
                
                Spacer()
                
                Nextbutton(title: "추가하기", isAbled: !(number.isEmpty) && !(text.isEmpty) && !(tappedExpenseCategory.isEmpty)) {
                    let spendData = SpendData(account_type: selectedType, account_date: currentDate, spend_bill: number, spend_category: tappedExpenseCategory, spend_content: text, spend_open: isCheckedShare, spend_overConsume: isCheckedExpense)
                    Task {
                        do {
                            try await accountManager2.createNewSpendAccount(spendData: spendData)
                        } catch {
                            print("Error")
                        }
                    }
                    
                    
                    
                    print(currentDate)
                    print("plus")
                    print(text)
                    print(number)
                    print(tappedDate)
                    print(tappedExpenseCategory)
                    print(isCheckedShare)
                    print(isCheckedExpense)
                    print(selectedType)
                    
                    
                    
                    
                    
                    
                    // Firestore에 데이터 저장
                    //                    let dateFormatter = DateFormatter()
                    //                    dateFormatter.dateFormat = "yyyy년 MM월 dd일"
                    //                    let dateString = tappedDate
                    //
                    //                    if let date = dateFormatter.date(from: dateString) {
                    //                    let expenseData = ExpenseData(
                    //                        userID: accountManager.db.collection("users").document("YOUR_USER_ID"),
                    //                        account_date: date,
                    //                        spend_bill: Int(Double(number) ?? 0.0),
                    //                        spend_category: tappedExpenseCategory,
                    //                        spend_content: text,
                    //                        spend_overConsume: isCheckedExpense,
                    //                        spend_open: isCheckedShare
                    //                            )
                    //                    accountManager.addExpenseData(expenseData: expenseData)
                    //                    clearData() // 데이터 초기화
                    //                    } else {
                    //                        // 날짜 변환에 실패한 경우, 필요에 따라 오류를 처리
                    //                    }
                }
                .padding(.bottom, 71)
            }
            // MARK: - 수입일 경우
            else if selectedType == 1 {
                BreakdownWriting(isDatePickerVisible: false, number: _number, selectedType: $selectedType, text: $text, currentDate: $currentDate, tappedExpenseCategory: $tappedExpenseCategory, tappedIncomeCategory: $tappedIncomeCategory, tappedDate: $tappedDate, item: .date, icon: .chevronRight, placeholder: "날짜를 선택하세요")
                
                BreakdownWriting(isDatePickerVisible: false, number: _number, selectedType: $selectedType, text: $text, currentDate: $currentDate, tappedExpenseCategory: $tappedExpenseCategory, tappedIncomeCategory: $tappedIncomeCategory, tappedDate: $tappedDate, item: .money, icon: .pencil, placeholder: "금액을 입력하세요")
                
                BreakdownWriting(isDatePickerVisible: false, number: _number, selectedType: $selectedType, text: $text, currentDate: $currentDate, tappedExpenseCategory: $tappedExpenseCategory, tappedIncomeCategory: $tappedIncomeCategory, tappedDate: $tappedDate, item: .category, icon: .chevronRight, placeholder: "카테고리를 선택하세요")
                
                BreakdownWriting(isDatePickerVisible: false, number: _number, selectedType: $selectedType, text: $text, currentDate: $currentDate, tappedExpenseCategory: $tappedExpenseCategory, tappedIncomeCategory: $tappedIncomeCategory, tappedDate: $tappedDate, item: .content, icon: .pencil, placeholder: "내용을 남겨주세요")
                
                Spacer()
                
                VStack {
                    Text("수입은 그룹원에게 공개되지 않아요.")
                        .modifier(Body2())
                        .foregroundColor(Color("Gray2"))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 12)
                    
                    Nextbutton(title: "추가하기", isAbled: !(number.isEmpty) && !(text.isEmpty) && !(tappedExpenseCategory.isEmpty)) {
                        let incomeDate = IncomeData(account_type: selectedType, account_date: currentDate, income_bill: number, income_category: tappedIncomeCategory, income_content: text)
                        
                        Task {
                            do {
                                try await accountManager2.createNewIncomeAccount(incomeData: incomeDate)
                            } catch {
                                print("Error")
                            }
                        }
                        
                        print("plus")
                        print(text)
                        print(number)
                        print(currentDate)
                        print(tappedIncomeCategory)
                        print(selectedType)
                        // Firestore에 데이터 저장
                        //                        let dateFormatter = DateFormatter()
                        //                        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
                        //                        let dateString = tappedDate
                        //
                        //                        if let date = dateFormatter.date(from: dateString) {
                        //                            let incomeData = IncomeData(
                        //                                userID: accountManager.db.collection("users").document("YOUR_USER_ID"),
                        //                                account_date: date,
                        //                                income_bill: Int(Double(number) ?? 0.0),
                        //                                income_category: tappedIncomeCategory,
                        //                                income_content: text
                        //                            )
                        //                        accountManager.addIncomeData(incomeData: incomeData)
                        //                        } else {
                        //                            // 날짜 변환에 실패한 경우, 필요에 따라 오류를 처리
                        //                        }
                        //                    }
                    }
                    .padding(.bottom, 71)
                }
                .padding(.top, 50)
                .padding(.horizontal, 20)
                .ignoresSafeArea()
                .onDisappear {
                    // 뷰가 사라질 때 viewModel의 clearData 메서드를 호출하여 데이터 초기화
                    clearData()
                }
            }
        }
    }
}


struct AddModalView_Previews: PreviewProvider {
    static var previews: some View {
        AddModalView()
    }
}
