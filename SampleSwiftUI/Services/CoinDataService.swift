//
//  CoinDataService.swift
//  SampleSwiftUI
//
//  Created by PS on 23/03/24.
//

import Foundation
import Combine

class CoinDataService {
	
	@Published var allCoins:[CoinModel] = []
	//var cancellable: Set<AnyCancellable>
	var coinSubscription: AnyCancellable?
	
	init() {
		getCoins()
	}
	
	private func getCoins(){
		
		guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else {
			return
		}
		
		coinSubscription = URLSession.shared.dataTaskPublisher(for: url)
			.subscribe(on: DispatchQueue.global(qos: .default))
			.tryMap { (output) -> Data in
				//
				guard let response = output.response as? HTTPURLResponse , response.statusCode >= 200 && response.statusCode < 300 else {
					print("Inside response else error")
					print(URLError.errorDomain)
					throw URLError(.badServerResponse)
				}
				print(response.statusCode)
				return output.data
			}
			.receive(on: DispatchQueue.main)
			.decode(type: [CoinModel].self, decoder: JSONDecoder())
			.sink { (completion) in
				
				switch completion {
					case .finished:
						break
					case .failure(let error):
						print(error.localizedDescription)
				}
				
			} receiveValue: { [weak self] (returnedCoins ) in
					self?.allCoins = returnedCoins
					self?.coinSubscription?.cancel()
			}
			

			
			
	}
}
