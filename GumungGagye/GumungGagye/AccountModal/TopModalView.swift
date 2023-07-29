//
//  TopModalView.swift
//  GumungGagye
//
//  Created by 신상용 on 2023/07/25.
//

import SwiftUI

struct TopModalView: View {
    // MARK: - PROPERTY
    
    @StateObject var inputdata = InputUserData.shared
    @Binding var account_type: Int
    @Binding var account_date: Date?
    @Binding var spend_bill: Int?
    @Binding var spend_category: Int?
    @Binding var spend_content: String
    
    @Binding var income_bill: Int?
    @Binding var income_category: Int?
    @Binding var income_content: String
    
    
    @Binding var spend_bill_string: String
    @Binding var income_bill_string: String
    
    // MARK: - BODY
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                //제일 위에 있는 내역 추가하기 줄
                HStack {
                    Text("내역 추가하기")
                        .modifier(H1Bold())
                        .foregroundColor(Color("Black"))
                    
                    Spacer()
//                    Text(inputdata.bankcardpay_info[0])
                    
                    if inputdata.bankcardpay == 0 {
                        
                    } else {
                        SmallButton(text: "\(inputdata.bankcardpay_info[0]) 열기"){
                            let app = inputdata.bankcardpay_info[1]
                            let appURL = NSURL(string: app)
                            if (UIApplication.shared.canOpenURL(appURL! as URL)) {
                                UIApplication.shared.open(appURL! as URL)
                            }
                            else {
                                print("No App installed.")
                            }
                        }
                    }
                } //: HSTACK
                .padding(.top, 50)
                .padding(.bottom, 48)
                
                HStack(spacing: 0) {
                    Text("거래유형")
                        .modifier(Body2())
                        .foregroundColor(Color("Gray1"))
                        .padding(.trailing, 23)
                    
                    MoneyTypeButton(moneyType: "지출", selectedType: $account_type, accountType: 0) {
                        account_type = 0
                        reset()
                    }
                    .padding(.trailing, 12)
                    
                    
                    MoneyTypeButton(moneyType: "수입", selectedType: $account_type, accountType: 1) {
                        account_type = 1
                        reset()
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 15)
                .padding(.leading, 11)
                
                Divider()
                    .frame(height: 1)
                    .overlay(Color("Gray4"))
            }
        }
        .padding(.horizontal, 20)
        
    }
}


//account_date: Date?
//@Binding var spend_bill: Int?
//@Binding var spend_category: Int?
//@Binding var spend_content: String
//
//@Binding var income_bill: Int?
//@Binding var income_category: Int?
//@Binding var income_content: String
//
//
//@Binding var spend_bill_string: String
//@Binding var income_bill_string: String

extension TopModalView {
    private func reset() {
        account_date = nil
        spend_bill = nil
        spend_category = nil
        spend_content = ""
        income_bill = nil
        income_category = nil
        income_content =  ""
        spend_bill_string = ""
        income_bill_string = ""
    }
}

// MARK: - PREVIEW
struct TopModalView_Previews: PreviewProvider {
    static var previews: some View {
        TopModalView(account_type: .constant(0), account_date: .constant(Date()), spend_bill: .constant(123), spend_category: .constant(1), spend_content: .constant("예시입니다."), income_bill: .constant(123), income_category: .constant(1), income_content: .constant("예시입니다."), spend_bill_string: .constant("예시입니다."), income_bill_string: .constant("예시입니다."))
            .previewLayout(.sizeThatFits)
//            .padding()
    }
}
