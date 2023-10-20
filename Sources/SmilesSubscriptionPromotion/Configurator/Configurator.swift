//
//  File.swift
//  
//
//  Created by Ghullam  Abbas on 03/10/2023.
//

import Foundation
import UIKit
import SmilesUtilities

public struct SmilesSubscriptionPromotionConfigurator {
   public enum ConfiguratorType {
       case SubscriptionDetails(isGuestUser: Bool,bogoResponse: SmilesSubscriptionBOGODetailsResponse,offer: BOGODetailsResponseLifestyleOffer,delegate: SmilesSubscriptionPromotionDelegate?)
       case SmilesSubscriptionPromotion(isGuestUser: Bool,showBackButton: Bool,delegate: SmilesSubscriptionPromotionDelegate?)
       case SmilesSubscriptionOrderSummary(bogoResponse: SmilesSubscriptionBOGODetailsResponse,offer: BOGODetailsResponseLifestyleOffer,delegate: SmilesSubscriptionPromotionDelegate?, onDismiss:()->Void)
       case smilesManageSubscriptionPop(bogoResponse: SmilesSubscriptionBOGODetailsResponse,offer: BOGODetailsResponseLifestyleOffer,delegate: SmilesSubscriptionPromotionDelegate?, onDismiss:()->Void)
       case CancelSubscriptionFeedBack
    }
    
    public static func create(type: ConfiguratorType) -> UIViewController {
        switch type {
        case .SubscriptionDetails(let isGuestUser,let bogoResponse, let offer, let delegate):
            let vc = SmilesSubscriptionDetailsVC(bogoDetailsResponse: bogoResponse, offer:offer, isGuestUser: isGuestUser,delegate: delegate)
            return vc
        case .SmilesSubscriptionPromotion(let isGuestUser, let showBackButton,let delegate):
            return SmilesSubscriptionPromotionVC(showBackButton: showBackButton, isGuestUser: isGuestUser,delegate: delegate)
        case .SmilesSubscriptionOrderSummary(let bogoResponse, let offer, let delegate, let onDismiss):
            let vc = OrderSummaryViewController(bogoDetailsResponse: bogoResponse, offer: offer, delegate: delegate, onDismiss: onDismiss)
            return vc
        case .smilesManageSubscriptionPop(let bogoResponse, let offer, let delegate, let onDismiss):
            let vc = ManageSubscriptionPopupViewController(bogoDetailsResponse: bogoResponse, offer: offer, delegate: delegate,onDismiss: onDismiss)
            return vc
        case.CancelSubscriptionFeedBack:
            return SubscriptionCancelFeedBackViewController()
        }
        
    }
    
}

