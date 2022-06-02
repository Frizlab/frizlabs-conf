/*
 * RootCoordinator.swift
 * Togever Pro
 *
 * Created by François Lamboley on 2021/11/14.
 * Copyright © 2021 Togever. All rights reserved.
 */

import Foundation

import CoordinatorProtocol



@MainActor
public protocol RootCoordinator : Coordinator {
	
	/** If this is called, the previous state was logged out, except if it is the initial call to `didLogin`/`didLogout`. */
	func didLogin(_ rootViewController: RootViewController)
	/** If this is called, the previous state was logged in, except if it is the initial call to `didLogin`/`didLogout`. */
	func didLogout(_ rootViewController: RootViewController)
	
}
