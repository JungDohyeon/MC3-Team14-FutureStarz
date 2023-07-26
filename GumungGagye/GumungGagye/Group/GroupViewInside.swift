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
    var groupData: GroupData
    
    var body: some View {
        ZStack {
            Color("background").ignoresSafeArea()
            ScrollView {
                VStack(spacing: 0) {
                    let _ = print("groupData: name: \(groupData.group_name), \(groupData.group_introduce)")
                    GroupTopInfo(groupData: groupData)
                    Divider()
                        .frame(height: 8)
                        .overlay(Color("Gray4"))
                    UserScroller()
                    GroupUserSumGraph()
                    UserNoSpend()
                }
            }
        }
    }
}

// MARK: 소비 내역이 없을 때
struct UserNoSpend: View {
    var body: some View {
        ZStack {
            Color("background").ignoresSafeArea()
            VStack(alignment: .leading, spacing: 20) {
                Text("4일 화요일")
                    .modifier(Body2())
                    .foregroundColor(.black)
                
                HStack {
                    VStack(alignment:. leading, spacing: 8) {
                        Text("오늘은 소비 내역이 없어요")
                            .modifier(Body2Bold())
                        
                        Text("작성하지 않은 친구를 콕 찔러볼까요?")
                            .modifier(Cap1())
                    }
                    .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        MainColorBtn(inputText: "콕 찌르기")
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

// MARK: 소비 내역이 있을 때


// MARK: Group Top Info
struct GroupTopInfo: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedOption: GroupOption?
    @State private var isLeaveAlertPresented: Bool = false
    @State private var isShowModal: Bool = false
    @State private var isUserDismiss: Bool = false
    var groupData: GroupData
    
    @StateObject var userData = InputUserData.shared
    @StateObject private var firebaseManager = FirebaseController.shared
    
    var body: some View {
        ZStack {
            Color("background").ignoresSafeArea()
            VStack(spacing: 0) {
                HStack {
                    Text("나의 그룹")
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    // MARK: Group Menu
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
                .padding(.bottom, 32)
                
                GroupRoomView(groupdata: groupData, isNotExist: false)
                
                
                Spacer()
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
            .padding(.horizontal, 20)
        }
    }
    
    
    var leaveAlert: Alert {
        Alert(
            title: Text("그룹 탈퇴하기"),
            message: Text("정말 그룹을 탈퇴하시겠습니까?"),
            primaryButton: .cancel(Text("취소")),
            secondaryButton: .destructive(Text("탈퇴하기")) {
                if let groupID = userData.group_id {
                    userData.group_id = ""
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        firebaseManager.decrementGroupCur(groupID: groupID)
                    }
                    presentationMode.wrappedValue.dismiss()
                } else {
                    print("group 탈퇴 에러 발생")
                }
               
            }
        )
    }
}

// MARK: User Scroll View
struct UserScroller: View {
    @StateObject private var firebaseManager = FirebaseController.shared
    @StateObject var inputdata = InputUserData.shared
    
    @State private var selectedPerson: String = ""
    @State private var userData: [UserData] = []
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(userData, id: \.id) { data in
                    VStack(spacing: 4) {
                        Circle()
                            .foregroundColor(Color("Gray3"))
                            .frame(width: 48, height: 48)
                            .overlay(
                                Circle()
                                    .stroke(selectedPerson == data.nickname ? Color("Main") : .clear, lineWidth: 2)
                                    .frame(width: 46, height: 46)
                            )
                        
                        Text(data.nickname)
                            .modifier(Cap2())
                            .foregroundColor(selectedPerson == data.nickname ? Color("Main") : .black)
                            .bold(selectedPerson == data.nickname)
                    }
                    .onTapGesture {
                        if selectedPerson != data.nickname {
                            selectedPerson = data.nickname
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 32)
        }
        .onAppear {
            if inputdata.group_id != nil || inputdata.group_id != "" {
                if let groupID = inputdata.group_id {
                    firebaseManager.fetchDataGroupUser(groupID: groupID) { arrayData in
                        if let arrayData = arrayData {
                            self.userData = arrayData
                        }
                        selectedPerson = userData[0].nickname
                    }
                }
            }
        }
    }
}


// MARK: Show Group user month graph
struct GroupUserSumGraph: View {
    var overAll: Double = 1000000
    var purchaseSum: Double = 256000
    var overpurchaseSum: Double = 56000
    @State private var sumGraphWidth: CGFloat = 0.0
    @State private var overGraphWidth: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            Color("background").ignoresSafeArea()
            VStack(spacing: 20) {
                MonthPicker()
                // Graph
                GeometryReader { geometry in
                    VStack(spacing: 8) {
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: 22)
                                .foregroundColor(Color("Light30"))
                            
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: sumGraphWidth , height: 22)
                                .foregroundColor(Color("Main"))
                            
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: overGraphWidth, height: 22)
                                .foregroundColor(Color("OverPurchasing"))
                        }
                        
                        
                        HStack(spacing: 8) {
                            HStack(spacing: 3) {
                                Text("과소비")
                                    .modifier(Cap1())
                                    .foregroundColor(Color("Gray2"))
                                Text("\(Int(overpurchaseSum))원")
                                    .modifier(Num5())
                                    .foregroundColor(Color("OverPurchasing"))
                            }
                            
                            Text("/")
                                .modifier(Cap1())
                                .foregroundColor(Color("Gray2"))
                            
                            HStack(spacing: 3) {
                                Text("총 지출")
                                    .modifier(Cap1())
                                    .foregroundColor(Color("Gray2"))
                                Text("\(Int(overpurchaseSum))원")
                                    .modifier(Num5())
                                    .foregroundColor(Color("Main"))
                            }
                            
                            Spacer()
                            Text("전체 \(Int(overAll))원")
                                .modifier(Cap1())
                                .foregroundColor(Color("Gray2"))
                        }
                    }
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1.0)) {
                            sumGraphWidth = CGFloat(purchaseSum/overAll) * (geometry.size.width-40)
                            overGraphWidth = CGFloat(overpurchaseSum/purchaseSum) * (geometry.size.width-40)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 28)
        .padding(.bottom, 55)
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

