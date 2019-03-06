
import UIKit
import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase



class TableViewController: UITableViewController {
    
    var lesson = [Group]()
    
    
    var dersadi: String!
    var dersbilmemne: String!
    
    
    

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let uid = Auth.auth().currentUser?.uid
        let database = Database.database().reference()
        DispatchQueue.main.async {
            database.child("Sohbetler").queryOrderedByKey().observe(.childAdded, with: {
                
                snapshot in
                
                let username = (snapshot.value as? NSDictionary)?["key"] as? String ?? ""
                let uid = (snapshot.value as? NSDictionary)?["uid"] as? String ?? ""
                self.lesson.append(Group(username: username, uid: uid))
                
                self.tableView.reloadData() 
                
            })
        }
        
        
        tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lesson.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let usernameTxtField = cell.viewWithTag(1) as! UILabel
        usernameTxtField.text = lesson[indexPath.row].username
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        dersadi = lesson[indexPath.row].username
        
        performSegue(withIdentifier: "toMessages", sender: indexPath)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationViewController = segue.destination as? SohbetVC {
            
            destinationViewController.recipient = dersadi
            
            destinationViewController.messageId = dersbilmemne
        }
    }
    
    
}


