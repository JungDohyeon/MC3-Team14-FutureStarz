//
//  CategoryInfo.swift
//  GumungGagye
//
//  Created by 신상용 on 2023/07/28.
//

import Foundation


final class CategoryInfo: ObservableObject {
    static let shared = CategoryInfo()

    var category_info = [[1: ["식비", "Food"], 2: ["카페", "Cafe"], 3: ["술∙ 유흥", "Alcohol"], 4: ["교통∙차량", "Vehicle"], 5: ["문화∙여가", "Leisure"], 6: ["주거∙통신", "Traffic"], 7: ["마트∙잡화", "Store"], 8: ["패션∙미용", "Fashion"], 9: ["생활", "Living"], 10: ["의료∙건강", "Health"], 11: ["교육", "Education"], 12: ["경조사∙회비", "Congratulation"], 13: ["기타", "Etc"]], [1:["급여", "Pay"], 2:["용돈", "PocketMoney"], 3: ["사업 수입", "Business"], 4:["금융 수입", "Finance"], 5:["부수입", "Extra"], 6:["기타", "Etc"]]]
    

    private init() { }
}
