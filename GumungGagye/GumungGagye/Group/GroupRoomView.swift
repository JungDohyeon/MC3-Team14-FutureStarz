//
//  GroupRoomView.swift
//  GumungGagye
//
//  Created by 정도현 on 2023/07/09.
//

import SwiftUI

struct GroupRoomView: View {
    let groupdata: GroupData
    var isNotExist: Bool
    
    var body: some View {
        ZStack {
            Color("background").ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text(groupdata.group_name)
                        .modifier(Body1Bold())
                        .foregroundColor(Color("Black"))
                    
                    Spacer()
                    

                    Rectangle()
                        .frame(width:24, height: 24)

                    if groupdata.lock_status {
                        Image(systemName: "lock.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18)
                            .foregroundColor(Color("Gray2"))
                    }
                }
                .padding(.bottom, 8)
                
                HStack {
                    Text(groupdata.group_introduce)
                        .modifier(Body2())
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color("Gray1"))
                    
                    Spacer()
                }
                .padding(.bottom, 16)
                    

                HStack(spacing: 23) {
                    HStack(spacing: 0) {
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 19)
                            .foregroundColor(Color("Gray2"))
                            .padding(.trailing, 11)

                        
                        Text(groupdata.group_goal.description)
                            .modifier(Body2())
                            .foregroundColor(Color("Gray1"))
                        
                    }

                    .padding(.trailing, 20)
                    
                    
                    HStack(spacing: 0) {
                        Rectangle()
                            .frame(width:24, height: 24)
                            .padding(.trailing, 8)

                    
                    
                    HStack(spacing: 0) {
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 19)
                            .foregroundColor(Color("Gray2"))
                            .padding(.trailing, 11)

                        
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
                    

                    NavigationLink {
                        
                    } label: {
                       GroupSignInBtn()
                    }

                }
                .padding(.bottom, 24)
                
                Divider()
                    .background(Color("Gray3"))

                    if isNotExist {
                        NavigationLink {
                            
                        } label: {
                           GroupSignInBtn()
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


struct GroupSignInBtn: View {
    var body: some View {
        Text("가입하기")
            .modifier(BtnBold())
            .foregroundColor(Color("Main"))
            .padding(.horizontal, 15)
            .padding(.vertical, 8)
            .background(
                Rectangle()

                    .foregroundColor(Color("Main"))

                    .foregroundColor(Color("Light"))
                    .cornerRadius(5)

            )
    }
}


struct GroupRoomView_Previews: PreviewProvider {
    static var previews: some View {

        GroupRoomView(groupdata: GroupData(id: "1", group_name: "test", group_introduce: "test", group_goal: 100000, group_cur: 7, group_max: 10, lock_status: true, group_pw: "1234"), isNotExist: true)
        GroupRoomView(groupdata: GroupData(id: "1", group_name: "test", group_introduce: "test", group_goal: 100000, group_cur: 7, group_max: 10, lock_status: true, group_pw: "1234"), isNotExist: true)

    }
}
