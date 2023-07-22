//
//  SelectingBank.swift
//  GumungGagye
//
//  Created by 신상용 on 2023/07/14.
//

import SwiftUI

struct SelectingBank: View {
    @State var logic: Bool = false
    @State var selectBankCardPay: Int = 0
    @State var selectBankCardPayIndex: Int = 0
    @State var isAbled: Bool = false
    @State private var isActive: Bool = false
    let inputdata = InputUserData.shared
    let bankCardPayData = BankCardPay.shared
    @Environment(\.presentationMode) var presentationMode
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment:.leading, spacing: 0) {
                HStack {
                    CustomBackButton { presentationMode.wrappedValue.dismiss() }
                    Spacer()
                    //                    NavigationLink {
                    //                        PreStart()
                    //                    } label: {
                    //                        Text("건너뛰기")
                    //                            .modifier(Body2())
                    //                            .foregroundColor(Color("Gray1"))
                    //                    }
                    
                    Button(action: {
                        inputdata.bankcardpay = 0
                        inputdata.bankcardpay_index = 0
                        inputdata.bankcardpay_info = bankCardPayData.card_info[0][0]
                        logic = true
                        
                    }, label: {
                        Text("건너뛰기")
                            .modifier(Body2())
                            .foregroundColor(Color("Gray1"))
                        
                    })
                    .navigationDestination(isPresented: $logic, destination: {
                        // 목적지
                        PreStart()
                        
                    })
                    
                }
                .padding(.top, 66)
                .padding(.bottom, 60)
                
                Text("주로 소비 내역을 확인하시는\n앱을 선택해주세요")
                    .modifier(H1Bold())
                    .padding(.bottom, 12)
                
                Text("소비 내역 입력시 바로가기 기능을 제공합니다")
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
                    inputdata.bankcardpay = selectBankCardPay
                    inputdata.bankcardpay_index = selectBankCardPayIndex
                    inputdata.bankcardpay_info = bankCardPayData.card_info[selectBankCardPay][selectBankCardPayIndex]
                    logic = true
                    
                }, label: {
                    OnboardingNextButton(isAbled: .constant(true), buttonText: "가입하기")
                    
                })
                .navigationDestination(isPresented: $logic, destination: {
                    // 목적지
                    PreStart()
                    
                })
                //                .disabled(!isAbled)
                .padding(.bottom, 59)
                
                
                
                
                //                NavigationLink(destination: SelectingBudget()) {
                //                    OnboardingNextButton(isAbled: $isAbled)
                //                }
                //                .padding(.bottom, 59)
            }
            .ignoresSafeArea()
            .navigationBarBackButtonHidden(true)
        }
        .padding(.horizontal, 20)
        
    }
}

struct SelectingBank_Previews: PreviewProvider {
    static var previews: some View {
        SelectingBank()
    }
}

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
        
        .background {
            Color.white
        }
        
    }
}
