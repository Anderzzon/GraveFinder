//
//  ComplianceViewModel.swift
//  GraveFinder
//
//  Created by Alessio on 2020-12-21.
//

import SwiftUI
import CryptoKit

class ComplianceViewModel {

    private let key:SymmetricKey
    
    init(){
        key = ComplianceViewModel.createKeyFromPassword("SuperDuperAwesomeSecretPassword")
    }
    
    func encrypt(string:String) -> Data? {
        let dataToEncrypt = string.data(using: .utf8)!
        let sealedBox = try? ChaChaPoly.seal(dataToEncrypt, using: key)
        return sealedBox?.combined
    }
    
    func decrypt(data:Data) -> String? {
        if let sealedBox = try? ChaChaPoly.SealedBox(combined: data),
           let decrypted = try? ChaChaPoly.open(sealedBox, using: key) {
            return String(decoding: decrypted, as: UTF8.self)
        }
        return nil
    }
    static func createKeyFromPassword(_ password: String) -> SymmetricKey {
      let hash = SHA256.hash(data: password.data(using: .utf8)!)
      let hashString = hash.map { String(format: "%02hhx", $0) }.joined()
      let subString = String(hashString.prefix(32))
      let keyData = subString.data(using: .utf8)!

      return SymmetricKey(data: keyData)
    }
}
