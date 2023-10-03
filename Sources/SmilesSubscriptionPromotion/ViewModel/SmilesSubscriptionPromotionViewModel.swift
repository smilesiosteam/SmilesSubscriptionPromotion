//
//  File.swift
//  
//
//  Created by Ghullam  Abbas on 03/10/2023.
//

import Foundation
import NetworkingLayer
import SmilesUtilities
import SmilesLocationHandler
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
    }
    
    enum Output {
       
        case fetchSubscriptionPromotionsDidSucceed(response: SmilesSubscriptionBOGODetailsResponse)
        case fetchSubscriptionPromotionsDidFail(error: Error)
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
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
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
}
