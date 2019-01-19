import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pageControl = UIPageControl()
    var patient: Patient!
    
    lazy var pageViewControllers: [UIViewController] = {
        return [self.createNewViewController(name: "HearthVC"),
                self.createNewViewController(name: "SleepVC"),
                self.createNewViewController(name: "WeightVC"),
                self.createNewViewController(name: "ExerciseVC"),
                self.createNewViewController(name: "HeightVC")]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        if let firstVC = self.pageViewControllers.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
        self.delegate = self
        configurePageControl()
    }
    
    func configurePageControl() {
        self.pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 50, width: UIScreen.main.bounds.width - 30, height: 50))
        self.pageControl.numberOfPages = self.pageViewControllers.count
        self.pageControl.currentPage = 0
        //self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.lightGray
        self.pageControl.currentPageIndicatorTintColor = UIColor.blue
        self.view.addSubview(self.pageControl)
    }
    
    func createNewViewController(name: String) -> UIViewController {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name) as? SinglePageViewController
        switch name {
        case "HearthVC":
            viewController?.arrayToShow = patient.hearthRecords as [AnyObject]
        case "SleepVC":
            viewController?.arrayToShow = patient.sleepRecords as [AnyObject]
        case "WeightVC":
            viewController?.arrayToShow = patient.weightRecords as [AnyObject]
        case "ExerciseVC":
            viewController?.arrayToShow = patient.workoutRecords as [AnyObject]
        case "HeightVC":
            viewController?.arrayToShow = patient.workoutRecords as [AnyObject]
        default:
            break
        }
        
        viewController?.patient = self.patient
        return viewController!
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = self.pageViewControllers.index(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        if previousIndex >= 0 {
            return self.pageViewControllers[previousIndex]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = self.pageViewControllers.index(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        if nextIndex < self.pageViewControllers.count {
            return self.pageViewControllers[nextIndex]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = self.pageViewControllers.index(of: currentViewController)!
    }

}
