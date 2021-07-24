//
//  APICaller.swift
//  CryptoClues
//
//  Created by Dala  on 7/23/21.
//

import UIKit

final class APICaller {
    static let shared = APICaller()
    
    private struct Constants {
        static let apiKey = "619E5006-7F95-4FF7-801C-3F96C2B99178"
        static let assetsEndpoint = "https://rest-sandbox.coinapi.io/v1/assets/"
    }
    
    private init() {}
    public var icons: [Icons] = []
    public var whenReadyBlock: ((Result<[Crypto], Error>) -> Void)?
    
    
    public func getAllCryptoData(completion: @escaping (Result<[Crypto], Error>) -> Void) {
        
        guard !icons.isEmpty else {
            whenReadyBlock = completion
            return
        }
        
        guard let url = URL(string: Constants.assetsEndpoint + "?apikey=" + Constants.apiKey) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let cryptos = try JSONDecoder().decode([Crypto].self, from: data)
                completion(.success(cryptos.sorted { first, second in
                    return first.price_usd ?? 0 > second.price_usd ?? 0
                }))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    public func getAllIcons() {
      
        guard let url = URL(string: "https://rest-sandbox.coinapi.io/v1/assets/icons/55/?apikey=619E5006-7F95-4FF7-801C-3F96C2B99178") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                self?.icons = try JSONDecoder().decode([Icons].self, from: data)
                if let completion = self?.whenReadyBlock {
                    self?.getAllCryptoData(completion: completion)
                }
            }
            catch {
            }
        }
        task.resume()
    }
}

