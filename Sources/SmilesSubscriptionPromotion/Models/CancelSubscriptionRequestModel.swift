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
    
    var promoCode : String?
    var action : Int?
    var packageId : String?
    var subscriptionId : String?
    var subscriptionSegment : String?
    var cancellationReason : String?

    enum CodingKeys: String, CodingKey {

        case promoCode = "promoCode"
        case action = "action"
        case packageId = "packageId"
        case subscriptionId = "subscriptionId"
        case subscriptionSegment = "subscriptionSegment"
        case cancellationReason = "cancellationReason"
     
    }


    public init(promoCode: String?,action: Int?,packageId: String?,subscriptionId: String?,subscriptionSegment: String?,rejectionReason: String?) {
        self.promoCode = promoCode
        self.action = action
        self.packageId = packageId
        self.subscriptionId = subscriptionId
        self.subscriptionSegment = subscriptionSegment
        self.cancellationReason = rejectionReason
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
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.promoCode, forKey: .promoCode)
        try container.encodeIfPresent(self.action, forKey: .action)
        try container.encodeIfPresent(self.packageId, forKey: .packageId)
        try container.encodeIfPresent(self.subscriptionId, forKey: .subscriptionId)
        try container.encodeIfPresent(self.subscriptionSegment, forKey: .subscriptionSegment)
        try container.encodeIfPresent(self.cancellationReason, forKey: .cancellationReason)
    }

}

class CancelSubscriptionResponseModel : BaseMainResponse {
    var status : Int?
    var successPopupMessage : String?
    var successPopupTitle : String?
    

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case successPopupMessage = "successPopupMessage"
        case successPopupTitle = "successPopupTitle"
    }
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        successPopupMessage = try values.decodeIfPresent(String.self, forKey: .successPopupMessage)
        successPopupTitle = try values.decodeIfPresent(String.self, forKey: .successPopupTitle)
        try super.init(from: decoder)
    }

}



