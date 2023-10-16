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
    var offer: BOGODetailsResponseLifestyleOffer?
    
    @IBOutlet weak var tableHeader: UIView!
    
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

    var shortTitle : String?
    @objc var bogoEventName: String = ""
    @objc var shouldShowLeftButtons = false
    public var isGuestUser: Bool = false
    public var showBackButton: Bool = false
    lazy var backButton: UIButton? = UIButton(type: .custom)
    
    var isDummy: Bool = true
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
    
    // MARK: Lifecycle
    public  init(showBackButton: Bool = false,isGuestUser: Bool,delegate: SmilesSubscriptionPromotionDelegate?) {
        self.delegate = delegate
        self.isGuestUser = isGuestUser
        self.showBackButton = showBackButton
        super.init(nibName: "SmilesSubscriptionDetailsVC", bundle: .module)
    }
    public override func viewDidLayoutSubviews() {
        tableHeader.frame = CGRect(origin: tableHeader.frame.origin, size: CGSize(width: tableView.bounds.size.width, height: tableHeader.bounds.size.height))
        
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
        super.viewDidLayoutSubviews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func viewDidLoad() {
        tableHeader.removeFromSuperview()
        tableView.tableHeaderView = tableHeader
        self.setupTableViewCells()
        subscriptionSubTitleLbl.fontTextStyle = .smilesBody3
        subscriptionTitleLbl.fontTextStyle = .smilesHeadline1
        subscriptionDescLbl.fontTextStyle = .smilesHeadline4
        self.tryNowView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true // change me!!!
        viewHeaderTitle.fontTextStyle = .smilesHeadline4
        self.shortTitle = offer?.offerTitle
        self.bind(to: viewModel)
//        subscriptionLogo.setImageWithUrlString(offer?.subscriptionIcon ?? "")
        subscriptionTitleLbl.text = offer?.offerTitle
        subscriptionSubTitleLbl.text = "subscription".localizedString.capitalizingFirstLetter()
        monthlyPrice.text = offer?.monthlyPrice
//        subscriptionDescLbl.text = offer.benefitsTitle
        if !self.showBackButton {
            backButton = nil
        }
        
        
        super.viewDidLoad()
//        if Constants.DeviceType.hasNotch {
//            emptyContainerTopConstraint.constant = 74
//        } else {
//            emptyContainerTopConstraint.constant = 44
//        }
        NSLayoutConstraint.activate([
            tableHeader.widthAnchor.constraint(equalTo: tableView.widthAnchor)
        ])
        if let navigationController = self.navigationController {
            if let previousViewController = navigationController.viewControllers[safe: navigationController.viewControllers.count - 2] {
                // Use the previousViewController
                print("Previous View Controller: \(previousViewController)")
              //  Constants.previousController = previousViewController
            }
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        setupUI()
        self.input.send(.getSubscriptionDetails(offer?.subscriptionSegment ?? ""))
        
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
    @objc func onClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    func setupUI() {
       
       //  viewHeader.frame = CGRect.init(x: viewHeader.frame.origin.x, y: viewHeader.frame.origin.y, width: viewHeader.frame.size.width, height: 88)
        self.headerView.isHidden = false
        self.headerViewHeight.constant = 270
        self.changeNavigationBarStyleWhileScrolling(intialState: true, withTitle: offer?.offerTitle ?? "")
        self.view.layoutIfNeeded()
        viewHeader.addGradientColors(UIColor.navigationGradientColorArray(), opacity: 1.0, direction: .diagnolLeftToRight)
        
        tryNowBtn.titleLabel?.fontTextStyle = .smilesHeadline4
        tryNowBtn.setTitle("Try 14-days free".localizedString, for: .normal)
        
    }
    
    func reloadData(){
        self.tableView.reloadData()
        self.subscriptionDescLbl.text = benefitsResponse?.benefitsTitle
    }
    func setupTableViewCells() {
        tableView.registerCellFromNib(SubscriptionDetailsCell.self, withIdentifier: String(describing: SubscriptionDetailsCell.self), bundle: .module)
        tableView.registerCellFromNib(SubscriptionMoreBenefitsCell.self, withIdentifier: String(describing: SubscriptionMoreBenefitsCell.self), bundle: .module)
    }
    
    @IBAction func tryNowButtonTapped(_ sender: Any) {
        let param = SmilesSubscriptionPromotionPaymentParams()
        param.lifeStyleOffer = offer
        self.delegate?.proceedToPayment(params: param, navigationType: .payment)
    }
    
    private func changeNavigationBarStyleWhileScrolling(intialState: Bool, withTitle title: String) {
        DispatchQueue.main.async {
           // self.setHeaderWithWhiteTitle(title)
        }
        
        //backButton.RoundedViewConrner(cornerRadius: 12.0)
        if intialState {
            //headerView.backgroundColor = .clear
           // backButton.backgroundColor = .white
           // removeHeaderGardientColor()
           // backButton.setImage(UIImage(assetIdentifier: .BackArrow_black), for: .normal)
        }
        else {
            viewHeader.addGradientColors(UIColor.navigationGradientColorArray(), opacity: 1.0, direction: .diagnolLeftToRight)

            //setHeaderGardientColor()
           // backButton.setImage(UIImage(assetIdentifier: .BackArrow_black), for: .normal)
        }
    }
    
    func didScrollTableView(scrollView: UIScrollView) {
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
                    self.changeNavigationBarStyleWhileScrolling(intialState: false, withTitle: self.shortTitle ?? "")
                    self.view.layoutIfNeeded()
                })
            } else {
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .transitionCrossDissolve, animations: {
                    self.headerView.isHidden = false
                    self.headerViewHeight.constant = 270
                    self.changeNavigationBarStyleWhileScrolling(intialState: true, withTitle: "")
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    func updateViewWith(response: SmilesSubscriptionBOGODetailsResponse?) {
        if let response = response {
            self.isDummy = false
            self.shortTitle = response.themeResources?.lifestyleShortTitle.asStringOrEmpty()
            self.subscriptionLogo.setImageWithUrlString(response.themeResources?.lifestyleLogoUrl ?? "")
            self.subscriptionSubTitleLbl.text = response.themeResources?.lifestyleTitle.asStringOrEmpty()
            self.subscriptionTitleLbl.text = shortTitle
            self.subscriptionDescLbl.text = response.themeResources?.lifestyleSubTitle.asStringOrEmpty()
            self.viewHeaderTitle.text = self.shortTitle
            self.tableView.reloadData()
            
        }
    }
}

