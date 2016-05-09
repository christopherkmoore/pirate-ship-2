//
//  ControlCenter.swift
//  Pirate Fleet
//
//  Created by Jarrod Parkes on 9/2/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

struct GridLocation {
    let x: Int
    let y: Int
}

struct Ship {
    let length: Int
    let location: GridLocation
    let isVertical: Bool
    let isWooden: Bool
    
    var cells: [GridLocation] {
        let start = self.location
        let end: GridLocation = ShipEndLocation(self)
        var occupiedCells = [GridLocation]()
        
        for x in start.x...end.x {
            for y in start.y...end.y {
                occupiedCells.append(GridLocation(x: x, y: y))
            }
        }
        return occupiedCells
    }

    
            
    
    var hitTracker: HitTracker
// TODO: Add a getter for sunk. Calculate the value returned using hitTracker.cellsHit.
    
    
    var sunk: Bool {
        for hit in hitTracker.cellsHit.values {
            if !hit {
                return false
            }
        }
        return true
    }

    
    init(length: Int, location: GridLocation, isVertical: Bool, hitTracker: HitTracker) {
        self.length = length
        self.location = location
        self.hitTracker = HitTracker()
        self.isVertical = isVertical
        self.isWooden = true
        
    }
    
    init(length: Int, location: GridLocation, isVertical: Bool, hitTracker: HitTracker, isWooden: Bool) {
        self.length = length
        self.location = location
        self.hitTracker = HitTracker()
        self.isVertical = isVertical
        self.isWooden = isWooden
        
    }
    
}

// TODO: Change Cell protocol to PenaltyCell and add the desired properties
protocol PenaltyCell {
    var location: GridLocation {get}
    var guaranteesHit: Bool {get}
    var penaltyText: String {get}
    
}

// TODO: Adopt and implement the PenaltyCell protocol
struct Mine: PenaltyCell {
    var location: GridLocation
    var guaranteesHit: Bool
    var penaltyText: String
    
    init(location: GridLocation, penaltyText: String) {
        self.location = location
        self.penaltyText = penaltyText
        self.guaranteesHit = false
    }
    
    init(location: GridLocation, guaranteesHit: Bool, penaltyText: String) {
        self.location = location
        self.guaranteesHit = false
        self.penaltyText = penaltyText
    }

}

// TODO: Adopt and implement the PenaltyCell protocol
struct SeaMonster: PenaltyCell {
    var location: GridLocation
    var guaranteesHit: Bool
    var penaltyText: String
}

class ControlCenter {
    
    func placeItemsOnGrid(human: Human) {
        
        let smallShip = Ship(length: 2, location: GridLocation(x: 3, y: 4), isVertical: true, hitTracker: HitTracker(), isWooden: true)
        human.addShipToGrid(smallShip)
        
        let mediumShip1 = Ship(length: 3, location: GridLocation(x: 0, y: 0), isVertical: false, hitTracker: HitTracker())
        human.addShipToGrid(mediumShip1)
        
        let mediumShip2 = Ship(length: 3, location: GridLocation(x: 3, y: 1), isVertical: false, hitTracker: HitTracker())
        human.addShipToGrid(mediumShip2)
        
        let largeShip = Ship(length: 4, location: GridLocation(x: 6, y: 3), isVertical: true, hitTracker: HitTracker())
        human.addShipToGrid(largeShip)
        
        let xLargeShip = Ship(length: 5, location: GridLocation(x: 7, y: 2), isVertical: true, hitTracker: HitTracker())
        human.addShipToGrid(xLargeShip)
        
        let mine1 = Mine(location: GridLocation(x: 6, y: 0), guaranteesHit: false, penaltyText: "Lucky for you the scallywag has turned and fled. Time to juice up!")
        human.addMineToGrid(mine1)
        
        let mine2 = Mine(location: GridLocation(x: 3, y: 3), penaltyText: "CP tripped... on your explosion. RIP")
        human.addMineToGrid(mine2)
        
        let seamonster1 = SeaMonster(location: GridLocation(x: 5, y: 6), guaranteesHit: true, penaltyText: "CP solo'd baron nashor.")
        human.addSeamonsterToGrid(seamonster1)

        let seamonster2 = SeaMonster(location: GridLocation(x: 2, y: 2), guaranteesHit: true, penaltyText: "CP wanted to feel big but the Sea Monster was bigger.")
        human.addSeamonsterToGrid(seamonster2)
        
    }
    
    func calculateFinalScore(gameStats: GameStats) -> Int {
        
        var finalScore: Int
        
        let sinkBonus = (5 - gameStats.enemyShipsRemaining) * gameStats.sinkBonus
        let shipBonus = (5 - gameStats.humanShipsSunk) * gameStats.shipBonus
        let guessPenalty = (gameStats.numberOfHitsOnEnemy + gameStats.numberOfMissesByHuman) * gameStats.guessPenalty
        
        finalScore = sinkBonus + shipBonus - guessPenalty
        
        return finalScore
    }
}