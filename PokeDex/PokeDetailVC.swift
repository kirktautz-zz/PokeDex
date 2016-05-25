//
//  PokeDetailVC.swift
//  PokeDex
//
//  Created by Kirk Tautz on 5/24/16.
//  Copyright © 2016 Kirk Tautz. All rights reserved.
//

import UIKit

class PokeDetailVC: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet var mainImg: UIImageView!
    @IBOutlet var descriptionLbl: UILabel!
    @IBOutlet var typeLbl: UILabel!
    @IBOutlet var defenseLbl: UILabel!
    @IBOutlet var heightLbl: UILabel!
    @IBOutlet var baseAttkLbl: UILabel!
    @IBOutlet var weightLbl: UILabel!
    @IBOutlet var pokeIdLbl: UILabel!
    @IBOutlet var evoLbl: UILabel!
    @IBOutlet var evoOneLbl: UIImageView!
    
    var pokemon: Pokemon!

    override func viewDidLoad() {
   
        name.text = pokemon.name
        mainImg.image = UIImage(named: "\(pokemon.pokedexId)")
        
        pokemon.downloadPokeDetails {
            dispatch_async(dispatch_get_main_queue(), { 
                self.updateUI()
            })
            
            
        }
        
    }
    
    func updateUI() {
        
        self.descriptionLbl.text = self.pokemon.pokeDescription
        self.typeLbl.text = self.pokemon.type
        self.defenseLbl.text = self.pokemon.defense
        self.heightLbl.text = self.pokemon.height
        self.weightLbl.text = self.pokemon.weight
        self.baseAttkLbl.text = self.pokemon.attack
        if self.pokemon.nextEvoId != "" {
        self.evoLbl.text = "Next evolution: \(self.pokemon.nextEvoText) LVL \(self.pokemon.nextEvoLvl)"
        } else {
            self.evoLbl.text = "No evolutions"
        }
        self.evoOneLbl.image = UIImage(named: self.pokemon.nextEvoId)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    @IBAction func backButtonPressed(sender: UIButton) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}
