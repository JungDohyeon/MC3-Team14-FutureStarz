//
//  SeletingBudget.swift
//  GumungGagye
//
//  Created by 신상용 on 2023/07/14.
//

import SwiftUI

struct SelectingBudget: View {
    
    @State private var isActive: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Selecting Budget")
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton { presentationMode.wrappedValue.dismiss() })
    }
}

struct SelectingBudget_Previews: PreviewProvider {
    static var previews: some View {
        SelectingBudget()
    }
}
