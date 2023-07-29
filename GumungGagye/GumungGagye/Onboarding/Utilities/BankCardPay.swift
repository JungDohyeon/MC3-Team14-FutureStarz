//
//  BankCardPay.swift
//  GumungGagye
//
//  Created by 신상용 on 2023/07/22.
//

import Foundation


final class BankCardPay: ObservableObject {
    static let shared = BankCardPay()

    var card_info = [[0:["선택안함", ""]],[1: ["신한은행", "solZzeung://"], 2: ["국민은행", "kbbank://"], 3: ["하나은행", ""], 4: ["우리은행", "Newsmartpib://"], 5: ["농협은행", ""], 6: ["기업은행", "ionebank://"], 7: ["제일은행", ""], 8: ["카카오뱅크", "kakaobank://"], 9: ["토스", "supertoss://"]], [1:["카카오페이", "kakaotalk://kakaopay/home"], 2:["네이버페이", "naverpayapp://"], 3: ["페이코", "payco://"]], [1:["신한카드", "shinhan-sr-ansimclick://"], 2:["현대카드", "hdcardappcardansimclick://"], 3:["삼성카드", "mpocket.online.ansimclick://"], 4:["롯데카드", "lotteappcard://"], 5:["국민카드", "kb-acp://"], 6:["하나카드", "cloudpay://"], 7:["우리카드", "com.wooricard.wcard://"], 8:["농협카드", "nhallonepayansimclick://"]]]
    
    

    private init() { }
}
