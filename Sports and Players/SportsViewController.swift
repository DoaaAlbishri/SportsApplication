//
//  ViewController.swift
//  Sports and Players
//
//  Created by admin on 22/12/2021.
//

import UIKit
import CoreData



class sportsCell :UITableViewCell{
    
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var sportNameLabel: UILabel!
    
    @IBOutlet weak var imageViewSport: UIImageView!
}

class SportsViewController: UIViewController {
    var sports = [Sports] ()
    var indexOfImage :Int = 0
    
    @IBOutlet weak var tableView: UITableView!
    var managedObjectContextOfSports = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBAction func addSportsButton(_ sender: UIBarButtonItem) {
        
        let addAlert = UIAlertController(title: "Add sport ", message: "Add the sport you want it", preferredStyle: .alert)
        
        addAlert.addTextField(configurationHandler: nil)
        let sport =  addAlert.textFields![0]
        sport.placeholder = "Enter sport"
        
        
        let saveAction = UIAlertAction(title: "Save", style: .default)
        {
            _ in
            
            let newSport = Sports(context: self.managedObjectContextOfSports)
            newSport.name = sport.text!
            
            self.tableView.reloadData()
            
            do {
                try self.managedObjectContextOfSports.save()
                print("Save successful")
            } catch {
                print("Error \(error)")
            }
            
            self.fetchSports()
        }
        
        
        
        present(addAlert, animated: true, completion: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        addAlert.addAction(saveAction)
        addAlert.addAction(cancelAction)
        
        
    }
    
    func fetchSports()
    {
        do {
            sports = try managedObjectContextOfSports.fetch(Sports.fetchRequest())
            print("Success")
        } catch {
            print("Error: \(error)")
        }
        tableView.reloadData()
        
    }
    
    //MARK: - Import Picture
    func importPicture() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    @IBAction func addImageButtonPressed(_ sender: UIButton) {
        indexOfImage = sender.tag
        importPicture()
        do {
            try self.managedObjectContextOfSports.save()
            print("Save successful")
        } catch {
            print("Error \(error)")
        }
        fetchSports()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        fetchSports()
    }
    
    
}

extension SportsViewController : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "sportCell", for: indexPath) as? sportsCell else {return UITableViewCell()}
        let sport = sports[indexPath.row]
        cell.sportNameLabel.text = sport.name
        if let imageData = sport.image {
            cell.imageViewSport.image = UIImage(data: imageData)
            cell.addImageButton.isHidden = true
        }
        return cell
    }
    // delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let sportname = sports[indexPath.row]
        managedObjectContextOfSports.delete(sportname)
        
        do
        {
            try managedObjectContextOfSports.save()
            
        } catch
        {print("\(error)")}
        
        sports.remove(at: indexPath.row)
        
        tableView.reloadData()
    }
    
    
    //update
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let editAlert = UIAlertController(title: "Edit sport ", message: "Edit sport as you want ", preferredStyle: .alert)
        
        editAlert.addTextField { (textField) -> Void in
            textField.text = self.sports[indexPath.row].name
        }
        let sport =  editAlert.textFields![0]
        
        let saveAction = UIAlertAction(title: "Edit", style: .default)
        {
            _ in
            
            self.sports[indexPath.row].name = sport.text!
            
            self.tableView.reloadData()
            
            do {
                try self.managedObjectContextOfSports.save()
                print("Edit successful")
            } catch {
                print("Error \(error)")
            }
            
            self.fetchSports()
        }
        
        
        
        present(editAlert, animated: true, completion: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        editAlert.addAction(saveAction)
        editAlert.addAction(cancelAction)
        
        
    }
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let playersViewController = storyboard?.instantiateViewController(withIdentifier: "PlayersViewController") as? PlayersViewController
        playersViewController?.sport = sports[indexPath.row]
        self.navigationController?.pushViewController(playersViewController!, animated: true)
    }
}

//MARK: - Picker Extension

extension SportsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.originalImage] as? UIImage
        //let indexPath = IndexPath(row: indexOfImage, section: 0)
        //let cell = tableView.cellForRow(at: indexPath) as! sportsCell
        //cell.imageViewSport.image = image
        picker.dismiss(animated: true, completion: nil)
    }
}
