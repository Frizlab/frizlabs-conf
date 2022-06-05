//___FILEHEADER___

import Foundation
import os.log
import UIKit



//@MainActor
@IBDesignable
public final class ___FILEBASENAMEASIDENTIFIER___ : UIView, UIContentView {
	
	public var configuration: UIContentConfiguration {
		didSet {
			guard let viewModel = configuration as? ___VARIABLE_productName:identifier___Config,
					viewModel != oldValue as? ___VARIABLE_productName:identifier___Config
			else {
				return
			}
			
			applyViewModel(viewModel)
		}
	}
	
	/** Convenience accessor to the view model (simple cast of the `configuration` to `___VARIABLE_productName:identifier___Config`). */
	public var viewModel: ___VARIABLE_productName:identifier___Config? {
		configuration as? ___VARIABLE_productName:identifier___Config
	}
	
	public init(configuration: ___VARIABLE_productName:identifier___Config) {
		self.configuration = configuration
		
		/* We must init with a big enough frame or we make some constraint fail… */
		super.init(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
		
		loadFromXib()
		didLoad(configuration)
	}
	
	public required init?(coder: NSCoder) {
		return nil
	}
	
	/* ***************
	   MARK: - Private
	   *************** */
	
	private func didLoad(_ viewModel: ___VARIABLE_productName:identifier___Config) {
		/* Do one-time configs here after view is loaded. */
		
		/* Update views from model. */
		applyViewModel(viewModel)
	}
	
	private func applyViewModel(_ viewModel: ___VARIABLE_productName:identifier___Config) {
#warning("Non-implemented method from template.")
	}
	
}
