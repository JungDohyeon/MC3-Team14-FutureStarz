//
//  DividerView.swift
//  GumungGagye
//
//  Created by jeongyun on 2023/07/11.
//

import SwiftUI

struct DividerView: View {
    var body: some View {
        Rectangle()
            .frame(maxWidth: .infinity, minHeight: 8, maxHeight: 8)
            .foregroundColor(Color("Gray4"))
    }
}

struct DividerView_Previews: PreviewProvider {
    static var previews: some View {
        DividerView()
    }
}
