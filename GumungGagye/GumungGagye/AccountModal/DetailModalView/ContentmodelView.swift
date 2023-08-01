//
//  ContentmodelView.swift
//  GumungGagye
//
//  Created by 신상용 on 2023/07/28.
//

import SwiftUI

struct ContentmodelView: View {
    // MARK: - PROPERTY
    @Binding var spend_content: String
    var getMaxString: Int
    
    
    // MARK: - BODY
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text("내용")
                        .modifier(Body2())
                        .foregroundColor(Color("Gray1"))
                        .padding(.trailing, 50)
                    ZStack(alignment: .leading){
                        ZStack(alignment: .leading) {
                            if spend_content.isEmpty {
                                Text("내용을 남겨보세요")
                                    .foregroundColor(Color("Gray2"))
                                    .modifier(Body1())
                            }
                            
                            TextField("", text: $spend_content, onEditingChanged: { isEditing in
                               
                            })
                            .padding(.vertical, 22)
                            .foregroundColor(Color("Black"))
                            .modifier(Body1Bold())
                            .submitLabel(.done)
                        }
                        HStack(spacing: 0) {
                            Spacer()
                            HStack(spacing: 0) {
                                Text(spend_content.count.description)
                                Text("/")
                                Text(getMaxString.description)
                            }
                            .modifier(Cap1())
                            .foregroundColor(Color("Gray2"))
                        }
                        
                    } //: HSTACK
                    Spacer()
                }
            }
            .padding(.leading, 11)
            Divider()
                .frame(height: 1)
                .overlay(Color("Gray4"))
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - PREVIEW
struct ContentmodelView_Previews: PreviewProvider {
    static var previews: some View {
        ContentmodelView(spend_content: .constant(""), getMaxString: 15)
    }
}
