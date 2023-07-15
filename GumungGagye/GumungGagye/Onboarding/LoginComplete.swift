//
//  LoginComplete.swift
//  GumungGagye
//
//  Created by 신상용 on 2023/07/15.
//

import SwiftUI

struct LoginComplete: View {
    @AppStorage("app_name") var app_name: String = ""
    @AppStorage("bankCardPay") var bankCardPay: Int = 0
    @AppStorage("bankCardPayIndex") var bankCardPayIndex: Int = 0
    @AppStorage("budget") var budget: String = ""
    
    var body: some View {
        VStack {
            Text("Login Complete")
            Text(app_name)
            Text("\(bankCardPay)")
            Text("\(bankCardPayIndex)")
            Text(budget)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct LoginComplete_Previews: PreviewProvider {
    static var previews: some View {
        LoginComplete()
    }
}
