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
    @Binding var overSpendSum: Int
    @Binding var spendTodaySum: Int
    @Binding var incomeTodaySum: Int
    
    var isGroup: Bool // 그룹에서 보일건지 내 뷰에서 보일건지 값
    
    @State var isSpendOnappear = true
    @State var isOverSpendOnappear = true
    @State var isIncomeOnappear = true
    
    // accountData를 전달받을 변수 추가
    var accountDataID: String

    var body: some View {
        HStack {
            if isGroup {
                if let spendData = spendData {
                    CategoryIcon(size: $size, accountType: 0, categoryIndex: spendData.category)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("-\(spendData.bill)원")
                            .modifier(Num3Bold())
                        
                        if spendData.open {
                            Text("\(spendData.content)")
                                .modifier(Cap2())
                        } else {
                            Image("Lock.fill.gray")
                                .resizable()
                                .frame(width: 11, height: 12)
                        }
                    }
                    .onAppear {
                        if isSpendOnappear {
                            spendSum += spendData.bill
                            spendTodaySum += spendData.bill
                            isSpendOnappear = false
                        }
                    }
                    
                    Spacer()
                    
                    HStack {
                        if !spendData.open {
                            HideTag(spendOpen: false)
                        }
                        if spendData.overConsume {
                            OverPurchaseTag(isOverPurchase: true)
                                .onAppear {
                                    if isOverSpendOnappear  {
                                        overSpendSum += spendData.bill
                                        isOverSpendOnappear = false
                                    }
                                }
                        }
                    }
                }
            } else {
                if let spendData = spendData {
                    CategoryIcon(size: $size, accountType: 0, categoryIndex: spendData.category)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("-\(spendData.bill)원")
                            .modifier(Num3Bold())
                        Text("\(spendData.content)")
                            .modifier(Cap2())
                    }
                    .onAppear {
                        if isSpendOnappear {
                            spendSum += spendData.bill
                            spendTodaySum += spendData.bill
                            isSpendOnappear = false
                        }
                    }
                    
                    Spacer()
                    
                    HStack {
                        if !spendData.open {
                            HideTag(spendOpen: false)
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
                            incomeTodaySum += incomeData.bill
                            isIncomeOnappear = false
                        }
                    }
                    
                    Spacer()
                } else {
                    Text("Data not found.")
                }
            }
        }
        .onAppear {
            BudgetFirebaseManager.shared.fetchAccountData(forAccountID: accountDataID) { data in
                self.spendData = data.0
                self.incomeData = data.1
            }
        }
    }
}


