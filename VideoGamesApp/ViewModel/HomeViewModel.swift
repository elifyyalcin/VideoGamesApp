//
//  HomeViewModel.swift
//  VideoGamesApp
//
//  Created by Elif Yalçın on 5.06.2022.
//

import UIKit
import Alamofire

protocol HomeViewModelProtocol : NSObject {
    func dataUpdated()
    func addData(pageData: [Result], listData: [Result], allData: [Result])
}

class HomeViewModel: NSObject {
    weak var delegate : HomeViewModelProtocol?
    private var gamesSlide = [Result]()
    private var gamesList = [Result]()
    
    func getGameData() {
        
        let url = "https://api.rawg.io/api/games?key=11b748a75ad6400ca2cbc86756ba946a"
        
        AF.request(url, method: .get).responseJSON { (res) in
            
            if ( res.response?.statusCode == 200 ) {
                
                let response = try? JSONDecoder().decode(GameModel.self, from: res.data!)
                
                if let gameList = response?.results {
                    self.gamesSlide.append(gameList[0])
                    self.gamesSlide.append(gameList[1])
                    self.gamesSlide.append(gameList[2])
                    self.gamesList = Array(gameList.dropFirst(3))
                    self.delegate?.addData(pageData: self.gamesSlide, listData: self.gamesList, allData: gameList)
                    self.delegate?.dataUpdated()
                }
            }            
        }
    }
}



