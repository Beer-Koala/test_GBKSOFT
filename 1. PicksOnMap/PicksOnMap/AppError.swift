//
//  AppError.swift
//  PicksOnMap
//
//  Created by BeerKoala on 6/15/19.
//  Copyright © 2019 a.kryvchykov. All rights reserved.
//

import Foundation

enum AppError: String, Error {
    case googleAuthError = "Ошибка авторизации Google"
    case authError = "Ошибка авторизации"
    case logoutError = "Ошибка деавторизации"
    case locationError = "Ошибка получения местоположения"
}
