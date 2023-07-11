//
//  GroupInfoView.swift
//  GumungGagye
//
//  Created by 정도현 on 2023/07/10.
//

import SwiftUI

// 그룹 정보 뷰
struct GroupInfoView: View {
    @State private var monthPicker: Month = .january
    
    var month = ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"]
    
    var body: some View {
        ZStack {
            Color("background").ignoresSafeArea()
            
            VStack {
                VStack {
                    GroupRoomView(groupdata: GroupData(id: "id", group_name: "Test", group_introduce: "Test", group_goal: 1000, group_cur: 3, group_max: 10, lock_status: true, group_pw: "1234"), isNotExist: false)
                }
                .frame(height: 110)
                .padding(.horizontal, 20)
                
                Divider()
                    .frame(height: 8)
                    .overlay(Color("Gray4"))
                
                VStack(spacing: 0) {
                    HStack {
                        Text("지출 랭킹")
                            .modifier(H2SemiBold())
                            .foregroundColor(Color("Black"))
                            .padding(.top, 36)
                        
                        Spacer()
                    }
                    .padding(.bottom, 16)
                    
                    HStack(spacing: 12) {
                        Button {
                            monthPicker.decrement()
                        } label: {
                            Image(systemName: "chevron.left")
                                .modifier(H2SemiBold())
                                .foregroundColor(Color("Gray1"))
                        }
                        
                        Text(monthPicker.monthName)
                            .modifier(Body1Bold())
                            .foregroundColor(.black)
                        
                        Button {
                            monthPicker.increment()
                        } label: {
                            Image(systemName: "chevron.right")
                                .modifier(H2SemiBold())
                                .foregroundColor(Color("Gray1"))
                        }
                        Spacer()
                    }
                }
                .padding(.bottom, 20)
                .padding(.horizontal, 20)
                
                ScrollView {
                    ForEach(1..<10) { rank in
                        GroupRankingView(ranking: rank, userName: "PADO", spendMoney: 7500)
                    }
                    .padding(.horizontal, 20)
                }
            }
            
        }
    }
}


enum Month: Int, CaseIterable {
    case january = 1, february, march, april, may, june, july, august, september, october, november, december
    
    var monthName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "M월"
        let date = Calendar.current.date(from: DateComponents(year: 2023, month: rawValue)) ?? Date()
        return dateFormatter.string(from: date)
    }
    
    mutating func increment() {
        self = self == .december ? .january : Month(rawValue: rawValue + 1)!
    }
    
    mutating func decrement() {
        self = self == .january ? .december : Month(rawValue: rawValue - 1)!
    }
}


struct GroupRankingView: View {
    var ranking: Int
    var userName: String
    var spendMoney: Int
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 34) {
                Text(ranking.description)
                    .modifier(Num5())
                
                
                Text(userName)
                    .modifier(Body2())
                
                Spacer()
                
                Text("-\(spendMoney.description)원")
                    .modifier(Num4SemiBold())
            }
            
            .padding(.vertical, 12)
            
            Divider()
        }
    }
}

struct GroupInfoView_Previews: PreviewProvider {
    static var previews: some View {
        GroupInfoView()
    }
}
