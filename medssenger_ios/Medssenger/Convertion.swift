import Foundation

class Conversazione {
    var key: String = ""
    var kullanici: String = ""
    var kullanici2: String = ""
    var usurname: String = ""
    var message: [Message] = []
    
    init(key: String, kullanici: String, kullanici2: String, message: [Message] = [], usurname: String = "") {
        self.key = key
        self.kullanici = kullanici
        self.kullanici2 = kullanici2
        self.message = message
        self.usurname = usurname
    }
    
    func aAnyObject() -> [String: Any] {
        return ["kullanici": kullanici, "kullanici2": kullanici2, "usurname": usurname]
    }
    
}
