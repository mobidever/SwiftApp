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
	
	@Published var isLoading = false
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
		
		
		$searchText.combineLatest(coinDataService.$allCoins)
			.debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
			.map(filterCoins)
			.sink { [weak self] (returnedCoins) in
				self?.allCoins = returnedCoins
			}
			.store(in: &cancellables)
		
		// updates portfolioCoins
		$allCoins.combineLatest(portfolioDataService.$savedEntities)
			.map(mapAllCoinsToPortfolioCoins)
			.sink{ [weak self] (returnedCoins) in
				self?.portfolioCoins = returnedCoins
			}.store(in: &cancellables)
		
		// updates marketData
		marketDataService.$marketData.combineLatest($portfolioCoins)
			.map(mapGlobalMarketData)
			.sink { [weak self] (returnedStats) in
			self?.statistics = returnedStats
			self?.isLoading = false
		}.store(in: &cancellables)
		
		
		
	}
	
	func reloadData(){
		isLoading = true
		coinDataService.getCoins()
		marketDataService.getCoins()
		HapticManager.notification(type: .success)
	}
	
	
	func updatePortfolio(coin:CoinModel, amount: Double) {
		portfolioDataService.updatePortfolio(coin: coin, amount: amount)
	}
	
	private func mapAllCoinsToPortfolioCoins(allCoins: [CoinModel], portfolioEnities: [PortfolioEntity]) -> [CoinModel] {
		
		allCoins.compactMap{ (coin) -> CoinModel? in
			guard let entity = portfolioEnities.first(where: {$0.coinID == coin.id}) else {
				return nil
			}
			return coin.updateHoldings(amount: entity.amount)
		}
	}
	
	
	
	private func mapGlobalMarketData(marketDataModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
		var stats : [StatisticModel] = []
		guard let data = marketDataModel else {
			return stats
		}
		let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
		let volume = StatisticModel(title: "Volume", value: data.volume)
		let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
		
		let portfolioValue = portfolioCoins
			.map({ $0.currentHoldingsValue })
			.reduce(0, +)

		
		let previousValue = portfolioCoins.map{ (coin) -> Double in
			let currentValue = coin.currentHoldingsValue
			let percentChange = (coin.priceChangePercentage24H ?? 0)/100
			
			let previousValue = currentValue/(1 + percentChange)
			return previousValue
		}.reduce(0, +)
		
		let percentChange = ((portfolioValue - previousValue) / previousValue) * 100

		let portfolio = StatisticModel(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimals(), percentageChange: percentChange)
		
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
