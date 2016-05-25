//
//  PokeListVC.swift
//  PokeDex
//
//  Created by Kirk Tautz on 5/23/16.
//  Copyright © 2016 Kirk Tautz. All rights reserved.
//

import UIKit
import AVFoundation

class PokeListVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    // MARK: IBOutlets and properties
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var pokeCollectionView: UICollectionView!
    
    var pokeArray = [Pokemon]()
    var filteredPokeArray = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false
    
    // MARK: IBActions
    @IBAction func musicButtonPressed(sender: UIButton) {
        
        if musicPlayer.playing == true {
            musicPlayer.stop()
            sender.alpha = 0.2
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
        
    }
    
    //MARK: View methods
    override func viewDidLoad() {
        
        super.viewDidLoad()

        pokeCollectionView.delegate = self
        pokeCollectionView.dataSource = self
        searchBar.delegate = self
        
        parsePokemonCSV()
        
        initAudio()
        
        searchBar.returnKeyType = .Done
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: Collection View methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        searchBar.resignFirstResponder()
        
        var poke: Pokemon!
        
        if inSearchMode {
            poke = filteredPokeArray[indexPath.row]
        } else {
            poke = pokeArray[indexPath.row]
        }
        
        performSegueWithIdentifier("PokeDetailVC", sender: poke)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode {
            
            return filteredPokeArray.count
        }
        
        return pokeArray.count

    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokeCell", forIndexPath: indexPath) as? PokeCell {
            
            
            
            let poke: Pokemon!
            
            if inSearchMode {
                
                poke = filteredPokeArray[indexPath.row]
                
            } else {
                
                poke = pokeArray[indexPath.row]
                
            }
            
            cell.configCell(poke)
            
            return cell
            
        } else {
            return PokeCell()
        }
       
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(105, 105)
    }
    
    // MARK: Pokemon parse functions
    func parsePokemonCSV() {
        
        if let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv") {
        
            do {
                
                let csv = try CSV(contentsOfURL: path)
                let rows = csv.rows
                
                for row in rows {
                    let pokeId = Int(row["id"]!)!
                    let name = row["identifier"]!
                    
                    let poke = Pokemon(name: name, pokedexId: pokeId)
                    pokeArray.append(poke)
                }
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        
    }
    
    // MARK: Play Audio
    func initAudio() {
        
        let path = NSBundle.mainBundle().pathForResource("music", ofType: "mp3")
        
        do {
            
            musicPlayer = try AVAudioPlayer(contentsOfURL: NSURL(string: path!)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    // MARK: Search bar methods
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            
            inSearchMode = false
            view.endEditing(true)
            searchBar.resignFirstResponder()
            pokeCollectionView.reloadData()
            
        } else {
            inSearchMode = true
            let lower = searchBar.text!.lowercaseString
            
            filteredPokeArray = pokeArray.filter({$0.name.rangeOfString(lower) != nil})
            pokeCollectionView.reloadData()
        }
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    // MARK: Keyboard methods
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        searchBar.resignFirstResponder()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PokeDetailVC" {
            if let pokeDetailVC = segue.destinationViewController as? PokeDetailVC {
                if let poke = sender as? Pokemon {
                    pokeDetailVC.pokemon = poke
                }
            }
        }
    }
}
