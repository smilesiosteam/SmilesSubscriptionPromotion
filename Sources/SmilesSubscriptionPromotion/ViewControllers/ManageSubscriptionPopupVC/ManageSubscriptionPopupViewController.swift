//
//  ManageSubscriptionPopupViewController.swift
//  
//
//  Created by Shmeel Ahmed on 20/10/2023.
//

import UIKit
import SmilesUtilities
import SmilesLanguageManager
class ManageSubscriptionPopupViewController: UIViewController {

    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet var panDismissView: UIView!
    
    
    
    @IBOutlet weak var cardImgView: UIImageView!
    @IBOutlet weak var paymentMethodView: UIView!
    @IBOutlet weak var offerTitleLabel: UILabel!
    @IBOutlet weak var paymentMethodLbl: UILabel!
    @IBOutlet weak var subscriptionChannelName: UILabel!
    @IBOutlet weak var paymentMethodCard: UILabel!
    @IBOutlet weak var subscriptionChannelLbl: UILabel!
    @IBOutlet weak var autoRenewDate: UILabel!
    @IBOutlet weak var pricePerMonth: UILabel!
    @IBOutlet weak var autoRenewsLbl: UILabel!
    
    
    // MARK: Properties
    var bogoResponse: SmilesSubscriptionBOGODetailsResponse?
    var delegate: SmilesSubscriptionPromotionDelegate?
    var dismissViewTranslation = CGPoint(x: 0, y: 0)
    var offer: BOGODetailsResponseLifestyleOffer?
    // MARK: Lifecycle
    var onDismiss = {}
    override func viewDidLoad() {
        super.viewDidLoad()
        panDismissView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
        panDismissView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        continueButton.setTitle("UnSubscribeTitle".localizedString, for: .normal)
        mainTitle.text = self.bogoResponse?.themeResources?.manageSubscriptionTitle
        roundedView.layer.cornerRadius = 12
        roundedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        updateUI()
    }
    
    public  init(bogoDetailsResponse:SmilesSubscriptionBOGODetailsResponse,offer:BOGODetailsResponseLifestyleOffer, delegate: SmilesSubscriptionPromotionDelegate?, onDismiss:@escaping ()->Void) {
        self.onDismiss = onDismiss
        self.delegate = delegate
        self.bogoResponse = bogoDetailsResponse
        self.offer = offer
        super.init(nibName: "ManageSubscriptionPopupViewController", bundle: .module)
    }
    func updateUI() {
        guard let offer, let bogoResponse else {return}
        offerTitleLabel.text = offer.offerTitle
        pricePerMonth.text = offer.monthlyPrice
        subscriptionChannelLbl.text = bogoResponse.themeResources?.subscriptionChannelText
        subscriptionChannelName.text = offer.subscriptionChannel
        if offer.autoRenewable == true && offer.expiryDate != nil,let expiryDt=AppCommonMethods.returnDate(from: offer.expiryDate!, format: "dd-MM-yyyy HH:mm:ss") {
            autoRenewsLbl.text =  bogoResponse.themeResources?.subscriptionExpriyText
            autoRenewDate.text = AppCommonMethods.convert(date: expiryDt, format: "dd MMM yyyy HH:mm:ss")
        } else if offer.nextRenewalDate != nil,let reneDt=AppCommonMethods.returnDate(from: offer.nextRenewalDate!, format: "dd-MM-yyyy HH:mm:ss") {
            autoRenewsLbl.text = bogoResponse.themeResources?.subscriptionAutoRenewsText
            autoRenewDate.text = AppCommonMethods.convert(date: reneDt, format: "dd MMM yyyy HH:mm:ss")
        }
        var paymentMethodType = ""
        if let paymentId = offer.paymentDetails?.paymentMethodId, paymentId == "2" {
            if let subType = offer.paymentDetails?.subType, let num = offer.paymentDetails?.cardNumber {
                let last4Chars = num.suffix(4)
                var cardEndingText = bogoResponse.themeResources?.subscribeCardEndingText
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
        paymentMethodLbl.text = bogoResponse.themeResources?.subscriptionPaymentMethodText
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    @objc func handleDismiss(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            dismissViewTranslation = sender.translation(in: view)
            if dismissViewTranslation.y > 0 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: self.dismissViewTranslation.y)
                })
            }
        case .ended:
            if dismissViewTranslation.y < 200 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.transform = .identity
                })
            }
            else {
                dismiss(animated: true) {
                    if let delegate = self.delegate {
                        
                    }
                }
            }
        default:
            break
        }
    }

    @objc func handleTap(sender: UITapGestureRecognizer) {
        dismiss(animated: true) {
            if let delegate = self.delegate {
                
            }
        }
    }

    @IBAction func continueAction() {
        self.dismiss {
            self.onDismiss()
        }
    }
    
    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true) {
            if let delegate = self.delegate {
                
            }
        }
    }
    
}