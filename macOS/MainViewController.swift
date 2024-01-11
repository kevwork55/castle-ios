//
//  MainViewController.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 6/16/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import Cocoa
import SwiftUI

class MainViewController: NSViewController {

	// interface
	@IBOutlet weak var detailView: NSView!
	@IBOutlet weak var sidebarView: NSView!
	@IBOutlet weak var toolbarView: NSView!

	// MARK: - NSViewController

	override func viewDidLoad() {
		super.viewDidLoad()

		detailView.additionalSafeAreaInsets = NSEdgeInsets(top: 22, left: 0, bottom: 0, right: 0)
		swapView(in: sidebarView, with: NSHostingView(rootView: SidebarView(controller: self)))
//		swapView(in: toolbarView, with: NSHostingView(rootView: ToolbarView()))
		swapView(in: detailView, with: NSHostingView(rootView: HomeView()))
	}

	override func viewDidAppear() {
		super.viewDidAppear()
		self.view.window?.isMovableByWindowBackground = true
	}

	// MARK: - Public

	func showControllerSettings(product: Product, settingGroup: SettingGroup) {
		// TODO: don't create the value set here
		let valueSet = settingGroup.createDefaultValueSet()

		let hostingView = NSHostingView(rootView: DetailTwoPaneView(pane1: {
			ControllerSettingsSections(product: product, settingGroup: settingGroup)
		}, pane2: {
			ControllerSettingsView(product: product, settingGroup: settingGroup, valueSet: valueSet)
		}))
		swapView(in: detailView, with: hostingView)

//		swapView(in: detailView, with: NSHostingView(rootView: ControllerSettingsView(product: product, settingGroup: settingGroup, valueSet: valueSet)))
	}

	func showDemoMode() {
		swapView(in: detailView, with: NSHostingView(rootView: DemoModeView(controller: self)))
	}

	func showLinkController() {
		swapView(in: detailView, with: NSHostingView(rootView: LinkControllerView()))
	}

	// MARK: - Private

	private func swapView(in parent: NSView, with view: NSView) {
		// remove the current subviews
		for subview in parent.subviews {
			subview.removeFromSuperview()
		}

		// setup the child view
		view.frame = parent.bounds
		view.autoresizingMask = [.height, .width]
		view.translatesAutoresizingMaskIntoConstraints = true
		parent.addSubview(view)
	}

}
