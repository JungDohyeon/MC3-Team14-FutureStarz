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
    @StateObject var budgetFirebaseManager = BudgetFirebaseManager.shared
    
    let year: String    // 년도
    let month: String   // 월
    let date: String    // 날짜
    let day: String     // 요일
    
    @State var dayFormat: String = ""
    @State var accountIDArray: [String] = []
    @State var overSpendSum = 0
    
    @Binding var incomeSum: Int
    @Binding var spendSum: Int
    
    @State var isSpendOnappear = true
    @State var isIncomeOnappear = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if accountIDArray.count > 0 {
                HStack {
                    Text("\(date)일 \(day)")
                        .modifier(Body2())
                    Spacer()
                    
                    if incomeSum > 0 {
                        Text("+\(incomeSum)원")
                            .modifier(Num4())
                            .foregroundColor(Color("Main"))
                    }
                    
                    if spendSum > 0 {
                        Text("-\(spendSum)원")
                            .modifier(Num4())
                    }
                }
                    
                ForEach(accountIDArray, id: \.self) { accountID in
                    Breakdown(size: .constant(.small), incomeSum: $incomeSum, spendSum: $spendSum, overSpendSum: $overSpendSum, isGroup: false, accountDataID: accountID)
                }
            }
        }
        .padding(.bottom, accountIDArray.count > 0 ? 52 : 0)
        .onAppear {
            if let userID = Auth.auth().currentUser?.uid {
                Task {
                    let todayDate = dayFormat.appending(year).appending("-").appending(month).appending("-").appending(date)
                    accountIDArray = try await fetchAccountArray(userID: userID, date: todayDate)
                }
            }
        }
        .onChange(of: month) { newValue in
            if let userID = Auth.auth().currentUser?.uid {
                Task {
                    let todayDate = dayFormat.appending(year).appending("-").appending(newValue).appending("-").appending(date)
                    accountIDArray = try await fetchAccountArray(userID: userID, date: todayDate)
                }
            }
            spendSum = 0
            incomeSum = 0
            overSpendSum = 0
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
