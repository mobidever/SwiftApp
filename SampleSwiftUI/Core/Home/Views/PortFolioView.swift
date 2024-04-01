//
//  PortFolioView.swift
//  SampleSwiftUI
//
//  Created by PS on 01/04/24.
//

import SwiftUI

struct PortFolioView: View {
	
	@EnvironmentObject private var vm:HomeViewModel
	@Environment(\.dismiss) var dismiss
	
	@State private var selectedCoin: CoinModel? = nil
	@State private var quantityText: String = ""
	@State private var showCheckMark: Bool = false

	
    var body: some View {
		NavigationView{
			ScrollView{
				VStack(alignment: .leading, spacing: 0){
					
					SearchBarView(searchText: $vm.searchText)
					coinLogoList
					
					if selectedCoin != nil {
						portfolioInputSection
					}
				}
			}.navigationTitle("Edit Portfolio")
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					XMarkButton(dismiss: _dismiss)
				}
				ToolbarItem(placement: .navigationBarTrailing) {
					trailingNavBarButton
				}
			}
		}.onChange(of: vm.searchText, perform: { value in
			if value	 == "" {
				removeSelectedCoin()
			}
		})
        Text("PortFolio View!!")
    }
}

#Preview {
	PortFolioView().environmentObject(DeveloperPreview.instance.homeVM)
}


extension PortFolioView {
	
	private var coinLogoList: some View {
		
		ScrollView(.horizontal, showsIndicators:true, content: {
			LazyHStack(spacing:10){
				ForEach(vm.allCoins) { coin in
					CoinLogoView(coin: coin)
						.onTapGesture {
							withAnimation(.easeIn) {
								selectedCoin = coin
							}
						}
						.frame(width: 75)
						.background(RoundedRectangle(cornerRadius: 10)
							.stroke(selectedCoin?.id == coin.id ? Color.theme.green: Color.clear
									, lineWidth: 1))
					
				}
			}
			.padding(.vertical,4)
			.padding(.leading)
		})
	}
	
	private func saveButtonPressed() {
		
		guard let coin = selectedCoin else {
			return
		}
		
		//save to portfolio
		//show checkmark
		withAnimation(.easeIn) {
			showCheckMark = true
			removeSelectedCoin()
		}
		
		//hide keyboard
		UIApplication.shared.endEditing()
		
		//hide checkMark.
		DispatchQueue.main.asyncAfter(deadline: .now()+2.0) {
			withAnimation(.easeOut) {
				showCheckMark = false
			}
		}
	}
	
	private func removeSelectedCoin() {
		selectedCoin = nil
		vm.searchText = ""
	}
	
	private var trailingNavBarButton : some View {
		HStack(spacing:10) {
			Image(systemName: "checkmark")
				.opacity(showCheckMark ? 1.0 : 0.0)
			
			Button(action: {
				
				saveButtonPressed()
			}, label: {
				Text("Save".uppercased())
			}).opacity( (selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText) ) ? 1.0: 0.0)
			
		}.font(.headline)
	}
	
	private var portfolioInputSection: some View {
		VStack(spacing: 20) {
			HStack{
				Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):" )
				Spacer()
				Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
			}
			Divider()
			HStack{
				Text("Amount Holiding: ")
				Spacer()
				TextField("Ex: 1.4", text: $quantityText).multilineTextAlignment(.trailing)
					.keyboardType(.decimalPad)
			}
			Divider()
			HStack{
				Text("Current Value :")
				Spacer()
				Text(getCurrentValue().asCurrencyWith2Decimals())
			}
			
		}
		.animation(.none)
		.padding()
		.font(.headline)
	}
	
	private func getCurrentValue() -> Double {
		if let quantity = Double(quantityText){
			return quantity * (selectedCoin?.currentPrice ?? 0)
		}
		
		return 0
	}
}
