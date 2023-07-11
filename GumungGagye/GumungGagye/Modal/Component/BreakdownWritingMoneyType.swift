//
//  BreakdownWriting.swift
//  GumungGagye
//
//  Created by 손서연 on 2023/07/10.
//

import SwiftUI

enum SelectedButtonType {
    case expense
    case income
}

struct BreakdownWritingMoneyType: View {
    @State private var selectButton: SelectedButtonType = .expense
    var moneyType: String
    var isSelected: Bool
    var action: () -> Void
    
    
    init(selectButton: SelectedButtonType, moneyType: String, isSelected: Bool, action: @escaping () -> Void) {
        self.selectButton = selectButton
        self.moneyType = moneyType
        self.isSelected = isSelected
        self.action = action
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 50) {
                Text("거래 유형")
                    .modifier(Body2())
                    .foregroundColor(Color("Gray1"))
                
                HStack(spacing: 12) {
                    MoneyTypeButton(moneyType: "지출", isSelected: selectButton == .expense) {
                        selectButton = .expense
                    }
                    
                    MoneyTypeButton(moneyType: "수입", isSelected: selectButton == .income) {
                        selectButton = .income
                    }
                }
            }
            .padding(.vertical, 15)
            .padding(.leading, 12)
            //            .padding(.trailing, 133)
        }
        .overlay(
            VStack {
                Spacer()
                Capsule()
                    .foregroundColor(Color("Gray4"))
                    .frame(height: 1)
            }
        )
    }
}


struct BreakdownWritingMoneyType_Previews: PreviewProvider {
    static var previews: some View {
        BreakdownWritingMoneyType(selectButton: .expense, moneyType: "지출", isSelected: true, action: {
            print("dddd")})
    }
}
