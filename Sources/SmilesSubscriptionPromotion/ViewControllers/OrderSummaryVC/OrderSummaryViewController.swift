//
//  OrderSummaryViewController.swift
//  
//
//  Created by Shmeel Ahmed on 09/10/2023.
//

import UIKit
import SmilesUtilities
import Combine

class OrderSummaryViewController: UIViewController {

    @IBOutlet weak var infoBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var totalPriceText: UILabel!
    @IBOutlet weak var totalValueView: UIView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var continueButtonView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var orderSummaryTitle: UILabel!
    @IBOutlet var panDismissView: UIView!
    @IBOutlet weak var totalHeadingLabel: UILabel!
    @IBOutlet weak var termsCheckBoxBtn: UIButton!
    @IBOutlet weak var offerTitleLbl: UILabel!
    @IBOutlet weak var offerSubtitle: UILabel!
    @IBOutlet weak var offerInfoBtn: UIButton!
    @IBOutlet weak var renewalInfo: UILabel!
    @IBOutlet weak var monthlyPrice: UILabel!
    @IBOutlet weak var termsLbl: UILabel!
    @IBOutlet weak var vatLbl: UILabel!
    
    // MARK: Properties
    var bogoResponse: SmilesSubscriptionBOGODetailsResponse?
    var delegate: SmilesSubscriptionPromotionDelegate?
    var dismissViewTranslation = CGPoint(x: 0, y: 0)
    var offer: BOGODetailsResponseLifestyleOffer?
    var themeResource: ThemeResources?
    var promoCode: BOGOPromoCode?
    var onDismiss = {}
    var moveToTerms: ((String) -> Void)
    var isSpecialOffer = false
    
    private var input: PassthroughSubject<SmilesSubscriptionCancellViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private lazy var viewModel: SmilesSubscriptionCancellViewModel = {
        return SmilesSubscriptionCancellViewModel()
    }()
    weak var moveToHomeDelegate: SubscriptionCanceledFeedbackViewControllerDeelegate?
    // MARK: Lifecycle

    fileprivate func setupUI() {
        self.bind(to: viewModel)
        continueButton.fontTextStyle  = .smilesTitle1
        panDismissView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
        panDismissView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        if themeResource == nil {
            themeResource = bogoResponse?.themeResources
        }
        orderSummaryTitle.text = self.themeResource?.orderSummaryText ?? themeResource?.orderSummaryText
        offerTitleLbl.text = offer?.offerTitle
        offerSubtitle.text = offer?.offerDescription
        if offer?.freeDuration ?? 0 < 1 {
            infoBtnHeight.constant = 0
            offerInfoBtn.isHidden = true
        }else{
            offerInfoBtn.setTitle((offer?.freeDuration ?? 0)>0 ? "Try {number}-days free".localizedString.replacingOccurrences(of: "{number}", with: "\(offer?.freeDuration ?? -1)") : "Subscribe now".localizedString, for: .normal)
        }
        renewalInfo.isHidden = !(offer?.autoRenewable ?? false)
        renewalInfo.text = "Auto renews".localizedString + " " + (self.bogoResponse?.themeResources?.autoRenewSubscriptionSubTitle ?? "N/A")
        
        let aed = "AED".localizedString + " "
        
        let smilesAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.circularXXTTMediumFont(size: 18),
            .foregroundColor: UIColor.appRevampPurpleMainColor,
        ]
        
        let price = offer?.priceBeforeDiscount ?? 0
        let attributedString = NSMutableAttributedString(string: aed,attributes: smilesAttributes)

        if price > 0 {
            let crossedAmount = "\(String(describing: offer?.priceBeforeDiscount ?? 0))".strikoutString(strikeOutColor: .appGreyColor_128)

            attributedString.append(crossedAmount)
            attributedString.append(NSMutableAttributedString(string: isSpecialOffer && (offer?.price ?? 0 <= 0)  ?  "Free".localizedString.capitalizingFirstLetter(): " \(offer?.monthlyPriceCost ?? "")/\("Month".localizedString)",attributes: smilesAttributes))
            self.monthlyPrice.attributedText = attributedString
        } else {
            attributedString.append(NSMutableAttributedString(string: "\(Double(offer?.monthlyPriceCost ?? "0") ?? 0)/\("Month".localizedString)",attributes: smilesAttributes))
            self.monthlyPrice.attributedText = attributedString
        }
        
        
        var prefixStr = "IAgreeTitle".localizedString
        if (bogoResponse?.themeResources?.termsAndConditionTitle?.count ?? 0) > 1 {
            prefixStr = bogoResponse!.themeResources!.termsAndConditionTitle![1]
        }
        var suffixStr = "Terms & Conditions".localizedString
        if (bogoResponse?.themeResources?.termsAndConditionTitle?.count ?? 0) > 0 {
            suffixStr = bogoResponse!.themeResources!.termsAndConditionTitle![0]
        }
        suffixStr = " "+suffixStr
        
        let prefix = NSMutableAttributedString(string: prefixStr,attributes: [
            .font: UIFont.circularXXTTRegularFont(size: 16),
            .foregroundColor: UIColor.black,
        ])
        
        let suffix = NSMutableAttributedString(string: suffixStr,attributes: [
            .font: UIFont.circularXXTTMediumFont(size: 16),
            .foregroundColor: UIColor(hexString: "#424c99"),
        ])
        
        prefix.append(suffix)
        
        self.termsLbl.attributedText = prefix
        
        
        continueButton.setTitle(self.themeResource?.cancelSubscriptionButtonText ?? themeResource?.cancelSubscriptionButtonText, for: .normal)
        
        roundedView.layer.cornerRadius = 12
        roundedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        totalHeadingLabel.text = "TotalTitle".localizedString
        
        if offer?.freeDuration ?? 0 > 0 {
            totalPriceText.text = "Free".localizedString
        }else{
            totalPriceText.text = "\(offer?.price ?? 0) " + "AED".localizedString
        }
        if (isSpecialOffer && offer?.price ?? 0.0 <= 0) {
            totalPriceText.text = "Free".localizedString.capitalizingFirstLetter()
            self.vatLbl.isHidden = true
        }
        udpateContinueBtn(isEnabled: termsCheckBoxBtn.isSelected)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    public  init(bogoDetailsResponse:SmilesSubscriptionBOGODetailsResponse,offer:BOGODetailsResponseLifestyleOffer, delegate: SmilesSubscriptionPromotionDelegate?, onDismiss:@escaping ()->Void, moveToTerms:@escaping ((String) -> Void)) {
        self.moveToTerms = moveToTerms
        self.onDismiss = onDismiss
        self.delegate = delegate
        self.bogoResponse = bogoDetailsResponse
        self.offer = offer
        super.init(nibName: "OrderSummaryViewController", bundle: .module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(to viewModel: SmilesSubscriptionCancellViewModel) {
        input = PassthroughSubject<SmilesSubscriptionCancellViewModel.Input, Never>()
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case.cancelSubscriptionDidSucceed(let response):
                    debugPrint(response)
                    if (response.responseCode != "1") {
                        self?.popToSubscriptionHomeVC()
                    }
                    
                case.cancelSubscriptionDidFail(let error):
                    debugPrint(error.localizedDescription)
                }
            }.store(in: &cancellables)
    }
    func popToSubscriptionHomeVC() {
        self.dismiss() {
            self.moveToHomeDelegate?.popToSubscriptionHomeVC()
        }
        
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
                    if let _ = self.delegate {
                        
                    }
                }
            }
        default:
            break
        }
    }

    @objc func handleTap(sender: UITapGestureRecognizer) {
        dismiss(animated: true) {
            if let _ = self.delegate {
                
            }
        }
    }

    @IBAction func continueAction() {
        
        if (isSpecialOffer && offer?.price ?? 0.0 <= 0 && promoCode != nil) {
            self.input.send(.cancelSubscription(subscriptionStatus: .SUBSCRIBE, promoCodeValue:promoCode?.promoCode , packageId: self.offer?.offerId ?? "", subscriptionId: self.offer?.subscriptionId, subscriptionSegement: self.offer?.subscriptionSegment ?? "", cancelationReason: nil, duration: promoCode?.duration))
        } else {
            self.dismiss {
                self.onDismiss()
            }
        }
        
    }
    
    @IBAction func termsPressed(_ sender: Any) {
        self.dismiss {
            if let terms = self.offer?.termsAndConditions {
                self.moveToTerms(terms)
            }
        }
    }
    
    func udpateContinueBtn(isEnabled:Bool){
        continueButtonView.isUserInteractionEnabled = isEnabled
        continueButtonView.backgroundColor = isEnabled ? UIColor.appRevampPurpleMainColor : UIColor.black.withAlphaComponent(0.1)
        let textColor = isEnabled ? .white : UIColor.black.withAlphaComponent(0.5)
        continueButton.setTitleColor(textColor, for: .normal)
        vatLbl.textColor = textColor
        totalPriceText.textColor = textColor
        totalHeadingLabel.textColor = textColor
        vatLbl.text = "VatInclusiveText".localizedString
    }
    @IBAction func termsCheckBoxPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        udpateContinueBtn(isEnabled: sender.isSelected)
    }
    
    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true) {
            if let _ = self.delegate {
                
            }
        }
    }
    
}
