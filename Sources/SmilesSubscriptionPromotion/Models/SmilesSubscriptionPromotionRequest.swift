//
//  File.swift
//  
//
//  Created by Ghullam  Abbas on 03/10/2023.
//

import Foundation
import SmilesBaseMainRequestManager

public class SmilesSubscriptionPromotionRequest: SmilesBaseMainRequest {
    
    // MARK: - Model Variables
    
    var isGuestUser: Bool?
   
    
    
    // MARK: - Model Keys
    
    enum CodingKeys: CodingKey {
       
        case isGuestUser
        
        
    }
    
    public init(isGuestUser: Bool?) {
        super.init()
        self.isGuestUser = isGuestUser
        
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.isGuestUser, forKey: .isGuestUser)
    }
}
