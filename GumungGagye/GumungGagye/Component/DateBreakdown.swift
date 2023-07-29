//
//  DateBreakdown.swift
//  GumungGagye
//
//  Created by Lee Juwon on 2023/07/11.
//

import SwiftUI

struct DateBreakdown: View {
    var accountDataList: [AccountData]
    @Binding var size: IconSize

    var body: some View {
        VStack(spacing: 0) {
            DateTotal()
                .padding(.bottom, 16)

//            ForEach(accountDataList) { accountData in
//                Breakdown(accountData: accountData, size: $size)
//                    .padding(.bottom, 20)
//            }
        }
    }
}


//struct DateBreakdown_Previews: PreviewProvider {
//    static var previews: some View {
//        DateBreakdown()
//    }
//}

