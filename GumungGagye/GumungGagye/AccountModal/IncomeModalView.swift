//
//  IncomeModalView.swift
//  GumungGagye
//
//  Created by 신상용 on 2023/07/25.
//

import SwiftUI

struct IncomeModalView: View {
    
    @Binding var account_type: Int
    @Binding var account_date: Date?
    @Binding var income_bill: Int?
    @Binding var income_category: Int?
    @Binding var income_content: String?
    
    
    
    @Binding var spend_bill_string: String
    
    var body: some View {
        VStack(spacing: 0) {
            
        }
    }
}

struct IncomeModalView_Previews: PreviewProvider {
    static var previews: some View {
        IncomeModalView(account_type: .constant(0), account_date: .constant(Date()), income_bill: .constant(1234), income_category: .constant(1), income_content: .constant("안녕하세요"), spend_bill_string: .constant(""))
            .previewLayout(.sizeThatFits)
    }
}
