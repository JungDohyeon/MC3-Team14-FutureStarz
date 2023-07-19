//
//  GroupMain.swift
//  GumungGagye
//
//  Created by 정도현 on 2023/07/09.
//

import SwiftUI

struct GroupNotExistView: View {
    @State private var isCreateGroup: Bool = false
    @State private var searchText: String = ""
    @State private var user: UserData?
    @ObservedObject private var firebaseManager = FirebaseController.shared
    
    var body: some View {
        GeometryReader { geo in
            NavigationView {
                ZStack {
                    Color("background").ignoresSafeArea()
                    
                    VStack(spacing: 0) {
                        Group {
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
                                .sheet(isPresented: $isCreateGroup) {
                                    CreateGroupView()
                                        .presentationDetents([.large])
                                        .presentationDragIndicator(.visible)
                                }
                            }
                            .padding(.bottom, 48)
                            
                            // MARK: Search Field
                            TextField("그룹 이름을 검색해주세요", text: $searchText)
                                .padding(.vertical, 12.5)
                                .padding(.leading, 40)
                                .padding(.trailing, 8)
                                .modifier(Body1Bold())
                                .foregroundColor(searchText.count == 0 ? Color("Gray2") : Color.black)
                                .background(Color("Gray4"))
                                .cornerRadius(12)
                                .overlay(
                                    HStack {
                                        Image(systemName: "magnifyingglass")
                                            .foregroundColor(Color("Gray2"))
                                            .font(.system(size: 16))
                                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                            .padding(.leading, 8)
                                    }
                                )
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .padding(.bottom, 32)
                        }
                        .padding(.horizontal, 20)
                        
                        
                        // MARK: Group Room List
                        
                        ScrollView {
                            VStack(spacing: 24) {
                                ForEach(searchResults) { room in
                                    GroupRoomView(groupdata: room, isNotExist: true)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.top, 78)
                }
            }
        }
        .onAppear {
            firebaseManager.fetchAllGroupData()
            firebaseManager.callUserData()      // test
            fetchCurUser()
        }
    }
    
    func fetchCurUser() {
        FirebaseController.fetchUserInfo { user in
            self.user = user
            print("user: \(user?.nickname)")
        }
    }
    
    // Search Results (filter)
    var searchResults: [GroupData] {
        if searchText.isEmpty {
            return firebaseManager.groupList
        } else {
            return firebaseManager.groupList.filter { $0.group_name.contains(searchText) }
        }
    }
}


struct GroupNotExistView_Previews: PreviewProvider {
    static var previews: some View {
        GroupNotExistView()
    }
}
