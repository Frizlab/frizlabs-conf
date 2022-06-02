/*
 * RootViewModel.swift
 * Togever Pro
 *
 * Created by François Lamboley on 2021/11/16.
 * Copyright © 2021 Togever. All rights reserved.
 */

import Combine
import Foundation



@MainActor
public protocol RootViewModel {
	
	var isPureConnectorConnected: AnyPublisher<Bool, Never> {get}
	
}
