////
////  CategoryPostView.swift
////  GumungGagye
////
////  Created by Lee Juwon on 2023/07/31.
////
//
//import SwiftUI
//import FirebaseAuth
//import Firebase
//
//struct CategoryPostView: View {
//    var budgetFirebaseManager = BudgetFirebaseManager.shared
//    let db = Firestore.firestore()
//    
//    let year: String    // 년도
//    let month: String   // 월
//    let date: String    // 날짜
//    let day: String     // 요일
//    @State var dayFormat: String = ""
//    @State var accountIDArray: [String] = []
//    @State var spendSum = 0
//    @State var incomeSum = 0
//
//    @ObservedObject var categoryInfo = CategoryInfo.shared
//    // 선택한 카테고리 정보를 저장할 상태 속성
//    @State private var selectedCategory = nil
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            if accountIDArray.count > 0 {
//                Text("\(date)일 \(day)")
//                    .modifier(Body2())
//
//                ForEach(accountIDArray, id: \.self) { accountID in
//                    // fetchSpendData 함수를 사용하여 accountID에 해당하는 소비 데이터를 가져옵니다.
//                    if let spendData = fetchCategorySpendData(forAccountID: accountID) {
//                        // 가져온 소비 데이터의 카테고리가 선택한 카테고리와 일치하는 경우에만 출력
//                        if spendData.category == selectedCategory.rawValue {
//                            Breakdown(size: .constant(.small), incomeSum: $incomeSum, spendSum: $spendSum, accountDataID: accountID)
//                        }
//                    }
//                }
//            }
//        }
//        .padding(.bottom, accountIDArray.count > 0 ? 52 : 0)
//        .onAppear {
//            if let userID = Auth.auth().currentUser?.uid {
//                Task {
//                    let todayDate = dayFormat.appending(year).appending("-").appending(month).appending("-").appending(date)
//                    accountIDArray = try await fetchAccountArray(userID: userID, date: todayDate)
//                }
//            }
//        }
//    }
//
//    func fetchCategorySpendData(forAccountID accountID: String) async throws -> ReadSpendData? {
//        do {
//            let querySnapshot = try await db.collection("spend").whereField("account_id", isEqualTo: accountID).limit(to: 1).getDocuments()
//            guard let document = querySnapshot.documents.first else {
//                return nil
//            }
//            let spendData = ReadSpendData(
//                id: document.documentID,
//                bill: document.data()["spend_bill"] as? Int ?? 0,
//                category: document.data()["spend_category"] as? Int ?? 0,
//                content: document.data()["spend_content"] as? String ?? "",
//                open: document.data()["spend_open"] as? Bool ?? false,
//                overConsume: document.data()["spend_overConsume"] as? Bool ?? false
//            )
//            return spendData
//        } catch {
//            throw error
//        }
//    }
//
//
//    func fetchAccountArray(userID userId: String, date: String) async throws -> [String] {
//        do {
//            let accountArray = try await budgetFirebaseManager.fetchPostData(userID: userId, date: date)
//            return accountArray
//        } catch {
//            throw error
//        }
//    }
//}
//
////struct CategoryPostView_Previews: PreviewProvider {
////    static var previews: some View {
////        CategoryPostView()
////    }
////}
