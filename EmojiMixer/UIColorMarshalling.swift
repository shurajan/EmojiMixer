//
//  UIColorMarshalling.swift
//  EmojiMixer
//
//  Created by Alexander Bralnin on 22.10.2024.
//

import UIKit

import UIKit

extension UIColor {
    // Метод для преобразования UIColor в hex-строку
    func toHexString() -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        // Получаем компоненты цвета
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // Преобразуем компоненты в hex-строку
        let hexString = String(format: "#%02X%02X%02X",
                               Int(red * 255),
                               Int(green * 255),
                               Int(blue * 255))
        return hexString
    }
    
    convenience init?(hex: String) {
        var hexFormatted = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        // Удаляем "#" если он присутствует
        if hexFormatted.hasPrefix("#") {
            hexFormatted.remove(at: hexFormatted.startIndex)
        }
        
        guard hexFormatted.count == 6 else { return nil }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue >> 16) & 0xFF) / 255.0
        let green = CGFloat((rgbValue >> 8) & 0xFF) / 255.0
        let blue = CGFloat(rgbValue & 0xFF) / 255.0
        
        // Инициализация UIColor
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
