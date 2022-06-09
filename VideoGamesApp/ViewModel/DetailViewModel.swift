//
//  DetailViewModel.swift
//  VideoGamesApp
//
//  Created by Elif Yalçın on 7.06.2022.
//

import UIKit
import Alamofire

protocol DetailViewModelProtocol : NSObject {
    func setData(gameImageUrl:String, gameName:String, releaseDate:String, metacriticRate:Int, gameDescription:String)
    func setData(id: Int, gameImageUrl:String, gameName:String, releaseDate:String, rating: Double)
}

class DetailViewModel: NSObject {
    
    weak var delegate : DetailViewModelProtocol?
    private let apiKey = "11b748a75ad6400ca2cbc86756ba946a"
    var gameId = Int()
    
    func getDetailData() {
        let url = "https://api.rawg.io/api/games/\(gameId)?key=\(apiKey)"
        
        AF.request(url, method: .get).responseJSON { (res) in
            
            if ( res.response?.statusCode == 200 ) {
                
                let response = try? JSONDecoder().decode(DetailModel.self, from: res.data!)
                
                if let gameImageUrl = response?.backgroundImage,
                   let gameName = response?.name,
                   let releaseDate = response?.released,
                   let metacriticRate = response?.metacritic,
                   let gameDescription = response?.detailModelDescription,
                   let rating = response?.rating,
                   let id = response?.id {
                    self.delegate?.setData(gameImageUrl: gameImageUrl, gameName: gameName, releaseDate: releaseDate, metacriticRate: metacriticRate, gameDescription: gameDescription)
                    self.delegate?.setData(id: id, gameImageUrl: gameImageUrl, gameName: gameName, releaseDate: releaseDate, rating: rating)
                }
            }
        }
    }
}
