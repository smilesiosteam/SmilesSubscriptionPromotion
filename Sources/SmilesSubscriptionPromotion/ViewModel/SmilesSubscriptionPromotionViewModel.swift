//
//  File.swift
//  
//
//  Created by Ghullam  Abbas on 03/10/2023.
//

import Foundation
import NetworkingLayer
import SmilesUtilities
import SmilesSharedServices
import Combine

enum Subscriptions: String {
    case onHold = "ON HOLD"
    case expired = "EXPIRED"
}

public class SmilesSubscriptionPromotionViewModel: NSObject {
    
    // MARK: - INPUT. View event methods
    public  enum Input {
        case getSubscriptionPromotions
        case getSubscriptionDetails(String)
        case getVideoTutorials
    }
    
    enum Output {
        
        case fetchSubscriptionPromotionsDidSucceed(response: SmilesSubscriptionBOGODetailsResponse)
        case fetchSubscriptionPromotionsDidFail(error: Error)
        case fetchSubscriptionDetailsDidSucceed(response: SubscriptionDetailsResponse)
        case fetchSubscriptionDetailsDidFail(error: Error)
        
        case fetchVideoTutorialsDidSucceed(response: SmilesSubsciptionVideoTutorialResponse)
        case fetchVideoTutorialsDidFail(error: Error)
    }
    
    // MARK: -- Variables
    private var output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    
}

extension SmilesSubscriptionPromotionViewModel {
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        output = PassthroughSubject<Output, Never>()
        input.sink { [weak self] event in
            switch event {
            case .getSubscriptionPromotions:
                self?.getSubscriptionPromotions()
            case .getSubscriptionDetails(let segment):
                self?.getSubscriptionDetails(subscriptionSegment: segment)
            case.getVideoTutorials:
                self?.getVideoTutorials()
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    func getVideoTutorials() {
        let exclusiveOffersRequest = SmilesSubsciptionTutorialRequestModel(operationName:"home/v1/get-video-tutorial" , sectionKey: "subscription")
        let service = SmilesSubscriptionPromotionRepository(
            networkRequest: NetworkingLayerRequestable(requestTimeOut: 60), baseUrl: AppCommonMethods.serviceBaseUrl,
            endPoint: .fetchVideoTutorials
        )
        
        service.smilesSubscriptionVideoTutorialService(request: exclusiveOffersRequest)
            .sink { [weak self] completion in
                debugPrint(completion)
                switch completion {
                case .failure(let error):
                    self?.output.send(.fetchVideoTutorialsDidFail(error: error))
                case .finished:
                    debugPrint("nothing much to do here")
                }
            } receiveValue: { [weak self] response in
                debugPrint("got my response here \(response)")
                self?.output.send(.fetchVideoTutorialsDidSucceed(response: response))
            }
            .store(in: &cancellables)
    }
    func getSubscriptionPromotions() {
        let exclusiveOffersRequest = SmilesSubscriptionPromotionRequest(isGuestUser: false)
        
        let service = SmilesSubscriptionPromotionRepository(
            networkRequest: NetworkingLayerRequestable(requestTimeOut: 60), baseUrl: AppCommonMethods.serviceBaseUrl,
            endPoint: .fetchSubscriptionPromotionList
        )
        
        service.smilesSubscriptionPromotionService(request: exclusiveOffersRequest)
            .sink { [weak self] completion in
                debugPrint(completion)
                switch completion {
                case .failure(let error):
                    self?.output.send(.fetchSubscriptionPromotionsDidFail(error: error))
                case .finished:
                    debugPrint("nothing much to do here")
                }
            } receiveValue: { [weak self] response in
                debugPrint("got my response here \(response)")
                self?.output.send(.fetchSubscriptionPromotionsDidSucceed(response: response))
            }
            .store(in: &cancellables)
    }
    
    func getSubscriptionDetails(subscriptionSegment:String) {
        let segmentBenefitsRequest = SubscriptionDetailsRequest(subscriptionSegment: subscriptionSegment)
        
        let service = SmilesSubscriptionPromotionRepository(
            networkRequest: NetworkingLayerRequestable(requestTimeOut: 60), baseUrl: AppCommonMethods.serviceBaseUrl,
            endPoint: .fetchSubscriptionDetails
        )
        
        service.smilesSubscriptionDetailsService(request: segmentBenefitsRequest)
            .sink { [weak self] completion in
                debugPrint(completion)
                switch completion {
                case .failure(let error):
                    self?.output.send(.fetchSubscriptionDetailsDidFail(error: error))
                case .finished:
                    debugPrint("nothing much to do here")
                }
            } receiveValue: { [weak self] response in
                debugPrint("got my response here \(response)")
                self?.output.send(.fetchSubscriptionDetailsDidSucceed(response: response))
            }
            .store(in: &cancellables)
    }
}
