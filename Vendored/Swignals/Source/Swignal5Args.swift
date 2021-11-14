import Foundation

public final class Swignal5Args<A, B, C, D, E>: SwignalBase {
	override public init() {}

	public func addObserver<L: AnyObject>(_ observer: L, callback: @escaping (_ observer: L, _ arg1: A, _ arg2: B, _ arg3: C, _ arg4: D, _ arg5: E) -> Void) {
		let observer = Observer5Args(swignal: self, observer: observer, callback: callback)
		addSwignalObserver(observer)
	}

	public func fire(_ arg1: A, arg2: B, arg3: C, arg4: D, arg5: E) {
		synced(self) {
			for watcher in swignalObservers {
				watcher.fire(arg1, arg2, arg3, arg4, arg5)
			}
		}
	}
}

private class Observer5Args<L: AnyObject, A, B, C, D, E>: ObserverGenericBase<L> {
	let callback: (_ observer: L, _ arg1: A, _ arg2: B, _ arg3: C, _ arg4: D, _ arg5: E) -> Void

	init(swignal: SwignalBase, observer: L, callback: @escaping (_ observer: L, _ arg1: A, _ arg2: B, _ arg3: C, _ arg4: D, _ arg5: E) -> Void) {
		self.callback = callback
		super.init(swignal: swignal, observer: observer)
	}

	override func fire(_ args: Any...) {
		if
			let arg1 = args[0] as? A,
			let arg2 = args[1] as? B,
			let arg3 = args[2] as? C,
			let arg4 = args[3] as? D,
			let arg5 = args[4] as? E
		{
			fire(arg1: arg1, arg2: arg2, arg3: arg3, arg4: arg4, arg5: arg5)
		} else {
			assertionFailure("Types incorrect")
		}
	}

	fileprivate func fire(arg1: A, arg2: B, arg3: C, arg4: D, arg5: E) {
		if let observer = observer {
			callback(observer, arg1, arg2, arg3, arg4, arg5)
		}
	}
}
