//
//  ModalView.swift
//  GumungGagye
//
//  Created by 신상용 on 2023/07/25.
//

import SwiftUI




struct ModalView: View {
    
    @State var account_type: Int = 0
    @State var account_date: Date?
    @State var spend_bill: Int?
    @State var spend_category: Int?
    @State var spend_content: String = ""
    
    @State var income_bill: Int?
    @State var income_category: Int?
    @State var income_content: String = ""
    
    
    @State var spend_bill_string: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                TopModalView(account_type: $account_type)
                
                if account_type == 0 {
                    SpendModalView(account_type: $account_type, account_date: $account_date, spend_bill: $spend_bill, spend_category: $spend_category, spend_content: $spend_content, spend_bill_string: $spend_bill_string)
                    
                    
                } else {
                    
                }
                Spacer()
            }
        }
        
    }
}

struct ModalView_Previews: PreviewProvider {
    static var previews: some View {
        ModalView()
            .previewLayout(.sizeThatFits)
    }
}
