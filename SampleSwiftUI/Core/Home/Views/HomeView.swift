//
//  HomeView.swift
//  SampleSwiftUI
//
//  Created by PS on 22/03/24.
//

import SwiftUI

struct HomeView: View {
	
	@EnvironmentObject private var vm: HomeViewModel
	@State private var showPortfolio : Bool = false
	@State private var showPortfolioView: Bool = false // to toggle portfolio edit sheet
	
    var body: some View {
		ZStack{
			Color.theme.background
				.ignoresSafeArea()
				.sheet(isPresented: $showPortfolioView, content: {
					PortFolioView().environmentObject(vm)
				})
			
			VStack (content: {
				homeHeader
				HomeStatsView(showPortfolio: $showPortfolio)
				SearchBarView(searchText: $vm.searchText)
				columnTitles
				if !showPortfolio {
					allCoinsList
					.transition(.move(edge: .trailing))
				} else {
					portFolioCoinsList.transition(.move(edge: .leading))
				}
				Spacer(minLength: 0)
				
			})
		}
    }
}

#Preview {
	HomeView().navigationBarHidden(true).environmentObject(DeveloperPreview.instance.homeVM)
}

extension HomeView {
	
	private var allCoinsList : some View {
		List {
			ForEach(vm.allCoins) { coin in
				CoinRowView(coin: coin, showHoldingColumn: false).listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
				
			}
		}.listStyle(PlainListStyle())
	}
	
	private var portFolioCoinsList : some View {
		List {
			ForEach(vm.portfolioCoins) { coin in
				CoinRowView(coin: coin, showHoldingColumn: true).listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
				
			}
		}.listStyle(PlainListStyle())
	}
	
	private var columnTitles: some View {
		
		HStack {
			Text("Coin")
			Spacer()
			if showPortfolio {
				Text("Holidings")
			}
			
			Text("Price")
				.frame(width: UIScreen.main.bounds.width/3.5, alignment: .trailing)
			
			Button(action: {
				withAnimation(.linear(duration: 2.0)){
					vm.reloadData()
				}
			}, label: {
				Image(systemName: "goforward")
			}).rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0), anchor:  .center)
		}.font(.caption)
			.foregroundColor(Color.theme.secondaryTextColor)
			.padding(.horizontal)
		
		
	}
	
	private var homeHeader: some View {
		
		HStack{
			CircleButtonView(iconName: showPortfolio ? "plus" : "info")
				.animation(.none)
				.onTapGesture {
					if showPortfolio {
						showPortfolioView.toggle()
					}
				}
				.background{
					CircleButtonAnimationView(animate: $showPortfolio)
				}
			Spacer()
			Text(showPortfolio ? "Portfolio" : "Live Prices" )
				.font(.headline)
				.fontWeight(.heavy)
				.foregroundStyle(Color.theme.accent)
			Spacer()
			CircleButtonView(iconName: "chevron.right")
				.rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
				.onTapGesture {
					withAnimation(.spring()){
						showPortfolio.toggle()
					}
				}
		}
		.padding(.horizontal)
	}
}
