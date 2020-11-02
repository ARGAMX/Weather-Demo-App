//
//  Town.swift
//  Weather
//
//  Created by Artem Argus Gusakov on 28.10.2020.
//  Copyright © 2020 PhilosophyIT. All rights reserved.
//


class Town: MappableObject {
    var id: Int = 0
    var name: String = ""
    
    convenience init(id: Int, name: String) {
        self.init()
        self.id = id
        self.name = name
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}


extension Town: TemperaturableTown {
    var temperature: String {
        return Constants.unknownTemp
    }
    var country: String {
        return Constants.unknownTemp
    }
    var iconUrl: String? {
        return nil
    }
}
