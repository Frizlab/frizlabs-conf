/*
 * RootViewController.swift
 * Togever Pro
 *
 * Created by François Lamboley on 2021/11/13.
 * Copyright © 2021 Togever. All rights reserved.
 */

import Combine
import Foundation
import UIKit



@MainActor
public final class RootViewController : UITabBarController {
	
	public let viewModel: RootViewModel
	public private(set) weak var coordinator: RootCoordinator?
	
	public init(viewModel: RootViewModel, coordinator: RootCoordinator?) {
		self.viewModel = viewModel
		self.coordinator = coordinator
		
		super.init(nibName: nil, bundle: nil)
		
		viewModel.isPureConnectorConnected
			.removeDuplicates()
			.receive(on: DispatchQueue.main)
			.sink{ [weak self] isConnected in
				guard let self = self else {return}
				if isConnected {self.coordinator?.didLogin(self)}
				else           {self.coordinator?.didLogout(self)}
			}
			.store(in: &observers)
	}
	
	public required init?(coder: NSCoder) {
		return nil
	}
	
	private var observers = Set<AnyCancellable>()
	
}
