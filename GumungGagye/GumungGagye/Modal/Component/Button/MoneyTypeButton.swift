//
//  MoneyTypeButton.swift
//  GumungGagye
//
//  Created by 손서연 on 2023/07/10.
//

import SwiftUI

enum SelectedButtonType {
    case expense
    case income
}

struct MoneyTypeButton: View {
    var moneyType: String
    var isSelected: Bool
    var action: () -> Void
    init(moneyType: String, isSelected: Bool, action: @escaping () -> Void) {
        self.moneyType = moneyType
        self.isSelected = isSelected
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(moneyType)
                .foregroundColor(isSelected ? Color.white : Color("Gray3"))
                .modifier(Body1Bold())
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
        }
        .background(isSelected ? Color("Main") : Color("Gray4"))
        .cornerRadius(5)
    }
}

struct MoneyTypeButton_Previews: PreviewProvider {
    static var previews: some View {
        MoneyTypeButton(moneyType: "지출", isSelected: true) {
            print("지출")
        }
    }
}
