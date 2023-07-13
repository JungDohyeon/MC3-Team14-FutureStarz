//
//  ConsListView.swift
//  GumungGagye
//
//  Created by Lee Juwon on 2023/07/10.
//

import SwiftUI

struct ConsListView: View {
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("내역")
                    .modifier(H2SemiBold())
                Spacer()
                SmallButton(text: "+ 추가"){
                    print("")
                }
            }
            .padding(.bottom, 36)
            

            ForEach(1..<10) {_ in
                DateBreakdown()
                    .padding(.bottom, 32)
            }
        }
        .padding(.horizontal, 20)
    }
}

struct ConsListView_Previews: PreviewProvider {
    static var previews: some View {
        ConsListView()
    }
}
