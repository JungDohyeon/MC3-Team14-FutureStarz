//
//  GroupViewInside.swift
//  GumungGagye
//
//  Created by 정도현 on 2023/07/10.
//

import SwiftUI

enum GroupOption: String, CaseIterable {
    case invite = "그룹 초대하기"
    case leave = "그룹 나가기"
    case explore = "그룹 둘러보기"
}

struct GroupViewInside: View {
    @Environment(\.dismiss) var dismiss
    @State private var isGroupInfo: Bool = false
    @State private var isShowModal: Bool = false
    @State private var selectedOption: GroupOption?
    
    @State private var isLeaveAlertPresented: Bool = false
    
    var body: some View {
        ZStack{
            NavigationView {
                VStack(spacing: 0) {
                    HStack(spacing: 22) {
                        Button {
                            isGroupInfo = false
                        } label: {
                            Text("지출 공유")
                                .foregroundColor(isGroupInfo ? Color("Gray2") : Color("Black"))
                        }
                        
                        Button {
                            isGroupInfo = true
                        } label: {
                            Text("그룹 정보")
                                .foregroundColor(isGroupInfo ? Color("Black") : Color("Gray2"))
                        }
                        
                        Spacer()
                        
                        Menu {
                            ForEach(GroupOption.allCases, id: \.self) { option in
                                Button {
                                    selectedOption = option
                                    if option == .leave {
                                        isLeaveAlertPresented = true
                                    } else {
                                        isShowModal = true
                                    }
                                } label: {
                                    Text(option.rawValue)
                                }
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.black)
                        }
                    }
                    .modifier(H1Bold())
                    .padding(.top, 24)
                    .padding(.bottom, 24)
                    .padding(.horizontal, 20)
                    
                    if !isGroupInfo {
                        ScrollView {
                            GroupSpendView()
                                .padding(.horizontal, 20)
                            
                            Divider()
                                .frame(height: 8)
                                .overlay(Color("Gray4"))
                            
                            GroupNotSpendView(userName: "Lavine")
                                .padding(.horizontal, 20)
                        }
                    } else {
                        VStack {
                            GroupInfoView()
                        }
                    }
                }
                .background(Color("background").ignoresSafeArea())
                .alert(isPresented: $isLeaveAlertPresented) {
                    leaveAlert
                }
                .sheet(isPresented: $isShowModal) {
                    if let option = selectedOption {
                        switch(option) {
                        case .invite:
                            ShareViewController(shareString: ["ShareCode"])
                                .presentationDetents([.medium])
                                .presentationDragIndicator(.visible)
                        case .leave:
                            EmptyView()
                        case .explore:
                            GroupNotExistView()
                        }
                    }
                }
            }
        }
    }
    
    var leaveAlert: Alert {
            Alert(
                title: Text("그룹 탈퇴하기"),
                message: Text("정말 그룹을 탈퇴하시겠습니까?"),
                primaryButton: .cancel(Text("취소")),
                secondaryButton: .destructive(Text("탈퇴하기")) {
                    // Handle leave group action here
                }
            )
        }
}

struct ShareViewController: UIViewControllerRepresentable {
    
    let shareString : [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        // shareString: 실제로 공유하기에서 복사되는 값, applicationActivities: 공유 어플 지정.
        return UIActivityViewController(activityItems: shareString, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // Do nothing
    }
}


struct GroupViewInside_Previews: PreviewProvider {
    static var previews: some View {
        GroupViewInside()
    }
}
