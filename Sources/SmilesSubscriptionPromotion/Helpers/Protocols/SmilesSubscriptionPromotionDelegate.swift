//
//  File.swift
//  
//
//  Created by Ghullam  Abbas on 04/10/2023.
//

import Foundation
import SmilesOffers
import SmilesStoriesManager
import UIKit

public protocol SmilesSubscriptionPromotionDelegate {
    
    func navigateEnterGiftCard()
    func navigateToScanQrController()
    func showYTPopupView(frame: UIView)
    
}

public enum SmilesSbuscriptionPromotionBillsAndRechargeAnimation: String {
    case BillPaymentNotEligible = "NotEligibleEtisalatCustomer"
    case PaymentFailed = "PaymentFailed"
}
