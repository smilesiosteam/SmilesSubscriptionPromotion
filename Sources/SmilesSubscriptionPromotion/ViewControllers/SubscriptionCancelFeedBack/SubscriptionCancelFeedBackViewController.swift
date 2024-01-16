//
//  SubscriptionCancelFeedBackViewController.swift
//  
//
//  Created by Ghullam  Abbas on 19/10/2023.
//

import Foundation
import UIKit
import Lottie
import LottieAnimationManager
import SmilesUtilities
import SmilesSharedServices
import Combine

enum OrderCancelFlowType {
    case COMMON
    case SUBSCRIPTION
}

class SubscriptionCancelFeedBackViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet var animationView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reasonsCollectionView: UICollectionView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var askToSelectOptionLabel: UILabel!
   

    var rejectionReasons : [String]?
   // var presenter: OrderCancelledPresentation?
    var orderId  = ""
    var orderNumber  = ""
    var cancelOrderResponse : SubscriptionCancelResponseModel?
    var rejectionReasonSelectedIndex = -1
    
   // var actionSheet: CustomizableActionSheet?
    var orderCancelFlowType: OrderCancelFlowType? = .SUBSCRIPTION
    var askForOption: String?
    var animationName = SubscriptionAnimation.Feedback.rawValue
    var themeResources: ThemeResources?
    
    var promoVal: String?
    var promoDur: String?
    var packageId: String?
    var subscriptionId: String?
    var subscriptionSegement: String?
    
    var offer: BOGODetailsResponseLifestyleOffer?
    var response:SmilesSubscriptionBOGODetailsResponse?
    
    private var input: PassthroughSubject<SmilesSubscriptionCancellViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private lazy var viewModel: SmilesSubscriptionCancellViewModel = {
        return SmilesSubscriptionCancellViewModel()
    }()
     
    
    // MARK: Lifecycle
    
    public  init() {
        super.init(nibName: "SubscriptionCancelFeedBackViewController", bundle: .module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        
        
        self.bind(to: viewModel)
        setupCollectionView()
        animateViewWithAnimation()
        styleViewUI()
        setDataForView()
       // self.presenter?.viewDidLoad(themeResources: self.themeResources)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    func bind(to viewModel: SmilesSubscriptionCancellViewModel) {
        input = PassthroughSubject<SmilesSubscriptionCancellViewModel.Input, Never>()
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case.cancelSubscriptionDidSucceed(let response):
                    self?.showCancelledPopup(model: response)
                case.cancelSubscriptionDidFail(let error):
                    debugPrint(error.localizedDescription)
                }
            }.store(in: &cancellables)
    }
    
     func styleViewUI() {

         doneButton.setTitle("DoneTitle".localizedString, for: .normal)
         self.doneButton.titleLabel?.fontTextStyle = .smilesHeadline4
         
         
         self.titleLabel.fontTextStyle = .smilesHeadline2
         self.titleLabel.textColor = .black
         
         self.descriptionLabel.fontTextStyle = .smilesBody2
         self.descriptionLabel.textColor = .black.withAlphaComponent(0.8)
         
         self.askToSelectOptionLabel.fontTextStyle = .smilesTitle2
         self.askToSelectOptionLabel.textColor = .black.withAlphaComponent(0.8)
         
         //getSupportTitleLabel.text = "GetSupport".localizedString
        // haveQuestionTitleLabel.text = "HaveQuestion".localizedString
        
    }
    
    func setDataForView() {
            
        self.titleLabel.isHidden = false
        self.descriptionLabel.isHidden = false
        self.reasonsCollectionView.isHidden = false
        self.titleLabel.text = self.response?.themeResources?.cancellationLandingTitle
        self.descriptionLabel.text = self.response?.themeResources?.cancellationPopupDesc
        self.rejectionReasons = self.response?.themeResources?.cancellationLandingReason
        self.askToSelectOptionLabel.text = self.response?.themeResources?.cancellationLandingDesc
        self.separatorView.isHidden = false
        self.askToSelectOptionLabel.isHidden = false
        self.reasonsCollectionView.reloadData()
           
        
    }
    
    func setupCollectionView() {
        
        if self.orderCancelFlowType != .SUBSCRIPTION {
            if #available(iOS 10.0, *) {
                setupCustomFlowLayout()
            } else {
                let flowLayout = UICollectionViewFlowLayout()
                flowLayout.scrollDirection = .vertical
                flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                self.reasonsCollectionView.collectionViewLayout = flowLayout
            }
        }
        
       
        reasonsCollectionView.register(UINib(nibName: "SubscriptionCancelCollectionViewCell", bundle: .module), forCellWithReuseIdentifier: "SubscriptionCancelCollectionViewCell")
        self.reasonsCollectionView.dataSource = self
        self.reasonsCollectionView.delegate = self
    }
    
    func setupCustomFlowLayout() {
        let columnLayout = CustomViewFlowLayout()
        columnLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        self.reasonsCollectionView.collectionViewLayout = columnLayout
    }
    
    
    @IBAction func getSupportButtonClicked(_ sender: Any) {
       // presenter?.openLiveChatUrl(with: orderId, orderNumber: orderNumber)
    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        if rejectionReasonSelectedIndex != -1 {
            if let reasons = rejectionReasons?[rejectionReasonSelectedIndex] {
               
                self.input.send(.cancelSubscription(subscriptionStatus: .UNSUBSCRIBE, promoCodeValue: promoVal, packageId: self.offer?.offerId ?? "", subscriptionId: self.offer?.subscriptionId, subscriptionSegement: self.offer?.subscriptionSegment ?? "", cancelationReason: reasons,duration:nil))
            }
        }
    }
    
    func animateViewWithAnimation() {
        LottieAnimationManager.showAnimationForOrders(onView: animationView, withJsonFileName: animationName, removeFromSuper: false, loopMode: .loop) { _ in
            
        }
        
    }
    
}

//extension OrderCancelledViewController: OrderCancelledView {
//    // TODO: implement view output methods
//}


extension SubscriptionCancelFeedBackViewController : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rejectionReasons?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubscriptionCancelCollectionViewCell", for: indexPath) as! SubscriptionCancelCollectionViewCell
        cell.titleLabe.fontTextStyle = .smilesTitle2
        cell.titleLabe.text = rejectionReasons?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let label = UILabel(frame: CGRect.zero)
        label.text = rejectionReasons?[indexPath.row] ?? ""
        label.sizeToFit()
        
        return CGSize(width: label.frame.width + 24, height: 36)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        rejectionReasonSelectedIndex = indexPath.row
        
        doneButton.isHidden = false
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        rejectionReasonSelectedIndex = -1
        doneButton.isHidden = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {}

}

extension SubscriptionCancelFeedBackViewController: SubscriptionCanceledFeedbackViewControllerDeelegate {
    func popToSubscriptionHomeVC() {
        guard let navigationController = self.navigationController else {
            // Handle the case where self.navigationController is nil
            return
        }

        for controller in navigationController.viewControllers {
            // Check if the controller is of type SmilesSubscriptionPromotionVC
            if let subscriptionVC = controller as? SmilesSubscriptionPromotionVC {
                navigationController.popToViewController(subscriptionVC, animated: false)
                return
            }
        }

        // Handle the case where SmilesSubscriptionPromotionVC is not found
        print("SmilesSubscriptionPromotionVC not found in navigation stack")
    }


    
    
    func showCancelledPopup(model: CancelSubscriptionResponseModel) {
        let vc = CancelSubscriptionFeedBackPopUpVC(canceResponse: model)
        vc.delegate = self
        self.present(vc, animated: false)
    }
    
}
