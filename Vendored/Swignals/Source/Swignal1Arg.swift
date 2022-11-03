import Foundation

public final class Swignal1Arg<A>: SwignalBase {
	override public init() {}

	public func addObserver<L: AnyObject>(_ observer: L, callback: @escaping (_ observer: L, _ arg1: A) -> Void) {
		let observer = Observer1Args(swignal: self, observer: observer, callback: callback)
		addSwignalObserver(observer)
	}

	public func fire(_ arg1: A) {
		synced(self) {
			for watcher in swignalObservers {
				watcher.fire(arg1)
			}
		}
	}
}

private class Observer1Args<L: AnyObject, A>: ObserverGenericBase<L> {
	let callback: (_ observer: L, _ arg1: A) -> Void

	init(swignal: SwignalBase, observer: L, callback: @escaping (_ observer: L, _ arg1: A) -> Void) {
		self.callback = callback
		super.init(swignal: swignal, observer: observer)
	}

	override func fire(_ args: Any...) {
		if let arg1 = args[0] as? A {
			fire(arg1: arg1)
		} else {
			assertionFailure("Types incorrect")
		}
	}

	fileprivate func fire(arg1: A) {
		if let observer {
			callback(observer, arg1)
		}
	}
}
