//
//  Breakdown.swift
//  GumungGagye
//
//  Created by Lee Juwon on 2023/07/11.
//
import SwiftUI

struct Breakdown: View {
    @StateObject var userData = InputUserData.shared
    
    @State private var spendData: ReadSpendData?
    @State private var incomeData: ReadIncomeData?
 
    @Binding var size: IconSize
    @Binding var incomeSum: Int
    @Binding var spendSum: Int
    
    @State var isSpendOnappear = true
    @State var isIncomeOnappear = true

    // accountData를 전달받을 변수 추가
    var accountDataID: String

    var body: some View {
        HStack {
            if let spendData = spendData {
                CategoryIcon(size: $size, accountType: 0, categoryIndex: spendData.category)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("-\(spendData.bill)")
                        .modifier(Num3Bold())
                    Text("\(spendData.content)")
                        .modifier(Cap2())
                }
                .onAppear {
                    if isSpendOnappear {
                        spendSum += spendData.bill
                        isSpendOnappear = false
                    }
                }
                
                Spacer()
                
                HStack {
                    if spendData.open {
                        OpenTag(spendOpen: true)
                    }
                    if spendData.overConsume {
                        OverPurchaseTag(isOverPurchase: true)
                    }
                }
                
            } else if let incomeData = incomeData {
                CategoryIcon(size: $size, accountType: 1, categoryIndex: incomeData.category)

                VStack(alignment: .leading, spacing: 2) {
                    Text("+\(incomeData.bill)")
                        .modifier(Num3Bold())
                    Text("\(incomeData.content)")
                        .modifier(Cap2())
                }
                .onAppear {
                    if isIncomeOnappear {
                        incomeSum += incomeData.bill
                        isIncomeOnappear = false
                    }
                }
                

                Spacer()
            } else {
                Text("Data not found.")
            }
        }
        .padding(.bottom, 20)
        .onAppear {
            incomeSum = 0
            spendSum = 0
            
            BudgetFirebaseManager.shared.fetchAccountData(forAccountID: accountDataID) { data in
                self.spendData = data.0
                self.incomeData = data.1
            }
        }
    }
}


