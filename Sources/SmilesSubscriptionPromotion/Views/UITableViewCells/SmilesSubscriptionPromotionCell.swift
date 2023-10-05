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
    func subscribeDidTapped(model: BOGODetailsResponseLifestyleOffer?)
}



class SmilesSubscriptionTableCellModel {
    var subscriptionTitle: String?
    var subscriptionImg : String?
    var subscriptionDesc : String?
    var monthlyPrice: String?
    var price: Double?
    var freeBogoOffer: Bool?
    var model: BOGODetailsResponseLifestyleOffer?
    var trialPeriod: String?
    var autoRenewPrice: String?
    
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
     func updateCell(rowModel: SmilesSubscriptionTableCellModel) {
        if let model = rowModel as? SmilesSubscriptionTableCellModel {
            
            let aed = "AED".localizedString + " "
            
            let smilesAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.circularXXTTBoldFont(size: 14),
                .foregroundColor: UIColor.black,
            ]
            
            let crossedAmount = "\(String(describing: model.price ?? 0))".strikoutString(strikeOutColor: .appGreyColor_128)
            
            var attributedString = NSMutableAttributedString(string: aed,attributes: smilesAttributes)
            attributedString.append(crossedAmount)
            attributedString.append(NSMutableAttributedString(string:  " \(model.model?.discountedPrice ?? 0)/month",attributes: smilesAttributes))
            self.amountLabel.attributedText = attributedString
            //"\(aed) \(crossedAmount) \( model.monthlyPrice.asStringOrEmpty())"
            self.titleLabel.text = model.subscriptionTitle
            self.detailLabel.text = model.subscriptionDesc
            
            self.offerImageView.setImageWithUrlString(model.model?.catalogImageUrl.asStringOrEmpty() ?? "",defaultImage: "subscriptionOfferImage", backgroundColor: .white) { image in
                if let image = image {
                    self.offerImageView.image = image
                }
            }
            
//            if let subscribedPlan = model.model, let isAutoRenewable = subscribedPlan.autoRenewable {
//                if !isAutoRenewable {
                    
                    
            if model.model?.isSubscription ?? false {
                self.subscribeButton.setTitle("ManageSubscriptionText".localizedString, for: .normal)
            }
            else {
                self.subscribeButton.setTitle("Subscribe now".localizedString, for: .normal)
            }
                    
//                } else {
//                    self.subscribeButton.setTitle("Subscribe now".localizedString, for: .normal)
//                }
//
//            } else {
//                self.subscribeButton.setTitle("Subscribe now".localizedString, for: .normal)
//            }
            
            
            //"\(String(describing: data.originalDirhamValue ?? "")) \(aed)".strikoutString(strikeOutColor: .appGreyColor_128)
            
//            subscriptionTitleLbl.text = model.subscriptionTitle.asStringOrEmpty()
//            self.subscriptionImg.setImageWithUrlString(model.subscriptionImg ?? "")
//
//            self.subscriptionDescLbl.text = model.subscriptionDesc ?? ""
//            autoRenewStackView.isHidden = false
//            if let freeOffer = model.freeBogoOffer, freeOffer == true {
//                if let price = model.price, price == 0 {
//                    subscriptionTypeLbl.isHidden = true
//                    monthlyPriceAttributedLabel.isHidden = true
//                }
//                else{
//                    subscriptionTypeLbl.isHidden = true
//                    monthlyPriceAttributedLabel.isHidden = false
//                    monthlyPriceAttributedLabel.attributedText = SwiftUtli.strikeOutString(string: model.monthlyPrice.asStringOrEmpty())
//                }
//            } else {
//                monthlyPriceAttributedLabel.isHidden = true
//                subscriptionTypeLbl.text = model.monthlyPrice.asStringOrEmpty()
//            }
//
            if let trialPeriod = model.trialPeriod, !trialPeriod.isEmpty {
                self.trialPeriodButton.setTitle(trialPeriod, for: .normal)
                
            } else {
               
            }
//            if let autoRenewPrice = model.autoRenewPrice, !autoRenewPrice.isEmpty {
//                autoRenewPriceLabel.isHidden = false
//                autoRenewPriceLabel.text = autoRenewPrice
//            } else {
//                autoRenewPriceLabel.isHidden = true
//            }
            self.bogoLifeStyleOfferModel = model.model
        }
        
    }
    @IBAction func subscribeBtnTapped(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.subscribeDidTapped(model: bogoLifeStyleOfferModel)
        }
    }
   
}
