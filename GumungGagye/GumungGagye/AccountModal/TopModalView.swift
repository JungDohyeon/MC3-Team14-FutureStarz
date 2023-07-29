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
                    }
                    .padding(.trailing, 12)
                    
                    
                    MoneyTypeButton(moneyType: "수입", selectedType: $account_type, accountType: 1) {
                        account_type = 1
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


// MARK: - PREVIEW
struct TopModalView_Previews: PreviewProvider {
    static var previews: some View {
        TopModalView(account_type: .constant(0))
            .previewLayout(.sizeThatFits)
//            .padding()
    }
}
