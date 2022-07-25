//___FILEHEADER___

import Foundation
import UIKit



struct ___FILEBASENAMEASIDENTIFIER___ : Equatable, UIContentConfiguration {
	
	init() {
	}
	
	func makeContentView() -> UIView & UIContentView {
		___VARIABLE_productName:identifier___View(configuration: self)
	}
	
	func updated(for state: UIConfigurationState) -> ___FILEBASENAMEASIDENTIFIER___ {
//		if let cellState = state as? UICellConfigurationState {
//			var res = self
//			res.scale = (cellState.isHighlighted || cellState.isSelected ? 0.95 : 1)
//			return res
//		}
		return self
	}
	
}
