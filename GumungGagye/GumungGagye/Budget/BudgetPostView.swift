//
//  BudgetPostView.swift
//  GumungGagye
//
//  Created by 정도현 on 2023/07/31.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct BudgetPostView: View {
    var budgetFirebaseManager = BudgetFirebaseManager.shared
    
    let year: String    // 년도
    let month: String   // 월
    let date: String    // 날짜
    let day: String     // 요일
    @State var dayFormat: String = ""
    @State var accountIDArray: [String] = []
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(year)년 \(month)월 \(date)일 \(day)")
                .modifier(Body2())
            ForEach(accountIDArray, id: \.self) { accountID in
                Breakdown(size: .constant(.small), accountDataID: accountID)
            }
        }
        .padding(.bottom, 30)
        .onAppear {
            if let userID = Auth.auth().currentUser?.uid {
                Task {
                    let todayDate = dayFormat.appending(year).appending("-").appending(month).appending("-").appending(date)
                    accountIDArray = try await fetchAccountArray(userID: userID, date: todayDate)
                }
            } else {
                print("NOT Exist USER")
            }
        }
    }
    
    func fetchAccountArray(userID userId: String, date: String) async throws -> [String] {
        do {
            let accountArray = try await budgetFirebaseManager.fetchPostData(userID: userId, date: date)
            return accountArray
        } catch {
            throw error
        }
    }

}
