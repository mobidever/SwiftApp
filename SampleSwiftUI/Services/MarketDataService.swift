//
//  MarketDataService.swift
//  SampleSwiftUI
//
//  Created by PS on 30/03/24.
//

import Foundation
import Combine

class MarketDataService {
	
	@Published var marketData: MarketDataModel? = nil
		
	var marketDataSubscription: AnyCancellable?
	
	init() {
		getCoins()
	}
	
	func getCoins(){
		
		guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else {
			return
		}
		
		marketDataSubscription = NetworkingManager.download(url: url)
			.decode(type: GlobalData.self, decoder: JSONDecoder())
			.sink { (completion) in
				print("Inside Sink")
				NetworkingManager.handleCompletion(completion: completion)
				
			} receiveValue: { [weak self] (returnedGlobalData ) in
				print("Inside receivedValue")
				self?.marketData = returnedGlobalData.data
				self?.marketDataSubscription?.cancel()
			}
		
		
		
		
	}
}
