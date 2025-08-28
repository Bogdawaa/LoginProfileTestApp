//
//  ProfileModel.swift
//  LoginProfileTestApp
//
//  Created by Bogdan Fartdinov on 22.08.2025.
//

struct Profile {
    let firstName: String
    let lastName: String
    let groupName: String
    let email: String
    let serviceName: String
    let login: String
    let groupTag: String
    let isAdmin: Bool
    let languageCode: String
    let serviceTypes: [String]
    let isTerminal: Bool
    let points: [ServicePoint]
}

struct ServicePoint {
    let airport: String
    let isClear: Bool
    let descriptionShort: String
    let isMultipleSessionEnabled: Bool
    let photoPaths: [String]
    let pointId: Int
    let pointId1C: String
    let pointName: String
    let products: [Product]
    let type: String
    
    var shortPointName: String {
        if let firstPart = pointName.split(separator: ",").first {
            return String(firstPart).trimmingCharacters(in: .whitespaces)
        }
        return pointName
    }
}

struct Product {
    let isActive: Bool
    let locale: String
    let name: String
    let offlinePrice: Int
    let onlinePrice: Int
    let productId: Int
}

// MARK: - Mapping from DTO
extension Profile {
    init(from dto: ProfileResponseDTO) {
        let profileDTO = dto.data?.profile
        
        self.firstName = profileDTO?.firstName ?? ""
        self.lastName = profileDTO?.lastName ?? ""
        self.groupName = profileDTO?.groupName ?? ""
        self.email = profileDTO?.email ?? ""
        self.login = profileDTO?.login ?? ""
        self.groupTag = profileDTO?.groupTag ?? ""
        self.isAdmin = profileDTO?.isAdmin ?? false
        self.languageCode = profileDTO?.languageCode ?? "ru"
        self.serviceTypes = profileDTO?.serviceType ?? []
        self.isTerminal = profileDTO?.terminal ?? false
        self.points = profileDTO?.points?.map { ServicePoint(from: $0) } ?? []
        self.serviceName = self.points.first?.shortPointName ?? "Не известно"
    }
}

extension ServicePoint {
    init(from dto: ServicePointDTO) {
        self.airport = dto.airport
        self.isClear = dto.isClear != 0
        self.descriptionShort = dto.descriptionShort
        self.isMultipleSessionEnabled = dto.multipleSessionEnable?.lowercased() == "true"
        self.photoPaths = dto.photoPath
        self.pointId = dto.pointId
        self.pointId1C = dto.pointId1C
        self.pointName = dto.pointName
        self.products = dto.products.map { Product(from: $0) }
        self.type = dto.type
    }
}

extension Product {
    init(from dto: ProductDTO) {
        self.isActive = dto.active
        self.locale = dto.locale
        self.name = dto.name
        self.offlinePrice = dto.offlinePrice
        self.onlinePrice = dto.onlinePrice
        self.productId = dto.productId
    }
}

// MARK: - Mock Data
extension Profile {
    static var mock: Profile {
        return Profile(
            firstName: "Иван",
            lastName: "Петров",
            groupName: "Оператор",
            email: "test@mail.com",
            serviceName: "Бизнес зал",
            login: "test_ios",
            groupTag: "1",
            isAdmin: false,
            languageCode: "ru",
            serviceTypes: [],
            isTerminal: true,
            points: [ServicePoint.mock]
        )
    }
}

extension ServicePoint {
    static var mock: ServicePoint {
        return ServicePoint(
            airport: "SVO",
            isClear: true,
            descriptionShort: "Бизнес зал",
            isMultipleSessionEnabled: false,
            photoPaths: [],
            pointId: 1,
            pointId1C: "123",
            pointName: "Бизнес зал",
            products: [Product.mock],
            type: "business"
        )
    }
}

extension Product {
    static var mock: Product {
        return Product(
            isActive: true,
            locale: "ru",
            name: "Product name",
            offlinePrice: 1,
            onlinePrice: 1,
            productId: 1
        )
    }
}
