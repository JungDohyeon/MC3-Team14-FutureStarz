//
//  DateBreakdown.swift
//  GumungGagye
//
//  Created by Lee Juwon on 2023/07/11.
//

import SwiftUI

struct DateBreakdown: View {
    var body: some View {
        
        VStack(spacing: 0) {
            DateTotal()
                .padding(.bottom, 16)
            Breakdown() // 있는 내역 다 보여주기 - ForEach
        }
        
    }
}

struct DateBreakdown_Previews: PreviewProvider {
    static var previews: some View {
        DateBreakdown()
    }
}
