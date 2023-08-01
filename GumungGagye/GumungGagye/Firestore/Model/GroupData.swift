//
//  GroupData.swift
//  GumungGagye
//
//  Created by 정도현 on 2023/07/19.
//

import Foundation

// MARK: GroupData
struct GroupData: Identifiable {
    var id: String
    var group_name: String  // 그룹 이름
    var group_introduce: String // 그룹 설명
    var group_goal: Int // 그룹 목표 금액
    var group_max: Int  // 최대 인원
    var lock_status: Bool   // 비공개 여부
    var group_pw: String   // 비공개 비번
    var timeStamp: Date   // Time Stamp
}
