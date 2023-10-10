//
//  File.swift
//  
//
//  Created by Ghullam  Abbas on 03/10/2023.
//

import Foundation
import NetworkingLayer

public enum SmilesSubscriptionPromotionEndPoints: String, CaseIterable {
    case fetchSubscriptionPromotionList
    case fetchSubscriptionDetails
    case fetchVideoTutorials
}

extension SmilesSubscriptionPromotionEndPoints {
    var serviceEndPoints: String {
        switch self {
        case .fetchSubscriptionPromotionList:
            return "lifestyle/v2/lifestyle-offers"
        case .fetchSubscriptionDetails:
            return "lifestyle/segment-benefits"
        case .fetchVideoTutorials:
            return "\(EndPoints.homeEndpoint)/v1/get-video-tutorial"
        }
    }
}
