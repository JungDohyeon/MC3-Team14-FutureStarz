//
//  SelectingBankView.swift
//  GumungGagye
//
//  Created by 신상용 on 2023/07/22.
//

import SwiftUI
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import FirebaseStorage

struct SelectingBankView: View {
    
//    @StateObject var inputdata = InputUserData.shared
    @State var logic: Bool = false
    @State var selectBankCardPay: Int
    @State var selectBankCardPayIndex: Int
    
    @State var isAbled: Bool = false
    @Binding var bankCardPaySetting: Bool
    let inputdata = InputUserData.shared
    let bankCardPayData = BankCardPay.shared
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment:.leading, spacing: 0) {
                
                Text("주로 소비 내역을 확인하시는\n앱을 선택해주세요")
                    .modifier(H1Bold())
                    .padding(.bottom, 12)
                    .padding(.top, 50)
                
                Text("가계부 내역 입력시 바로가기 기능을 제공해요.")
                    .modifier(Body1())
                    .foregroundColor(Color("Gray1"))
                    .padding(.bottom, 36)
                
                ScrollView(showsIndicators: false) {
                    LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
                        Section(header: BankView_header(var_text: "은행")) {
                            LazyVGrid(columns: columns) {
                                ForEach(1...9, id: \.self) { index in
                                    BankCardPayView(bankCardPay: 1, index: index, selectBankCardPay: $selectBankCardPay, selectBankCardPayIndex: $selectBankCardPayIndex, isAbled: $isAbled)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 36)
                    
                    LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
                        Section(header: BankView_header(var_text: "페이")) {
                            LazyVGrid(columns: columns) {
                                ForEach(1...3, id: \.self) { index in
                                    BankCardPayView(bankCardPay: 2, index: index, selectBankCardPay: $selectBankCardPay, selectBankCardPayIndex: $selectBankCardPayIndex, isAbled: $isAbled)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 36)
                    
                    LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
                        Section(header: BankView_header(var_text: "카드사")) {
                            LazyVGrid(columns: columns) {
                                
                                ForEach(1...8, id: \.self) { index in
                                    BankCardPayView(bankCardPay: 3, index: index, selectBankCardPay: $selectBankCardPay, selectBankCardPayIndex: $selectBankCardPayIndex, isAbled: $isAbled)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 36)
                }
                
                Spacer()
                
                Button(action: {
                    Task{
                        inputdata.bankcardpay = selectBankCardPay
                        inputdata.bankcardpay_index = selectBankCardPayIndex
                        inputdata.bankcardpay_info = bankCardPayData.card_info[selectBankCardPay][selectBankCardPayIndex]!
                        if let userss = Auth.auth().currentUser {
                            try await Firestore.firestore().collection("users").document(userss.uid).updateData(["bankcardpay": inputdata.bankcardpay, "bankcardpay_index": inputdata.bankcardpay_index, "bankcardpay_info": inputdata.bankcardpay_info])
                        }
                    }
                    
                    logic = true
                    bankCardPaySetting = false
                }, label: {
                    OnboardingNextButton(isAbled: $isAbled, buttonText: "저장하기")
                })
                .padding(.bottom, 25)
            }
        }
        .padding(.horizontal, 20)
        .background(Color("background"))
    }
}

//struct SelectingBankView_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectingBankView(bankCardPaySetting: .constant(true))
//            .previewLayout(.sizeThatFits)
//    }
//}
private struct BankView_header: View {
    
    var var_text: String = ""
    
    fileprivate var body: some View {
        HStack(spacing: 0) {
            Text(var_text)
                .modifier(H2SemiBold())
                .foregroundColor(Color("Gray1"))
            Spacer()
        }
        .padding(.bottom, 24)
        .background(Color("background"))
    }
}
