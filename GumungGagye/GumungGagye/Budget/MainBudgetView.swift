//
//  MainBudgetView.swift
//  GumungGagye
//
//  Created by Lee Juwon on 2023/07/10.
//

import SwiftUI

struct MainBudgetView: View {
    
    @StateObject var userData = InputUserData.shared
    
    var body: some View {
        
        VStack(alignment: .leading) {
            // 월(날짜) 이동
            MoveMonth(size: .Big, selectedMonth: Date.now) // 숫자 데이터로 받아오기
                .padding(.top, 24)
                .padding(.horizontal, 20)
            
            ScrollView {
                VStack(spacing:0) {
                    VStack(spacing: 36) {
                        
//                        TargetBudgetView(spendBill: 100000, userData: <#T##arg#>)
//                            .padding(.top, 16)
                        SectionBar()
//                        CurrentAssetView(nickname: <#String#>, spendBill: <#Int#>, incomeBill: <#Int#>)
                        SectionBar()
                            .padding(.bottom, 26)
                    }
                    
                    LazyVStack( alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
                        Section(header: Header()) {
                            
                            ForEach(1..<10) {_ in
                                Text("rere")
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
        }
        .clipped()
        .foregroundColor(Color("Black"))
        .background(Color("background"))
    }
}


struct Header: View {
    
    @State var showAddModalView: Bool = false

    var body: some View {
        HStack {
            Text("내역")
                .modifier(H2SemiBold())
            Spacer()
            SmallButton(text: "+ 추가"){
                self.showAddModalView = true
            }
            .sheet(isPresented: self.$showAddModalView) {
//                AddModalView()
                ModalView(showAddModalView: $showAddModalView)
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
                    .background(Color("White"))
            }
        }
        .padding(.top, 10)
        .padding(.bottom, 10) // 전꺼 36
        .background(Color("background"))
        
    }
}

struct MainBudgetView_Previews: PreviewProvider {
    static var previews: some View {
        MainBudgetView()
    }
}
