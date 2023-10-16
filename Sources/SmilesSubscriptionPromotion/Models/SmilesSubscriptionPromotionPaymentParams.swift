//
//  File.swift
//  
//
//  Created by Ghullam  Abbas on 16/10/2023.
//

import Foundation
import SmilesUtilities
import SmilesOffers

@objc public class SmilesSubscriptionPromotionPaymentParams: NSObject {
    
    public var lifeStyleOffer: BOGODetailsResponseLifestyleOffer? = nil
    public var freeOffer: OfferDO? = nil
    public var themeResources: ThemeResources? = nil
    public var isComingFromSpecialOffer: Bool = false
    public var isComingFromTreasureChest: Bool = false
    
}
