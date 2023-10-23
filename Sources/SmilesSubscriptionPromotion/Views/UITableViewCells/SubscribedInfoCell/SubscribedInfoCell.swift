//
//  SubscribedInfoCell.swift
//  
//
//  Created by Shmeel Ahmad on 04/10/2023.
//

import UIKit
import SmilesUtilities
import SmilesFontsManager
import SmilesLanguageManager


class SubscribedInfoCell: UITableViewCell {
    
    @IBOutlet weak var cardImgView: UIImageView!
    @IBOutlet weak var subscriptionChannelView: UIView!
    
    @IBOutlet weak var autoRenewalView: UIView!
    
    @IBOutlet weak var paymentMethodView: UIView!
    
    @IBOutlet weak var containerView: UICustomView!
    
    @IBOutlet weak var offerTitleLabel: UILabel!
    
    @IBOutlet weak var paymentMethodLbl: UILabel!
    
    @IBOutlet weak var subscriptionChannelName: UILabel!
    @IBOutlet weak var paymentMethodCard: UILabel!
    
    @IBOutlet weak var subscriptionChannelLbl: UILabel!
    
    @IBOutlet weak var autoRenewDate: UILabel!
    @IBOutlet weak var pricePerMonth: UILabel!
    
    @IBOutlet weak var autoRenewsLbl: UILabel!
    
    var offer:BOGODetailsResponseLifestyleOffer?
    var bogoResponse:SmilesSubscriptionBOGODetailsResponse?
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.titleLabel.fontTextStyle = .smilesHeadline4
    }
    
    func updateCell(offer: BOGODetailsResponseLifestyleOffer, bogoResponse:SmilesSubscriptionBOGODetailsResponse?) {
        self.offer = offer
        self.bogoResponse = bogoResponse
        containerView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.05)
        offerTitleLabel.text = offer.offerTitle
        pricePerMonth.text = offer.monthlyPrice
        subscriptionChannelLbl.text = bogoResponse?.themeResources?.subscriptionChannelText
        subscriptionChannelName.text = offer.subscriptionChannel
        if offer.autoRenewable == true && offer.expiryDate != nil,let expiryDt=AppCommonMethods.returnDate(from: offer.expiryDate!, format: "dd-MM-yyyy HH:mm:ss") {
            autoRenewsLbl.text =  bogoResponse?.themeResources?.subscriptionExpriyText
            autoRenewDate.text = AppCommonMethods.convert(date: expiryDt, format: "dd MMM yyyy HH:mm:ss")
        } else if offer.nextRenewalDate != nil,let reneDt=AppCommonMethods.returnDate(from: offer.nextRenewalDate!, format: "dd-MM-yyyy HH:mm:ss") {
            autoRenewsLbl.text = bogoResponse?.themeResources?.subscriptionAutoRenewsText
            autoRenewDate.text = AppCommonMethods.convert(date: reneDt, format: "dd MMM yyyy HH:mm:ss")
        }else{
            autoRenewalView.isHidden = true
        }
        var paymentMethodType = ""
        if let paymentId = offer.paymentDetails?.paymentMethodId, paymentId == "2" {
            if let subType = offer.paymentDetails?.subType, let num = offer.paymentDetails?.cardNumber {
                let last4Chars = num.suffix(4)
                var cardEndingText = bogoResponse?.themeResources?.subscribeCardEndingText
                cardEndingText = cardEndingText?.replacingOccurrences(of: "{{card_title}}", with: subType).replacingOccurrences(of: "{{masked_card_number}}", with: last4Chars)
                paymentMethodType = cardEndingText ?? ""
            }
        } else {
            if SmilesLanguageManager.shared.currentLanguage == .ar {
                paymentMethodType = offer.paymentDetails?.titleAr ?? ""
            } else {
                paymentMethodType = offer.paymentDetails?.title ?? ""
            }
        }
        
        if !paymentMethodType.isEmpty {
            paymentMethodCard.text = paymentMethodType
            paymentMethodView.isHidden = false
            cardImgView.setImageWithUrlString( offer.paymentDetails?.cardImg ?? offer.paymentDetails?.iconUrl ?? "")
        } else {
            paymentMethodView.isHidden = true
        }
        paymentMethodLbl.text = bogoResponse?.themeResources?.subscriptionPaymentMethodText
        
    }
}
