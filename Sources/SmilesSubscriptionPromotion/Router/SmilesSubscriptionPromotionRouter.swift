//
//  File.swift
//  
//
//  Created by Ghullam  Abbas on 03/10/2023.
//

import SmilesSharedServices
import SmilesUtilities
import UIKit

@objcMembers
public final class SmilesSubscriptionPromotionRouter: NSObject {
    
    public static let shared = SmilesSubscriptionPromotionRouter()
    
    private override init() {}
    
    public func push(navVC: UINavigationController) {
        let vc = SmilesSubscriptionPromotionConfigurator.create(type: .SmilesSubscriptionPromotion)
        navVC.pushViewController(vc, animated: true)
    }
 
}

