import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD


class PasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var validPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var passwordAgain: UITextField!
    
      var email: String!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        validPassword.delegate = self
        newPassword.delegate = self
        passwordAgain.delegate = self
        
        
  
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == validPassword {
            newPassword.becomeFirstResponder()
        }
        else if textField == newPassword {
            passwordAgain.becomeFirstResponder()
        }
        else if textField == passwordAgain {
            textField.resignFirstResponder()
        }
        return true
    }


    
    @IBAction func passwordUpdateAction(_ sender: Any) {
    
            if self.validPassword.text == "" && self.newPassword.text == "" && self.passwordAgain.text == "" {
                let alert = UIAlertController(title: "Hata", message: "Gerekli alanlar boş bırakılamaz.", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
                
            }
            else if self.validPassword.text == "" {
                let alert = UIAlertController(title: "Hata", message: "Geçerli parola kısmı boş bırakılamaz.", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
                
            }
            else if self.newPassword.text == "" {
                let alert = UIAlertController(title: "Hata", message: "Yeni parola kısmı boş bırakılamaz.", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else if self.passwordAgain.text == "" {
                let alert = UIAlertController(title: "Hata", message: "Parola tekrar kısmı boş bırakılamaz.", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else if self.validPassword.text == self.newPassword.text && self.validPassword.text == self.passwordAgain.text {
                let alert = UIAlertController(title: "Hata", message: "Girdiğiniz parola yeni parolanızla aynı. Tekrar Deneyin", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else if self.newPassword.text != self.passwordAgain.text {
                let alert = UIAlertController(title: "Hata", message: "Girdiğiniz parola yeni parolanızla aynı değil. Tekrar Deneyin", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else {    //eğer hata yoksa
     
                //Parola değiştirme olayı
                let user = Auth.auth().currentUser
                email = UserDefaults.standard.string(forKey: "user")
                var credential: AuthCredential
                credential = EmailAuthProvider.credential(withEmail: email, password: validPassword.text!)
                
                user?.reauthenticate(with: credential, completion: { (error) in
                    if error == nil {
                        user?.updatePassword(to: self.newPassword.text!) { (errror) in
                            
                        self.passwordSuccess(title: "Bilgi", message: "Parolanız başarılı bir şekilde değiştirildi. Yeni giriş bilgileriniz ile tekrardan giriş yapmanız gerekmektedir. ")
                         
                        }
                    } else {
                        let alert = UIAlertController(title: "Hata", message: "Sisteme kayıtlı parolanız yanlıştır. Tekrar deneyin.", preferredStyle: UIAlertController.Style.alert)
                        let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
                        alert.addAction(okButton)
                        self.present(alert, animated: true, completion: nil)
                    }
                })
                
        }
        
        
    }


    func passwordSuccess(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            
            UserDefaults.standard.removeObject(forKey: "user") //kullanıcı silinip giriş yap ekranına gitsin
            UserDefaults.standard.synchronize()
            let signIn = self.storyboard?.instantiateViewController(withIdentifier: "signInVC")
            let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
            delegate.window?.rootViewController = signIn
            delegate.rememberLogin()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
