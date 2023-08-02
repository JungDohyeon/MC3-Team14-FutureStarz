//
//  PersonalDaySpendView.swift
//  GumungGagye
//
//  Created by 정도현 on 2023/07/11.
//

import SwiftUI

struct PersonalDaySpendView: View {
    @StateObject var budgetFirebaseManager = BudgetFirebaseManager.shared
    @StateObject var userData = InputUserData.shared
    
    @State private var commentInput: String = ""
    @State var commentArray: [OutputComment] = []
    
    @Binding var accountIDArray: [String]
    @Binding var postID: String
    
    var month: String
    var date: String
    var day: String
    var selectedUserName: String
    var spendTodaySum: Int
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                AboutUserSpendView(userName: selectedUserName, month: month, date: date, day: day, spendTodaySum: spendTodaySum, accountIDArray: $accountIDArray)
                    .padding(.horizontal, 20)
                    .onAppear {
                        budgetFirebaseManager.fetchAllcommentID(postID: postID)
                    }
                
                Divider()
                    .frame(height: 8)
                    .overlay(Color("Gray4"))
                
                HStack(spacing: 9) {
                    Image(systemName: "bubble.left.fill")
                        .foregroundColor(Color("Gray2"))
                        .font(.system(size: 16))
                        .padding(.top, 2)
                    
                    HStack(spacing: 4) {
                        Text("댓글")
                        Text(budgetFirebaseManager.commentIDArray.count.description)
                            .foregroundColor(Color("Gray1"))
                    }
                    .modifier(Body1Bold())
                    
                    Spacer()
                }
                .padding(.top, 36)
                .padding(.horizontal, 20)
                
                VStack(spacing: 0) {
                    ForEach(budgetFirebaseManager.commentIDArray, id: \.self) { comment in
                        CommentView(id: comment)
                    }
                }
                .padding(.horizontal, 20)
            }
            
            ZStack {
                TextField("댓글을 입력해주세요", text: $commentInput)
                    .padding(.vertical, 12.5)
                    .padding(.horizontal, 12)
                    .modifier(Body1Bold())
                    .foregroundColor(commentInput.count == 0 ? Color("Gray2") : Color.black)
                    .background(Color("Gray4"))
                    .cornerRadius(12)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.top, 16)
                    .padding(.bottom, 12)
                    .padding(.horizontal, 20)
                
                HStack {
                    Spacer()
                    
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 16))
                        .foregroundColor(commentInput.count == 0 ? Color("Gray2") : Color("Main"))
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, 32)
                        .onTapGesture {
                            if commentInput.count == 0 {
                                
                            } else {
                                budgetFirebaseManager.saveCommentToFirestore(comment: InputComment(date: Date.now, content: commentInput, userName: userData.nickname!), postID: postID)
                                commentInput = ""
                            }
                        }
                }
            }
        }
    }
}


struct AboutUserSpendView: View {
    var userName: String
    var month: String
    var date: String
    var day: String
    var spendTodaySum: Int
    
    @Binding var accountIDArray: [String]
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Group {
            VStack(spacing: 8) {
                HStack(spacing: 2) {
                    Text("\(month)월 \(date)일 \(day)")
                        .modifier(Cap1())
                    
                    Spacer()
                }
                
                HStack {
                    Text("\(spendTodaySum)원")
                        .modifier(Num1())
                    Spacer()
                }
            }
            .padding(.top, 48)
            .padding(.bottom, 24)
            
            VStack(spacing: 20) {
                ForEach(accountIDArray, id: \.self) { accountID in
                    Breakdown(size: .constant(.small), incomeSum: .constant(0), spendSum: .constant(0), overSpendSum: .constant(0), spendTodaySum: .constant(0), incomeTodaySum: .constant(0), isGroup: true, accountDataID: accountID)
                }
            }
            .padding(.bottom, 36)
        }
        .navigationBarBackButtonHidden()
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Image("Chevron.back.light.black")
        }))
        .navigationBarTitle("\(userName)의 하루 지출", displayMode: .inline)
    }
}


struct CommentView: View {
    @StateObject var budgetFirebaseManager = BudgetFirebaseManager.shared
    @State private var comment: OutputComment? = nil
    var id: String
    
    var body: some View {
        VStack(spacing: 8) {
            if let comment = comment {
                HStack(spacing: 8) {
                    Text(comment.userName)
                        .modifier(Body2Bold())
                    Text(comment.date)
                        .modifier(Cap1())
                        .foregroundColor(Color("Gray2"))
                    
                    Spacer()
                    
                    Button {
                        // TODO: 삭제 구현
                    } label: {
                        Text("삭제")
                            .modifier(Cap1())
                            .foregroundColor(Color("Gray2"))
                    }
                }
                
                HStack {
                    Text(comment.content)
                        .modifier(Body2())
                    
                    Spacer()
                }
            }
        }
        .onAppear {
            Task {
                comment = try await budgetFirebaseManager.fetchCommentData(commentID: id)
            }
            
        }
        .padding(.vertical, 20)
    }
}

