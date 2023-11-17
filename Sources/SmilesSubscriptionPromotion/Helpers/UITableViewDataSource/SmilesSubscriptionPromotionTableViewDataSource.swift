//
//  File.swift
//  
//
//  Created by Ghullam  Abbas on 03/10/2023.
//

import Foundation
import UIKit
import SmilesUtilities
import SmilesSharedServices


extension SmilesSubscriptionPromotionVC: UITableViewDataSource, UITableViewDelegate {
    

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isDummy ? 8 : self.response?.lifestyleOffers?.count ?? 0
    }

    public  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SmilesSubscriptionPromotionCell", for: indexPath) as! SmilesSubscriptionPromotionCell
        
        if self.isDummy {
            cell.enableSkeleton()
            cell.showAnimatedSkeleton()
        } else {
            cell.hideSkeleton()
            if let offer = self.response?.lifestyleOffers?[indexPath.row] {
                cell.delegate = self
                let subModel = SmilesSubscriptionTableCellModel()
                subModel.subscriptionTitle = (offer.isSubscription ?? false) ? offer.subscribedOfferTitle : offer.offerTitle
                subModel.subscriptionImg = offer.subscribeImage
                subModel.price = offer.price
                subModel.beforeDiscountedPrice = Double(offer.priceBeforeDiscount ?? 0)
                subModel.freeBogoOffer = offer.freeBogoOffer
                subModel.monthlyPrice = offer.monthlyPrice
                subModel.subscriptionDesc = offer.offerDescription
                subModel.model = offer
                if let freeDuration = offer.freeDuration, freeDuration > 0 {
                    subModel.trialPeriod = self.response?.themeResources?.subscriptionExpandDescText?[safe: 0]?.replacingOccurrences(of: "%s", with: "\(freeDuration)") ?? ""
                }
                
                if let duration = offer.monthlyPriceCost, !duration.isEmpty {
                    subModel.autoRenewPrice = self.response?.themeResources?.subscriptionExpandDescText?[safe: 1]?.replacingOccurrences(of: "%s", with: "\(duration)") ?? ""
                }
                if let subscriptionStatus = offer.subscriptionStatus, !subscriptionStatus.isEmpty, subscriptionStatus.lowercased() ==  "parked" {
                    if let expireyText = offer.subscriptionStatusText, !expireyText.isEmpty {
                        subModel.isSubscriptionOnHold = true
                        subModel.subscriptionOnHoldDesc = expireyText
                        subModel.subscriptionAccountNumber = offer.subscriptionAccountNumber
                        subModel.subscriptionStateColor = .subscriptionOnHoldColor
                        subModel.subscribedSegment = self.response?.themeResources?.subscriptionOnHoldText
                        subModel.subscribedStatus = self.response?.themeResources?.subscriptionOnHoldText
                    }
                } else {
                    subModel.isSubscriptionOnHold = false
                    subModel.subscriptionStateColor = .appGreenSecondaryColor
                    subModel.subscribedStatus = self.response?.themeResources?.subscriptionActiveText
                }

                cell.updateCell(rowModel: subModel)
            }
        }
        return cell
    }


    public  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    public  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}

    public  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {}
   
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.didScrollTableView(scrollView:scrollView)
    }
}

extension TableViewDataSource where Model == SmilesSubscriptionBOGODetailsResponse {
    static func make(forSubscriptions subscriptions: [SmilesSubscriptionBOGODetailsResponse],
                     reuseIdentifier: String = String(describing: SmilesSubscriptionPromotionCell.self), data: String, isDummy: Bool = false) -> TableViewDataSource {
        return TableViewDataSource(
            models: subscriptions,
            reuseIdentifier: reuseIdentifier,
            data: data,
            isDummy: isDummy
        ) { (subscription, cell, data, indexPath) in
            guard let cell = cell as? SmilesSubscriptionPromotionCell else { return }
            guard let offer =  subscription.lifestyleOffers?.first else { return }
            let subModel = SmilesSubscriptionTableCellModel()
            subModel.subscriptionTitle = offer.offerTitle
            subModel.subscriptionImg = offer.subscribeImage
            subModel.price = offer.price
            subModel.freeBogoOffer = offer.freeBogoOffer
            subModel.monthlyPrice = offer.monthlyPrice
            subModel.subscriptionDesc = offer.offerDescription
            subModel.model = offer
            if let freeDuration = offer.freeDuration, freeDuration > 0 {
                subModel.trialPeriod = subscription.themeResources?.subscriptionExpandDescText?[safe: 0]?.replacingOccurrences(of: "%s", with: "\(freeDuration)") ?? ""
            }
            
            if let duration = offer.monthlyPriceCost, !duration.isEmpty {
                subModel.autoRenewPrice = subscription.themeResources?.subscriptionExpandDescText?[safe: 1]?.replacingOccurrences(of: "%s", with: "\(duration)") ?? ""
            }
            cell.updateCell(rowModel: subModel)
            cell.selectionStyle = .none
//            cell.callBack = { () in
//                //                cell.toggleButton.isSelected = !cell.toggleButton.isSelected
//            }
            
            
            
        }
    }
//    fileprivate func configureHideSection<T>(for section: SmilesExplorerSectionIdentifier, dataSource: T.Type) {
//        if let index = getSectionIndex(for: section) {
//            (self.dataSource?.dataSources?[index] as? TableViewDataSource<T>)?.models = []
//            (self.dataSource?.dataSources?[index] as? TableViewDataSource<T>)?.isDummy = false
//            self.mutatingSectionDetails.removeAll(where: { $0.sectionIdentifier == section.rawValue })
//            
//            self.configureDataSource()
//        }
//    }
}

