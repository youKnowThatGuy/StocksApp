//
//  MainPageController.swift
//  StocksApp
//
//  Created by Клим on 21.03.2021.
//

import UIKit

class MainPageController: UIPageViewController {
    let moduleBuilder = ModuleBuilder()
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.moduleBuilder.createMainModule(),
                self.moduleBuilder.createFavouriteModule()]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        if let firstViewController = orderedViewControllers.first {
               setViewControllers([firstViewController],
                direction: .forward,
                   animated: true,
                   completion: nil)
           }
    }
    
    
    

}

extension MainPageController: UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
                    return nil
                }
                
                let previousIndex = viewControllerIndex - 1
                
                guard previousIndex >= 0 else {
                    return nil
                }
                
                guard orderedViewControllers.count > previousIndex else {
                    return nil
                }
                
                return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
                    return nil
                }
                let nextIndex = viewControllerIndex + 1
                let orderedViewControllersCount = orderedViewControllers.count
                guard orderedViewControllersCount != nextIndex else {
                    return nil
                }
                guard orderedViewControllersCount > nextIndex else {
                    return nil
                }
        
                return orderedViewControllers[nextIndex]
        }
    
}
