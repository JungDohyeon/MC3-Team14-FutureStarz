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
    @State var postData: PostDataModel = PostDataModel(accountArray: [], postID: "")
    
    // 일 총합
    @State var spendTodaySum = 0
    @State var incomeTodaySum = 0
    
    // 달 총합
    @State var overSpendSum = 0
    @Binding var incomeSum: Int
    @Binding var spendSum: Int
    
    @State var isSpendOnappear = true
    @State var isIncomeOnappear = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if postData.accountArray.count > 0 {
                HStack {
                    Text("\(date)일 \(day)")
                        .modifier(Body2())
                    Spacer()
                    
                    if incomeTodaySum > 0 {
                        Text("+\(incomeTodaySum)원")
                            .modifier(Num4())
                            .foregroundColor(Color("Main"))
                    }
                    
                    if spendTodaySum > 0 {
                        Text("-\(spendTodaySum)원")
                            .modifier(Num4())
                    }
                }
                    
                ForEach(postData.accountArray, id: \.self) { accountID in
                    Breakdown(size: .constant(.small), incomeSum: $incomeSum, spendSum: $spendSum, overSpendSum: $overSpendSum, spendTodaySum: $spendTodaySum, incomeTodaySum: $incomeTodaySum, isGroup: false, accountDataID: accountID)
                }
            }
        }
        .padding(.bottom, postData.accountArray.count > 0 ? 52 : 0)
        .onAppear {
            if let userID = Auth.auth().currentUser?.uid {
                Task {
                    let todayDate = dayFormat.appending(year).appending("-").appending(month).appending("-").appending(date)
                    postData = try await fetchAccountArray(userID: userID, date: todayDate)
                }
            }
        }
        .onChange(of: month) { newValue in
            if let userID = Auth.auth().currentUser?.uid {
                Task {
                    let todayDate = dayFormat.appending(year).appending("-").appending(newValue).appending("-").appending(date)
                    postData = try await fetchAccountArray(userID: userID, date: todayDate)
                }
            }
            spendSum = 0
            incomeSum = 0
            overSpendSum = 0
            spendTodaySum = 0
            incomeTodaySum = 0
        }
    }
    
    func fetchAccountArray(userID userId: String, date: String) async throws -> PostDataModel {
        do {
            let postModel = try await budgetFirebaseManager.fetchPostData(userID: userId, date: date)
            return postModel
        } catch {
            throw error
        }
    }
}
