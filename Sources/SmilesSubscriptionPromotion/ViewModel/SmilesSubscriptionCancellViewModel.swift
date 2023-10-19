//
//  File.swift
//  
//
//  Created by Ghullam  Abbas on 19/10/2023.
//

import Foundation
import NetworkingLayer
import SmilesUtilities
import SmilesLocationHandler
import SmilesSharedServices
import Combine

public enum SmilesSubscribtionStatus: Int {

    case SUBSCRIBE = 1, UNSUBSCRIBE = 2, PARKED = 3
}

public class SmilesSubscriptionCancellViewModel: NSObject {
    
    // MARK: - INPUT. View event methods
    public  enum Input {
        case cancelSubscription(subscriptionStatus: SmilesSubscribtionStatus, promoCodeValue: String?, duration: String?, packageId: String, subscriptionId: String?, subscriptionSegement: String, cancelationReason: String)
    }
    
    enum Output {
        
        case cancelSubscriptionDidSucceed(response: CancelSubscriptionResponseModel)
        case cancelSubscriptionDidFail(error: Error)
    }
    
    // MARK: -- Variables
    private var output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    
}

extension SmilesSubscriptionCancellViewModel {
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        output = PassthroughSubject<Output, Never>()
        input.sink { [weak self] event in
            switch event {
            case .cancelSubscription(let status,let promoValue,let duration,let packageId,let subscriptionId,let subscriptionSegment,let cancelReason):
                self?.cancelSubscription(subscriptionStatus: status, promoCodeValue: promoValue, duration: duration, packageId: packageId, subscriptionId: subscriptionId, subscriptionSegement: subscriptionSegment, cancelationReason: cancelReason)
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    func cancelSubscription(subscriptionStatus: SmilesSubscribtionStatus, promoCodeValue: String?, duration: String?, packageId: String, subscriptionId: String?, subscriptionSegement: String, cancelationReason: String) {
        
        let cancelRequest = CancelSubscriptionRequestModel()
        cancelRequest.promoCode = promoCodeValue
        cancelRequest.duration = duration
        cancelRequest.subscriptionId = subscriptionId
        cancelRequest.packageId = packageId
        cancelRequest.subscriptionSegment = subscriptionSegement
        cancelRequest.rejectionReason = cancelationReason
        cancelRequest.action = subscriptionStatus.rawValue
        
        let service = SmilesSubscriptionPromotionRepository(
            networkRequest: NetworkingLayerRequestable(requestTimeOut: 60), baseUrl: AppCommonMethods.serviceBaseUrl,
            endPoint: .cancelSubscription
        )
        
        service.cancelSubscriptionService(request: cancelRequest)
            .sink { [weak self] completion in
                debugPrint(completion)
                switch completion {
                case .failure(let error):
                    self?.output.send(.cancelSubscriptionDidFail(error: error))
                case .finished:
                    debugPrint("nothing much to do here")
                }
            } receiveValue: { [weak self] response in
                debugPrint("got my response here \(response)")
                self?.output.send(.cancelSubscriptionDidSucceed(response: response))
            }
            .store(in: &cancellables)
    }
    

}
