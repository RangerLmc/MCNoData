//
//  UIColor+mc.swift
//  MCNoData
//
//  Created by zc_mc on 2021/9/14.
//

import UIKit

public extension UIColor {
    /// 根据整形RGBA值返回颜色
    ///
    /// - Parameters:
    ///   - red: 取值范围 0-255
    ///   - green: 取值范围 0-255
    ///   - blue: 取值范围 0-255
    ///   - alpha: 取值范围 0-255 默认为255
    convenience init?(red: Int, green: Int, blue: Int, alpha: Int = 255) {
        guard red >= 0, red <= 255,
              green >= 0, green <= 255,
              blue >= 0, blue <= 255,
              alpha >= 0, alpha <= 255 else { return nil }

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha) / 255.0)
    }

    /// 根据16进制颜色值返回颜色
    ///
    /// 格式如：#RGB #RGBA #RRGGBB #GRRGGBBAA 0xRGB 0xRGBA...等
    ///
    /// 字符串前缀 ‘#’ 和 ‘0x’ 不是必须的
    ///
    /// 如果未制定 alpha 则默认为 1;
    ///
    /// 如果发生了任何错误则返回nil
    ///
    /// - Parameter hexString: 颜色值字符串
    convenience init?(_ hexString: String, _ alpha: CGFloat = 1.0) {
        var str = ""
        if hexString.lowercased().hasPrefix("0x") {
            str = hexString.replacingOccurrences(of: "0x", with: "")
        } else if hexString.lowercased().hasPrefix("#") {
            str = hexString.replacingOccurrences(of: "#", with: "")
        } else {
            str = hexString
        }

        let length = str.count
        // 如果不是 RGB RGBA RRGGBB RRGGBBAA 结构
        if length != 3 && length != 4 && length != 6 && length != 8 {
            return nil
        }

        // 将 RGB RGBA 转换为 RRGGBB RRGGBBAA 结构
        if length < 5 {
            var tStr = ""
            str.forEach { tStr.append(String(repeating: $0, count: 2)) }
            str = tStr
        }

        guard let hexValue = Int(str, radix: 16) else { return nil }

        var calpha = 255 * alpha
        var red = 0
        var green = 0
        var blue = 0

        if length == 3 || length == 6 {
            red = (hexValue >> 16) & 0xFF
            green = (hexValue >> 8) & 0xFF
            blue = hexValue & 0xFF
        } else {
            red = (hexValue >> 20) & 0xFF
            green = (hexValue >> 16) & 0xFF
            blue = (hexValue >> 8) & 0xFF
            calpha = CGFloat(hexValue & 0xFF)
        }

        self.init(red: red, green: green, blue: blue, alpha: Int(calpha))
    }
    
    // 透明度设置
    func alhpa(_ value: CGFloat) -> UIColor {
         self.withAlphaComponent(value)
    }
}
