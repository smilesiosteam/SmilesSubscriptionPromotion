//
//  File.swift
//  
//
//  Created by Ghullam  Abbas on 03/10/2023.
//

import Foundation
import Combine
import NetworkingLayer
import SmilesOffers
import SmilesBaseMainRequestManager

protocol SmilesSubscriptionPromotionServiceable {
    func smilesSubscriptionPromotionService(request: SmilesBaseMainRequest) -> AnyPublisher<SmilesSubscriptionBOGODetailsResponse, NetworkError>
}

class SmilesSubscriptionPromotionRepository: SmilesSubscriptionPromotionServiceable {
    
    private var networkRequest: Requestable
    private var baseUrl: String
    private var endPoint: SmilesSubscriptionPromotionEndPoints

  // inject this for testability
    init(networkRequest: Requestable, baseUrl: String, endPoint: SmilesSubscriptionPromotionEndPoints) {
        self.networkRequest = networkRequest
        self.baseUrl = baseUrl
        self.endPoint = endPoint
    }
  
    func smilesSubscriptionPromotionService(request: SmilesBaseMainRequest) -> AnyPublisher<SmilesSubscriptionBOGODetailsResponse, NetworkError> {
        let endPoint = SmilesSubscriptionPromotionRequestBuilder.getSmilesSubscriptionPromotions(request: request)
        let request = endPoint.createRequest(baseUrl: baseUrl, endPoint: .fetchSubscriptionPromotionList)
        
        return self.networkRequest.request(request)
    }
    
}
