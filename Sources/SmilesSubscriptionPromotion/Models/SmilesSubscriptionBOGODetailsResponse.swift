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

public class SmilesSubscriptionBOGODetailsResponse : BaseMainResponse {
    let themeResources: ThemeResources?
    let lifestyleOffers : [BOGODetailsResponseLifestyleOffer]?
    let offerHeader : String?
    let offers : [SmilesSubscriptionOffersList]?
    let subscriptionStatus : String?
    let termsAndConditions : String?
    let isCustomerElgibile: Bool?
    let lifestyleOfferTitle: String?
    let lifestyleImageUrl : String?
    let lifestyleLogoUrl : String?
    let lifestyleSubTitle : String?
    let lifestyleTitle : String?
    let otherSubscription : String?
    let promoCodeButtonText : String?
    let promoCodeTitle : String?
    let subscribeButtonText : String?
    let subscriptionTitle : String?
    let termsAndConditionTitle : String?
    let unSubscribeButtonText : String?
    let changePaymentMethodText : String?
    let authorizeCardTitle : String?
    let authorizeCardDesc : String?
    let authorizeCardIconUrl : String?
    
    
    
    enum BOGODetailsCodingKeys: String, CodingKey {
        case themeResources
        case lifestyleOffers = "lifestyleOffers"
        case offerHeader = "offerHeader"
        case offers = "offers"
        case subscriptionStatus = "subscriptionStatus"
        case termsAndConditions = "termsAndConditions"
        case isCustomerElgibile = "isCustomerElgibile"
        case lifestyleOfferTitle = "lifestyleOfferTitle"
        case lifestyleImageUrl = "lifestyleImageUrl"
        case lifestyleLogoUrl = "lifestyleLogoUrl"
        case lifestyleSubTitle = "lifestyleSubTitle"
        case lifestyleTitle = "lifestyleTitle"
        case otherSubscription = "otherSubscription"
        case promoCodeButtonText = "promoCodeButtonText"
        case promoCodeTitle = "promoCodeTitle"
        case subscribeButtonText = "subscribeButtonText"
        case subscriptionTitle = "subscriptionTitle"
        case termsAndConditionTitle = "termsAndConditionTitle"
        case unSubscribeButtonText = "unSubscribeButtonText"
        case changePaymentMethodText
        case authorizeCardTitle
        case authorizeCardDesc
        case authorizeCardIconUrl
        
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: BOGODetailsCodingKeys.self)
        themeResources = try values.decodeIfPresent(ThemeResources.self, forKey: .themeResources)
        lifestyleOffers = try values.decodeIfPresent([BOGODetailsResponseLifestyleOffer].self, forKey: .lifestyleOffers)
        offerHeader = try values.decodeIfPresent(String.self, forKey: .offerHeader)
        offers = try values.decodeIfPresent([SmilesSubscriptionOffersList].self, forKey: .offers)
        subscriptionStatus = try values.decodeIfPresent(String.self, forKey: .subscriptionStatus)
        termsAndConditions = try values.decodeIfPresent(String.self, forKey: .termsAndConditions)
        isCustomerElgibile = try values.decodeIfPresent(Bool.self, forKey: .isCustomerElgibile)
        lifestyleOfferTitle = try values.decodeIfPresent(String.self, forKey: .lifestyleOfferTitle)
        lifestyleImageUrl = try values.decodeIfPresent(String.self, forKey: .lifestyleImageUrl)
        lifestyleLogoUrl = try values.decodeIfPresent(String.self, forKey: .lifestyleLogoUrl)
        lifestyleSubTitle = try values.decodeIfPresent(String.self, forKey: .lifestyleSubTitle)
        lifestyleTitle = try values.decodeIfPresent(String.self, forKey: .lifestyleTitle)
        otherSubscription = try values.decodeIfPresent(String.self, forKey: .otherSubscription)
        promoCodeButtonText = try values.decodeIfPresent(String.self, forKey: .promoCodeButtonText)
        promoCodeTitle = try values.decodeIfPresent(String.self, forKey: .promoCodeTitle)
        subscribeButtonText = try values.decodeIfPresent(String.self, forKey: .subscribeButtonText)
        subscriptionTitle = try values.decodeIfPresent(String.self, forKey: .subscriptionTitle)
        termsAndConditionTitle = try values.decodeIfPresent(String.self, forKey: .termsAndConditionTitle)
        unSubscribeButtonText = try values.decodeIfPresent(String.self, forKey: .unSubscribeButtonText)
        changePaymentMethodText =  try values.decodeIfPresent(String.self, forKey: .changePaymentMethodText)
        authorizeCardTitle = try values.decodeIfPresent(String.self, forKey: .authorizeCardTitle)
        authorizeCardDesc = try values.decodeIfPresent(String.self, forKey: .authorizeCardDesc)
        authorizeCardIconUrl = try values.decodeIfPresent(String.self, forKey: .authorizeCardIconUrl)
        try super.init(from: decoder)
    }
    
}


class SmilesSubscriptionOffersList : Codable {
    
    var categoryId : String?
    var categoryOrder : Int?
    var cinemaOfferFlag : Bool?
    var dirhamValue : String?
    var imageURL : String?
    var isWishlisted : Bool?
    var merchantDistance : String?
    var offerDescription : String?
    var offerId : String?
    var offerTitle : String?
    var offerType : String?
    var offerTypeAr : String?
    var partnerImage : String?
    var partnerName : String?
    var pointsValue : String?
    var originalPointsValue : String?
    var originalDirhamValue : String?
    var voucherPromoText : String?
    var isBirthdayOffer : Bool?
    var isRedeemedOffer : Bool?
    var birthdayTxt : String?
    var redeemedTxt : String?
    var recommendationModelEvent: String?
    
    enum CodingKeys: String, CodingKey {
        case categoryId = "categoryId"
        case categoryOrder = "categoryOrder"
        case cinemaOfferFlag = "cinemaOfferFlag"
        case dirhamValue = "dirhamValue"
        case imageURL = "imageURL"
        case isWishlisted = "isWishlisted"
        case merchantDistance = "merchantDistance"
        case offerDescription = "offerDescription"
        case offerId = "offerId"
        case offerTitle = "offerTitle"
        case offerType = "offerType"
        case offerTypeAr = "offerTypeAr"
        case partnerImage = "partnerImage"
        case partnerName = "partnerName"
        case pointsValue = "pointsValue"
        case originalPointsValue = "originalPointsValue"
        case originalDirhamValue = "originalDirhamValue"
        case voucherPromoText = "voucherPromoText"
        case isBirthdayOffer = "isBirthdayOffer"
        case isRedeemedOffer = "isRedeemedOffer"
        case birthdayTxt = "birthdayTxt"
        case redeemedTxt = "redeemedTxt"
        case recommendationModelEvent
    }
    
    required init(from decoder: Decoder) throws {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            categoryId = try values.decodeIfPresent(String.self, forKey: .categoryId)
            categoryOrder = try values.decodeIfPresent(Int.self, forKey: .categoryOrder)
            cinemaOfferFlag = try values.decodeIfPresent(Bool.self, forKey: .cinemaOfferFlag)
            dirhamValue = try values.decodeIfPresent(String.self, forKey: .dirhamValue)
            imageURL = try values.decodeIfPresent(String.self, forKey: .imageURL)
            isWishlisted = try values.decodeIfPresent(Bool.self, forKey: .isWishlisted)
            merchantDistance = try values.decodeIfPresent(String.self, forKey: .merchantDistance)
            offerDescription = try values.decodeIfPresent(String.self, forKey: .offerDescription)
            offerId = try values.decodeIfPresent(String.self, forKey: .offerId)
            offerTitle = try values.decodeIfPresent(String.self, forKey: .offerTitle)
            offerType = try values.decodeIfPresent(String.self, forKey: .offerType)
            offerTypeAr = try values.decodeIfPresent(String.self, forKey: .offerTypeAr)
            partnerImage = try values.decodeIfPresent(String.self, forKey: .partnerImage)
            partnerName = try values.decodeIfPresent(String.self, forKey: .partnerName)
            pointsValue = try values.decodeIfPresent(String.self, forKey: .pointsValue)
            originalPointsValue = try values.decodeIfPresent(String.self, forKey: .originalPointsValue)
            originalDirhamValue = try values.decodeIfPresent(String.self, forKey: .originalDirhamValue)
            voucherPromoText = try values.decodeIfPresent(String.self, forKey: .voucherPromoText)
            isBirthdayOffer = try values.decodeIfPresent(Bool.self, forKey: .isBirthdayOffer)
            isRedeemedOffer = try values.decodeIfPresent(Bool.self, forKey: .isRedeemedOffer)
            birthdayTxt = try values.decodeIfPresent(String.self, forKey: .birthdayTxt)
            redeemedTxt = try values.decodeIfPresent(String.self, forKey: .redeemedTxt)
            recommendationModelEvent = try values.decodeIfPresent(String.self, forKey: .recommendationModelEvent)
            
        } catch let ex {
            print(ex.localizedDescription)
        }
    }
    
    init() {
        categoryId = ""
        categoryOrder = 0
        cinemaOfferFlag = false
        dirhamValue = ""
        imageURL = ""
        isWishlisted = false
        merchantDistance = ""
        offerDescription = ""
        offerId = ""
        offerTitle = ""
        offerType = ""
        offerTypeAr = ""
        partnerImage = ""
        partnerName = ""
        pointsValue = ""
        originalPointsValue = ""
        originalDirhamValue = ""
        voucherPromoText = ""
        isRedeemedOffer = false
        isBirthdayOffer = false
        redeemedTxt = ""
        birthdayTxt = ""
        recommendationModelEvent = ""
    }
    
    func asDictionary(dictionary: [String: Any]) -> [String: Any] {
        let encoder = DictionaryEncoder()
        guard let encoded = try? encoder.encode(self) as [String: Any] else {
            return [:]
        }
        return encoded.mergeDictionaries(dictionary: dictionary)
    }
    
}
