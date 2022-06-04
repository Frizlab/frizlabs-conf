//___FILEHEADER___

import Foundation
import UIKit

import CoordinatorProtocol
import PWZeXtenderZ

import ___VARIABLE_prefix______VARIABLE_productName___View



@MainActor
final class ___FILEBASENAMEASIDENTIFIER___ : ___VARIABLE_prefix______VARIABLE_productName___View.___FILEBASENAMEASIDENTIFIER___ {
	
	let navigationController: UINavigationController
	private(set) weak var parentCoordinator: ParentCoordinator?
	
	init(_ navigationController: UINavigationController, parentCoordinator: ParentCoordinator?) {
		self.parentCoordinator = parentCoordinator
		self.navigationController = navigationController
	}
	
	func start(animated: Bool) {
		let viewController = ___VARIABLE_productName___ViewController.instantiate(viewModel: ___VARIABLE_productName___ViewModel(), coordinator: self)
		viewController.hpn_add(DismissedCallbackVCE{ [weak self] _ in self.flatMap{ $0.parentCoordinator?.childDidEnd($0) } })
		
		navigationController.pushViewController(viewController, animated: animated)
		viewController.refreshTitle()
	}
	
	func forceEndPresentations(animated: Bool, _ completionHandler: @escaping () -> Void) {
		forceEndChildrenPresentations([/*no child for now*/], animated: animated, completionHandler: {
			/* Nothing to do yet. */
			completionHandler()
		})
	}
	
}
