//
//  HomeViewModel.swift
//  SampleSwiftUI
//
//  Created by PS on 23/03/24.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
	
	private let coinDataService = CoinDataService()
	private let marketDataService = MarketDataService()
	private let portfolioDataService = PortfolioDataService()
	
	
	@Published var  statistics: [StatisticModel] = []
	@Published var allCoins: [CoinModel] = []
	@Published var portfolioCoins: [CoinModel] = []
	
	
	private var cancellables = Set<AnyCancellable>()
	@Published var searchText = ""
	init() {
		addSubscribers()
//		DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
//			self.allCoins.append(DeveloperPreview.instance.coin)
//			self.portfolioCoins.append(DeveloperPreview.instance.coin)
//		}
	}
	
	func addSubscribers(){
		
//		dataService.$allCoins
//			.sink { [weak self] (returnedCoins) in
//				self?.allCoins = returnedCoins
//			}
//			.store(in: &cancellables)
		
		marketDataService.$marketData
			.map(mapGlobalMarketData)
			.sink { [weak self] (returnedStats) in
			self?.statistics = returnedStats
		}.store(in: &cancellables)
		
		// updates portfolioCoins
		$allCoins.combineLatest(portfolioDataService.$savedEntities)
			.map{ (coinModels, portfolioEnities) -> [CoinModel] in
				coinModels.compactMap{ (coin) -> CoinModel? in
					guard let entity = portfolioEnities.first(where: {$0.coinID == coin.id}) else {
						return nil
					}
					return coin.updateHoldings(amount: entity.amount)
				}
			}.sink{ [weak self] (returnedCoins) in
				self?.portfolioCoins = returnedCoins
			}.store(in: &cancellables)
		
		$searchText.combineLatest(coinDataService.$allCoins)
			.debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
			.map(filterCoins)
			.sink { [weak self] (returnedCoins) in
				self?.allCoins = returnedCoins
			}
			.store(in: &cancellables)
			
	}
	
	func updatePortfolio(coin:CoinModel, amount: Double) {
		portfolioDataService.updatePortfolio(coin: coin, amount: amount)
	}
	
	private func mapGlobalMarketData(marketDataModel: MarketDataModel?) -> [StatisticModel] {
		var stats : [StatisticModel] = []
		guard let data = marketDataModel else {
			return stats
		}
		let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
		let volume = StatisticModel(title: "Volume", value: data.volume)
		let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
		let portfolio = StatisticModel(title: "Portfolio Value", value: "$0.00", percentageChange: 0)
		stats.append(contentsOf: [
			marketCap, volume, btcDominance, portfolio
		])
		return stats
	}
	
	private func filterCoins(text: String, coins: [CoinModel]) ->  [CoinModel] {
		
		guard !text.isEmpty else {
			return coins
		}
		let lowerCaseText = text.lowercased()
		
		let filteredCoins = coins.filter { (coin) in
			return coin.name.lowercased().contains(lowerCaseText) ||
			coin.symbol.lowercased().contains(lowerCaseText) ||
			coin.id.lowercased().contains(lowerCaseText)
		}
		
		return filteredCoins
		
	}
	
}
