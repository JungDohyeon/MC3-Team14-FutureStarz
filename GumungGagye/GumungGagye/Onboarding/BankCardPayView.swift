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

    let bankCardPayData = BankCardPay.shared
    
    var body: some View {
        VStack(spacing: 0) {
//            Image("bank\(index)")
            Image(bankCardPayData.card_info[bankCardPay][index]![0])
                .frame(width: 32, height: 32)
                .padding(.bottom, 4)
            Text(bankCardPayData.card_info[bankCardPay][index]![0])
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
//            inputdata.bankcardpay = bankCardPay
//            inputdata.bankcardpay_index = index
//            inputdata.bankcardpay_info = bankCardPayData.card_info[bankCardPay][index]
            isAbled = true
        }
        
    }
}

struct BankCardPayView_Previews: PreviewProvider {
    static var previews: some View {
        BankCardPayView(bankCardPay: 1, index: 1, selectBankCardPay: .constant(1), selectBankCardPayIndex: .constant(1), isAbled: .constant(false))
            .previewLayout(.fixed(width: 108, height: 80))
    }
}
