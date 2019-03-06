

import Foundation
import Firebase

class Messaggio {
    var testo: String = ""
    var data: Double = 0.0
    var utente: String = ""
    
    init(testo: String, data: Double, utente: String) {
        self.testo = testo
        self.data = data
        self.utente = utente
    }
    
    init(dati: [String:Any]){
        self.testo = dati["testo"] as! String
        self.data = dati["data"] as! Double
        self.utente = dati["utente"] as! String
    }
    
    func aAnyObject() -> [String: Any]{
        return ["testo": testo, "data": data, "utente": utente]
    }
    
}

