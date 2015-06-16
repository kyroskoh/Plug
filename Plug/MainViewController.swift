//
//  MainViewController.swift
//  Plug
//
//  Created by Alexander Marchant on 7/16/14.
//  Copyright (c) 2014 Plug. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController, PopularSectionModeMenuTarget {
    @IBOutlet weak var mainContentView: NSView!
    
    var navigationController: NavigationController!
    var currentViewController: BaseContentViewController!
    var currentTrackViewController: NSViewController?
    var trafficButtons: TrafficButtons?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    deinit {
        Notifications.unsubscribeAll(observer: self)
    }
    
    func setup() {
        Notifications.subscribe(observer: self, selector: "navigationSectionChanged:", name: Notifications.NavigationSectionChanged, object: nil)
        Notifications.subscribe(observer: self, selector: "displayError:", name: Notifications.DisplayError, object: nil)
        Notifications.subscribe(observer: self, selector: "currentTrackDidShow:", name: Notifications.CurrentTrackDidShow, object: nil)
        Notifications.subscribe(observer: self, selector: "currentTrackDidHide:", name: Notifications.CurrentTrackDidHide, object: nil)
    }
    
    override func viewDidLoad() {
        for controller in childViewControllers {
            if controller is NavigationController {
                navigationController = controller as! NavigationController
            }
        }
    }
    
    override func viewDidAppear() {
        super.viewDidLoad()
        
        if currentViewController == nil {
            changeNavigationSection(NavigationSection.Popular)
        }
        
        addCurrentTrackViewController()
    }
    
    func changeNavigationSection(section: NavigationSection) {
        Notifications.post(name: Notifications.NavigationSectionChanged, object: self, userInfo: ["navigationSection": section.rawValue])
    }
    
    func navigationSectionChanged(notification: NSNotification) {
        let raw = (notification.userInfo!["navigationSection"] as! NSNumber).integerValue
        let section = NavigationSection(rawValue: raw)!
        updateUIForSection(section)
    }
    
    func displayError(notification: NSNotification) {
        let error = notification.userInfo!["error"] as! NSError
        let displayErrorViewController = storyboard!.instantiateControllerWithIdentifier("DisplayErrorViewController") as! DisplayErrorViewController
        displayErrorViewController.representedObject = error
        let insets = NSEdgeInsetsMake(36, 69, 0, 0)
        ViewPlacementHelper.AddTopAnchoredSubview(displayErrorViewController.view, toSuperView: view, withFixedHeight: 40, andInsets: insets)
        Interval.single(5, closure: {
            displayErrorViewController.view.removeFromSuperview()
        })
    }
    
    func updateUIForSection(section: NavigationSection) {
        var newViewController = section.viewController(storyboard!, target: self)
        currentViewController = newViewController
        navigationController.setNewRootViewController(newViewController)
    }
    
    func currentTrackDidShow(notification: NSNotification) {
        currentTrackViewController!.view.hidden = true
    }

    func currentTrackDidHide(notification: NSNotification) {
        currentTrackViewController!.view.hidden = false
    }
    
    func addCurrentTrackViewController() {
        currentTrackViewController = storyboard!.instantiateControllerWithIdentifier("CurrentlyPlaylingTrackViewController") as! CurrentlyPlaylingTrackViewController
        let insets = NSEdgeInsetsMake(0, 69, 47, 0)
        ViewPlacementHelper.AddBottomAnchoredSubview(currentTrackViewController!.view, toSuperView: view, withFixedHeight: 70, andInsets: insets)
        currentTrackViewController!.view.hidden = true
    }
    
    func popularSectionModeChanged(sender: NSMenuItem) {
        
    }
}

extension NavigationSection {
    static var viewControllers = [String: BaseContentViewController]()
    
    var viewControllerIdentifier: String {
        switch self {
        case .Popular:
            return "PopularTracksViewController"
        case .Favorites:
            return "FavoriteTracksViewController"
        case .Latest:
            return "LatestTracksViewController"
        case .Blogs:
            return "BlogDirectoryViewController"
        case .Feed:
            return "FeedTracksViewController"
        case .Genres:
            return "TagsViewController"
        case .Friends:
            return "FriendsViewController"
        case .Search:
            return "SearchViewController"
        }
    }
    
    func menu(target: AnyObject?) -> NSMenu? {
        switch self {
        case .Popular:
            return PopularSectionMode.menu(target)
        default:
            return nil
        }
    }
    
    func viewController(storyboard: NSStoryboard, target: AnyObject?) -> BaseContentViewController {
        return savedViewController ?? createViewController(storyboard, target: target)
    }
    
    private var savedViewController: BaseContentViewController? {
        return NavigationSection.viewControllers[self.viewControllerIdentifier]
    }
    
    private func createViewController(storyboard: NSStoryboard, target: AnyObject?) -> BaseContentViewController {
        let targetViewController = storyboard.instantiateControllerWithIdentifier(self.viewControllerIdentifier) as! BaseContentViewController
        targetViewController.dropdownMenu = self.menu(target)
        
        NavigationSection.viewControllers[self.viewControllerIdentifier] = targetViewController
        
        return targetViewController
    }
}

extension PopularSectionMode {
    static func menu(target: AnyObject?) -> NSMenu {
        let menu = NSMenu()
        menu.title = self.navigationSection.title
        
        menu.addItemWithTitle(self.Now.title, action: "popularSectionModeChanged:", keyEquivalent: "")
        menu.addItemWithTitle(self.LastWeek.title, action: "popularSectionModeChanged:", keyEquivalent: "")
        menu.addItemWithTitle(self.NoRemixes.title, action: "popularSectionModeChanged:", keyEquivalent: "")
        menu.addItemWithTitle(self.RemixesOnly.title, action: "popularSectionModeChanged:", keyEquivalent: "")
        
        for item in (menu.itemArray as! [NSMenuItem]) {
            item.target = target
        }
        
        return menu
    }
}

protocol PopularSectionModeMenuTarget {
    func popularSectionModeChanged(sender: NSMenuItem)
}
