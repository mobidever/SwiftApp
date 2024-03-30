//
//  CoinView.swift
//  SampleSwiftUI
//
//  Created by PS on 22/03/24.
//

import SwiftUI

struct CoinRowView: View {
	
	let coin: CoinModel
	let showHoldingColumn : Bool
	
    var body: some View {
		HStack {
			leftColumn
			Spacer()
			if showHoldingColumn {
				centerColumn
			}
			rightColumn
		}
    }
}

#Preview {
	CoinRowView(coin: DeveloperPreview.instance.coin,showHoldingColumn: true)
}

extension CoinRowView {
	
	private var leftColumn: some View {
		HStack(spacing:0) {
			Text("\(coin.rank)")
				.font(.caption)
				.foregroundStyle(Color.theme.secondaryTextColor)
				.frame(minWidth: 30)
			CoinImageView(coin: coin)
				.frame(width: 30, height: 30)
			Text(coin.symbol.uppercased())
				.font(.headline)
				.padding(.leading, 6)
				.foregroundStyle(Color.theme.accent)
		}
	}
	
	private var centerColumn: some View {
		VStack(alignment:.trailing){
			Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
			Text((coin.currentHoldings ?? 0).asNumberString()).foregroundStyle(Color.theme.accent)
		}
	}
	
	private var rightColumn : some View {
		VStack(alignment:.trailing){
			Text("\(coin.currentPrice.asCurrencyWith2Decimals())")
				.bold()
				.foregroundStyle(Color.theme.accent)
			Text("\(coin.priceChangePercentage24H?.asPercentString() ?? "")")
				.foregroundColor((coin.priceChangePercentage24H ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
		}.frame(width: UIScreen.main.bounds.width/3.5, alignment: .trailing) //TODO: Try using Geometry
			.font(.subheadline)
	}
}
