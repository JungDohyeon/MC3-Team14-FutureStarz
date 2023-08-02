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
                            .keyboardType(.numberPad)
                            .foregroundColor(Color("Black"))
                            .modifier(Body1Bold())
//                            .onChange(of: spend_bill_string, perform: { newValue in
//                                spend_bill = Int(spend_bill_string)
//                                spend_bill_string = formatNumber(spend_bill)
//                            })
                            
                        }
                        HStack(spacing: 0) {
                            Spacer()
                            
                            Image("Pencil")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color("Gray2"))
                                .fontWeight(.bold)
                                .padding(.trailing, 11)
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
        .onAppear {
            spend_bill_string = formatNumber(spend_bill)
        }
        .onChange(of: spend_bill_string) { newValue in
            let cleanedValue = newValue.filter { "0123456789".contains($0) }
            spend_bill = Int(cleanedValue)
            
            spend_bill_string = formatNumber(spend_bill)
        }
        
    }
    
    // 세자리마다 쉼표를 추가하는 함수
    private func formatNumber(_ number: Int?) -> String {
        guard let number = number else {
            return ""
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number)) ?? ""
    }
    
}

struct BillmodalView_Previews: PreviewProvider {
    static var previews: some View {
        BillmodalView(spend_bill: .constant(10000), spend_bill_string: .constant(""))
            .previewLayout(.sizeThatFits)
    }
}
