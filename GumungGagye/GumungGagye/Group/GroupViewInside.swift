//
//  GroupViewInside.swift
//  GumungGagye
//
//  Created by 정도현 on 2023/07/10.
//

import SwiftUI
import FirebaseAuth

enum GroupOption: String, CaseIterable {
    case invite = "그룹 초대하기"
    case leave = "그룹 나가기"
    case explore = "그룹 둘러보기"
}

struct GroupViewInside: View {
    @Environment(\.presentationMode) var presentationMode
    
    var groupData: GroupData
    
    @StateObject var userData = InputUserData.shared
    @StateObject private var firebaseManager = FirebaseController.shared
    
    @State var selectedUserID: String?
    @State private var selectedOption: GroupOption?
    @State private var isLeaveAlertPresented: Bool = false
    @State private var isShowModal: Bool = false
    
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
                .padding(.horizontal, 20)
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
                            GroupNotExistView(userHasGroup: true)
                                .presentationDetents([.large])
                                .presentationDragIndicator(.visible)
                        }
                    }
                }
                
                ScrollView {
                    VStack(spacing: 0) {
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

// MARK: Group Top Info
struct GroupTopInfo: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isUserDismiss: Bool = false
    
    var groupData: GroupData
    
    @StateObject var userData = InputUserData.shared
    @StateObject private var firebaseManager = FirebaseController.shared
    
    var body: some View {
        ZStack {
            Color("background").ignoresSafeArea()
            VStack(spacing: 0) {
                GroupRoomView(groupdata: groupData, isNotExist: false)
                
                Spacer()
            }
            .background(Color("background").ignoresSafeArea())
            .padding(.horizontal, 20)
        }
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
    @State var selectedMonth = Date.now
    
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
                            if userData.count > 0 && selectedPersonID == nil {
                                selectedPerson = userData[0].nickname
                                selectedPersonID = userData[0].id
                            }
                        }
                    }
                }
            }
            
            // =======================================================================================
            
            GroupUserSumGraph(groupData: groupData, purchaseSum: $spendSum, overpurchaseSum: $overSpendSum, selectedMonth: $selectedMonth)
            
            if let selectedPersonID = selectedPersonID {
                ForEach(daysInSelectedMonth().reversed(), id: \.self) { day in
                    BudgetGroupView(year: getYear(day: day), month: getMonth(day: day), date: getDate(day: day), day: getDay(day: day), selectedUserID: selectedPersonID, selectedUserName: selectedPerson, spendSum: $spendSum, overSpendSum: $overSpendSum)
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    // 선택 한 달의 범위 리턴
    private func daysInSelectedMonth() -> Range<Int> {
        let calendar = Calendar.current
        guard let monthRange = calendar.range(of: .day, in: .month, for: selectedMonth) else {
            return 1..<2
        }
        
        return monthRange
    }
    
    func getYear(day: Int) -> String {
        let components = DateComponents(year: Calendar.current.component(.year, from: selectedMonth), month: Calendar.current.component(.month, from: selectedMonth), day: day)
        if let date = Calendar.current.date(from: components) {
            dateFormatter.dateFormat = "YYYY"
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    func getMonth(day: Int) -> String {
        let components = DateComponents(year: Calendar.current.component(.year, from: selectedMonth), month: Calendar.current.component(.month, from: selectedMonth), day: day)
        if let date = Calendar.current.date(from: components) {
            dateFormatter.dateFormat = "MM"
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    func getDate(day: Int) -> String {
        let components = DateComponents(year: Calendar.current.component(.year, from: selectedMonth), month: Calendar.current.component(.month, from: selectedMonth), day: day)
        if let date = Calendar.current.date(from: components) {
            dateFormatter.dateFormat = "d"
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    func getDay(day: Int) -> String {
        let components = DateComponents(year: Calendar.current.component(.year, from: selectedMonth), month: Calendar.current.component(.month, from: selectedMonth), day: day)
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
    var selectedUserName: String
    
    @State var dayFormat: String = ""
    @State var accountIDArray: [String] = []
    @State var incomeSum = 0
    
    @Binding var spendSum: Int
    @Binding var overSpendSum: Int
    
    @State private var spendTodaySum = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if accountIDArray.count > 0 {
                NavigationLink {
                    PersonalDaySpendView(accountIDArray: $accountIDArray, month: month, date: date, day: day, selectedUserName: selectedUserName, spendTodaySum: spendTodaySum)
                    
                } label: {
                    HStack(spacing: 0) {
                        Text("\(date)일 \(day)")
                            .modifier(Body2())
                        Spacer()
                        
                        if spendTodaySum > 0 {
                            Text("-\(spendTodaySum)원")
                                .modifier(Num4SemiBold())
                        }
                        Image("Chevron.right.thick.black")
                            .resizable()
                            .frame(width: 10, height: 14)
                            .padding(.leading, 3)
                    }
                    .foregroundColor(.black)
                }
                VStack(spacing: 20) {
                    ForEach(accountIDArray, id: \.self) { accountID in
                        Breakdown(size: .constant(.small), incomeSum: $incomeSum, spendSum: $spendSum, overSpendSum: $overSpendSum, spendTodaySum: $spendTodaySum, incomeTodaySum: .constant(0), isGroup: true, accountDataID: accountID)
                    }
                }
            }
            else if ((getYear(from: Date.now) == Int(year)) && (getMonth(from: Date.now) == Int(month)) && (getDate(from: Date.now) == Int(date)) && accountIDArray.count == 0) {
                if selectedUserID != Auth.auth().currentUser?.uid {
                    UserNoSpendView(date: date, day: day)
                } else {
                    HStack(spacing: 0) {
                        Text("\(date)일 \(day)")
                            .modifier(Body2())
                        Spacer()
                        
                        if spendTodaySum > 0 {
                            Text("-\(spendTodaySum)원")
                                .modifier(Num4SemiBold())
                        }
                    }
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
            spendTodaySum = 0
            spendSum = 0
            incomeSum = 0
            overSpendSum = 0
        }
        .onChange(of: month) { newValue in
            if let userID = selectedUserID {
                Task {
                    let todayDate = dayFormat.appending(year).appending("-").appending(newValue).appending("-").appending(date)
                    accountIDArray = try await fetchAccountArray(userID: userID, date: todayDate)
                }
            }
            spendTodaySum = 0
            spendSum = 0
            incomeSum = 0
            overSpendSum = 0
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
    
    func getYear(from date: Date) -> Int {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        return year
    }
    
    func getMonth(from date: Date) -> Int {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        return month
    }
    
    func getDate(from date: Date) -> Int {
        let calendar = Calendar.current
        let date = calendar.component(.day, from: date)
        return date
    }
}

// MARK: Show Group user month graph
struct GroupUserSumGraph: View {
    var groupData: GroupData
    @Binding var purchaseSum: Int
    @Binding var overpurchaseSum: Int
    @Binding var selectedMonth: Date
    
    @State private var sumGraphWidth: CGFloat = 0.0
    @State private var overGraphWidth: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            Color("background").ignoresSafeArea()
            VStack(alignment: .leading, spacing: 20) {
                MoveMonth(size: .Small, selectedMonth: $selectedMonth)
                
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
                            withAnimation(.easeInOut(duration: 0.7)) {
                                sumGraphWidth = purchaseSum > groupData.group_goal ? (geometry.size.width) : CGFloat(Double(purchaseSum)/Double(groupData.group_goal)) * (geometry.size.width)
                                overGraphWidth = overpurchaseSum > groupData.group_goal ? (geometry.size.width) : CGFloat(Double(overpurchaseSum)/Double(groupData.group_goal)) * (geometry.size.width)
                            }
                        }
                        .onChange(of: [purchaseSum, overpurchaseSum]) { newValue in
                            withAnimation(.easeInOut(duration: 0.7)) {
                                if newValue[0] > groupData.group_goal {
                                    sumGraphWidth = (geometry.size.width)
                                    overGraphWidth = (geometry.size.width)
                                } else {
                                    sumGraphWidth = newValue[0] > groupData.group_goal ? (geometry.size.width) : CGFloat(Double(newValue[0])/Double(groupData.group_goal)) * (geometry.size.width)
                                    overGraphWidth = newValue[1] > groupData.group_goal ? (geometry.size.width) : CGFloat(Double(newValue[1])/Double(groupData.group_goal)) * (geometry.size.width)
                                }
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

