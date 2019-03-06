import UIKit

class MessageViewCell: UITableViewCell {

   
    @IBOutlet weak var senderInformation: UILabel!    
    @IBOutlet weak var senderMessage: UILabel!
    @IBOutlet weak var senderMessageTime: UILabel!
    @IBOutlet weak var senderView: UIView?
    
    
    @IBOutlet weak var receiverInformation: UILabel!
    @IBOutlet weak var receiverMessage: UILabel!
    @IBOutlet weak var receiverMessageTime: UILabel!
    @IBOutlet weak var receiverView: UIView?
    var ImageView: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        /*self.receiverView?.layer.shadowPath = UIBezierPath(roundedRect:
            (self.receiverView?.bounds)!, cornerRadius: (self.receiverView?.layer.cornerRadius)!).cgPath
        self.receiverView?.layer.shadowColor = UIColor.black.cgColor
        self.receiverView?.layer.shadowOpacity = 0.5
        self.receiverView?.layer.shadowOffset = CGSize(width: 10, height: 10)
        self.receiverView?.layer.shadowRadius = 1
        self.receiverView?.layer.masksToBounds = false*/
        
       self.receiverView?.layer.cornerRadius = 10
       self.receiverView?.clipsToBounds = true
      // self.receiverView?.backgroundColor = UIColor(patternImage: UIImage(named:"Alinan.png")!)
        
        self.senderView?.layer.cornerRadius = 10
        self.senderView?.clipsToBounds = true
        //self.senderView?.backgroundColor = UIColor(patternImage: UIImage(named:"Gonderilen.png")!)
 
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
