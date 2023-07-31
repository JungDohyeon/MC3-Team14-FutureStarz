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
    @State var selectedUserID: String?
    
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
                    UserScroller(groupData: groupData)
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
                        ShareViewController(shareString: ["ssoap://receiver?groupID=\(groupData.id)"])
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
                    firebaseManager.decrementGroupCur(groupID: groupID)
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
    
    @State private var selectedPersonID: String?
    @State private var selectedPerson: String = ""
    @State private var userData: [UserData] = []
    
    @State var overSpendSum = 0
    @State var spendSum = 0
    
    let today = Calendar.current.component(.day, from: Date())
    let dateFormatter = DateFormatter()
    
    var groupData: GroupData
    
    var body: some View {
        VStack {
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
                            if selectedPersonID != data.id {
                                selectedPerson = data.nickname
                                selectedPersonID = data.id
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
                            if userData.count > 0 {
                                selectedPerson = userData[0].nickname
                                selectedPersonID = userData[0].id
                            }
                        }
                    }
                }
            }
            
            // =======================================================================================
            
            GroupUserSumGraph(groupData: groupData, purchaseSum: $spendSum, overpurchaseSum: $overSpendSum)
            
            if let selectedPersonID = selectedPersonID {
                
                // 1 ~ 31 한달 보여주기.
                ForEach((1...today).reversed(), id:\.self) { day in
                    BudgetGroupView(year: getYear(day: day), month: getMonth(day: day), date: getDate(day: day), day: getDay(day: day), selectedUserID: selectedPersonID, spendSum: $spendSum, overSpendSum: $overSpendSum)
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    func getYear(day: Int) -> String {
        let components = DateComponents(year: Calendar.current.component(.year, from: Date()), month: Calendar.current.component(.month, from: Date()), day: day)
        if let date = Calendar.current.date(from: components) {
            dateFormatter.dateFormat = "YYYY"
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    
    func getMonth(day: Int) -> String {
        let components = DateComponents(year: Calendar.current.component(.year, from: Date()), month: Calendar.current.component(.month, from: Date()), day: day)
        if let date = Calendar.current.date(from: components) {
            dateFormatter.dateFormat = "MM"
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    func getDate(day: Int) -> String {
        let components = DateComponents(year: Calendar.current.component(.year, from: Date()), month: Calendar.current.component(.month, from: Date()), day: day)
        if let date = Calendar.current.date(from: components) {
            dateFormatter.dateFormat = "dd"
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    func getDay(day: Int) -> String {
        let components = DateComponents(year: Calendar.current.component(.year, from: Date()), month: Calendar.current.component(.month, from: Date()), day: day)
        if let date = Calendar.current.date(from: components) {
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: date)
        }
        return ""
    }
}



struct BudgetGroupView: View {
    @StateObject var budgetFirebaseManager = BudgetFirebaseManager.shared
    
    let year: String    // 년도
    let month: String   // 월
    let date: String    // 날짜
    let day: String     // 요일
    
    var selectedUserID: String?
    
    @State var dayFormat: String = ""
    @State var accountIDArray: [String] = []
    @State var incomeSum = 0
    @Binding var spendSum: Int
    @Binding var overSpendSum: Int
    
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
                    Breakdown(size: .constant(.small), incomeSum: $incomeSum, spendSum: $spendSum, overSpendSum: $overSpendSum, isGroup: true, accountDataID: accountID)
                }
            }
        }
        .padding(.bottom, accountIDArray.count > 0 ? 52 : 0)
        .onAppear {
            if let userID = selectedUserID {
                Task {
                    let todayDate = dayFormat.appending(year).appending("-").appending(month).appending("-").appending(date)
                    accountIDArray = try await fetchAccountArray(userID: userID, date: todayDate)
                }
            }
        }
        .onChange(of: selectedUserID) { newValue in
            if let userID = newValue {
                Task {
                    let todayDate = dayFormat.appending(year).appending("-").appending(month).appending("-").appending(date)
                    accountIDArray = try await fetchAccountArray(userID: userID, date: todayDate)
                }
            }
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

// MARK: Show Group user month graph
struct GroupUserSumGraph: View {
    var groupData: GroupData
    @Binding var purchaseSum: Int
    @Binding var overpurchaseSum: Int
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
                                .frame(width: sumGraphWidth, height: 22)
                                .foregroundColor(Color("Main"))
                            
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: overGraphWidth, height: 22)
                                .foregroundColor(Color("OverPurchasing"))
                        }
                        
                        
                        HStack(spacing: 8) {
                            HStack(spacing: 3) {
                                Text("과소비")
                                    .modifier(Cap1())
                                    .foregroundColor(Color("Gray1"))
                                Text("\(overpurchaseSum)원")
                                    .modifier(Num5())
                                    .foregroundColor(Color("OverPurchasing"))
                            }
                            
                            Text("/")
                                .modifier(Cap1())
                                .foregroundColor(Color("Gray2"))
                            
                            HStack(spacing: 3) {
                                Text("총 지출")
                                    .modifier(Cap1())
                                    .foregroundColor(Color("Gray1"))
                                Text("\(purchaseSum)원")
                                    .modifier(Num5())
                                    .foregroundColor(purchaseSum > groupData.group_goal ? Color("OverPurchasing") : Color("Main"))
                            }
                            
                            Spacer()
                            Text("전체 \(groupData.group_goal)원")
                                .modifier(Cap1())
                                .foregroundColor(Color("Gray1"))
                        }
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1.0)) {
                                sumGraphWidth = purchaseSum > groupData.group_goal ? (geometry.size.width) : CGFloat(Double(purchaseSum)/Double(groupData.group_goal)) * (geometry.size.width)
                                overGraphWidth = overpurchaseSum > groupData.group_goal ? (geometry.size.width) : CGFloat(Double(overpurchaseSum)/Double(groupData.group_goal)) * (geometry.size.width)
                            }
                        }
                        .onChange(of: [purchaseSum, overpurchaseSum]) { newValue in
                            withAnimation(.easeInOut(duration: 1.0)) {
                                sumGraphWidth = newValue[0] > groupData.group_goal ? (geometry.size.width) : CGFloat(Double(newValue[0])/Double(groupData.group_goal)) * (geometry.size.width)
                                overGraphWidth = newValue[1] > groupData.group_goal ? (geometry.size.width) : CGFloat(Double(newValue[1])/Double(groupData.group_goal)) * (geometry.size.width)
                            }
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

