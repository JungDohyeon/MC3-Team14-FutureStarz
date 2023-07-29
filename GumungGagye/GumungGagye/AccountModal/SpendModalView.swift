//
//  SpendModalView.swift
//  GumungGagye
//
//  Created by 신상용 on 2023/07/25.
//

import SwiftUI

struct SpendModalView: View {
    // MARK: - PROPERTY
    
    // MARK: - State
    
    
    
    // MARK: - Binding
    @Binding var account_type: Int
    @Binding var account_date: Date?
    @Binding var spend_bill: Int?
    @Binding var spend_category: Int?
    @Binding var spend_content: String
    
    
    
    @Binding var spend_bill_string: String
    
    // MARK: - BODY
    var body: some View {
        VStack(spacing: 0) {
            DatemodalView(account_date: $account_date)
            BillmodalView(spend_bill: $spend_bill, spend_bill_string: $spend_bill_string)
            CategorymodelView(account_type: $account_type, spend_category: $spend_category)
            ContentmodelView(spend_content: $spend_content)
            
        }
    }
}


// MARK: - PREVIEW
struct SpendModalView_Previews: PreviewProvider {
    static var previews: some View {
        SpendModalView(account_type: .constant(0), account_date: .constant(Date()), spend_bill: .constant(1234), spend_category: .constant(1), spend_content: .constant("안녕하세요"), spend_bill_string: .constant(""))
            .previewLayout(.sizeThatFits)
    }
}
