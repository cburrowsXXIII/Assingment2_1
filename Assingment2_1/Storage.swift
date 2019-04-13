//
//  Storage.swift
//  Assingment2_1
//
//  Created by Christopher Burrows on 13/4/19.
//  Copyright © 2019 Christopher Burrows. All rights reserved.
//

import Foundation

class Storage {
    static let shared: Storage = Storage()
    
    var objects: [Place]
    
    private init(){
        objects = [Place]()
    }
}
