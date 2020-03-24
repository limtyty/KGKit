//
//  File.swift
//  
//
//  Created by Lim TyTy on 3/24/20.
//

import UIKit

public protocol LayoutAnchor {

    func constraint(equalTo: Self, constant: CGFloat) -> NSLayoutConstraint

    func constraint(greaterThanOrEqualTo: Self, constant: CGFloat) -> NSLayoutConstraint

    func constraint(lessThanOrEqualTo: Self, constant: CGFloat) -> NSLayoutConstraint
}

protocol LayoutDimension: LayoutAnchor {

    func constraint(equalToConstant c: CGFloat) -> NSLayoutConstraint

    func constraint(greaterThanOrEqualToConstant c: CGFloat) -> NSLayoutConstraint

    func constraint(lessThanOrEqualToConstant c: CGFloat) -> NSLayoutConstraint

}

protocol LayoutAxis: LayoutAnchor {

    associatedtype Dimension: LayoutDimension

    func anchor(to: Self) -> Dimension

    func constraint(equalToSystemSpacing anchor: Self, multiplier: CGFloat) -> NSLayoutConstraint

    func constraint(greaterThanOrEqualToSystemSpacing anchor: Self, multiplier: CGFloat) -> NSLayoutConstraint

    func constraint(lessThanOrEqualToSystemSpacing anchor: Self, multiplier: CGFloat) -> NSLayoutConstraint
}

public struct Layout {
    private init() { /* Namespace */ }

    public struct Property<Anchor: LayoutAnchor> {
        fileprivate let anchor: Anchor
    }

    /// A value which defines the spacing between
    /// a child view which is pinned to its superview.
    ///
    /// - system: uses system magins via the APIs (not a constant)
    /// - constant: uses a constant value
    public enum Margins {
        case system
        case constant(CGFloat)

        public static let zero: Margins = .constant(0)
    }

    struct Offset<Anchor: LayoutAnchor> {
        fileprivate let anchor: Anchor
        fileprivate let offset: CGFloat
    }

    struct Relative<Anchor: LayoutAxis> {
        enum Direction {
            case inside, outside
        }
        fileprivate let property: Property<Anchor>
        fileprivate let direction: Direction
        fileprivate let margins: Margins
    }

    /// The target for Pinning DSL.
    ///
    /// The value indicates what the receiver (a UIView
    /// subclass) will be pinned to.
    ///
    /// - superview: i.e. directly to its superview
    /// - guide: to an arbitraty UILayoutGuide
    /// - safeArea: to the safe area layout guide
    /// - layoutMargins: to the layout margins guide
    ///    This is effectively the same as pinning to the
    ///    superview and using .system margins.
    public enum PinningTarget {
        case superview
        case guide(UILayoutGuide)
        case safeArea
        case layoutMargins
    }

    /// A class which provides a façade around layout anchors given a UIView.
    public final class Proxy {

        /// The leading anchor Property
        public lazy var leading = property(with: view.leadingAnchor)

        /// The trailing anchor Property
        public lazy var trailing = property(with: view.trailingAnchor)

        /// The top anchor Property
        public lazy var top = property(with: view.topAnchor)

        /// The bottom anchor Property
        public lazy var bottom = property(with: view.bottomAnchor)

        /// The width dimension anchor Property
        public lazy var width = property(with: view.widthAnchor)

        /// The height dimension anchor Property
        public lazy var height = property(with: view.heightAnchor)

        /// The centerX anchor Property
        public lazy var centerX = property(with: view.centerXAnchor)

        /// The centerY anchor Property
        public lazy var centerY = property(with: view.centerYAnchor)

        private let view: UIView

        fileprivate init(view: UIView) {
            self.view = view
        }

        private func property<A: LayoutAnchor>(with anchor: A) -> Layout.Property<A> {
            return Layout.Property(anchor: anchor)
        }
    }
}

extension Layout.Property {

    func equal(to otherAnchor: Anchor, offsetBy constant: CGFloat = 0) {
        anchor.constraint(equalTo: otherAnchor, constant: constant).isActive = true
    }

    func greaterThanOrEqual(to otherAnchor: Anchor, offsetBy constant: CGFloat = 0) {
        anchor.constraint(greaterThanOrEqualTo: otherAnchor, constant: constant).isActive = true
    }

    func lessThanOrEqual(to otherAnchor: Anchor, offsetBy constant: CGFloat = 0) {
        anchor.constraint(lessThanOrEqualTo: otherAnchor, constant: constant).isActive = true
    }
}

extension Layout.Property where Anchor: LayoutDimension {

    func equal(to constant: CGFloat) {
        anchor.constraint(equalToConstant: constant).isActive = true
    }

    func greaterThanOrEqual(to constant: CGFloat) {
        anchor.constraint(greaterThanOrEqualToConstant: constant).isActive = true
    }

    func lessThanOrEqual(to constant: CGFloat) {
        anchor.constraint(lessThanOrEqualToConstant: constant).isActive = true
    }
}

extension Layout.Property where Anchor: LayoutAxis {

    func equal(toSystemSpacing otherAnchor: Anchor, multiplier: CGFloat = 1) {
        anchor.constraint(equalToSystemSpacing: otherAnchor, multiplier: multiplier).isActive = true
    }

    func greaterThanOrEqual(toSystemSpacing otherAnchor: Anchor, multiplier: CGFloat = 1) {
        anchor.constraint(greaterThanOrEqualToSystemSpacing: otherAnchor, multiplier: multiplier).isActive = true
    }

    func lessThanOrEqual(toSystemSpacing otherAnchor: Anchor, multiplier: CGFloat = 1) {
        anchor.constraint(lessThanOrEqualToSystemSpacing: otherAnchor, multiplier: multiplier).isActive = true
    }
}

// MARK: - Operators, Anchors Offsets
func +<Anchor: LayoutAnchor>(lhs: Anchor, rhs: CGFloat) -> Layout.Offset<Anchor> {
    return Layout.Offset(anchor: lhs, offset: rhs)
}

func -<Anchor: LayoutAnchor>(lhs: Anchor, rhs: CGFloat) -> Layout.Offset<Anchor> {
    return Layout.Offset(anchor: lhs, offset: -rhs)
}

func ==<Anchor: LayoutAnchor>(lhs: Layout.Property<Anchor>, rhs: Layout.Offset<Anchor>) {
    lhs.equal(to: rhs.anchor, offsetBy: rhs.offset)
}

func ==<Anchor: LayoutAnchor>(lhs: Layout.Property<Anchor>, rhs: Anchor) {
    lhs.equal(to: rhs)
}

func >=<Anchor: LayoutAnchor>(lhs: Layout.Property<Anchor>, rhs: Layout.Offset<Anchor>) {
    lhs.greaterThanOrEqual(to: rhs.anchor, offsetBy: rhs.offset)
}

func >=<Anchor: LayoutAnchor>(lhs: Layout.Property<Anchor>, rhs: Anchor) {
    lhs.greaterThanOrEqual(to: rhs)
}

func <=<Anchor: LayoutAnchor>(lhs: Layout.Property<Anchor>, rhs: Layout.Offset<Anchor>) {
    lhs.lessThanOrEqual(to: rhs.anchor, offsetBy: rhs.offset)
}

func <=<Anchor: LayoutAnchor>(lhs: Layout.Property<Anchor>, rhs: Anchor) {
    lhs.lessThanOrEqual(to: rhs)
}

// MARK: - Operators, Dimensions
func ==<Anchor: LayoutDimension>(lhs: Layout.Property<Anchor>, rhs: CGFloat) {
    lhs.equal(to: rhs)
}

func >=<Anchor: LayoutDimension>(lhs: Layout.Property<Anchor>, rhs: CGFloat) {
    lhs.greaterThanOrEqual(to: rhs)
}

func <=<Anchor: LayoutDimension>(lhs: Layout.Property<Anchor>, rhs: CGFloat) {
    lhs.lessThanOrEqual(to: rhs)
}

// MARK: - Operations, Dimension Relations
func +<Anchor: LayoutAxis>(lhs: Anchor, rhs: Layout.Margins) -> Layout.Relative<Anchor> {
    return Layout.Relative(property: Layout.Property(anchor: lhs), direction: .inside, margins: rhs)
}

func -<Anchor: LayoutAxis>(lhs: Anchor, rhs: Layout.Margins) -> Layout.Relative<Anchor> {
    return Layout.Relative(property: Layout.Property(anchor: lhs), direction: .outside, margins: rhs)
}

func ==<Anchor: LayoutAxis>(lhs: Layout.Property<Anchor>, rhs: Layout.Relative<Anchor>) {
    switch (rhs.direction, rhs.margins) {
    case (.inside, .system):
        lhs.equal(toSystemSpacing: rhs.property.anchor)
    case (.outside, .system):
        rhs.property.equal(toSystemSpacing: lhs.anchor)
    case let (.inside, .constant(constant)):
        lhs.equal(to: rhs.property.anchor, offsetBy: constant)
    case let (.outside, .constant(constant)):
        rhs.property.equal(to: lhs.anchor, offsetBy: constant)
    }
}

func >=<Anchor: LayoutAxis>(lhs: Layout.Property<Anchor>, rhs: Layout.Relative<Anchor>) {
    switch (rhs.direction, rhs.margins) {
    case (.inside, .system):
        lhs.greaterThanOrEqual(toSystemSpacing: rhs.property.anchor)
    case (.outside, .system):
        rhs.property.greaterThanOrEqual(toSystemSpacing: lhs.anchor)
    case let (.inside, .constant(constant)):
        lhs.greaterThanOrEqual(to: rhs.property.anchor, offsetBy: constant)
    case let (.outside, .constant(constant)):
        rhs.property.greaterThanOrEqual(to: lhs.anchor, offsetBy: constant)
    }
}

func <=<Anchor: LayoutAxis>(lhs: Layout.Property<Anchor>, rhs: Layout.Relative<Anchor>) {
    switch (rhs.direction, rhs.margins) {
    case (.inside, .system):
        lhs.lessThanOrEqual(toSystemSpacing: rhs.property.anchor)
    case (.outside, .system):
        rhs.property.lessThanOrEqual(toSystemSpacing: lhs.anchor)
    case let (.inside, .constant(constant)):
        lhs.lessThanOrEqual(to: rhs.property.anchor, offsetBy: constant)
    case let (.outside, .constant(constant)):
        rhs.property.lessThanOrEqual(to: lhs.anchor, offsetBy: constant)
    }
}


// MARK: - Conformance
extension NSLayoutAnchor: LayoutAnchor { }

extension NSLayoutDimension: LayoutDimension { }

extension NSLayoutXAxisAnchor: LayoutAxis {

    public func anchor(to otherAnchor: NSLayoutXAxisAnchor) -> NSLayoutDimension {
        return anchorWithOffset(to: otherAnchor)
    }

    public func constraint(equalToSystemSpacing anchor: NSLayoutXAxisAnchor, multiplier: CGFloat) -> NSLayoutConstraint {
        return constraint(equalToSystemSpacingAfter: anchor, multiplier: multiplier)
    }

    public func constraint(greaterThanOrEqualToSystemSpacing anchor: NSLayoutXAxisAnchor, multiplier: CGFloat) -> NSLayoutConstraint {
        return constraint(greaterThanOrEqualToSystemSpacingAfter: anchor, multiplier: multiplier)
    }

    public func constraint(lessThanOrEqualToSystemSpacing anchor: NSLayoutXAxisAnchor, multiplier: CGFloat) -> NSLayoutConstraint {
        return constraint(lessThanOrEqualToSystemSpacingAfter: anchor, multiplier: multiplier)
    }
}

extension NSLayoutYAxisAnchor: LayoutAxis {

    public func anchor(to otherAnchor: NSLayoutYAxisAnchor) -> NSLayoutDimension {
        return anchorWithOffset(to: otherAnchor)
    }

    public func constraint(equalToSystemSpacing anchor: NSLayoutYAxisAnchor, multiplier: CGFloat) -> NSLayoutConstraint {
        return constraint(equalToSystemSpacingBelow: anchor, multiplier: multiplier)
    }

    public func constraint(greaterThanOrEqualToSystemSpacing anchor: NSLayoutYAxisAnchor, multiplier: CGFloat) -> NSLayoutConstraint {
        return constraint(greaterThanOrEqualToSystemSpacingBelow: anchor, multiplier: multiplier)
    }

    public func constraint(lessThanOrEqualToSystemSpacing anchor: NSLayoutYAxisAnchor, multiplier: CGFloat) -> NSLayoutConstraint {
        return constraint(lessThanOrEqualToSystemSpacingBelow: anchor, multiplier: multiplier)
    }
}

// MARK: - DSL
extension UIView {

    /// Layout DSL
    ///
    /// Use trailing closure syntax to set autolayout
    ///   constraints using the anchors available on
    ///   the only argument. For example:
    ///
    /// ```swift
    /// view.layout {
    ///     $0.top == anotherView.topAnchor + 20
    /// }
    /// ```
    ///
    /// - See: `Layout.Proxy`
    ///
    /// - Parameter closure: a closure which receives a `Layout.Proxy`
    public func layout(using block: (Layout.Proxy) -> Void) {
        translatesAutoresizingMaskIntoConstraints = false
        block(Layout.Proxy(view: self))
    }
}

extension Layout {

    public struct Pinning {

        /// The target for Pinning DSL.
        ///
        /// The value indicates what the receiver (a UIView
        /// subclass) will be pinned to.
        ///
        /// - superview: i.e. directly to its superview
        /// - guide: to an arbitraty UILayoutGuide
        /// - safeArea: to the safe area layout guide
        /// - layoutMargins: to the layout margins guide
        ///    This is effectively the same as pinning to the
        ///    superview and using .system margins.
        public enum Target {

            case parent(UIView?)
            case guide(UILayoutGuide)

            public static let superview: Target = .parent(nil)
        }

        /// A Modifier of the Pinning Target
        ///
        /// - bounds: the default, meaning the edges of the target
        /// - safeArea: the safe area layout guides
        /// - layoutMargins: the layout margins guide
        public enum Modifier {
            case bounds, safeArea, layoutMargins
        }
    }
}

extension UIView {

    /// Layout Pinning
    ///
    /// Pin the view to its superview using a combination of
    /// a pinning target and margins. For example:
    ///
    /// ```swift
    /// // pin to superview with zero margins
    /// view.pin(to: .superview)
    /// // pin to a layout guide
    /// view.pin(to: .guide(aLayoutGuide))
    /// // pin to a parent view
    /// view.pin(to: .parent(anotherView))
    /// // pin to superview with system margins
    /// view.pin(to: .superview, margins: .system)
    /// // pin to superview with constant 10pt margin
    /// view.pin(to: superview, margins: .constant(10))
    /// ```
    ///
    /// - See: Layout.Pinning.Target
    /// - See: Layout.Margins
    ///
    /// - Parameters:
    ///   - target: the target to pin to, for example: .superview
    ///   - margins: the margins to use, defaults to .zero
    func pin(to target: Layout.Pinning.Target, margins: Layout.Margins = .zero) {
        pin(to: .bounds, of: target, margins: margins)
    }

    /// Layout Pinning
    ///
    /// Pin the view to its superview using a combination of
    /// a pinning modifier, target and margins. For example:
    ///
    /// ```swift
    /// // pin to superview with zero margins
    /// view.pin(to: .bounds, of: .superview)
    /// // pin to bounds of layout guide
    /// view.pin(to: .bounds, of: .guide(aLayoutGuide))
    /// // pin to safe area of a parent view
    /// view.pin(to: .safeArea, of: .parent(anotherView))
    /// // pin to safe area with system margins
    /// view.pin(to: .safeArea, of: .superview, margins: .system)
    /// // pin to safe area with constant 10pt margin
    /// view.pin(to: .safeArea, of: superview, margins: .constant(10))
    /// ```
    ///
    /// - See: Layout.Pinning.Modifier
    /// - See: Layout.Pinning.Target
    /// - See: Layout.Margins
    ///
    /// - Parameters:
    ///   - modifier: the pinning modifier, for example: .safeArea
    ///   - target: the target to pin to, (defaults to) for example: .superview
    ///   - margins: the margins to use, defaults to .zero
    func pin(to modifier: Layout.Pinning.Modifier, of target: Layout.Pinning.Target = .superview, margins: Layout.Margins = .zero) {

        guard let superview = superview else {
            fatalError("Superview not available - add view to a superview first, or ensure view controller's view is loaded.")
        }

        switch target {

        case let .guide(guide):
            layout {
                $0.leading == guide.leadingAnchor + margins
                $0.trailing == guide.trailingAnchor - margins
                $0.top == guide.topAnchor + margins
                $0.bottom == guide.bottomAnchor - margins
            }

        case .parent(nil):
            pin(to: modifier, of: .parent(superview), margins: margins)

        case let .parent(.some(view)):

            assert(isDescendant(of: view))

            switch modifier {

            case .safeArea:
                pin(to: .bounds, of: .guide(view.safeAreaLayoutGuide), margins: margins)

            case .layoutMargins:
                pin(to: .bounds, of: .guide(view.layoutMarginsGuide), margins: margins)

            case .bounds:
                layout {
                    $0.leading == view.leadingAnchor + margins
                    $0.trailing == view.trailingAnchor - margins
                    $0.top == view.topAnchor + margins
                    $0.bottom == view.bottomAnchor - margins
                }
            }
        }
    }

    /// Layout Pinning
    ///
    /// Pin the view to its superview using a combination of
    /// a pinning target and edge insets. For example:
    ///
    /// ```swift
    /// // pin to superview with zero insets
    /// view.pin(to: .superview)
    /// // pin to bounds of layout guide
    /// view.pin(to: .bounds, of: .guide(aLayoutGuide))
    /// // pin to safe area of a parent view
    /// view.pin(to: .safeArea, of: .parent(anotherView))
    /// // pin to superview with custom insets
    /// view.pin(to: .superview, insets: UIEdgeInsets(top: 4, left: 5, bottom: 6, right: 7))
    /// ```
    ///
    /// - See: Layout.Pinning.Target
    ///
    /// - Parameters:
    ///   - target: the target to pin to, for example: .superview
    ///   - insets: the UIEdgeInsets to use
    func pin(to target: Layout.Pinning.Target, insets: UIEdgeInsets) {
        pin(to: .bounds, of: target, insets: insets)
    }

    /// Layout Pinning
    ///
    /// Pin the view to its superview using a combination of
    /// a pinning modifier, target and edge insets. For example:
    ///
    /// ```swift
    /// // pin to superview with zero insets
    /// view.pin(to: .bounds, of: .superview)
    /// // pin to a layout guide
    /// view.pin(to: .bounds, of: .guide(aLayoutGuide))
    /// // pin to a parent view
    /// view.pin(to: safeArea, of: .parent(anotherView))
    /// // pin to layout margin of parent view with custom insets
    /// view.pin(to: .layoutMargins, of: .parent(anotherView), insets: UIEdgeInsets(top: 4, left: 5, bottom: 6, right: 7))
    /// ```
    ///
    /// - See: Layout.Pinning.Target
    ///
    /// - Parameters:
    ///   - modifier: the pinning modifier, for example: .safeArea
    ///   - target: the target to pin to, (defaults to) for example: .superview
    ///   - insets: the UIEdgeInsets to use
    func pin(to modifier: Layout.Pinning.Modifier, of target: Layout.Pinning.Target = .superview, insets: UIEdgeInsets) {

        guard let superview = superview else {
            fatalError("Superview not available - add view to a superview first, or ensure view controller's view is loaded.")
        }

        switch target {

        case let .guide(guide):
            layout {
                $0.leading == guide.leadingAnchor + insets.left
                $0.trailing == guide.trailingAnchor - insets.right
                $0.top == guide.topAnchor + insets.top
                $0.bottom == guide.bottomAnchor - insets.bottom
            }

        case .parent(nil):
            pin(to: modifier, of: .parent(superview), insets: insets)

        case let .parent(.some(view)):

            assert(isDescendant(of: view))

            switch modifier {

            case .safeArea:
                pin(to: .bounds, of: .guide(view.safeAreaLayoutGuide), insets: insets)

            case .layoutMargins:
                pin(to: .bounds, of: .guide(view.layoutMarginsGuide), insets: insets)

            case .bounds:
                layout {
                    $0.leading == view.leadingAnchor + insets.left
                    $0.trailing == view.trailingAnchor - insets.right
                    $0.top == view.topAnchor + insets.top
                    $0.bottom == view.bottomAnchor - insets.bottom
                }
            }
        }
    }
}


// MARK: - Helper Geometery
func +(lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> UIEdgeInsets {
    return UIEdgeInsets(top: lhs.top + rhs.top, left: lhs.left + rhs.left, bottom: lhs.bottom + rhs.bottom, right: lhs.right + rhs.right)
}

func -(lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> UIEdgeInsets {
    return UIEdgeInsets(top: lhs.top - rhs.top, left: lhs.left - rhs.left, bottom: lhs.bottom - rhs.bottom, right: lhs.right - rhs.right)
}

