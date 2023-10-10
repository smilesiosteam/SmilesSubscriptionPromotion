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

@objc public protocol SmilesSubscriptionPromotionDelegate: AnyObject {
    
    func navigateEnterGiftCard()
    func navigateToScanQrController()
    func registerPersonalizationEventRequest(urlScheme: String?,offerId: String?,bannerType: String?,eventName: String?)
    func checkEligiblity()
}

public enum SmilesSbuscriptionPromotionBillsAndRechargeAnimation: String {
    case BillPaymentNotEligible = "NotEligibleEtisalatCustomer"
    case PaymentFailed = "PaymentFailed"
}
