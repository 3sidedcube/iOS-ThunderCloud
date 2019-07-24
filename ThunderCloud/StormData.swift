//
//  StormData.swift
//  ThunderCloud
//
//  Created by Ryan Bourne on 08/03/2018.
//  Copyright © 2018 threesidedcube. All rights reserved.
//

import Foundation

/// StormData (i.e., data we receive from Storm) should be in this format - a key relating to a particular value).
/// This value could be anything - string, int, bool, more StormData - so it's left as any.
/// Hopefully this can help make everything more Swifty ;)
public typealias StormData = [AnyHashable: Any]
