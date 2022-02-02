//
//  LikeProtocol.swift
//  WhiteAndFluffy
//
//  Created by Егор Шкарин on 02.02.2022.
//

import Foundation

protocol LikeProtocol {
    var likeNotification:  Notification.Name { get }
    var unLikeNotification:  Notification.Name { get }
}

extension LikeProtocol {
    var likeNotification: Notification.Name {
        return Notification.Name(rawValue: "like")
    }
    var unLikeNotification: Notification.Name {
        return Notification.Name(rawValue: "unlike")
    }
}
