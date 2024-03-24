//
//  Cosmos+Settings.swift
//  MeLiChallenge
//
//  Created by InfinixSoft on 24/03/2024.
//

import Cosmos

extension CosmosSettings {
    static func setupSettings() -> CosmosSettings {
        var settings = CosmosSettings()

//        settings.emptyImage = #imageLiteral(resourceName: "emptyStarIcon").withRenderingMode(.alwaysOriginal)
//        settings.filledImage =  #imageLiteral(resourceName: "starIcon").withRenderingMode(.alwaysOriginal)
        
        settings.emptyBorderWidth  = 1
        settings.filledBorderWidth = 1
        settings.starSize = 20
        settings.starMargin = 5
        settings.fillMode = .half
        settings.filledColor = .app
        settings.filledBorderColor = .app
        settings.emptyBorderColor = .app

        return settings
    }
}

final class CosmosCustomView: CosmosView {
    override func awakeFromNib() {
        super.awakeFromNib()
        settings = .setupSettings()
        rating = 5
    }
}

