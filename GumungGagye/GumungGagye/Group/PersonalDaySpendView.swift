//
//  PersonalDaySpendView.swift
//  GumungGagye
//
//  Created by 정도현 on 2023/07/11.
//

import SwiftUI

struct PersonalDaySpendView: View {
    @State private var commentInput: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            Group {
                VStack(spacing: 8) {
                    HStack(spacing: 2) {
                        Text("7월 23일")
                            .modifier(Cap1())
                        Text("파도")
                            .modifier(Cap1Bold())
                        
                        Spacer()
                    }
                    
                    HStack {
                        Text("25,000원")
                            .modifier(Num1())
                        Spacer()
                    }
                }
                .padding(.top, 48)
                .padding(.bottom, 24)
                
                VStack(spacing: 12) {
                    PurchasingContent(isOverPurchase: true)
                    PurchasingContent(isOverPurchase: false)
                    PurchasingContent(isOverPurchase: true)
                }
                .padding(.bottom, 36)
            }
            .padding(.horizontal, 20)
         
            
            Divider()
                .frame(height: 8)
                .overlay(Color("Gray4"))
            
            ScrollView {
                HStack(spacing: 9) {
                    Image(systemName: "bubble.left.fill")
                        .foregroundColor(Color("Gray2"))
                        .font(.system(size: 16))
                        .padding(.top, 2)
                    
                    HStack(spacing: 4) {
                        Text("댓글")
                        Text(3.description)
                            .foregroundColor(Color("Gray1"))
                    }
                    .modifier(Body1Bold())
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                
                TextField("댓글을 입력해주세요", text: $commentInput)
                    .padding(.vertical, 12.5)
                    .padding(.horizontal, 12)
                    .modifier(Body1Bold())
                    .foregroundColor(commentInput.count == 0 ? Color("Gray2") : Color.black)
                    .background(Color("Gray4"))
                    .cornerRadius(12)
                    .overlay(
                        HStack {
                            Image(systemName: "paperplane.fill")
                                .font(.system(size: 16))
                                .foregroundColor(commentInput.count == 0 ? Color("Gray2") : Color("Main"))
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                                .padding(.trailing, 12)
                        }
                    )
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.top, 16)
                    .padding(.bottom, 12)
                    .padding(.horizontal, 20)
                
                VStack(spacing: 0) {
                    CommentView()
                    CommentView()
                    CommentView()
                    CommentView()
                    CommentView()
                    CommentView()
                    CommentView()
                    CommentView()
                    CommentView()
                }
                .padding(.horizontal, 20)
            }
            .padding(.top, 36)
        }
    }
}


struct CommentView: View {
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Text("파도")
                    .modifier(Body2Bold())
                Text("3시간전")
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
                Text("열심히 절약하는 모습 멋있어요!")
                    .modifier(Body2())
                
                Spacer()
            }
        }
        .padding(.vertical, 20)
    }
}


struct PersonalDaySpendView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalDaySpendView()
    }
}
