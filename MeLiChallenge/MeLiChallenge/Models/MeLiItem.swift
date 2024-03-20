//
//  MeLiItem.swift
//  MeLiChallenge
//
//  Created by InfinixSoft on 19/03/2024.
//

import Foundation

final class MeLiItem: NSObject, Decodable {
    
    var id:                 String?
    var title:              String?
    var confition:          String?
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
    
    enum CodingKeys: String, CodingKey {
        case id                 = "id"
        case title              = "title"
        case confition          = "condition"
        case thumbnailId        = "thumbnail_id"
        case catalogProductId   = "catalog_product_id"
        case listingTypeId      = "listing_type_id"
        case permalink          = "permalink"
        case buyingMode         = "buying_mode"
        case siteId             = "site_id"
        case categoryId         = "category_id"
        case domainId           = "domain_id"
        case thumbnail          = "thumbnail"
        case currencyId         = "currency_id"
        case orderBackend       = "order_backend"
        case price              = "price"
        case originalPrice      = "original_price"
        case salePrice          = "sale_price"
        case availableQuantity  = "available_quantity"
        case officialStoreId    = "official_store_id"
        case useThumbnailId     = "use_thumbnail_id"
        case acceptsMercadoPago = "accepts_mercadopago"
        case shipping           = "shipping"
        case stopTime           = "stop_time"
        case seller             = "seller"
        case attributes         = "attributes"
        case installments       = "installments"
        case winnerItemId       = "winner_item_id"
        case catalog_listing    = "catalog_listing"
        case discounts          = "discounts"
        case promotions         = "promotions"
        case inventoryId        = "inventory_id"
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
    }

    enum BuyMode: String {
        case buyItNow = "buy_it_now"
    }
    
    enum CurrencyId: String {
        case ars = "ARS"
    }
}

final class ItemShippingInfo: NSObject, Decodable {
    
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
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        storePickUp  = try container.decodeIfPresent(Bool.self, forKey: .storePickUp)
        freeShipping = try container.decodeIfPresent(Bool.self, forKey: .freeShipping)
        logisticType = try container.decodeIfPresent(String.self, forKey: .logisticType)
        mode         = try container.decodeIfPresent(String.self, forKey: .mode)
        tags         = try container.decodeIfPresent([String].self, forKey: .tags) ?? []
    }
}

final class ItemSeller: NSObject, Decodable {
    
    var id:       Int?
    var nickname: String?
    
    enum CodingKeys: String, CodingKey {
        case id       = "id"
        case nickname = "nickname"
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id       = try container.decodeIfPresent(Int.self, forKey: .id)
        nickname = try container.decodeIfPresent(String.self, forKey: .nickname)
    }
}

final class ItemAttribute: NSObject, Decodable {
    
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
    
    enum CodingKeys: String, CodingKey {
        case id                 = "id"
        case name               = "name"
        case valueId            = "value_id"
        case valueName          = "value_name"
        case attributeGroupId   = "attribute_group_id"
        case attributeGroupName = "attribute_group_name"
        case valueStruct        = "value_struct"
        case values             = "values"
        case source             = "source"
        case valueType          = "value_type"
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id                 = try container.decodeIfPresent(String.self, forKey: .id)
        name               = try container.decodeIfPresent(String.self, forKey: .name)
        valueId            = try container.decodeIfPresent(String.self, forKey: .valueId)
        valueName          = try container.decodeIfPresent(String.self, forKey: .valueName)
        attributeGroupId   = try container.decodeIfPresent(String.self, forKey: .attributeGroupId)
        attributeGroupName = try container.decodeIfPresent(String.self, forKey: .attributeGroupName)
    //    valueStruct:Object
    //    values:Array[1]
        source             = try container.decodeIfPresent(Int.self, forKey: .source)
        valueType          = try container.decodeIfPresent(String.self, forKey: .valueType)
    }
}

final class ItemInstallment: NSObject, Decodable {
    var quantity:   Int?
    var amount:     Double?
    var rate:       Double?
    var currencyId: String?
    
    enum CodingKeys: String, CodingKey {
        case quantity   = "quantity"
        case amount     = "amount"
        case rate       = "rate"
        case currencyId = "currency_id"
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        quantity   = try container.decodeIfPresent(Int.self, forKey: .quantity)
        amount     = try container.decodeIfPresent(Double.self, forKey: .amount)
        rate       = try container.decodeIfPresent(Double.self, forKey: .rate)
        currencyId = try container.decodeIfPresent(String.self, forKey: .currencyId)
    }
}
