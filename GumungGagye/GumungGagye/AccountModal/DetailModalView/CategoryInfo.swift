//
//  CategoryInfo.swift
//  GumungGagye
//
//  Created by 신상용 on 2023/07/28.
//

import Foundation


final class CategoryInfo: ObservableObject {
    static let shared = CategoryInfo()

    var category_info = [[1: ["식비", "bank1"], 2: ["카페", "bank1"], 3: ["술, 유흥", "bank1"], 4: ["교통, 차량", "bank1"], 5: ["문화, 여가", "bank1"], 6: ["주거, 통신", "bank1"], 7: ["마트, 편의점, 잡화", "bank1"], 8: ["패션, 미용", "bank1"], 9: ["생활", "bank1"], 10: ["의료, 건강, 피트니스", "bank1"], 11: ["교육", "bank1"], 12: ["경조사, 회비", "bank1"], 13: ["기타", "bank1"]], [1:["급여", "bank1"], 2:["용돈", "bank1"], 3: ["사업 수입", "bank1"], 4:["금융 수입", "bank1"], 5:["부수입", "bank1"], 6:["기타", "bank1"]]]
    

    private init() { }
}
