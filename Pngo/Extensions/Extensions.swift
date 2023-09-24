import UIKit

extension UIView {
    
    //MARK: - Layout
    
    func setConstraints(top:     NSLayoutYAxisAnchor? = nil, paddingTop:        CGFloat? = 0,
                        bottom:       NSLayoutYAxisAnchor? = nil, paddingBottom:     CGFloat? = 0,
                        leading:      NSLayoutXAxisAnchor? = nil, paddingLeading:    CGFloat? = 0,
                        trialaing:    NSLayoutXAxisAnchor? = nil, paddingTrialaing:  CGFloat? = 0,
                        xAxis:        NSLayoutXAxisAnchor? = nil, paddingxAxis:      CGFloat? = 0,
                        yAxis:        NSLayoutYAxisAnchor? = nil, paddingyAxis:      CGFloat? = 0,
                        widthAnchor:  NSLayoutDimension?   = nil, widthMultiplier:   CGFloat? = 1,
                        heightAnchor: NSLayoutDimension?   = nil, heightMultiplier:  CGFloat? = 1,
                        width:     CGFloat? = nil, height: CGFloat? = nil,
                        equalToConstraintsOf parentView: UIView? = nil){
        
        self.translatesAutoresizingMaskIntoConstraints = false
        if let top = top{
            self.topAnchor.constraint(equalTo: top, constant: paddingTop!).isActive = true
        }
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom!).isActive = true
        }
        if let leading = leading {
            self.leadingAnchor.constraint(equalTo: leading, constant: paddingLeading!).isActive = true
        }
        if let trialaing = trialaing {
            self.trailingAnchor.constraint(equalTo: trialaing, constant: -paddingTrialaing!).isActive = true
        }
        
        if let xAxis = xAxis {
            self.centerXAnchor.constraint(equalTo: xAxis, constant: paddingxAxis!).isActive = true
        }
        if let yAxis = yAxis {
            self.centerYAnchor.constraint(equalTo: yAxis, constant: paddingyAxis!).isActive  = true
        }
        if let heightAnchor = heightAnchor {
            self.heightAnchor.constraint(equalTo: heightAnchor, multiplier: heightMultiplier!).isActive = true
        }
        if let widthAnchor = widthAnchor {
            self.widthAnchor.constraint(equalTo: widthAnchor, multiplier: widthMultiplier!).isActive = true
        }
        if let width = width{
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        guard let parentView = parentView else {
            return
        }
        self.topAnchor.constraint(equalTo: parentView.topAnchor, constant: 0).isActive           = true
        self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: 0).isActive     = true
        self.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 0).isActive   = true
        self.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: 0).isActive = true
    }
    
    
    
    //MARK: - shadow Methods
    func addShadow (shadowColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)) {
        self.layer.shadowColor   = shadowColor.cgColor
        self.layer.shadowOffset  = CGSize(width: 0.0, height: 3.0)
        self.layer.shadowRadius  = 2.0
        self.layer.shadowOpacity = 0.2
    }
    
    
    func removeShadow () {
        self.layer.shadowColor   = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset  = CGSize(width: 0.0, height: -3.0) //(0.0, -3.0)
        self.layer.shadowOpacity = 0.0 //0.0
        self.layer.shadowRadius  = 3.0 //3.0
    }
    
    
    //MARK: -borderMethods
    func addBorder(color: UIColor, width: CGFloat ){
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    func removeBorder(){
        self.layer.borderWidth = 0
        self.layer.borderColor = .none
    }
    
    
    func addBlurEffect(){
        let blurEffect        = UIBlurEffect(style: UIBlurEffect.Style.prominent)
        let blurEffectView    = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame  = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
    
}






//MARK: - UIButton
extension UIButton{
    func configure (text: String,
                    font: UIFont,
                    image: UIImage? = nil,
                    alignment: ContentHorizontalAlignment? = .center,
                    titleColor: UIColor? = .black,
                    backgroundColor: UIColor? = .clear){
        
        self.setTitle(text, for: .normal)
        self.titleLabel?.font = font
        //self.titleLabel?.textAlignment = titleAlignment!
        self.contentHorizontalAlignment = alignment!
        
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        
        if let img = image{
            self.setImage(img, for: .normal)
        }
        
        self.autoLayoutTitle()
    }
    
    
    func autoLayoutTitle(shifToLeft: Bool? = false, shiftToRight: Bool? = false){
        
        let ratio      = 0.8
        let titileSize = CGSize(width: frame.width*ratio, height: frame.height*ratio)
        let buttonSize = CGSize(width: frame.width,       height: frame.height)
        
        titleEdgeInsets = UIEdgeInsets(top:   (buttonSize.height - titileSize.height) / 2,
                                       left:   shifToLeft! ? 0 : (buttonSize.width  - titileSize.width)  / 2,
                                       bottom: (buttonSize.height - titileSize.height) / 2,
                                       right:  shiftToRight! ? 0 : (buttonSize.width  - titileSize.width)  / 2)
        titleLabel!.adjustsFontSizeToFitWidth = true;
        titleLabel!.minimumScaleFactor = 0.5;
    }
    
}



//MARK: - UILabel
extension UILabel {
    func configure(text: String,
                   font: UIFont,
                   alignment: NSTextAlignment? = NSTextAlignment.left,
                   numberOfLines: Int?  = 1,
                   textColor: UIColor?  = .black,
                   backgroundColor: UIColor? = .clear){
        
        self.text = text
        self.font = font
        
        self.textAlignment = alignment!
        self.numberOfLines = numberOfLines!
        self.adjustsFontSizeToFitWidth = self.numberOfLines != 0
        self.minimumScaleFactor = 0.5
        
        self.textColor = textColor!
        self.backgroundColor = backgroundColor!
        
        guard self.numberOfLines != 1 else { return }
        self.lineBreakMode = .byWordWrapping
    }
}


//MARK: - UIImage
extension UIImageView {
    func configure(image: UIImage,
                   backgroundColor: UIColor? = nil,
                   tintColor: UIColor?=nil,
                   mode: UIView.ContentMode? = .scaleAspectFit){
        
        self.image = image
        self.contentMode = mode!
        if let backgroundColor = backgroundColor {
            self.backgroundColor = backgroundColor
        }
        if let tintColor = tintColor {
            self.tintColor = tintColor
        }
        
    }
    
}

//MARK: - UITextField
extension UITextField{
    
    func configure(placeholder: String,
                   alignment: NSTextAlignment? = nil,
                   keyboardType: UIKeyboardType? = nil,
                   clearButtonMode: ViewMode?  = nil,
                   isSecure: Bool?=nil){
        
        self.placeholder     = placeholder
        self.textAlignment   = alignment ?? .left
        self.keyboardType    = keyboardType ?? .default
        self.clearButtonMode = clearButtonMode ?? .whileEditing
        self.isSecureTextEntry = isSecure ?? false
       
        self.borderStyle     = .none
        self.minimumFontSize = 10
       // self.font      = Fonts.smallBody
        //self.textColor = Colors.black1
    }
    
    
}


