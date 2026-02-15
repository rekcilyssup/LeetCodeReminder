//
//  StatusBarController.swift
//  LeetCodeReminder
//
//  Created on Feb 15, 2026
//

import AppKit
import SwiftUI
import Combine

// MARK: - Floating Panel (like Raycast)
class FloatingPanel: NSPanel {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }
    
    init(contentRect: NSRect) {
        super.init(
            contentRect: contentRect,
            styleMask: [.nonactivatingPanel, .fullSizeContentView, .borderless],
            backing: .buffered,
            defer: false
        )
        
        isFloatingPanel = true
        level = .popUpMenu
        isOpaque = false
        backgroundColor = .clear
        hasShadow = true
        titleVisibility = .hidden
        titlebarAppearsTransparent = true
        isMovableByWindowBackground = false
        hidesOnDeactivate = false
        animationBehavior = .utilityWindow
        collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
    }
}

// MARK: - Status Bar Controller
class StatusBarController: NSObject {
    private var statusItem: NSStatusItem!
    private var panel: FloatingPanel!
    private var leetCodeService: LeetCodeService
    private var cancellables = Set<AnyCancellable>()
    private var clickOutsideMonitor: Any?
    
    override init() {
        leetCodeService = LeetCodeService()
        super.init()
        
        setupStatusItem()
        setupPanel()
        setupObservers()
        
        leetCodeService.fetchAllData()
        
        // Refresh every 5 minutes
        Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { [weak self] _ in
            self?.leetCodeService.fetchAllData()
        }
    }
    
    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            button.title = "●"
            button.target = self
            button.action = #selector(togglePanel)
        }
    }
    
    private func setupPanel() {
        let panelWidth: CGFloat = 320
        let panelHeight: CGFloat = 400
        
        panel = FloatingPanel(contentRect: NSRect(x: 0, y: 0, width: panelWidth, height: panelHeight))
        
        let hostingView = NSHostingView(
            rootView: MenuBarView(service: leetCodeService)
                .frame(width: panelWidth)
        )
        
        // Let the hosting view size itself to fit content
        let fittingSize = hostingView.fittingSize
        let finalHeight = max(fittingSize.height, panelHeight)
        
        // Wrap in a visual effect view for vibrancy (like Raycast)
        let visualEffect = NSVisualEffectView()
        visualEffect.material = .hudWindow
        visualEffect.state = .active
        visualEffect.blendingMode = .behindWindow
        visualEffect.wantsLayer = true
        visualEffect.layer?.cornerRadius = 12
        visualEffect.layer?.masksToBounds = true
        
        hostingView.frame = NSRect(x: 0, y: 0, width: panelWidth, height: finalHeight)
        visualEffect.frame = hostingView.frame
        visualEffect.addSubview(hostingView)
        
        panel.setContentSize(NSSize(width: panelWidth, height: finalHeight))
        panel.contentView = visualEffect
        panel.contentView?.wantsLayer = true
        panel.contentView?.layer?.cornerRadius = 12
        panel.contentView?.layer?.masksToBounds = true
    }
    
    private func setupObservers() {
        Publishers.CombineLatest(
            leetCodeService.$userStatus,
            leetCodeService.$isLoading
        )
        .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
        .receive(on: DispatchQueue.main)
        .sink { [weak self] status, _ in
            self?.updateStatusIcon(status: status)
        }
        .store(in: &cancellables)
    }
    
    private func updateStatusIcon(status: UserStatus?) {
        guard let button = statusItem.button else { return }
        
        if let status = status {
            let color: NSColor = status.dailyProblemCompleted ? .systemGreen : .systemRed
            let attrs: [NSAttributedString.Key: Any] = [
                .foregroundColor: color,
                .font: NSFont.systemFont(ofSize: 16, weight: .bold)
            ]
            button.attributedTitle = NSAttributedString(string: "●", attributes: attrs)
        }
    }
    
    @objc private func togglePanel() {
        if panel.isVisible {
            hidePanel()
        } else {
            showPanel()
        }
    }
    
    private func showPanel() {
        guard let button = statusItem.button,
              let buttonWindow = button.window else { return }
        
        let buttonFrame = buttonWindow.convertToScreen(button.convert(button.bounds, to: nil))
        let panelWidth = panel.frame.width
        let panelHeight = panel.frame.height
        
        // Position below the menu bar icon, centered
        let x = buttonFrame.midX - panelWidth / 2
        let y = buttonFrame.minY - panelHeight - 4
        
        panel.setFrameOrigin(NSPoint(x: x, y: y))
        
        // Activate the app so the panel can receive events
        NSApp.activate(ignoringOtherApps: true)
        
        // Animate in
        panel.alphaValue = 0
        panel.makeKeyAndOrderFront(nil)
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.15
            context.timingFunction = CAMediaTimingFunction(name: .easeOut)
            panel.animator().alphaValue = 1
        }
        
        // Start monitoring for clicks outside (with slight delay to avoid catching the current click)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.startClickOutsideMonitor()
        }
    }
    
    private func hidePanel() {
        stopClickOutsideMonitor()
        
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.1
            context.timingFunction = CAMediaTimingFunction(name: .easeIn)
            panel.animator().alphaValue = 0
        } completionHandler: { [weak self] in
            self?.panel.orderOut(nil)
        }
    }
    
    // MARK: - Click Outside Monitoring
    private func startClickOutsideMonitor() {
        // Global monitor: catches clicks outside the app entirely
        clickOutsideMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] _ in
            self?.hidePanel()
        }
    }
    
    private func stopClickOutsideMonitor() {
        if let monitor = clickOutsideMonitor {
            NSEvent.removeMonitor(monitor)
            clickOutsideMonitor = nil
        }
    }
    
    deinit {
        stopClickOutsideMonitor()
    }
}

