//
//  GroupRoomView.swift
//  GumungGagye
//
//  Created by 정도현 on 2023/07/09.
//

import SwiftUI

struct GroupRoomView: View {
    
    let groupdata: GroupData
    let isNotExist: Bool
    
    var body: some View {
        ZStack {
            Color("background").ignoresSafeArea()
            
            // MARK: 그룹 명
            
            VStack(spacing: 0) {
                HStack {
                    Text(groupdata.group_name)
                        .modifier(Body1Bold())
                        .foregroundColor(Color("Black"))
                    
                    Spacer()
                    
                    if groupdata.lock_status {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 16))
                            .foregroundColor(Color("Gray2"))
                    }
                }
                .padding(.bottom, 8)
                
                
                // MARK: 그룹 소개 글
                
                HStack {
                    Text(groupdata.group_introduce)
                        .modifier(Body2())
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color("Gray1"))
                    
                    Spacer()
                }
                .padding(.bottom, 16)
                
                // MARK: 그룹 목표 금액, 최대 인원
                
                HStack(spacing: 23) {
                    HStack(spacing: 6) {
                        Image(systemName: "wonsign.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(Color("Gray2"))
                        
                        HStack(spacing: 0) {
                            Text(groupdata.group_goal.description)
                            Text("원")
                        }
                        .modifier(Body2())
                        .foregroundColor(Color("Gray1"))
                    }
                    
                    HStack(spacing: 0) {
                        Image(systemName: "person.fill")
                            .font(.system(size: 16))
                            .foregroundColor(Color("Gray2"))
                            .padding(.trailing, 7)
                        
                        Group {
                            Text(groupdata.group_cur.description)
                            Text("/")
                            Text(groupdata.group_max.description)
                            Text("명")
                        }
                        .modifier(Body2())
                        .foregroundColor(Color("Gray1"))
                    }
                    .padding(.trailing, 20)
                    
                    Spacer()
                    
                    // MARK: 가입 버튼
                    // 가입된 그룹이 없을 경우 가입 버튼 생성
                    if isNotExist {
                        NavigationLink {
                            GroupViewInside()
                        } label: {
                            MainColorBtn(inputText: "가입하기")
                        }
                    }
                }
                .padding(.bottom, 24)
                
                if isNotExist {
                    Divider()
                        .background(Color("Gray3"))
                }
            }
        }
    }
}


struct MainColorBtn: View {
    var inputText: String
    
    var body: some View {
        Text(inputText)
            .modifier(BtnBold())
            .foregroundColor(Color("Main"))
            .padding(.horizontal, 15)
            .padding(.vertical, 8)
            .background(
                Rectangle()
                    .foregroundColor(Color("Light"))
                    .cornerRadius(5)
            )
    }
}


struct GroupRoomView_Previews: PreviewProvider {
    static var previews: some View {
        GroupRoomView(groupdata: GroupData(id: "1", group_name: "test", group_introduce: "test", group_goal: 100000, group_cur: 7, group_max: 10, lock_status: true, group_pw: "1234"), isNotExist: true)
    }
}
