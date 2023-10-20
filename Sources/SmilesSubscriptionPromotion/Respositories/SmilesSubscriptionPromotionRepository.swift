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
    func smilesSubscriptionDetailsService(request: SubscriptionDetailsRequest) -> AnyPublisher<SubscriptionDetailsResponse, NetworkError>
    func smilesSubscriptionVideoTutorialService(request: SmilesBaseMainRequest) -> AnyPublisher<SmilesSubsciptionVideoTutorialResponse, NetworkError>
    func cancelSubscriptionService(request: CancelSubscriptionRequestModel) -> AnyPublisher<CancelSubscriptionResponseModel, NetworkError>
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
    
    func smilesSubscriptionDetailsService(request: SubscriptionDetailsRequest) -> AnyPublisher<SubscriptionDetailsResponse, NetworkError> {
        let endPoint = SmilesSubscriptionPromotionRequestBuilder.getSmilesSubscriptionPromotions(request: request)
        let request = endPoint.createRequest(baseUrl: baseUrl, endPoint: .fetchSubscriptionDetails)
        return self.networkRequest.request(request)
    }
    func smilesSubscriptionVideoTutorialService(request: SmilesBaseMainRequest) -> AnyPublisher<SmilesSubsciptionVideoTutorialResponse, NetworkError> {
        let endPoint = SmilesSubscriptionPromotionRequestBuilder.getSmilesVideoTutorial(request: request)
        let request = endPoint.createRequest(baseUrl: baseUrl, endPoint: .fetchVideoTutorials)
        return self.networkRequest.request(request)
    }
    func cancelSubscriptionService(request: CancelSubscriptionRequestModel) -> AnyPublisher<CancelSubscriptionResponseModel, NetworkingLayer.NetworkError> {
        let endPoint = SmilesSubscriptionPromotionRequestBuilder.cancelSubscription(request: request)
        let request = endPoint.createRequest(baseUrl: baseUrl, endPoint: .cancelSubscription)
        return self.networkRequest.request(request)
    }
}
