//
//  SmilesSubscriptionDetailsVC.swift
//  
//
//  Created by Shmeel Ahmad on 04/10/2023.
//


import Foundation
import UIKit
import LottieAnimationManager
import SmilesUtilities
import SmilesSharedServices
import NetworkingLayer
import Combine

public class SmilesSubscriptionDetailsVC: UIViewController {
   public var offer: BOGODetailsResponseLifestyleOffer?
    
    @IBOutlet weak var unsubInfoLbl: UILabel!
    
    var bogoDetailsResponse:SmilesSubscriptionBOGODetailsResponse?
    @IBOutlet weak var cancelInfoLbl: UILabel!
    @IBOutlet weak var tableHeader: UIView!
    
    @IBOutlet weak var unsubInfoView: UIView!
    
    
    @IBOutlet weak var tableHeaderIcon: UIView!
    @IBOutlet weak var headerViewBottom: UIView! {
        didSet {
            headerViewBottom.layer.cornerRadius = 12
            if #available(iOS 11.0, *) {
                headerViewBottom.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            } else {
                // Fallback on earlier versions
                headerViewBottom.isHidden = true
            }
        }
    }
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: HeaderGradientView!
    @IBOutlet weak var subscriptionTitleLbl: UILabel!
    @IBOutlet weak var subscriptionSubTitleLbl: UILabel!
    @IBOutlet weak var subscriptionDescLbl: UILabel!
    @IBOutlet weak var monthlyPrice: UILabel!
    @IBOutlet weak var subscriptionLogo: UIImageView!
    @IBOutlet weak var tryNowBtn: UIButton!
    @IBOutlet weak var tryNowView: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewHeaderTitle: UILabel!
    
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    // MARK: Properties
    @objc var bogoEventName: String = ""
    @objc var shouldShowLeftButtons = false
    public var isGuestUser: Bool = false
    public var showBackButton: Bool = true
    
    private var delegate: SmilesSubscriptionPromotionDelegate?
   
    // MARK: - PROPERTIES -
    private var input: PassthroughSubject<SmilesSubscriptionPromotionViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private lazy var viewModel: SmilesSubscriptionPromotionViewModel = {
        return SmilesSubscriptionPromotionViewModel()
    }()
    
    var benefitsResponse:SubscriptionDetailsResponse?{
        didSet{
            self.reloadData()
        }
    }
  public  var promoCode: BOGOPromoCode?
    
    // MARK: Lifecycle
    public  init(bogoDetailsResponse:SmilesSubscriptionBOGODetailsResponse,offer:BOGODetailsResponseLifestyleOffer, isGuestUser: Bool,delegate: SmilesSubscriptionPromotionDelegate?) {
        self.delegate = delegate
        self.isGuestUser = isGuestUser
        self.bogoDetailsResponse = bogoDetailsResponse
        self.offer = offer
        super.init(nibName: "SmilesSubscriptionDetailsVC", bundle: .module)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction  func onClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        setupUI()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.changeNavigationBarStyleWhileScrolling(intialState: true, withTitle: offer?.offerTitle ?? "")
        self.view.layoutIfNeeded()
    }
    override public func viewDidDisappear(_ animated: Bool) {
       
        let cells = self.tableView.visibleCells
        for cell in cells {
            if let cell = cell as? SubscriptionDetailsCell {
                cell.stopTimer()
            }
            // call invalidate
        }
    }

    func bind(to viewModel: SmilesSubscriptionPromotionViewModel) {
        input = PassthroughSubject<SmilesSubscriptionPromotionViewModel.Input, Never>()
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case.fetchVideoTutorialsDidSucceed(_):
                    break
                case.fetchVideoTutorialsDidFail(_):
                    break
                case .fetchSubscriptionPromotionsDidSucceed(_):
                    break
                case .fetchSubscriptionPromotionsDidFail(_):
                    break
                case .fetchSubscriptionDetailsDidSucceed(let response):
                    self?.benefitsResponse = response
                    
                case .fetchSubscriptionDetailsDidFail(error: let error):
                    debugPrint(error.localizedDescription)
                }
            }.store(in: &cancellables)
    }
    var isSubscribed:Bool{offer?.isSubscription ?? false}
    func setupUI() {
        tableHeader.removeFromSuperview()
        headerView.isHidden = isSubscribed
        cancelInfoLbl.text = "Cancel anytime without commitment".localizedString
        backBtn.isSelected = isSubscribed
        unsubInfoLbl.text = self.bogoDetailsResponse?.themeResources?.manageSubscriptionDescText ?? ""
        self.headerViewHeight.constant = headerView.isHidden ? 88 : 310
        self.changeNavigationBarStyleWhileScrolling(intialState: false, withTitle: self.offer?.offerTitle ?? "")
        viewHeaderTitle.textColor = isSubscribed ? .black : .white

        self.setupTableViewCells()
        subscriptionSubTitleLbl.fontTextStyle = .smilesBody3
        subscriptionTitleLbl.fontTextStyle = .smilesHeadline1
        subscriptionDescLbl.fontTextStyle = .smilesHeadline4
        self.tryNowView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        viewHeaderTitle.fontTextStyle = .smilesHeadline4
        self.bind(to: viewModel)
        
        self.subscriptionLogo.setImageWithUrlString(offer?.subscriptionIcon ?? "")
        self.viewHeaderTitle.text = offer?.isSubscription ?? false ?  self.bogoDetailsResponse?.themeResources?.cancelSubscriptionTitle: self.offer?.offerTitle
        
        subscriptionTitleLbl.text = offer?.offerTitle
        subscriptionSubTitleLbl.text = "subscription".localizedString.capitalizingFirstLetter()
        monthlyPrice.text = "AED".localizedString + " " + "\(offer?.price ?? 0)" + " per month"
        if promoCode != nil {
            if (offer?.price ?? 0.0 <= 0) {
                monthlyPrice.text = "Free".localizedString
            }
        }
        
        
        if !isSubscribed {
            tableView.tableHeaderView = tableHeader
            NSLayoutConstraint.activate([
                tableHeader.widthAnchor.constraint(equalTo: tableView.widthAnchor)
            ])
        }
        unsubInfoView.isHidden = !isSubscribed
        cancelInfoLbl.isHidden = isSubscribed
        tableHeaderIcon.isHidden = !isSubscribed
        tryNowBtn.titleLabel?.fontTextStyle = .smilesHeadline4
        let titleTxt = (offer?.isSubscription ?? false) ? "UnSubscribeTitle".localizedString.lowercased().capitalizingFirstLetter() : ((offer?.freeDuration ?? 0)>0 ? "Try {number}-days free".localizedString.replacingOccurrences(of: "{number}", with: "\(offer?.freeDuration ?? -1)") : "Subscribe now".localizedString)
        tryNowBtn.setTitle(titleTxt, for: .normal)
        if !(offer?.isSubscription ?? false) {
            self.input.send(.getSubscriptionDetails(offer?.subscriptionSegment ?? ""))
        }
    }
    
    func reloadData(){
        self.tableView.reloadData()
        self.subscriptionDescLbl.text = benefitsResponse?.benefitsTitle
//        self.subscriptionDescLbl.attributedText = benefitsResponse?.benefitsTitle?.htmlToAttributedString
    }
    func setupTableViewCells() {
        tableView.registerCellFromNib(SubscriptionDetailsCell.self, withIdentifier: String(describing: SubscriptionDetailsCell.self), bundle: .module)
        tableView.registerCellFromNib(SubscriptionMoreBenefitsCell.self, withIdentifier: String(describing: SubscriptionMoreBenefitsCell.self), bundle: .module)
        tableView.registerCellFromNib(SubscribedInfoCell.self, withIdentifier: String(describing: SubscribedInfoCell.self), bundle: .module)
    }
    
    @IBAction func tryNowButtonTapped(_ sender: Any) {

        if (offer?.isSubscription ?? false){
            //move to cancel
            let vc = SmilesSubscriptionPromotionConfigurator.create(type: .CancelSubscriptionFeedBack) as! SubscriptionCancelFeedBackViewController
            vc.response = bogoDetailsResponse
            vc.offer = offer

            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = SmilesSubscriptionPromotionConfigurator.create(type: .SmilesSubscriptionOrderSummary(bogoResponse: self.bogoDetailsResponse!, offer: self.offer!, delegate: self.delegate, onDismiss: {
                let param = SmilesSubscriptionPromotionPaymentParams()
                param.lifeStyleOffer = self.offer
                if (self.promoCode != nil) {
                    self.delegate?.proceedToPayment(params: param, navigationType: .withTextPromo)
                } else {
                    self.delegate?.proceedToPayment(params: param, navigationType: .payment)
                }
                
            }, moveToTerms: { terms in
                self.delegate?.navigateToTermsAndConditions(terms: terms)
            })) as! OrderSummaryViewController
            vc.modalPresentationStyle = .overFullScreen
            if (promoCode != nil) {
                vc.moveToHomeDelegate = self
                vc.isSpecialOffer = true
                
            }
            self.present(vc, animated: true)
        }
    }
    
    private func changeNavigationBarStyleWhileScrolling(intialState: Bool, withTitle title: String) {
        DispatchQueue.main.async {
           // self.setHeaderWithWhiteTitle(title)
        }
        
        //backButton.RoundedViewConrner(cornerRadius: 12.0)
        if !intialState && !isSubscribed {
            viewHeader.addGradientColors(UIColor.navigationGradientColorArray(), opacity: 1.0, direction: .diagnolLeftToRight)
        }else{
            viewHeader.backgroundColor = .white
        }
        
    }
    
    func didScrollTableView(scrollView: UIScrollView) {
        if isSubscribed{return}
        if scrollView == tableView {
            var tableViewHeight = tableView.frame.height
            if headerView.isHidden {
                tableViewHeight -= 182
            }
            guard scrollView.contentSize.height > tableViewHeight else { return }
            var compact: Bool?
            if scrollView.contentOffset.y > 90 {
               compact = true
            } else if scrollView.contentOffset.y < 0 {
                compact = false
            }
            guard let compact, compact != headerView.isHidden else { return }
            if compact {
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .transitionCrossDissolve, animations: {
                    self.headerView.isHidden = true
                    self.headerViewHeight.constant = 88
                    self.changeNavigationBarStyleWhileScrolling(intialState: false, withTitle: self.offer?.offerTitle ?? "")
                    self.view.layoutIfNeeded()
                })
            } else {
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .transitionCrossDissolve, animations: {
                    self.headerView.isHidden = false
                    self.headerViewHeight.constant = 310
                    self.changeNavigationBarStyleWhileScrolling(intialState: true, withTitle: "")
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    func stopAutoScrollTimer() {
        
    }
}

extension SmilesSubscriptionDetailsVC: SubscriptionMoreBenefitsCellProtocol,SubscriptionCanceledFeedbackViewControllerDeelegate {
    func didTapOnTermsAndConditions(termsAndConditions: String) {
        self.delegate?.navigateToTermsAndConditions(terms: termsAndConditions)
    }
    func popToSubscriptionHomeVC() {
        for controller in (self.navigationController!.viewControllers) as Array<Any> {
            if (controller as AnyObject).isKind(of: SmilesSubscriptionPromotionVC.self) {
                self.navigationController?.popToViewController(controller as! UIViewController, animated: false)
                break
            }
        }
    }
}
