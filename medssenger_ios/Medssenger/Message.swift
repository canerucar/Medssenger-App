import Foundation
import Firebase

class Message {
    var text: String = ""
    var data: Double = 0.0
    var gonderici: String = ""
    
    init(text: String, data: Double, gonderici: String) {
        self.text = text
        self.data = data
        self.gonderici = gonderici
    }
    
    init(data: [String:Any]){
        self.text = data["mesajText"] as! String
        self.data = data["zaman"] as! Double
        self.gonderici = data["gonderici"] as! String
    }
    
    func aAnyObject() -> [String: Any]{
        return ["mesajText": text, "zaman": data, "gonderici": gonderici]
    }
    
}
