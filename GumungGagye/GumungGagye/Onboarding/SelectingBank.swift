//
//  SelectingBank.swift
//  GumungGagye
//
//  Created by 신상용 on 2023/07/14.
//

import SwiftUI

struct SelectingBank: View {
    
    @State private var isActive: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment:.leading, spacing: 0) {
                HStack {
                    CustomBackButton { presentationMode.wrappedValue.dismiss() }
                    Spacer()
                    Text("건너뛰기")
                        .modifier(Body2())
                        .foregroundColor(Color("Gray1"))
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
                
                
                
                //                Text("은행")
                //                    .modifier(H2SemiBold())
                //                    .foregroundColor(Color("Gray1"))
                
                ScrollView(showsIndicators: false) {
                    LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
                        Section(header: BankView_header(var_text: "카드")) {
                            VStack {
                                ForEach(1...20, id: \.self) { index in
                                    Text("Item \(index)")
                                        .font(.title)
                                }
                            }
                        }
                    }
                    
                    
                    LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
                        Section(header: BankView_header(var_text: "페이")) {
                            VStack() {
                                ForEach(1...20, id: \.self) { index in
                                    Text("Item \(index)")
                                        .font(.title)
                                }
                            }
                        }
                    }
                }
                .clipped()
                Spacer()
                
                NavigationLink(destination: SelectingBudget()) {
                    OnboardingNextButton(isAbled: .constant(true))
                }
                .padding(.bottom, 59)
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
