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
       case SubscriptionDetails(isGuestUser: Bool,showBackButton: Bool,delegate: SmilesSubscriptionPromotionDelegate?)
       case SmilesSubscriptionPromotion(isGuestUser: Bool,showBackButton: Bool,delegate: SmilesSubscriptionPromotionDelegate?)
    }
    
    public static func create(type: ConfiguratorType) -> UIViewController {
        switch type {
        case .SubscriptionDetails(let isGuestUser, let showBackButton,let delegate):
            let vc = SmilesSubscriptionDetailsVC(showBackButton: showBackButton, isGuestUser: isGuestUser,delegate: delegate)
            return vc
        case .SmilesSubscriptionPromotion(let isGuestUser, let showBackButton,let delegate):
            return SmilesSubscriptionPromotionVC(showBackButton: showBackButton, isGuestUser: isGuestUser,delegate: delegate)
        }
        
    }
    
}

