//
//  BankCardPayView.swift
//  GumungGagye
//
//  Created by 신상용 on 2023/07/15.
//

import SwiftUI

struct BankCardPayView: View {
    
    var bankCardPay: Int
    var index: Int
    @Binding var selectBankCardPay: Int
    @Binding var selectBankCardPayIndex: Int
    @Binding var isAbled: Bool
    let inputdata = InputUserData.shared
    var card_info = [[0:""],[1: "신한은행", 2: "국민은행", 3: "하나은행", 4: "우리은행", 5: "농협은행", 6: "기업은행", 7: "제일은행", 8: "카카오뱅크", 9: "토스"], [1:"카카오페이", 2:"네이버페이", 3: "페이코"], [1:"신한카드", 2:"현대카드", 3:"삼성카드", 4:"롯데카드", 5:"국민카드", 6:"하나카드", 7:"우리카드", 8:"농협카드"]]
    
    var body: some View {
        VStack(spacing: 0) {
            Image("bank\(index)")
                .frame(width: 32, height: 32)
                .padding(.bottom, 4)
            Text(card_info[bankCardPay][index]!)
        }
        .frame(width: 108, height: 80)
        .background {
            Color("Gray4")
                
        }
        .cornerRadius(9)
        .overlay(
            RoundedRectangle(cornerRadius: 9)
                .inset(by: 2)
                .stroke(selectBankCardPay == bankCardPay && selectBankCardPayIndex == index ? Color("Main") : Color.clear, lineWidth: 2)
        )
        
        .onTapGesture {
            selectBankCardPay = bankCardPay
            selectBankCardPayIndex = index
            inputdata.bankcardpay = bankCardPay
            inputdata.bankcardpay_index = index
            isAbled = true
        }
        
    }
}

struct BankCardPayView_Previews: PreviewProvider {
    static var previews: some View {
        BankCardPayView(bankCardPay: 1, index: 9, selectBankCardPay: .constant(1), selectBankCardPayIndex: .constant(1), isAbled: .constant(false))
            .previewLayout(.fixed(width: 108, height: 80))
    }
}
