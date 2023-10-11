//
//  File.swift
//  
//
//  Created by Ghullam  Abbas on 03/10/2023.
//

import Foundation
import NetworkingLayer
import SmilesUtilities
import SmilesSharedServices


// MARK: - SubscriptionDetailsResponse
class SubscriptionDetailsResponse: BaseMainResponse {
    let subscriptionSegment: String?
    let benefitsList: [BenefitsList]?
    let benefitsTitle: String?
    enum CodingKeys: String, CodingKey {
        case subscriptionSegment, benefitsList, benefitsTitle
    }

    init(extTransactionID: String?, subscriptionSegment: String?, benefitsList: [BenefitsList]?, benefitsTitle:String?) {
        self.subscriptionSegment = subscriptionSegment
        self.benefitsList = benefitsList
        self.benefitsTitle = benefitsTitle
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        subscriptionSegment = try values.decodeIfPresent(String.self, forKey: .subscriptionSegment)
        benefitsTitle = try values.decodeIfPresent(String.self, forKey: .benefitsTitle)
        benefitsList = try values.decodeIfPresent([BenefitsList].self, forKey: .benefitsList)
        try super.init(from: decoder)
    }
    
    
}

// MARK: - BenefitsList
class BenefitsList: Codable {
    let title, subTitle, backgroundColor: String?, textColor: String?
    let images: [String]?

    init(title: String?, subTitle: String?, backgroundColor: String?, textColor: String?, images: [String]?) {
        self.title = title
        self.subTitle = subTitle
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.images = images
    }
}
