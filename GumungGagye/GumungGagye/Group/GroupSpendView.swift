//
//  GroupSpendView.swift
//  GumungGagye
//
//  Created by 정도현 on 2023/07/10.
//

import SwiftUI

// 그룹 지출 내역 뷰
struct GroupSpendView: View {
    @State private var selectedDate: Date? = Date()
    @State private var curMonth: Date = Date()
    
    func getDatesInYear() -> [Date] {
        // 현재 날짜를 기준 + 1년
        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())!
        
        var dates: [Date] = []
        var currentDate = startDate
        
        while currentDate <= endDate {
            dates.append(currentDate)
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return dates
    }
    
    // 선택된 날짜 여부
    func isSelected(_ date: Date) -> Bool {
        guard let selectedDate = selectedDate else {
            return false
        }
        
        return Calendar.current.isDate(date, inSameDayAs: selectedDate)
    }
    
    // 오늘 날짜 확인
    func isToday(_ date: Date) -> Bool {
        return Calendar.current.isDateInToday(date)
    }
    
    var body: some View {
        ZStack {
            Color("background").ignoresSafeArea()
            VStack(spacing: 36) {
                CalendarView()
                    .frame(height: 95)
                
                VStack(spacing: 40) {
                    ForEach(1..<5) { _ in
                        GroupUserSpendView()
                    }
                }
                .padding(.bottom, 36)
            }
        }
    }
}

// 아직 기입 안한사람 리스트
struct GroupNotSpendView: View {
    var userName: String
    
    var body: some View {
        ZStack {
            Color("background").ignoresSafeArea()
            VStack(spacing: 24) {
                VStack(spacing: 4) {
                    HStack {
                        Text("아직 오늘 내역을 작성하지 않았어요")
                            .modifier(Body1Bold())
                        Spacer()
                    }
                    
                    HStack {
                        Text("작성하지 않은 친구를 콕 찔러볼까요?")
                            .modifier(Body2())
                            .foregroundColor(Color("Gray1"))
                        Spacer()
                    }
                }
                
                VStack(spacing: 37) {
                    ForEach(1..<4) { _ in
                        GroupNotSpendList(userName: userName)
                    }
                }
            }
            .padding(.vertical, 36)
        }
    }
    
}

// 아직 기입 안한 사람
struct GroupNotSpendList: View {
    var userName: String
    
    var body: some View {
        HStack {
            Text(userName)
                .modifier(Body1())
            
            Spacer()
            
            Button {
                
            } label: {
                MainColorBtn(inputText: "콕 찌르기")
            }
            
        }
    }
}


struct CalendarView: View {
    
    // 달력 시작 날짜, 끝나는 날짜
    let startDate = Calendar.current.date(from: DateComponents(year: 2023, month: 1, day: 2))!
    let endDate = Calendar.current.date(from: DateComponents(year: 2023, month: 12, day: 31))!
    
    @State private var selectedDate: Date? = Date() // 사용자가 선택한 날짜 (기본 = 오늘 날짜)
    @State private var presentedDate = Date()   // 현재 사용자 화면에 표시되는 날짜
    @State private var tagNum: Int = 0   // Page Tag
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(monthFormatter.string(from: dateArray()[tagNum][6]))
                .modifier(H2SemiBold())
            
            TabView(selection: $tagNum) {
                ForEach(dateArray().indices, id: \.self) { index in
                    let weekDates = dateArray()[index]
                    HStack(spacing: 18.5) {
                        ForEach(weekDates, id: \.self) { date in
                            VStack(spacing: 4) {
                                Text(dayOfWeekFormatter.string(from: date))
                                    .modifier(Cap2())
                                    .foregroundColor(Color("Gray2"))
                                
                                Text(dayFormatter.string(from: date))
                                    .modifier(Num3())
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(isToday(date) ? Color("Main") : Color("Gray1"))
                                    .background(isSelected(date) ? Color("Light30") : .clear)
                                    .cornerRadius(12)
                                    .onTapGesture {
                                        selectedDate = date
                                    }
                            }
                        }
                    }
                    .onAppear {
                        presentedDate = dateArray()[index][6]
                    }
                }
            }
            .onAppear {
                // 화면이 나타나면 오늘 날짜가 있는 배열 먼저 보여준다.
                for idx in 0..<dateArray().count {
                    if isTodayIncluded(dateArray()[idx]) {
                        tagNum = idx
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        
    }
    
    // 배열에 오늘 날짜가 있는지 탐색
    func isTodayIncluded(_ weekDates: [Date]) -> Bool {
        guard let today = selectedDate else {
            return false
        }
        return weekDates.contains { Calendar.current.isDate($0, inSameDayAs: today) }
    }
    
    
    // 선택된 날짜 여부
    func isSelected(_ date: Date) -> Bool {
        guard let selectedDate = selectedDate else {
            return false
        }
        
        return Calendar.current.isDate(date, inSameDayAs: selectedDate)
    }
    
    // 오늘 날짜인지 확인
    func isToday(_ date: Date) -> Bool {
        return Calendar.current.isDateInToday(date)
    }
    
    // 날짜 배열 생성
    func dateArray() -> [[Date]] {
        var array: [[Date]] = []
        var currentDate = startDate
        
        while currentDate <= endDate {
            var weekDates: [Date] = []
            for i in 0..<7 {
                if let date = Calendar.current.date(byAdding: .day, value: i, to: currentDate) {
                    weekDates.append(date)
                }
            }
            array.append(weekDates)
            currentDate = Calendar.current.date(byAdding: .day, value: 7, to: currentDate)!
        }
        
        return array
    }
    
    
    // 형식
    let dayOfWeekFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter
    }()
    
    let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter
    }()
    
    let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
}

struct GroupSpendView_Previews: PreviewProvider {
    static var previews: some View {
        GroupSpendView()
    }
}
