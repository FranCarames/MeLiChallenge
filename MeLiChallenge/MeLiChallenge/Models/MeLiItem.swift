//
//  MeLiItem.swift
//  MeLiChallenge
//
//  Created by InfinixSoft on 19/03/2024.
//

import Foundation
import ObjectMapper

final class MeLiItem: Mappable {
    
    var id:                 String?
    var title:              String?
    var condition:          String?
    var thumbnailId:        String?
    var catalogProductId:   String?
    var listingTypeId:      String?
    var permalink:          String?
    var buyingMode:         BuyMode?
    var siteId:             String?
    var categoryId:         String?
    var domainId:           String?
    var thumbnail:          String?
    var currencyId:         CurrencyId?
    var orderBackend:       Int?
    var price:              Int?
    var originalPrice:      Int?
    var salePrice:          Int?
    var availableQuantity:  Int?
    var officialStoreId:    String?
    var useThumbnailId:     Bool?
    var acceptsMercadoPago: Bool?
    var shipping:           ItemShippingInfo?
//var stopTime:"2042-12-08T04:00:00.000Z"
    var seller:             ItemSeller?
    var attributes:         [ItemAttribute] = []
    var installments:       ItemInstallment?
    var winnerItemId:       String?
    var catalog_listing:    Bool?
//    discounts:null
//    promotions:Array[0]
    var inventoryId:        String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        id                 <- map["id"]
        title              <- map["title"]
        condition          <- map["condition"]
        thumbnailId        <- map["thumbnail_id"]
        catalogProductId   <- map["catalog_product_id"]
        listingTypeId      <- map["listing_type_id"]
        permalink          <- map["permalink"]
        buyingMode         <- map["buying_mode"]
        siteId             <- map["site_id"]
        categoryId         <- map["category_id"]
        domainId           <- map["domain_id"]
        thumbnail          <- map["thumbnail"]
        currencyId         <- map["currency_id"]
        orderBackend       <- map["order_backend"]
        price              <- map["price"]
        originalPrice      <- map["original_price"]
        salePrice          <- map["sale_price"]
        availableQuantity  <- map[""]
        officialStoreId    <- map["official_store_id"]
        useThumbnailId     <- map["use_thumbnail_id"]
        acceptsMercadoPago <- map["accepts_mercadopago"]
        shipping           <- map["shipping"]
//var stopTime:"2042-12-08T04:00:00.000Z"       "stop_time"
        seller             <- map["seller"]
        attributes         <- map["attributes"]
        installments       <- map["installments"]
        winnerItemId       <- map["winner_item_id"]
        catalog_listing    <- map["catalog_listing"]
//        discounts          <- map["discounts"]
//        promotions         <- map["promotions"]
        inventoryId        <- map["inventory_id"]
    }

    enum BuyMode: String {
        case buyItNow = "buy_it_now"
    }
    
    enum CurrencyId: String {
        case ars = "ARS"
    }
}

final class ItemShippingInfo: Mappable {
    
    var storePickUp:  Bool?
    var freeShipping: Bool?
    var logisticType: String?
    var mode: String?
    var tags: [String] = []
//    var benefits: null
//    var promise: null
    
    enum CodingKeys: String, CodingKey {
        case storePickUp  = "store_pick_up"
        case freeShipping = "free_shipping"
        case logisticType = "logistic_type"
        case mode         = "mode"
        case tags         = "tags"
        case benefits     = "benefits"
        case promise      = "promise"
    }
    
    required init?(map: Map) {}

    func mapping(map: Map) {
        storePickUp  <- map["store_pick_up"]
        freeShipping <- map["free_shipping"]
        logisticType <- map["logistic_type"]
        mode         <- map["mode"]
        tags         <- map["tags"]
//        benefits     <- map["benefits"]
//        promise      <- map["promise"]
    }
}

final class ItemSeller: Mappable {
    
    var id:       Int?
    var nickname: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id       <- map["id"]
        nickname <- map["nickname"]
    }
}

final class ItemAttribute: Mappable {
    
    var id:                 String?
    var name:               String?
    var valueId:            String?
    var valueName:          String?
    var attributeGroupId:   String?
    var attributeGroupName: String?
//    valueStruct:Object
//    values:Array[1]
    var source:             Int?
    var valueType:          String?
    
    required init?(map: Map) {}

    func mapping(map: Map) {
        id   <- map["id"]
        name <- map["name"]
        
        id                 <- map["id"]
        name               <- map["name"]
        valueId            <- map["value_id"]
        valueName          <- map["value_name"]
        attributeGroupId   <- map["attribute_group_id"]
        attributeGroupName <- map["attribute_group_name"]
//        valueStruct        <- map["value_struct"]
//        values             <- map["values"]
        source             <- map["source"]
        valueType          <- map["value_type"]
    }
}

final class ItemInstallment: Mappable {
    var quantity:   Int?
    var amount:     Double?
    var rate:       Double?
    var currencyId: String?
    
    required init?(map: Map) {}

    func mapping(map: Map) {
        quantity   <- map["quantity"]
        amount     <- map["amount"]
        rate       <- map["rate"]
        currencyId <- map["currency_id"]
    }
}
