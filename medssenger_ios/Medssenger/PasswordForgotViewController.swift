import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD


class PasswordForgotViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTxtField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTxtField.delegate = self
        
//        self.hideKeyboard()
    
      //  self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)

     
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    

    
    @IBAction func passwordReset(_ sender: Any) {
        
        
        
        if emailTxtField.text == "" {
            let alert = UIAlertController(title: "Hata", message: "Mail adresi boş bırakılamaz.", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
            
        } else {
            resetPassword(email: emailTxtField.text!)
            }
        
        
    }

        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTxtField {
            textField.resignFirstResponder()
        }
        return true
    }
    
//    func hideKeyboard() {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PasswordViewController.dismissKeyboard))
//        view.addGestureRecognizer(tap)
//
//    }
//
//    @objc func dismissKeyboard() {
//        view.endEditing(true)
//    }
    
    

    func resetPassword(email: String){
        SVProgressHUD.show()
        Auth.auth().sendPasswordReset(withEmail: email, completion: {(error) in
            if error == nil {
                self.passwordResetSuccess(title: "Bilgi", message: "Mail adresinize gelen linke tıklayarak parolanızı sıfırlayabilirsiniz")
                
            }else {
                print(error!.localizedDescription)
            }
    })
    }
    
    func passwordResetSuccess(title: String, message: String) {
        SVProgressHUD.dismiss()
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)

        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
