//
//  UserData.swift
//  GumungGagye
//
//  Created by 신상용 on 2023/07/19.
//

import Foundation
import UIKit

final class InputUserData: ObservableObject {
    static let shared = InputUserData()

    @Published var user_id: String?
    @Published var email: String?
    @Published var nickname: String?
    @Published var group_id: String?
    @Published var goal: Int?
    @Published var bankcardpay: Int?
    @Published var bankcardpay_index: Int?
    @Published var profile_image: UIImage?
    @Published var profile_image_url: String?
    @Published var bankcardpay_info: [String]?

    private init() { }
}
