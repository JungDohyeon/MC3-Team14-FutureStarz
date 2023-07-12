//
//  ConnectView.swift
//  GumungGagye
//
//  Created by 손서연 on 2023/07/10.
//

import SwiftUI

struct ConnectView: View {
    @State var showAddModalView: Bool = false
    
    var body: some View {
        Button {
            self.showAddModalView = true
        } label: {
            Text("+추가")
        }
        .sheet(isPresented: self.$showAddModalView) {
            AddModalView()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }
}

struct ConnectView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectView()
    }
}
