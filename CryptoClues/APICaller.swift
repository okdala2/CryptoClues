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
    
    public func getAllCryptoData(completion: @escaping (Result<[Crypto], Error>) -> Void) {
        
        guard let url = URL(string: Constants.assetsEndpoint + "?apikey=" + Constants.apiKey) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let cryptos = try JSONDecoder().decode([Crypto].self, from: data)
                completion(.success(cryptos))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

