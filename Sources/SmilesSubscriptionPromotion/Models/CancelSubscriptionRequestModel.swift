//
//  File.swift
//  
//
//  Created by Ghullam  Abbas on 19/10/2023.
//

import Foundation
import SmilesUtilities
import SmilesLocationHandler
import NetworkingLayer
import SmilesBaseMainRequestManager

class CancelSubscriptionRequestModel : SmilesBaseMainRequest {
    
    var promoCode : String? = nil
    var duration : String? = nil
    var action : Int? = nil
    var packageId : String? = nil
    var subscriptionId : String? = nil
    var subscriptionSegment : String? = nil
    var paymentMethod : String? = nil
    var rejectionReason : String? = nil

    enum CodingKeys: String, CodingKey {

        case promoCode = "promoCode"
        case duration = "duration"
        case action = "action"
        case packageId = "packageId"
        case subscriptionId = "subscriptionId"
        case subscriptionSegment = "subscriptionSegment"
        case paymentMethod = "paymentMethod"
        case rejectionReason = "rejectionReason"
     
    }


    override init() {
        super.init()
    }
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    func asDictionary(dictionary: [String: Any]) -> [String: Any] {
          let encoder = DictionaryEncoder()
          guard let encoded = try? encoder.encode(self) as [String: Any] else {
              return [:]
          }
          return encoded.mergeDictionaries(dictionary: dictionary)
      }
    

}

class CancelSubscriptionResponseModel : BaseMainResponse {
    var status : Int?
    var title : String?
    var description : String?
    var rejectionReasons : [String]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case title = "title"
        case description = "description"
        case rejectionReasons = "rejectionReasons"
    }
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        rejectionReasons = try values.decodeIfPresent([String].self, forKey: .rejectionReasons)
        
        try super.init(from: decoder)
    }

}



