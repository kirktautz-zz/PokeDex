//
//  Pokemon.swift
//  PokeDex
//
//  Created by Kirk Tautz on 5/23/16.
//  Copyright © 2016 Kirk Tautz. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon: NSObject {
    
    // Create name and id variables
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvoText: String!
    private var _nextEvoId: String!
    private var _nextEvoLvl: String!
    private var _resourceURL: String!
    
    // Getters
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var pokeDescription: String {
        return _description
    }
    
    var type: String {
        return _type
    }
    
    var defense: String {
        return _defense
    }
    
    var height: String {
        return _height
    }
    
    var weight: String {
        return _weight
    }
    
    var attack: String {
        return _attack
    }
    
    var nextEvoText: String {
        get {
            if _nextEvoText != nil {
                return _nextEvoText
            }
            return ""
        }
    }
    
    var nextEvoId: String {
        get {
            if _nextEvoId != nil {
                return _nextEvoId
            }
            return ""
        }
    }
    
    var nextEvoLvl: String {
        get {
            if _nextEvoLvl != nil {
                return _nextEvoLvl
            }
            return ""
        }
    }
    
    
    
    
    // You must give it a name and id
    
    init(name: String, pokedexId: Int) {
        _name = name
        _pokedexId = pokedexId
        _resourceURL = "\(BASE_URL)\(POKE_URL)\(_pokedexId)/"
    }
    
    func downloadPokeDetails(completed: DownloadComplete) {
        
        Alamofire.request(.GET, _resourceURL).responseJSON { (response) in
            let result = response.result
            
            print(result.value)
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                    
                }
                if let height = dict["height"] as? String {
                    self._height = height
                    
                }
                if let attack = dict["attack"] as? Int {
                    self._attack = String(attack)
                    
                }
                if let defense = dict["defense"] as? Int {
                    self._defense = String(defense)
                    
                }
                
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0 {
                    
                    if let name = types[0]["name"] {
                        self._type = name.capitalizedString
                    }
                    
                    if types.count > 1 {
                        for i in 1 ..< types.count {
                            if let name = types[i]["name"] {
                                self._type! += " / \(name.capitalizedString)"
                            }
                            
                        }
                    }
                } else {
                    self._type = ""
                }
                print(self._type)
                
                if let description = dict["descriptions"] as? [Dictionary<String, String>] where description.count > 0 {
                    if let url = description[0]["resource_uri"] {
                        let nsurl = NSURL(string: "\(BASE_URL)\(url)")!
                        Alamofire.request(.GET, nsurl).responseJSON(completionHandler: { (response) in
                            if let result = response.result.value {
                                if let desc = result["description"] as? String {
                                    self._description = desc
                                    print(self._description)
                                }
                            }
                            completed()
                        })
                        
                    }
                } else {
                    self._description = ""
                }
                
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 1 {
                    if let to = evolutions[0]["to"] as? String {
                        if to.rangeOfString("mega") == nil {
                            if let str = evolutions[0]["resource_uri"] as? String {
                                let newStr = str.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                self._nextEvoId = num
                                self._nextEvoText = to
                                
                                if let lvl = evolutions[0]["level"] as? Int {
                                    self._nextEvoLvl = String(lvl)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}
