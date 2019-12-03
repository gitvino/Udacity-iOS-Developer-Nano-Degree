//
//  GCDBlackBox.swift
//  On The Map
//
//  Created by Vinoth kumar on 25/3/18.
//  Copyright © 2018 Vinoth kumar. All rights reserved.
//

import Foundation

func performUIUpdates (_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
