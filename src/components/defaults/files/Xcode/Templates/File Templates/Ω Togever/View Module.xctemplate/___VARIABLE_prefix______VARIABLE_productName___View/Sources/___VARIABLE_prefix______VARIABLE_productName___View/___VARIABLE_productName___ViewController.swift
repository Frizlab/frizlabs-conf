//___FILEHEADER___

import Combine
import Foundation
import UIKit



@MainActor
public final class ___FILEBASENAMEASIDENTIFIER___ : UIViewController {
	
	public static func instantiate(viewModel: ___VARIABLE_productName___ViewModel, coordinator: ___VARIABLE_productName___Coordinator) -> ___FILEBASENAMEASIDENTIFIER___ {
		return UIStoryboard(name: "___FILEBASENAMEASIDENTIFIER___", bundle: .module)
			.instantiateInitialViewController{ coder in
				___FILEBASENAMEASIDENTIFIER___(coder: coder, viewModel: viewModel, coordinator: coordinator)
			}!
	}
	
	public let viewModel: ___VARIABLE_productName___ViewModel
	public private(set) weak var coordinator: ___VARIABLE_productName___Coordinator?
	
	public init?(coder: NSCoder, viewModel: ___VARIABLE_productName___ViewModel, coordinator: ___VARIABLE_productName___Coordinator?) {
		self.viewModel = viewModel
		self.coordinator = coordinator
		
		super.init(coder: coder)
	}
	
	public required init?(coder: NSCoder) {
		return nil
	}
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		
		bindModel()
	}
	
	/* ***************
	   MARK: - Private
	   *************** */
	
	private var observers = Set<AnyCancellable>()
	
	private func bindModel() {
	}
	
}
