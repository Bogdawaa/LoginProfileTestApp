//
//  ProfileModel.swift
//  LoginProfileTestApp
//
//  Created by Bogdan Fartdinov on 22.08.2025.
//

struct Profile {
    let firstName: String
    let lastName: String
    let position: String
    let email: String
    let serviceName: String
    let login: String
}

extension Profile {
    static var mock: Profile {
        return Profile(
            firstName: "Tom",
            lastName: "Cruise",
            position: "Qwe",
            email: "qwee@mail.com",
            serviceName: "business",
            login: "test"
        )
    }
}
