//
//  BillmodalView.swift
//  GumungGagye
//
//  Created by 신상용 on 2023/07/27.
//

import SwiftUI

struct BillmodalView: View {
    // MARK: - PROPERTY
    
    @Binding var spend_bill: Int?
    @Binding var spend_bill_string: String

    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text("금액")
                        .modifier(Body2())
                        .foregroundColor(Color("Gray1"))
                        .padding(.trailing, 50)
                    ZStack(alignment: .leading){
                        ZStack(alignment: .leading) {
                            if spend_bill_string.isEmpty {
                                Text("지출 금액을 입력하세요")
                                    .foregroundColor(Color("Gray2"))
                                    .modifier(Body1())
                            }
                            
                            TextField("", text: $spend_bill_string, onEditingChanged: { isEditing in
                               
                            })
                            .padding(.vertical, 22)
                            .keyboardType(.decimalPad)
                            .foregroundColor(Color("Black"))
                            .modifier(Body1Bold())
                            .onChange(of: spend_bill_string, perform: { newValue in
                                spend_bill = Int(spend_bill_string)
                            })
                            
                        }
                        HStack(spacing: 0) {
                            Spacer()
                            
                            Image("Pencil")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color("Gray2"))
                                .fontWeight(.bold)
                                .padding(.trailing, 11)
                            //화살표 이미지
//                            Image(systemName: "chevron.right")
//                                .frame(width: 24, height: 24)
//                                .foregroundColor(Color("Gray2"))
//                                .fontWeight(.bold)
//                                .padding(.trailing, 11)
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

struct BillmodalView_Previews: PreviewProvider {
    static var previews: some View {
        BillmodalView(spend_bill: .constant(10000), spend_bill_string: .constant(""))
            .previewLayout(.sizeThatFits)
    }
}
