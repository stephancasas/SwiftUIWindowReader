//
//  WindowReader.swift
//  SwiftUIWindowReader
//
//  Created by Stephan Casas on 7/27/23.
//

import AppKit;
import SwiftUI;

public struct WindowReader: View {
    
    public typealias    WindowReaderContent = (_ window: NSWindow) -> any View;
    public typealias  WindowReaderAuxiliary = (_ window: NSWindow) -> Void;
    public typealias WindowReaderAuxContent = () -> any View;
    
    private let   content: (NSWindow) -> AnyView;
    private var auxiliary: WindowReaderAuxiliary;
    
    @State private var window: NSWindow? = nil;
    
    /// Create a new `WindowReader` using a `ViewBuilder` which does
    /// not receive the context `NSWindow`.
    ///
    /// Pinning `.using(:)` to this initializer will provide callback
    /// access to the `NSWindow`.
    ///
    public init(@ViewBuilder content: @escaping WindowReaderAuxContent) {
        self.content = { _ in AnyView(content()) };
        self.auxiliary = { _ in };
    }
    
    /// Create a new `WindowReader` using a `ViewBuilder` which receives
    /// the context `NSWindow`.
    ///
    public init(@ViewBuilder content: @escaping WindowReaderContent) {
        self.content = { AnyView(content($0)) };
        self.auxiliary = { _ in }
    }
    
    
    /// Create a new `WindowReader` using a callback that receives the
    /// context `NSWindow` and a `ViewBuilder` which does not receive
    /// the context `NSWindow`.
    ///
    public init(
        using auxiliaryCallback: @escaping WindowReaderAuxiliary,
        @ViewBuilder content: @escaping WindowReaderAuxContent
    ) {
        self.content = { _ in AnyView(content()) };
        self.auxiliary = auxiliaryCallback;
    }
    
    /// Bind a callback which should receive the context `NSWindow`.
    ///
    public func using(
        _ auxiliaryCallback: @escaping WindowReaderAuxiliary
    ) -> Self {
        var copy = self;
        copy.auxiliary = auxiliaryCallback;
        
        return copy;
    }
    
    public var body: some View {
        if let window = self.window {
            self.content(window)
                .onAppear(perform: { self.auxiliary(window) })
        } else {
            WindowReadingView(self.$window)
                .accessibilityHidden(true)
        }
    }
    
    private struct WindowReadingView: NSViewRepresentable {
        @Binding private var window: NSWindow?;
        
        init(_ window: Binding<NSWindow?>) {
            self._window = window;
        }
        
        func makeNSView(context: Context) -> NSWindowReadingView {
            let nsView = NSWindowReadingView();
            nsView.windowPublisher = self.$window;
            
            return nsView;
        }
        
        func updateNSView(_ nsView: NSWindowReadingView, context: Context) { }
        
        class NSWindowReadingView: NSView {
            var windowPublisher: Binding<NSWindow?> = .constant(nil);
            
            override func viewWillMove(toWindow newWindow: NSWindow?) {
                guard let newWindow = newWindow else { return }
                windowPublisher.wrappedValue = newWindow;
            }
        }
    }
    
}
