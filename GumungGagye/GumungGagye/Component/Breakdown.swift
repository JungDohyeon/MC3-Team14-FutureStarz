//
//  Breakdown.swift
//  GumungGagye
//
//  Created by Lee Juwon on 2023/07/11.
//

import SwiftUI

struct Breakdown: View {
    @StateObject var userData = InputUserData.shared
    var readAccountManager = ReadAccountManager.shared
    
    let accountData: AccountData

    @Binding var size: IconSize

    var body: some View {
        HStack {
            if accountData.account_type == 0 {
                if let spendData = accountData.spend_data {
                    CategoryIcon(size: $size, accountType: 0, categoryIndex: spendData.spend_category)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(spendData.spend_bill)")
                            .modifier(Num3Bold())
                        Text("\(spendData.spend_content)")
                            .modifier(Cap2())
                    }
                    
                    Spacer()
                    
                    HStack {
                        if spendData.spend_open {
                            OpenTag(spendOpen: true)
                        }
                        if spendData.spend_overConsume {
                            OverPurchaseTag(isOverPurchase: true)
                        }
                    }
                    
                    let _ = print("\(spendData.spend_category)")
                    let _ = print("\(spendData.spend_bill)")
                    let _ = print("\(spendData.spend_content)")
                    
                }
            } else if accountData.account_type == 1 {
                if let incomeData = accountData.income_data {
                    CategoryIcon(size: $size, accountType: 1, categoryIndex: incomeData.income_category)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(incomeData.income_bill)")
                            .modifier(Num3Bold())
                        Text("\(incomeData.income_content)")
                            .modifier(Cap2())
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

