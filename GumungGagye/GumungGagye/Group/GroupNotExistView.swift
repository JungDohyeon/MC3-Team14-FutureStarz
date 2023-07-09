//
//  GroupMain.swift
//  GumungGagye
//
//  Created by 정도현 on 2023/07/09.
//

import SwiftUI

struct GroupNotExistView: View {
    @State private var isCreateGroup: Bool = false
    @ObservedObject var groupList = GroupListStore()
    
    var body: some View {
        GeometryReader { geo in
            NavigationView {
                ZStack {
                    Color("background").ignoresSafeArea()
                    
                    VStack {
                        HStack {
                            Text("그룹 둘러보기")
                                .modifier(H1Bold())
                            
                            Spacer()
                            
                            Button {
                                isCreateGroup.toggle()
                            } label: {
                                Image(systemName: "plus")
                                    .resizable()
                                    .fontWeight(.medium)
                                    .foregroundColor(.black)
                                    .scaledToFit()
                                    .padding(2)
                                    .frame(width: 20)
                            }
                            .sheet(isPresented: $isCreateGroup, onDismiss: {
                                groupList.fetchData()
                            }) {
                                CreateGroupView()
                            }
                        }
                        .padding(.bottom, 48)
                        
                        Rectangle()
                            .frame(maxWidth: .infinity, maxHeight: geo.size.height/16)
                            .padding(.bottom, 32)
                        
                        
                        ScrollView {
                            VStack (spacing: 20) {
                                ForEach(groupList.groupList) { room in
                                    GroupRoomView(groupdata: room)
                                }
                            }
                        }
                    }
                    .padding(.top, 78)
                    .padding(.horizontal, 20)
                }
            }
        }
        .onAppear {
            groupList.fetchData()
        }
    }
}


struct GroupNotExistView_Previews: PreviewProvider {
    static var previews: some View {
        GroupNotExistView()
            .environmentObject(GroupListStore())
    }
}
