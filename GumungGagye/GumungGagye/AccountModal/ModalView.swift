//
//  ModalView.swift
//  GumungGagye
//
//  Created by 신상용 on 2023/07/25.
//

import SwiftUI




struct ModalView: View {
    @Binding var showAddModalView: Bool
    @State var account_type: Int = 0
    @State var account_date: Date?
    @State var spend_bill: Int?
    @State var spend_category: Int?
    @State var spend_content: String = ""
    @State var spend_open: Bool = false
    @State var spend_overConsume: Bool = false
    
    
    @State var income_bill: Int?
    @State var income_category: Int?
    @State var income_content: String = ""
    
    
    @State var spend_bill_string: String = ""
    @State var income_bill_string: String = ""
    
    var accountManager2 = AccountManager2.shared
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                TopModalView(account_type: $account_type, account_date: $account_date, spend_bill: $spend_bill, spend_category: $spend_category, spend_content: $spend_content, income_bill: $income_bill, income_category: $income_category, income_content: $income_content, spend_bill_string: $spend_bill_string, income_bill_string: $income_bill_string)
                
                if account_type == 0 {
                    SpendModalView(account_type: $account_type, account_date: $account_date, spend_bill: $spend_bill, spend_category: $spend_category, spend_content: $spend_content, spend_open: $spend_open, spend_overConsume: $spend_overConsume, spend_bill_string: $spend_bill_string)
                    
                    
                } else {
                    IncomeModalView(account_type: $account_type, account_date: $account_date, spend_bill: $income_bill, spend_category: $income_category, spend_content: $income_content, spend_bill_string: $income_bill_string)
                }
                Spacer()
                
                if account_type == 0 {
                    Nextbutton(title: "추가하기", isAbled: ((account_date) != nil) && ((spend_bill) != nil) && ((spend_category) != nil) && !(spend_content.isEmpty)) {
                        let inputSpendData = InputSpendData(account_type: account_type, account_date: account_date ?? Date(), spend_bill: spend_bill ?? 0, spend_category: spend_category ?? 0, spend_content: spend_content , spend_open: spend_open, spend_overConsume: spend_overConsume)
                        Task {
                            do {
                                try await accountManager2.createNewSpendAccount(inputSpendData: inputSpendData)
                            } catch {
                                print("Error")
                            }
                        }
                        showAddModalView = false
                        
                    }
                    .padding(.bottom, 71)
                    .padding(.horizontal, 20)
                } else if account_type == 1 {
                    
                    Text("수입은 그룹원에게 공개되지 않아요.")
                        .modifier(Body2())
                        .foregroundColor(Color("Gray2"))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 12)
                    
                    Nextbutton(title: "추가하기", isAbled: ((account_date) != nil) && ((income_bill) != nil) && ((income_category) != nil) && !(income_content.isEmpty)) {
                        let inputIncomeDate = InputIncomeData(account_type: account_type, account_date: account_date ?? Date(), income_bill: income_bill ?? 0, income_category: income_category ?? 0, income_content: income_content)
                        
                        Task {
                            do {
                                try await accountManager2.createNewIncomeAccount(inputIncomeData: inputIncomeDate)
                            } catch {
                                print("Error")
                            }
                        }
                        showAddModalView = false
                        
                    }
                    .padding(.bottom, 71)
                    .padding(.horizontal, 20)
                }
                
                
                
            }
        }
        
    }
}

struct ModalView_Previews: PreviewProvider {
    static var previews: some View {
        ModalView(showAddModalView: .constant(true))
            .previewLayout(.sizeThatFits)
    }
}




//Button(action: {
//    print(account_type)
//    print(account_date)
//    print(spend_bill)
//    print(spend_category)
//    print(spend_content)
//    print(spend_bill_string)
//
//}, label: {
//    Text("제출")
//})
