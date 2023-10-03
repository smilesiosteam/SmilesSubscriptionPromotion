//
//  File.swift
//  
//
//  Created by Ghullam  Abbas on 03/10/2023.
//

import Foundation
public enum SmilesSubscriptionPromotionEndPoints: String, CaseIterable {
    case fetchSubscriptionPromotionList
}

extension SmilesSubscriptionPromotionEndPoints {
    var serviceEndPoints: String {
        switch self {
        case .fetchSubscriptionPromotionList:
            return "lifestyle/v2/lifestyle-offers"
        }
    }
}
