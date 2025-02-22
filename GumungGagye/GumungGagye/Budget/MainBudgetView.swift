//
//  MainBudgetView.swift
//  GumungGagye
//
//  Created by Lee Juwon on 2023/07/10.
//

import SwiftUI

struct MainBudgetView: View {
    @StateObject var userData = InputUserData.shared
    
    @State var incomeSum = 0
    @State var spendSum = 0
    @State var selectedMonth = Date.now

    let dateFormatter = DateFormatter()

    var body: some View {
        VStack(alignment: .leading) {
            // 월(날짜) 이동
            MoveMonth(size: .Big, selectedMonth: $selectedMonth) // 숫자 데이터로 받아오기
                .padding(.top, 24)
                .padding(.horizontal, 20)
            
            ScrollView {
                VStack(spacing:0) {
                    VStack(spacing: 36) {
                        TargetBudgetView(spendBill: $spendSum, selectedMonth: $selectedMonth)
                            .padding(.top, 16)
                        SectionBar()
                        CurrentAssetView(spendBill: spendSum, incomeBill: incomeSum)
                        SectionBar()
                            .padding(.bottom, 26)
                    }
                
                    VStack(alignment: .leading, spacing: 0) {
                        Section(header: Header().padding(.bottom, 35)) {
                            ForEach(daysInSelectedMonth().reversed(), id: \.self) { day in
                                BudgetPostView(year: getYear(day: day), month: getMonth(day: day), date: getDate(day: day), day: getDay(day: day), incomeSum: $incomeSum, spendSum: $spendSum)
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
    
    // 선택 한 달의 범위 리턴
    private func daysInSelectedMonth() -> Range<Int> {
        let calendar = Calendar.current
        guard let monthRange = calendar.range(of: .day, in: .month, for: selectedMonth) else {
            return 1..<2
        }
        
        return monthRange
    }
    
    func getYear(day: Int) -> String {
        let components = DateComponents(year: Calendar.current.component(.year, from: selectedMonth), month: Calendar.current.component(.month, from: selectedMonth), day: day)
        if let date = Calendar.current.date(from: components) {
            dateFormatter.dateFormat = "YYYY"
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    func getMonth(day: Int) -> String {
        let components = DateComponents(year: Calendar.current.component(.year, from: selectedMonth), month: Calendar.current.component(.month, from: selectedMonth), day: day)
        if let date = Calendar.current.date(from: components) {
            dateFormatter.dateFormat = "M"
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    func getDate(day: Int) -> String {
        let components = DateComponents(year: Calendar.current.component(.year, from: selectedMonth), month: Calendar.current.component(.month, from: selectedMonth), day: day)
        if let date = Calendar.current.date(from: components) {
            dateFormatter.dateFormat = "d"
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    func getDay(day: Int) -> String {
        let components = DateComponents(year: Calendar.current.component(.year, from: selectedMonth), month: Calendar.current.component(.month, from: selectedMonth), day: day)
        if let date = Calendar.current.date(from: components) {
            dateFormatter.dateFormat = "EEEE"
            dateFormatter.locale = Locale(identifier: "ko_KR")
            return dateFormatter.string(from: date)
        }
        return ""
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
