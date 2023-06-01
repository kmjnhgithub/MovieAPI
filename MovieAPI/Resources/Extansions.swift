//
//  Extansions.swift
//  NetflixClone
//
//  Created by mike liu on 2023/5/29.
//

import Foundation


extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
