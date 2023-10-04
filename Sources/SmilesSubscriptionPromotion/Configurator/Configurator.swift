//
//  File.swift
//  
//
//  Created by Ghullam  Abbas on 03/10/2023.
//

import Foundation
import UIKit

public struct SmilesSubscriptionPromotionConfigurator {
    
   public enum ConfiguratorType {
       case SmilesSubscriptionPromotion(isGuestUser: Bool,showBackButton: Bool,delegate: SmilesSubscriptionPromotionDelegate?)
    }
    
    public static func create(type: ConfiguratorType) -> UIViewController {
        switch type {
        case .SmilesSubscriptionPromotion(let isGuestUser, let showBackButton,let delegate):
            return SmilesSubscriptionPromotionVC(showBackButton: showBackButton, isGuestUser: isGuestUser,delegate: delegate)
        }
        
    }
    
}
