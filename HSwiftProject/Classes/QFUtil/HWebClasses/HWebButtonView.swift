//
//  HWebButtonView.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/16.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit
import Kingfisher

class HWebButtonView: UIButton {
    
    lazy private var _imageView: UIImageView! = {
        let imageView: UIImageView = UIImageView(frame: self.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = false
        imageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return imageView
    }()
    
    private var lastURL: String = ""
    
    //父类那个tintColor有问题
    var renderColor: UIColor? {
        didSet {
            self.renderColor = oldValue;
            if self.renderColor != nil {
                _imageView.tintColor = oldValue;
                _imageView.image = _imageView.image?.withRenderingMode(.alwaysTemplate)
                self.tintColor = oldValue;
                self.setImage(self.image(for:.normal)?.withRenderingMode(.alwaysTemplate), for:.normal)
            }else {
                _imageView.image = _imageView.image?.withRenderingMode(.alwaysOriginal)
                self.setImage(self.image(for:.normal)?.withRenderingMode(.alwaysOriginal), for:.normal)
            }
        }
    }
    var placeHoderImage: UIImage?
    
    var pressed: callback?
    var didGetImage: callback?
    var didGetError: callback?
    
    required init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    private func setup() -> Void {
        self.addSubview(_imageView)
        //self.backgroundColor = UIColor.colorWithHex(0xe8e8e8)
        self.backgroundColor = UIColor.clear
        self.initialize()
    }
    
    private func initialize() -> Void {
        titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.imageView?.contentMode = .scaleAspectFill
        self.layer.masksToBounds = true
        self.addTarget(self, action: #selector(buttonPressed), for:.touchUpInside)
    }

    private func _setImage(_ image: UIImage?) {
        self._imageView.kf.cancelDownloadTask()
        if (image != nil) {
            if renderColor != nil {
                _imageView.tintColor = renderColor;
                _imageView.h_image = image?.withRenderingMode(.alwaysTemplate)
            }else {
                _imageView.h_image = image;
            }
        }else {
            _imageView.h_image = nil;
        }
    }
    
    /**
    *  直接设置图片
    *
    *  @param image 图片
    */
    func setImage(_ image: UIImage?) {
        self._setImage(image)
        self.lastURL = "";
        self.placeHoderImage = nil;
        self.imageView?.alpha = 1;
        if didGetImage != nil {
            didGetImage!(self, image!)
        }
    }

    /**
    *  设置图片链接
    *
    *  @param url 链接
    *
    */
    func setImageUrl(_ url: URL) -> Void {
        self.setImageUrl(url, syncLoadCache: false)
    }

    /**
    *  设置图片链接,如果有缓存同步读取缓存
    *
    *  @param url           链接
    *  @param syncLoadCache 是否同步读缓存
    *
    */
    func setImageUrl(_ url: URL, syncLoadCache cache: Bool) -> Void {
        self.setImageUrlString(url.absoluteString, syncLoadCache: cache)
    }

    /**
    *  设置图片链接
    *
    *  @param urlString 链接字符串
    *
    */
    func setImageUrlString(_ urlString: String) -> Void {
        self.setImageUrlString(urlString, syncLoadCache: false)
    }
    
    /**
    *  设置图片链接,如果有缓存同步读取缓存
    *
    *  @param urlString           链接字符串
    *  @param syncLoadCache 是否同步读缓存
    *
    */
    func setImageUrlString(_ urlString: String, syncLoadCache cache: Bool) -> Void {
        if urlString.lengthOfBytes(using: .utf8) == 0 {
            self._setImage(nil)
            self.lastURL = ""
            if didGetError != nil {
                didGetError!(self, herr(kDataFormatErrorCode, desc: "url = \(urlString)"))
            }
            return;
        }
        
        if urlString.hasPrefix("http") == false {
            let image: UIImage? = UIImage(named: urlString)
            self._setImage(image)
            self._imageView.alpha = 1;
            if didGetImage != nil {
                didGetImage!(self, _imageView.image!)
            }
            return;
        }
        if self._imageView.image != nil && lastURL.isEqual(urlString) {
            self._imageView.alpha = 1;
            if didGetImage != nil {
                didGetImage!(self, _imageView.image!)
            }
            return;
        }
        
        if self.placeHoderImage == nil && self._imageView.image == nil {
            self._imageView.alpha = 0;
        }
        
        let placeholder: UIImage? = self.placeHoderImage;
        
        self._setImage(nil)
        self.lastURL = ""
        let url: URL = URL(string: urlString)!
        
        if cache {
            KingfisherManager.shared.cache.retrieveImage(forKey: urlString) { result in
                switch result {
                case.success(let value):
                    if value.image != nil {
                        self._setImage(value.image)
                        self._imageView.alpha = 1;
                        self.lastURL = url.absoluteString;
                        if self.didGetImage != nil {
                            self.didGetImage!(self, value.image)
                        }
                    }
                case .failure(_): break
                }
            }
        }
        if _imageView.image == nil {
            _imageView.kf.setImage(with: url, placeholder: placeholder, options: [.transition(ImageTransition.fade(1))], progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    self._setImage(value.image)
                    self.lastURL = url.absoluteString;
                    if value.cacheType == .none {
                        UIView.animate(withDuration: 0.5) {
                            self._imageView.alpha = 1;
                        }
                    }else {
                        self._imageView.alpha = 1;
                    }
                    if self.didGetImage != nil {
                        self.didGetImage!(self, value.image)
                    }
                case .failure(let value):
                    if self.didGetError != nil {
                        self.didGetError!(self, value as AnyObject)
                    }
                }
            }
        }
    }

    /**
    *  设置图片名称，通过文件的方式加载
    *
    *  @param fileName 图片名称
    */
    func setImageWithFile(_ fileName: String) -> Void {
        if fileName.lengthOfBytes(using: .utf8) > 0 {
            let resourcePath: String = Bundle.main.resourcePath!
            let filePath: String = resourcePath.appendingFormat("/%@", fileName)
            let image: UIImage = UIImage(contentsOfFile: filePath)!
            self.setImage(image)
        }else {
            self._setImage(nil)
            self.lastURL = ""
            if didGetError != nil {
                didGetError!(self, herr(kDataFormatErrorCode, desc: "url = \(fileName)"))
            }
        }
    }

    /**
    *  设置图片名称，通过imageName的方式加载
    *
    *  @param fileName 图片名称
    */
    func setImageWithName(_ fileName: String) -> Void {
        if fileName.lengthOfBytes(using: .utf8) > 0 {
            self.setImage(UIImage(named: fileName))
        }
    }

    //点击响应事件
    @objc private func buttonPressed() -> Void {
        if pressed != nil {
            pressed!(self, nil)
        }
    }
    
    //设置背景颜色
    override internal var backgroundColor: UIColor? {
        get {
            return _imageView.backgroundColor
        }
        set(newValue) {
            _imageView.backgroundColor = newValue
        }
    }
    
    //是否圆角展示图片
    var fillet: Bool {
        get {
            return self._imageView.fillet
        }
        set(newValue) {
            self._imageView!.fillet = newValue
        }
    }

    //默认居中显示
    var filletStyle: UIImageViewFilletStyle {
        get {
            return self._imageView.filletStyle
        }
        set(newValue) {
            self._imageView.filletStyle = newValue
        }
    }
    
}
