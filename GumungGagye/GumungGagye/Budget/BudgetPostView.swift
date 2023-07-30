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
    @State var incomeSum = 0
    @State var spendSum = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("\(date)일 \(day)")
                    .modifier(Body2())
                Spacer()
                
                Text("+\(incomeSum)원")
                    .modifier(Num4())
                    .foregroundColor(Color("Main"))
                
                Text("-\(spendSum)원")
                    .modifier(Num4())
            }
                
            ForEach(accountIDArray, id: \.self) { accountID in
                Breakdown(size: .constant(.small), incomeSum: $incomeSum, spendSum: $spendSum, accountDataID: accountID)
            }
        }
        .padding(.bottom, 52)
        .onAppear {
            if let userID = Auth.auth().currentUser?.uid {
                Task {
                    let todayDate = dayFormat.appending(year).appending("-").appending(month).appending("-").appending(date)
                    accountIDArray = try await fetchAccountArray(userID: userID, date: todayDate)
                }
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