//
//  GroupInfoView.swift
//  GumungGagye
//
//  Created by 정도현 on 2023/07/10.
//

import SwiftUI

// 그룹 정보 뷰
struct GroupInfoView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var firebaseManager = FirebaseController.shared
    @StateObject var inputdata = InputUserData.shared
    
    var groupData: GroupData

    @State private var userData: [UserData] = []
    
    var body: some View {
        ZStack {
            Color("background").ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    MonthPicker()
                }
                .padding(.top, 36)
                .padding(.bottom, 8)
                .padding(.horizontal, 20)
                
                ScrollView {
                    
                    ForEach(userData, id: \.id) { data in
                        GroupRankingView(ranking: 1, userName: data.nickname, spendMoney: 7500)
                    }
                    .padding(.horizontal, 20)
                }
                
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("그룹 지출 랭킹")
        .navigationBarBackButtonHidden()
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "chevron.left")
                .font(.system(size: 16))
                .fontWeight(.regular)
                .foregroundColor(.black)
        }))
        .onAppear {
            if inputdata.group_id != nil || inputdata.group_id != "" {
                if let groupID = inputdata.group_id {
                    firebaseManager.fetchDataGroupUser(groupID: groupID) { arrayData in
                        if let arrayData = arrayData {
                            self.userData = arrayData
                        }
                    }
                }
            }
        }
    }
    
    func fetchImage(url: URL) async throws -> UIImage {
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
              (200...299).contains(statusCode) else { throw NSError(domain: "fetch error", code: 1004) }
        guard let image = UIImage(data: data) else {return UIImage(systemName: "person.fill")!}
        
        return image
    }
}

struct MonthPicker: View {
    
    @State var monthPicker: Month = .january
    
    var month = ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"]
    
    var body: some View {
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
