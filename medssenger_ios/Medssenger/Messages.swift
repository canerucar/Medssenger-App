//
//  Conversazione.swift
//  WhatsChatFede
//
//  Created by Federico Milani on 06/11/16.
//  Copyright © 2016 iFede94. All rights reserved.
//

import Foundation

class Conversazione {
    var chiave: String = ""
    var utente1: String = ""
    var utente2: String = ""
    var nomeUtente: String = ""
    var messaggi: [Messaggio] = []
    
    init(chiave: String, utente1: String, utente2: String, messaggi: [Messaggio] = [], nomeUtente: String = "") {
        self.chiave = chiave
        self.utente1 = utente1
        self.utente2 = utente2
        self.messaggi = messaggi
        self.nomeUtente = nomeUtente
    }
    
    func aAnyObject() -> [String: Any] {
        return ["utente1": utente1, "utente2": utente2, "nomeUtente": nomeUtente]
    }
    
}

