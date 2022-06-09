//
//  GameDB.swift
//  VideoGamesApp
//
//  Created by Elif Yalçın on 8.06.2022.
//

import Foundation
import SQLite

struct Game {
    var id: Int = 0
    var imgUrl:String = ""
    var name:String = ""
    var rating:Double = 0.0
    var release: String = ""
}

class DB {
    
    var db:Connection!
    var gameTable = Table("tList")
    
    let id = Expression<Int>("id")
    let imgUrl = Expression<String>("imgUrl")
    let name = Expression<String>("name")
    let rating = Expression<Double>("rating")
    let release = Expression<String>("release")
    
    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    func connection() {
        
        let  dbPath = path + "/db.sqlite3"
        db = try! Connection(dbPath)
        
        do {
            try db.scalar(gameTable.exists)
        } catch  {
            try! db.run(gameTable.create { t in
                t.column(id, primaryKey: true)
                t.column(imgUrl)
                t.column(name)
                t.column(rating)
                t.column(release)
            })
        }
    }
    
    func insertGame(id: Int,imgUrl: String, name: String, rating: Double, release: String) -> Int64 {
        
        do {
            let insert = gameTable.insert( self.id <- id, self.imgUrl <- imgUrl, self.rating <- rating, self.name <- name, self.release <- release )
            return try db.run(insert)
        } catch  {
            return -1
        }
    }
    
    func gameList() -> [Game] {
        var arr:[Game] = []
        let users = try! db.prepare(gameTable)
        for item in users {
            let us = Game(id: item[id], imgUrl: item[imgUrl], name: item[name], rating: item[rating],release: item[release] )
            arr.append(us)
        }
        return arr
    }
    
    func deleteGame( gameId: Int ) -> Int {
        let alice = gameTable.filter(Expression<Bool>(id==gameId))
        return try! db.run( alice.delete() )
    }
    
}

