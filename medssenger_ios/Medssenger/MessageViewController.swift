import UIKit
import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SwiftKeychainWrapper

var currentUser = String()

struct MessageInformation {
    let sender : String!
    let messageText : String!
    let time : String!
}

class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    var message = [MessageInformation]()
    var messageDetail = [MessageDetail]()
    var keyboard = false
    
     var messageId: String!
     var recipient: String!
    
    var user: String!
   
    @IBOutlet weak var etiket: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var TxtField: UITextField!
    @IBOutlet weak var txtView: UITextView!
    
    var mesajText: String!
    var dateFormatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        self.hideKeyboard()
        
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        //TextView'ın kenarlarını yumuşattık.
        txtView.layer.borderWidth = 0.9
        txtView.layer.borderColor = borderColor.cgColor
        txtView.layer.cornerRadius = 18.0
        txtView.placeholder = "Mesajınızı Girin"
        txtView.placeholderColor = UIColor.lightGray
        //TextView sağdan ortadan soldan üstten text ayarlarını verdik.
        txtView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 40)
        
        textViewDidChange(txtView)
        
      //  var postData = [String]()
        /*tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 92*/
        
      //  self.tabBarController?.tabBar.isHidden = true //Tab Bar'ı gizliyor ekranda
        //tableView.tableFooterView = UIView()
        user = UserDefaults.standard.string(forKey: "user")
        
       
        //let database = Database.database().reference()
        
        /*mesajText = TxtField.text
        date = "12:59 AM"*/
        
        
        //print("bilgiler:",user )
        //print(recipient)
        etiket.title = recipient
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        
        
   
        
        let database = Database.database().reference()
        DispatchQueue.main.async {
            database.child("Sohbetler").child(self.recipient).child("mesaj").observe(.childAdded, with: {
                
                snapshot in
               //postData.append("")
                
                let sender = (snapshot.value as? NSDictionary)?["gonderici"] as? String ?? ""
                let messageText = (snapshot.value as? NSDictionary)?["mesajText"] as? String ?? ""
                let time = (snapshot.value as? NSDictionary)?["zaman"] as? String ?? ""
                self.message.append(MessageInformation(sender: sender, messageText: messageText, time: time))
                 self.tableView.reloadData()
                
                if self.message.count != 0
                {
                    let ds = IndexPath.init(row: self.message.count - 1, section: 0)
                    self.tableView.scrollToRow(at: ds, at: .bottom, animated: false)
                }
                
            })
        }
        
        self.tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return message.count
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        if message.count != 0
        {
            let ds = IndexPath.init(row: message.count - 1, section: 0)
            tableView.scrollToRow(at: ds, at: .top, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if message[indexPath.row].sender == user {
            let group = message[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SenderCell", for: indexPath) as! MessageViewCell
            
            
            cell.senderInformation.text = group.sender
            cell.senderMessage.text = group.messageText
            cell.senderMessageTime.text = group.time
            
            return cell
        }else
        {
            let group = message[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverCell", for: indexPath) as! MessageViewCell
            cell.receiverInformation.text = group.sender
            cell.receiverMessage.text = group.messageText
            cell.receiverMessageTime.text = group.time
            
            return cell
        }
        
    }
    
    @IBAction func backPressed (_ sender: AnyObject) {
  
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendButton(_ sender: Any) {
        if txtView.text == ""
        {
            
        }else
        {
            user = UserDefaults.standard.string(forKey: "user")
            mesajText = txtView.text
            let formatter = DateFormatter()
            // initially set the format based on your datepicker date / server String
            formatter.dateFormat = "dd-MM-yyyy HH:mm"
            
            let myString = formatter.string(from: Date()) // string purpose I add here
            // convert your string to date
            let yourDate = formatter.date(from: myString)
            //then again set the date format whhich type of output you need
            formatter.dateFormat = "dd/MM/yyyy HH.mm"
            // again convert your date to string
            let myStringafd = formatter.string(from: yourDate!)
            let database = Database.database().reference()
            
            database.child("Sohbetler").child(self.recipient).child("mesaj").childByAutoId().setValue(["gonderici": user, "mesajText": mesajText, "zaman": myStringafd])
            
            //ref.child("Sohbetler/\(self.recipient)/mesajlar/gonderici").setValue(user)
            //ref.child("Sohbetler").child(Auth.auth().currentUser!.uid).setValue(user)
            //ref.child("Sohbetler/\(self.recipient)/mesajlar/gonderici").setValue(user)
            //textViewDidChange(txtView)
            txtView.text = nil
        }
        
        
        
    
    }
    
    
    //TextView'a tıklandığında klavye yukarıda gözükmesi
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(MessageViewController.keyboardOut(notifica:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MessageViewController.keyboardInside(notifica:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    @objc func keyboardInside(notifica: Notification) {
        InPutkeyboard(su: false, notifica: notifica)
    }
    @objc func keyboardOut(notifica: Notification) {
        InPutkeyboard(su: true, notifica: notifica)
    }
    func InPutkeyboard(su: Bool, notifica: Notification) {
        guard su != keyboard else {
            return
        }
        let info = notifica.userInfo
        let endKeyboard: CGRect = ((info?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue)!
        let animationDuration: TimeInterval = info?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut, animations: {
            let animationDuration = self.view.convert(endKeyboard, to: nil)
            let verticalMovement = animationDuration.size.height * (su ? -1 : 1)
            self.view.frame = self.view.frame.offsetBy(dx: 0, dy: verticalMovement)
            self.keyboard = !self.keyboard
        }, completion: nil)
        
    }
    
    //Textview için verilen kurallar.
    func textViewDidChange(_ textView: UITextView) {
        textView.isScrollEnabled = false
        let large = textView.frame.size.width
        let size = textView.sizeThatFits(CGSize(width: large, height: CGFloat.greatestFiniteMagnitude))
        let heigh = size.height
        if heigh > 33{
            textView.isScrollEnabled = true
        }else{
        
    }
    }
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MessageViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
}
    


