//
//  CoinImageService.swift
//  SampleSwiftUI
//
//  Created by PS on 30/03/24.
//

import Foundation
import Combine
import SwiftUI

class CoinImageService {
	
	@Published var image: UIImage? = nil
	var imageSubscription : AnyCancellable?
	private let coin: CoinModel
	private let fileManager = LocalFileManager.instance
	private let folderName = "coin_images"
	private let imageName : String
	
	init(coin: CoinModel){
		self.coin = coin
		self.imageName = coin.id
		getCoinImage()
	}
	
	private func getCoinImage() {
		if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
			image = savedImage
			print("Returned image from File Manager")
		}
		else {
			print("Image Downloaded now")
			downloadCoinImage()
		}
	}
	
	private func downloadCoinImage() {
		
		guard let url = URL(string: coin.image) else {
			return
		}
		
		imageSubscription = NetworkingManager.download(url: url)
			.tryMap({ (data) -> UIImage? in
				return UIImage(data: data)
			})
			.sink { (completion) in
				print("Inside Sink")
				NetworkingManager.handleCompletion(completion: completion)
				
			} receiveValue: { [weak self] (returnedImage ) in
				print("Inside receivedValue")
				guard let self = self, let downloadedImage = returnedImage else {
					return
				}
				self.image = downloadedImage
				self.imageSubscription?.cancel()
				self.fileManager.saveImage(image: downloadedImage, imageName: imageName, folderName: folderName)
			}
	}
}
