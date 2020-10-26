import UIKit
import Firebase
import FirebaseFirestore

class TipsFeature: UIViewController {
    
    struct Data {
        static var myEmail = CustomSignUp.Data.email
        static var myTasks = [String()]
    }
    
    let db = Firestore.firestore()
    
    var myControllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        
        if HomePage.Data.coloredPensBoolean == true {
            let coloredPensVC = coloredPensTip()
            myControllers.append(coloredPensVC)
        }
        
        if HomePage.Data.constantPacingBoolean == true {
            let fidgetVC = FidgetTool()
            myControllers.append(fidgetVC)
        }
        
        if HomePage.Data.musicBoolean == true {
            let musicVC = MusicTip()
            myControllers.append(musicVC)
        }
        
        if HomePage.Data.notificationsBoolean == true {
            let notificationVC = noNearbyDeviceTip()
            myControllers.append(notificationVC)
        }
        
        let breatheVC = breatheTip()
        myControllers.append(breatheVC)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            self.presentPageVC()
        })
    }
    
    func presentPageVC() {
        guard let first = myControllers.first else { return }
        let vc = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        
        vc.delegate = self
        vc.dataSource = self
        
        vc.setViewControllers([first], direction: .forward, animated: true, completion: nil)
        
        present(vc, animated: true)
    }
}

extension TipsFeature: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
     func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = myControllers.firstIndex(of: viewController), index > 0 else { return nil }
        
        let before = index - 1
        
        return myControllers[before]
     }
     
     func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = myControllers.firstIndex(of: viewController), index < (myControllers.count - 1) else { return nil }
        
        let after = index + 1
        
        return myControllers[after]
     }
    
}
