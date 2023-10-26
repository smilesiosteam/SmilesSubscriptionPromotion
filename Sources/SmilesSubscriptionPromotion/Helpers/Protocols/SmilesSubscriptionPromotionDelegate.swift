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

@objc public enum SmilesSubscriptionPromotionNavigationType: Int {
    case payment, withTextPromo, withQRPromo, freeTicket
}


@objc public protocol SmilesSubscriptionPromotionDelegate: AnyObject {
    
    func navigateEnterGiftCard()
    func navigateToScanQrController()
    func registerPersonalizationEventRequest(urlScheme: String?,offerId: String?,bannerType: String?,eventName: String?)
    func checkEligiblity()
    func proceedToPayment(params: SmilesSubscriptionPromotionPaymentParams, navigationType: SmilesSubscriptionPromotionNavigationType)
    func navigateToTermsAndConditions(terms: String)
    func setPersonalizationEventSource(personalizationEventSource: String?)
    func setBogoAndOfferData(bogoDetailsResponse:AnyObject?,offer:AnyObject?)
}

public enum SmilesSbuscriptionPromotionBillsAndRechargeAnimation: String {
    case BillPaymentNotEligible = "NotEligibleEtisalatCustomer"
    case PaymentFailed = "PaymentFailed"
}
