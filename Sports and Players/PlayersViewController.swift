//
//  PlayersViewController.swift
//  Sports and Players
//
//  Created by admin on 22/12/2021.
//

import UIKit

class PlayersViewController: UIViewController {
    var managedObjectContextOfPlayer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var sport : Sports?
    
    var players = [Players]()
    
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        //  let sportsViewController = storyboard?.instantiateViewController(withIdentifier: "SportsViewController") as? SportsViewController
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBAction func addPlayersButton(_ sender: UIBarButtonItem) {
        
        let addAlert = UIAlertController(title: "Add player ", message: "Add details of player", preferredStyle: .alert)
        
        addAlert.addTextField(configurationHandler: nil)
        addAlert.addTextField(configurationHandler: nil)
        addAlert.addTextField(configurationHandler: nil)
        let name =  addAlert.textFields![0]
        let age =  addAlert.textFields![1]
        let height =  addAlert.textFields![2]
        name.placeholder = "Enter name"
        age.placeholder = "Enter Age"
        height.placeholder = "Enter Height"
        
        
        let saveActionplayer = UIAlertAction(title: "Save", style: .default)
        {
            _ in
            
            let new = Players(context: self.managedObjectContextOfPlayer)
            new.playerName = name.text!
            
            new.age = age.text!
            
            new.height = height.text!
            
            
            self.sport?.addToPlayers(new)
            
            self.tableView.reloadData()
            self.savePlayers()
        }
        
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        addAlert.addAction(saveActionplayer)
        addAlert.addAction(cancelAction)
        present(addAlert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        fetchPlayers()
    }
    
    func savePlayers()
    {
        do {
            try managedObjectContextOfPlayer.save()
            print("Save successful")
        } catch {
            print("Error \(error)")
        }
        
        fetchPlayers()
        
    }
    func fetchPlayers()
    
    {
        do {
            players = try managedObjectContextOfPlayer.fetch(Players.fetchRequest())
            print("Success")
        } catch {
            print("Error: \(error)")
        }
        tableView.reloadData()
    }
    
}

extension PlayersViewController : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let players = sport?.players {
            return players.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "player", for: indexPath)
        
        if let players = sport?.players?.allObjects as? [Players] {
            let player = players[indexPath.row]
            cell.textLabel?.text = "\(player.playerName!) - Age: \(player.age), Height: \(player.height)"
        }
        return cell
    }
    
    // delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if let players = sport?.players?.allObjects as? [Players] {
            let player = players[indexPath.row]
            managedObjectContextOfPlayer.delete(player)
        }
        
        do
        {
            try managedObjectContextOfPlayer.save()
            
        } catch
        {print("\(error)")}
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let editAlert = UIAlertController(title: "Edit player ", message: "Edit details of player", preferredStyle: .alert)
        
        editAlert.addTextField(configurationHandler: nil)
        editAlert.addTextField(configurationHandler: nil)
        editAlert.addTextField(configurationHandler: nil)
        
        let name =  editAlert.textFields![0]
        let age =  editAlert.textFields![1]
        let height =  editAlert.textFields![2]
        
        name.placeholder = "Enter name"
        age.placeholder = "Enter age"
        height.placeholder = "Enter height"
        let saveActionplayer = UIAlertAction(title: "Edit", style: .default)
        {
            _ in
            
            if let players = self.sport?.players?.allObjects as? [Players] {
                let player = players[indexPath.row]
                player.playerName = name.text!
                player.age = age.text!
                player.height = height.text!
            }
            self.savePlayers()
            self.tableView.reloadData()
            self.fetchPlayers()
            
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        editAlert.addAction(saveActionplayer)
        editAlert.addAction(cancelAction)
        present(editAlert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
    }
    
}
