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
    @State var selectedMonth = Date.now
    
    var body: some View {
        ZStack {
            Color("background").ignoresSafeArea()
            
            ScrollView {
                HStack {
                    MoveMonth(size: .Small, selectedMonth: $selectedMonth) // 숫자 데이터로 받아오기
                    Spacer()
                }
                .padding(.top, 36)
                .padding(.bottom, 8)
                .padding(.horizontal, 20)
                
                ScrollView {
                    ForEach(Array(userData.enumerated()), id: \.element.id) { index, data in
                        GroupRankingView(ranking: index + 1, userName: data.nickname, spendMoney: 490230 + (index*61535))
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
            Image("Chevron.back.light.black")
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

