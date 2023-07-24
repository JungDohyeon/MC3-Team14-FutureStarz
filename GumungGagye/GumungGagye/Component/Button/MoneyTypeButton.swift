//
//  MoneyTypeButton.swift
//  GumungGagye
//
//  Created by 손서연 on 2023/07/10.
//

import SwiftUI

//enum SelectedButtonType {
//    case expense
//    case income
//}

enum SelectedButtonType: Int {
    case expense = 0
    case income = 1
}

struct MoneyTypeButton: View {
    var moneyType: String
    @Binding var selectedType: Int
    @State var accountType: Int
    var action: () -> Void
    
//    init(moneyType: String, action: @escaping () -> Void) {
//        self.moneyType = moneyType
//
//        self.action = action
//    }
    
    var body: some View {
        Button {
            action()
            print(selectedType)
        } label: {
            Text(moneyType)
                .foregroundColor((selectedType == accountType) ? Color.white : Color("Gray3"))
                .modifier(Body1Bold())
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
        }
        .background((selectedType == accountType) ? Color("Main") : Color("Gray4"))
        .cornerRadius(5)
    }
}

//struct MoneyTypeButton_Previews: PreviewProvider {
//    static var previews: some View {
//        MoneyTypeButton(moneyType: "지출", selectedType: 0) {
//            print("지출")
//        }
//    }
//}
