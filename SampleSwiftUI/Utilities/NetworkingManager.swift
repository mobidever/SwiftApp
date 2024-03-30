//
//  NetworkingManager.swift
//  SampleSwiftUI
//
//  Created by PS on 29/03/24.
//

import Foundation
import Combine

class NetworkingManager {
	
	enum NetworkingError: LocalizedError {
		
		case badURLResponse(url: URL)
		case unknown(url: URL)
		
		var errorDescription: String? {
			switch self {
				case .badURLResponse(url: let url) : return "[🔥] Bad Response from URL: \(url)"
						
				case .unknown(url: let url) : return "[⚠️] Unknown error occurred from URL: \(url)"
			}
		}
	}
	
	static func handleCompletion(completion: Subscribers.Completion<Error>){
		switch completion {
			case .finished:
				break
			case .failure(let error):
				print(error.localizedDescription)
		}
	}
	
	static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
		
		guard let response = output.response as? HTTPURLResponse , response.statusCode >= 200 && response.statusCode < 300 else {
			throw NetworkingError.badURLResponse(url: url)
		}
		print(response.statusCode)
		return output.data
	}
	
	static func download(url: URL) ->  AnyPublisher<Data, Error>  {
		
		return  URLSession.shared.dataTaskPublisher(for: url)
			.subscribe(on: DispatchQueue.global(qos: .default))
			.tryMap {
				try handleURLResponse(output: $0, url: url)
			}
			.receive(on: DispatchQueue.main)
			.eraseToAnyPublisher()
	}
}
