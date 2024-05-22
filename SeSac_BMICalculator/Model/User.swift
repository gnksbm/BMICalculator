//
//  User.swift
//  SeSac_BMICalculator
//
//  Created by gnksbm on 5/22/24.
//

import Foundation

struct User: Codable {
    let name: String?
    let weight: Double?
    let height: Double?
}

extension User {
    private static let userDefaultsKey: String = "user"
    
    static func fetchUser() -> User? {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey)
        else {
            print("저장된 유저 정보가 없음")
            return nil
        }
        do {
            return try JSONDecoder().decode(Self.self, from: data)
        } catch {
            print(
                String(describing: self),
                "디코딩 에러: \(error.localizedDescription)"
            )
            return nil
        }
    }
    
    static func removeUser() {
        UserDefaults.standard.removeObject(forKey: Self.userDefaultsKey)
    }
    
    static func saveUser(user: Self) {
        do {
            let data = try JSONEncoder().encode(user)
            UserDefaults.standard.set(data, forKey: Self.userDefaultsKey)
        } catch {
            print(
                String(describing: self),
                "인코딩 에러: \(error.localizedDescription)"
            )
        }
    }
    
    static func updateUser(
        newName: String?
    ) {
        let savedUser = fetchUser()
        saveUser(
            user: .init(
                name: newName,
                weight: savedUser?.weight,
                height: savedUser?.height
            )
        )
    }
    
    static func updateUser(
        newWeight: Double,
        newHeight: Double
    ) {
        let savedUser = fetchUser()
        saveUser(
            user: .init(
                name: savedUser?.name,
                weight: newWeight,
                height: newHeight
            )
        )
    }
}
