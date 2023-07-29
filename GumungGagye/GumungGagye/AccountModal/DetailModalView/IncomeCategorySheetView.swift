//
//  IncomeCategorySheetView.swift
//  GumungGagye
//
//  Created by 신상용 on 2023/07/28.
//

import SwiftUI

struct IncomeCategorySheetView: View {
    // MARK: - PROPERTY
    @Binding var isCategoryPickerVisible: Bool
    @Binding var spend_category: Int?
    // MARK: - BODY
    var body: some View {
        Text("IncomeCategorySheetView")
    }
}

struct IncomeCategorySheetView_Previews: PreviewProvider {
    static var previews: some View {
        IncomeCategorySheetView(isCategoryPickerVisible: .constant(true), spend_category: .constant(1))
    }
}
