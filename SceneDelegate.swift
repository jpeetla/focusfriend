import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    let db = Firestore.firestore()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if UserDefaults.standard.bool(forKey: "isLoggedIn") == true {
            let cleanEmail = UserDefaults.standard.string(forKey: "email")
            let cleanPassword = UserDefaults.standard.string(forKey: "password")

            Auth.auth().signIn(withEmail: cleanEmail!, password: cleanPassword!) { (result, error) in
                if error != nil {
                        
                }

                else {
                    CustomSignUp.Data.email = cleanEmail!
                    self.retrieveTasksandMove(storyboard: storyboard)
                }
            }
        }
        
        else {
            let loginNavController = storyboard.instantiateViewController(identifier: "LoginController")
            window?.rootViewController = loginNavController
        }
    }
    
    func retrieveTasksandMove(storyboard: UIStoryboard) {
        db.collection("user").document(CustomSignUp.Data.email).getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                HomePage.Data.myTasks = dataDescription!["myTasks"] as! [String]
                HomePage.Data.myPoints = dataDescription!["points"] as! String
                HomePage.Data.totalFriends = dataDescription!["totalFriends"] as! String
                
                HomePage.Data.lastSubject = dataDescription!["lastSubject"] as! String
                HomePage.Data.lastTask = dataDescription!["lastTask"] as! String
                HomePage.Data.lastSessions = dataDescription!["lastSessions"] as! String
                HomePage.Data.lastLength = dataDescription!["lastLength"] as! String
                        
                let mainTabBarController = storyboard.instantiateViewController(identifier: "HomeController")
                self.window?.rootViewController = mainTabBarController
            }
            else {
                print("Error retrieving tasks...")
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func changeRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard let window = self.window else {
            return
        }
        
        // change the root view controller to your specific view controller
        window.rootViewController = vc
        
        UIView.transition(with: window,
        duration: 0.5,
        options: [.transitionFlipFromRight],
        animations: nil,
        completion: nil)
    }
}

