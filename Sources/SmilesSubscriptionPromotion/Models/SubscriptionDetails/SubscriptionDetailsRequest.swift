//
//  File.swift
//  
//
//  Created by Ghullam  Abbas on 03/10/2023.
//

import Foundation
import SmilesBaseMainRequestManager

public class SubscriptionDetailsRequest: SmilesBaseMainRequest {
    
    // MARK: - Model Variables
    
    var subscriptionSegment: String?
   
    
    
    // MARK: - Model Keys
    
    enum CodingKeys: CodingKey {
       
        case subscriptionSegment
        
        
    }
    
    public init(subscriptionSegment: String?) {
        super.init()
        self.subscriptionSegment = subscriptionSegment
        
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.subscriptionSegment, forKey: .subscriptionSegment)
    }
}
