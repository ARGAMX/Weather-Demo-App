//
//  UIColor+Extensions.swift
//

import UIKit

extension UIColor {
	
	convenience init(hexString: String) {
		let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
		var int = UInt32()
		Scanner(string: hex).scanHexInt32(&int)
		let a, r, g, b: UInt32
		switch hex.count {
		case 3: // RGB (12-bit)
			(a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
		case 6: // RGB (24-bit)
			(a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
		case 8: // ARGB (32-bit)
			(a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
		default:
			(a, r, g, b) = (255, 0, 0, 0)
		}
		self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
	}
    
    convenience init(decimalRed r: Int, decimalGreen g: Int, decimalBlue b: Int, decimalAlpha a: Int = 255) {
            self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var r:CGFloat=0, g:CGFloat=0, b:CGFloat=0, a:CGFloat=0;
        if(self.getRed(&r, green: &g, blue: &b, alpha: &a)){
            return UIColor(red: min(r + percentage/100, 1.0),
                           green: min(g + percentage/100, 1.0),
                           blue: min(b + percentage/100, 1.0),
                           alpha: a)
        }else{
            return nil
        }
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format:"#%06x", rgb)
    }
    
    @nonobjc static var mtCollectionHeaderBackgroundColor: UIColor {
        return mtGrayLightColor07
    }
        
    @nonobjc static var mtThemeColorOld: UIColor {
        return #colorLiteral(red: 0.9803921569, green: 0.4, blue: 0, alpha: 1) // FA6600
    }
    
    @nonobjc static var mtThemeColor: UIColor {
        return #colorLiteral(red: 0.9529411765, green: 0.4392156863, blue: 0.1294117647, alpha: 1) // F37021
    }
    
    @nonobjc static var mtThemeDeepColor: UIColor {
        return #colorLiteral(red: 0.9333333333, green: 0.3254901961, blue: 0, alpha: 1) // EE5300
    }
    
    @nonobjc static var mtTriggerColor: UIColor {
        return #colorLiteral(red: 0.07450980392, green: 0.7058823529, blue: 0.9960784314, alpha: 1) // 13B4FE
    }
    
    @nonobjc static var mtIndicatorActivatedColor: UIColor {
        return #colorLiteral(red: 0.5882352941, green: 0.7450980392, blue: 0.1176470588, alpha: 1) // 96BE1E
    }
    
    @nonobjc static var mtIndicatorDeactivatedColor: UIColor {
        return #colorLiteral(red: 0.9411764706, green: 0.1137254902, blue: 0.07058823529, alpha: 1) // F01D12
    }
    
    @nonobjc static var mtTextColor: UIColor {
        return #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1176470588, alpha: 1) // 1E1E1E
    }
    
    @nonobjc static var mtGrayDarkColor01: UIColor {
        return #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 1) // 2F2F2F
    }
    
    @nonobjc static var mtAdditionalTextColor: UIColor {
        return #colorLiteral(red: 0.431372549, green: 0.431372549, blue: 0.431372549, alpha: 1) // 6E6E6E
    }
    
    @nonobjc static var mtGrayColor02: UIColor {
        return #colorLiteral(red: 0.568627451, green: 0.568627451, blue: 0.568627451, alpha: 1) // 919191
    }
    
    @nonobjc static var mtGrayColor03: UIColor {
        return #colorLiteral(red: 0.6196078431, green: 0.6196078431, blue: 0.6196078431, alpha: 1) // 9E9E9E
    }
    
    @nonobjc static var mtGrayColor04: UIColor {
        return #colorLiteral(red: 0.6274509804, green: 0.6745098039, blue: 0.6941176471, alpha: 1) // A0ACB1
    }
    
    @nonobjc static var mtGrayLightColor05: UIColor {
        return #colorLiteral(red: 0.7843137255, green: 0.7843137255, blue: 0.7843137255, alpha: 1) // C8C8C8
    }
    
    @nonobjc static var mtGrayLightColor06: UIColor {
        return #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1) // D8D8D8
    }
    
    @nonobjc static var mtGrayLightColor07: UIColor {
        return #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1) // F0F0F0
    }

    @nonobjc static var mtGrayLightColor08: UIColor {
        return #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9411764706, alpha: 1) // F2F2F0
    }
    
    @nonobjc static var mtTextWhiteColor: UIColor {
        return .white
    }

}
