import UIKit
import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD


var currentUserChatId2 = String()

struct Group {
    let lessonTitle: String!
    let lessonCast: String!
    
}
struct MessageDetail {
    let subTitle : String!
    let subTime : String!
    
}


class GroupTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var lessonCast: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        imgView.backgroundColor = UIColor.red
        
        imgView.layer.cornerRadius = imgView.frame.size.width / 2
        imgView.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
class GroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var lesson = [Group]()
    var message = [MessageDetail]()
    var postData : [String] = []
    var dersadi: String!
    var dersbilmemne: String!
   
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    var colors: [String] = [
        
        "#0078ff", "#fb7f71", "#f59000", "#b80505", "#ffdf55", "#eaa1c2", "#6227ae", "#b8bcc8",
        "#ff9b4f", "#db2323", "#800080", "#4f98ca", "#f66767", "#8accb3", "#0fb784", "#9cc9b1",
        "#9f9f9f", "#e0c1b2", "#b2d1e0", "#e0d8b2", "#8ac3cc", "#888888", "#88a2ad", "#785066",
        "#408ec9", "#ef6a65"
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        
        SVProgressHUD.show(withStatus: "Dersler Yükleniyor")
        
        
//        let spinningActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
//        spinningActivity.label.text = "Dersler Yükleniyor"
//        spinningActivity.detailsLabel.text = "Lütfen Bekleyin..."
        SVProgressHUD.show(withStatus: "Dersler Yükleniyor.")
        let _ = Auth.auth().currentUser?.uid
        let database = Database.database().reference()
        DispatchQueue.main.async {
            database.child("Sohbetler").queryOrderedByKey().observe(.childAdded, with: {
                
                snapshot in
                
                let username = (snapshot.value as? NSDictionary)?["key"] as? String ?? ""
                //Veri tabanından gelen dersleri aldık
                let lessonCast = username
                //Gelen derslerin İlk harfını cast ettik start Index'le
                let cast = String(lessonCast[lessonCast.startIndex])
                self.lesson.append(Group(lessonTitle: username, lessonCast: cast))
                SVProgressHUD.dismiss()
               // MBProgressHUD.hide(for: self.view, animated: true)
                SVProgressHUD.dismiss()
                self.tableView.reloadData()
                
            })
        }
        
        self.tableView.reloadData()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lesson.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GroupTableViewCell
        
        let group = lesson[indexPath.row]
        
        cell.title.text = group.lessonTitle
        
        let colorString = colors[Int(arc4random_uniform(UInt32(colors.count)))]
        
        cell.imgView.backgroundColor = UIColor.hexStringToUIColor(hex: colorString)
        
        //Main.storyboard'taki label'a set ettik.
        cell.lessonCast.text = group.lessonCast
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        dersadi = lesson[indexPath.row].lessonTitle
        
        performSegue(withIdentifier: "toMessages", sender: indexPath)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationViewController = segue.destination as? MessageViewController {
            
            destinationViewController.recipient = dersadi
            
            destinationViewController.messageId = dersbilmemne
        }
    }
    


}
