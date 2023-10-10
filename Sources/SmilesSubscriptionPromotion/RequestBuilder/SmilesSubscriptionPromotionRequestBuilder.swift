//
//  File.swift
//  
//
//  Created by Ghullam  Abbas on 03/10/2023.
//

import Foundation
import NetworkingLayer
import SmilesUtilities
import SmilesBaseMainRequestManager

enum SmilesSubscriptionPromotionRequestBuilder {
    
    
    case getSmilesSubscriptionPromotions(request: SmilesBaseMainRequest)
    case getSmilesVideoTutorial(request: SmilesBaseMainRequest)
    
    
    var requestTimeOut: Int {
        return 20
    }
    
    
    var httpMethod: SmilesHTTPMethod {
        switch self {
        case .getSmilesSubscriptionPromotions:
            return .POST
        case.getSmilesVideoTutorial:
            return .POST
        }
    }
    
    // compose the NetworkRequest
    func createRequest(baseUrl: String, endPoint: SmilesSubscriptionPromotionEndPoints) -> NetworkRequest {
        var headers: [String: String] = [:]

        headers["Content-Type"] = "application/json"
        headers["Accept"] = "application/json"
        headers["CUSTOM_HEADER"] = "pre_prod"
        
        return NetworkRequest(url: getURL(baseUrl: baseUrl, for: endPoint), headers: headers, reqBody: requestBody, httpMethod: httpMethod)
    }
    
    
    var requestBody: Encodable? {
        switch self {
        case .getSmilesSubscriptionPromotions(let request):
            return request
        case.getSmilesVideoTutorial(let request):
            return request
        }
        
    }
    
    
    func getURL(baseUrl: String, for endPoint: SmilesSubscriptionPromotionEndPoints) -> String {
        return baseUrl + endPoint.serviceEndPoints
    }
}

