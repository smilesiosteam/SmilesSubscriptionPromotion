//
//  SmilesSubscriptionPromotionCell.swift
//  
//
//  Created by Ghullam  Abbas on 03/10/2023.
//

import UIKit
import SmilesUtilities
import SmilesFontsManager

protocol SmilesSubscriptionButtonCellDelegate: AnyObject {
    func subscribeDidTapped(model: BOGODetailsResponseLifestyleOffer)
}



class SmilesSubscriptionTableCellModel {
    var subscriptionTitle: String?
    var subscriptionImg : String?
    var subscriptionDesc : String?
    var monthlyPrice: String?
    var price: Double?
    var beforeDiscountedPrice: Double?
    var freeBogoOffer: Bool?
    var model: BOGODetailsResponseLifestyleOffer?
    var trialPeriod: String?
    var autoRenewPrice: String?
    
    var subscriptionStateColor: UIColor?
    var subscribedSegment: String?
    var autoRenewHeading: String?
    var expiryDate: String?
    var nextRenewalDate: String?
    var paymentMethodHeading: String?
    var paymentMethodType: String?
    var subscriptionStatus: String?
    var cardImg: String?
    var autoRenewable: Bool?
    var isSubscription: Bool?
    var isSubscriptionOnHold: Bool?
    var subscriptionOnHoldDesc: String?
    var subscriptionAccountNumber: String?
    var freePlanTitle: String?
    var subscriptionAmount: String?
    var isCBDOffer: Bool?
    var subscribedStatus: String?
    
    init() {}
}


class SmilesSubscriptionPromotionCell: UITableViewCell {
    
    //MARK: - IBOutlets -
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var trialPeriodButton: UIButton!
    @IBOutlet weak var subscribeButton: UIButton!
    @IBOutlet weak var offerImageView: UIImageView!
    
    @IBOutlet weak var subscriptionStateView: UIView!
    @IBOutlet weak var subscriptionStateLabel: UILabel!
    @IBOutlet weak var subscriptionStateIconView: UIImageView!
    
    weak var delegate: SmilesSubscriptionButtonCellDelegate?
    var bogoLifeStyleOfferModel: BOGODetailsResponseLifestyleOffer?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.titleLabel.fontTextStyle = .smilesHeadline2
        self.detailLabel.fontTextStyle = .smilesBody2
        self.subscribeButton.titleLabel?.fontTextStyle = .smilesHeadline4
        self.trialPeriodButton.titleLabel?.fontTextStyle = .smilesBody3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
     func updateCell(rowModel: SmilesSubscriptionTableCellModel?) {
        if let model = rowModel {
            self.subscribeButton.isHidden = false
            let aed = "AED".localizedString + " "
            
            let smilesAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.circularXXTTBoldFont(size: 14),
                .foregroundColor: UIColor.black,
            ]
            
            let price = model.beforeDiscountedPrice ?? 0
            let attributedString = NSMutableAttributedString(string: aed,attributes: smilesAttributes)

            if price > 0 {
                let crossedAmount = "\(String(describing: model.beforeDiscountedPrice ?? 0))".strikoutString(strikeOutColor: .appGreyColor_128)
                attributedString.append(crossedAmount)
                attributedString.append(NSMutableAttributedString(string:  " \(model.model?.monthlyPriceCost ?? "")/\("Month".localizedString)",attributes: smilesAttributes))
                self.amountLabel.attributedText = attributedString
            } else {
                let priceInDouble = Double(model.model?.monthlyPriceCost ?? "0") ?? 0
                if (priceInDouble > 0) {
                    attributedString.append(NSMutableAttributedString(string: "\(priceInDouble)/\("Month".localizedString)",attributes: smilesAttributes))
                    self.amountLabel.attributedText = attributedString
                } else {
                    self.amountLabel.text = "Free".localizedString
                }
                
            }
        
            self.titleLabel.text = model.subscriptionTitle
            self.detailLabel.text = model.subscriptionDesc
            
            self.offerImageView.setImageWithUrlString(model.model?.catalogImageUrl.asStringOrEmpty() ?? "",defaultImage: "subscriptionOfferImage", backgroundColor: .white) { image in
                if let image = image {
                    self.offerImageView.image = image
                }
            }
                    
            if model.model?.isSubscription ?? false ||  model.isSubscriptionOnHold ?? false{
                self.subscribeButton.setTitle("ManageSubscriptionText".localizedString, for: .normal)
                self.subscribeButton.backgroundColor = .appRevampPurpleMainColor
                self.subscribeButton.setTitleColor(.white, for: .normal)
                self.subscriptionStateView.isHidden = false
                
}
            else {
                self.subscribeButton.setTitle("Subscribe now".localizedString, for: .normal)
                subscriptionStateView.isHidden = true
                self.subscribeButton.backgroundColor = .white
                self.subscribeButton.setTitleColor(.appRevampPurpleMainColor, for: .normal)
            }
                    
            if let trialPeriod = model.trialPeriod, !trialPeriod.isEmpty {
                self.trialPeriodButton.isHidden = false
                self.trialPeriodButton.setTitle(trialPeriod, for: .normal)
                
            } else {
                self.trialPeriodButton.isHidden = true
            }
            self.bogoLifeStyleOfferModel = model.model
            
            self.subscriptionStateIconView.RoundedViewConrner(cornerRadius: self.subscriptionStateIconView.frame.width / 2)
            subscriptionStateLabel.text = model.subscribedStatus.asStringOrEmpty()
            subscriptionStateLabel.textColor = model.subscriptionStateColor
            self.subscriptionStateIconView.backgroundColor = model.subscriptionStateColor
        }
        
    }
    @IBAction func subscribeBtnTapped(_ sender: UIButton) {

        if let delegate, let bogoLifeStyleOfferModel {
            delegate.subscribeDidTapped(model: bogoLifeStyleOfferModel)
        }
    }
   
}
