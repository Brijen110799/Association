
import Foundation
import Alamofire
import SwiftyJSON
import CommonCrypto

class AlamofireSingleTon: NSObject {

    //static let baseURL = "https://app.myassociation.app/" // LIVE
    static let baseURL = "https://dev.myassociation.app/" // DEV

    //let base_url = "https://app.myassociation.app/" // LIVE
    let base_url = "https://dev.myassociation.app/" // DEV
    
    let mainUrl = baseURL + "mainApi/"
    let commonURL = baseURL + "commonApi/"

//    let mainUrl = "https://master.myassociation.app/mainApi/"
//    let commonURL = "https://master.myassociation.app/commonApi/"
    let thirdpartyURL = "https://offerscouponsdeals.in/api/merchant/"
    var dataDefine = Data()
    //    https://offerscouponsdeals.in/api/merchant/stores_list
    static let sharedInstance = AlamofireSingleTon()
    let basevc = BaseVC()
    
    /// Post request with *default Base URL*
    func requestPost(serviceName:String,parameters: [String:String]?,baseUer:String! = BaseVC().baseUrl() , completionHandler: @escaping (Data?, NSError?) -> ()) {
        let header : HTTPHeaders = basevc.getHeaders()
        var param = parameters
        param?.updateValue(basevc.doGetLanguageId() , forKey: "language_id")
        
        
        print("param \(param)")
        let url = "\(baseUer ?? "")\(serviceName)"
        print("url \(url)")
       // print("header \(header)")
        
         AF.request(url, method: .post, parameters: param, encoder: URLEncodedFormParameterEncoder.default, headers: header).response { response in
            
            switch(response.result) {
            case .success(_):
                if let json =  response.data {
                   let pri =  JSON(json)
                    print("json data" , pri)
                }
                
                completionHandler(response.data, nil)
                break
            case .failure(_):
                print("json data fails" )
                completionHandler(response.data,response.error as NSError?)
                break
            }
        }
    }
    func requestPostMainEncrept(serviceName:String,parameters: [String:String]?, completionHandler: @escaping (Data?, NSError?) -> ()) {
        //let header = basevc.getHeaders()
            
       // print("hgsdh" , mainUrl+serviceName)
        let url = "\(mainUrl)\(serviceName)"
        print("url \(url)")
        var param = parameters
        param?.updateValue(basevc.doGetLanguageId() , forKey: "language_id")
        
        /*Alamofire.request(mainUrl + serviceName, method: .post, parameters: param, encoding: URLEncoding.default, headers: header).responseString { (response) in
        
            do {
                let response = try  Utils.aesDecrypt(key: "4c5cfefcc958f1748eb31dcc609736FK", iv: "K8Csuc2GiKvetPZg", message:response.result.value!)
                self.dataDefine = Data(response.utf8)
                             
            } catch {
                print("parse error")
            }
            switch(response.result) {

            case .success(_):
                if response.result.value != nil{
                    let json = JSON(self.dataDefine)
                    print("json data" , json)
                    completionHandler(self.dataDefine,nil)
                }
                break

            case .failure(_):
                completionHandler(nil,response.result.error as NSError?)
                break
            }
        }
        
        AF.request(url, method: .post, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default, headers: header).response { response in
           
            do {
                let response = try  Utils.aesDecrypt(key: "4c5cfefcc958f1748eb31dcc609736FK", iv: "K8Csuc2GiKvetPZg", message:response.result.value!)
                self.dataDefine = Data(response.utf8)
                             
            } catch {
                print("parse error")
            }
           switch(response.result) {
           case .success(_):
               let json = JSON(response.data!)
               print("json data" , json)
               
               completionHandler(response.data, nil)
               break
           case .failure(_):
               print("json data fails" )
               completionHandler(response.data,response.error as NSError?)
               break
           }
       }*/
        
    }
    func requestPostMain(serviceName:String,parameters: [String:String]?, completionHandler: @escaping (Data?, NSError?) -> ()) {
        let header = basevc.getHeaders()
        print("hgsdh" , mainUrl+serviceName)
        var param = parameters
        param?.updateValue(basevc.doGetLanguageId() , forKey: "language_id")
        print("params " , param!)
        let url = "\(mainUrl)\(serviceName)"
        print("url \(url)")
        AF.request(url, method: .post, parameters: param, encoder: URLEncodedFormParameterEncoder.default, headers: header).response { response in
           
           switch(response.result) {
           case .success(_):
               let json = JSON(response.data!)
               print("json data" , json)
               
               completionHandler(response.data, nil)
               break
           case .failure(_):
               print("json data fails" )
               completionHandler(response.data,response.error as NSError?)
               break
           }
       }
//        Alamofire.request(mainUrl+serviceName, method: .post, parameters: param, encoding: URLEncoding.default, headers: header).responseJSON { (response:DataResponse<Any>) in
//
//            switch(response.result) {
//
//            case .success(_):
//                if response.result.value != nil{
//                    let json = JSON(response.data!)
//                    print("json data" , json)
//                    completionHandler(response.data,nil)
//                }
//                break
//
//            case .failure(_):
//                completionHandler(nil,response.result.error as NSError?)
//                break
//
//            }
//        }
        
    }
    func requestPostMultipart(serviceName:String,parameters: [String:Any]?,imagesArray:[UIImage],fileName:String! = "photo",compression :CGFloat!,fileURL:URL! = nil,fileParam:String! = "", completionHandler: @escaping (Data?, NSError?) -> ()) {
        let baseUer = BaseVC().baseUrl()
        let header = basevc.getHeaders()
        var param = parameters
        param?.updateValue(basevc.doGetLanguageId() , forKey: "language_id")
        let url = "\(baseUer)\(serviceName)"
        print("url \(url)")
//        Alamofire.upload(multipartFormData: { multipartFormData in
//
//            for (key,value) in param! {
//                if let value = value as? String {
//                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//                }
//            }
//            print("---------image array count",imagesArray.count,"--------")
//            for image in imagesArray {
//                print("------image filename \(String(describing: fileName!))[]")
//                if  let imageData = image.jpegData(compressionQuality:compression) {
//                    multipartFormData.append(imageData, withName: "\(String(describing: fileName!))[]", fileName: fileName!, mimeType: "image/*")
//                }
//            }
//            if fileURL != nil {
//                multipartFormData.append(fileURL, withName: fileParam)
//            }
//            print(multipartFormData)
//        },
//                         to:baseUer+serviceName,headers: header)
//        { (result) in
//            switch result {
//            case .success(let upload, _, _):
//
//                upload.responseJSON { response in
//                    if response.result.value != nil{
//                        let json = JSON(response.data!)
//                        print("json data" , json)
//                        completionHandler(response.data,nil)
//                    }
//                }
//                break
//            case .failure(let encodingError):
//                print("fail" , encodingError)
//            }
//        }
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key,value) in param! {
                if let value = value as? String {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }
            print("---------image array count",imagesArray.count,"--------")
            for image in imagesArray {
                print("------image filename \(String(describing: fileName!))[]")
                if  let imageData = image.jpegData(compressionQuality:compression) {
                    multipartFormData.append(imageData, withName: "\(String(describing: fileName!))[]", fileName: fileName!, mimeType: "image/*")
                }
            }
            if fileURL != nil {
                multipartFormData.append(fileURL, withName: fileParam)
            }
            print(multipartFormData)
            //             print(multipartFormData)
        }, to: url, method: .post, headers: header).uploadProgress(queue: .main, closure: { progress in
            
        }).response { (response) in
            
            switch response.result {
            case .success(let resut):
                
                let json = JSON(response.data!)
                print("json data" , json)
                
                print("upload success for multipartdata-image result: \(String(describing: resut))")
                completionHandler(response.data, nil)
                
            case .failure(let err):
                print("upload err multipartdata-image: \(err)")
                completionHandler(response.data, response.error as NSError?)
            }
        }
        
        
    }
    
    
    func requestPostMultipartmultiImagesfromdata(serviceName:String,parameters: [String:Any]?,imageData:Data,fileName : String!,imageData1:Data,fileName1: String!,compression :CGFloat!,fileURL:URL! = nil,fileParam:String! = "", completionHandler: @escaping (Data?, NSError?) -> ()) {
        
        let baseUer = BaseVC().baseUrl()
        let header = basevc.getHeaders()
            //["key":BaseVC().apiKey()]
        var param = parameters
        param?.updateValue(basevc.doGetLanguageId() , forKey: "language_id")
        let url = "\(baseUer)\(serviceName)"
        print("url \(url)")
        print("header \(header)")
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key,value) in param! {
                if let value = value as? String {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }
            
            print(imageData.count)
            if imageData.count != 0
            {
                multipartFormData.append(imageData, withName: fileName, fileName:fileName + ".png" , mimeType: "image/*")

            }
         
            if imageData1.count != 0
            {
                multipartFormData.append(imageData1, withName: fileName1, fileName:fileName1 + ".png" , mimeType: "image/*")
               
            }
        
            print(multipartFormData)
            //             print(multipartFormData)
        }, to: url, method: .post, headers: header).uploadProgress(queue: .main, closure: { progress in
            
        }).response { (response) in
            
            switch response.result {
            case .success(let resut):
                
                let json = JSON(response.data!)
                print("json data" , json)
                
                print("upload success for multipartdata-image result: \(String(describing: resut))")
                completionHandler(response.data, nil)
                
            case .failure(let err):
                print("upload err multipartdata-image: \(err)")
                completionHandler(response.data, response.error as NSError?)
            }
        }
//        Alamofire.upload(multipartFormData: { multipartFormData in
//
//            for (key,value) in param! {
//                if let value = value as? String {
//                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//                }
//            }
//            if imageFile != nil{
//                if  let imageData = imageFile.jpegData(compressionQuality:compression) {
//                    multipartFormData.append(imageData, withName: fileName, fileName:fileName + ".png" , mimeType: "image/*")
//                }
//            }
//            print(multipartFormData)
//        },to:baseUer+serviceName,headers: header)
//        { (result) in
//            switch result {
//            case .success(let upload, _, _):
//
//                upload.responseJSON { response in
//                    if response.result.value != nil{
//                        let json = JSON(response.data!)
//                        print("json data" , json)
//                        completionHandler(response.data,nil)
//                    }
//                }
//                break
//
//            case .failure(let encodingError):
//                print("fail" , encodingError)
//            }
//        }
        
        
    }
    
    func requestPostMultipartmultiImages(serviceName:String,parameters: [String:Any]?,imageFile:UIImage!,fileName : String!,imageFile1:UIImage!,fileName1: String!,compression :CGFloat!, completionHandler: @escaping (Data?, NSError?) -> ()) {
        
        let baseUer = BaseVC().baseUrl()
        let header = basevc.getHeaders()
            //["key":BaseVC().apiKey()]
        var param = parameters
        param?.updateValue(basevc.doGetLanguageId() , forKey: "language_id")
        let url = "\(baseUer)\(serviceName)"
        print("url \(url)")
        print("header \(header)")
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key,value) in param! {
                if let value = value as? String {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }
            if imageFile != nil{
                if  let imageData = imageFile.jpegData(compressionQuality:compression) {
                    multipartFormData.append(imageData, withName: fileName, fileName:fileName + ".png" , mimeType: "image/*")
                }
            }
            if imageFile1 != nil{
                if  let imageData = imageFile1.jpegData(compressionQuality:compression) {
                    multipartFormData.append(imageData, withName: fileName1, fileName:fileName1 + ".png" , mimeType: "image/*")
                }
            }
            print(multipartFormData)
            //             print(multipartFormData)
        }, to: url, method: .post, headers: header).uploadProgress(queue: .main, closure: { progress in
            
        }).response { (response) in
            
            switch response.result {
            case .success(let resut):
                
                let json = JSON(response.data!)
                print("json data" , json)
                
                print("upload success for multipartdata-image result: \(String(describing: resut))")
                completionHandler(response.data, nil)
                
            case .failure(let err):
                print("upload err multipartdata-image: \(err)")
                completionHandler(response.data, response.error as NSError?)
            }
        }
//        Alamofire.upload(multipartFormData: { multipartFormData in
//
//            for (key,value) in param! {
//                if let value = value as? String {
//                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//                }
//            }
//            if imageFile != nil{
//                if  let imageData = imageFile.jpegData(compressionQuality:compression) {
//                    multipartFormData.append(imageData, withName: fileName, fileName:fileName + ".png" , mimeType: "image/*")
//                }
//            }
//            print(multipartFormData)
//        },to:baseUer+serviceName,headers: header)
//        { (result) in
//            switch result {
//            case .success(let upload, _, _):
//
//                upload.responseJSON { response in
//                    if response.result.value != nil{
//                        let json = JSON(response.data!)
//                        print("json data" , json)
//                        completionHandler(response.data,nil)
//                    }
//                }
//                break
//
//            case .failure(let encodingError):
//                print("fail" , encodingError)
//            }
//        }
        
        
    }
    func requestPostMultipartImage(serviceName:String,parameters: [String:Any]?,imageFile:UIImage!,fileName : String!,compression :CGFloat!, completionHandler: @escaping (Data?, NSError?) -> ()) {
        
        let baseUer = BaseVC().baseUrl()
        let header = basevc.getHeaders()
            //["key":BaseVC().apiKey()]
        var param = parameters
        param?.updateValue(basevc.doGetLanguageId() , forKey: "language_id")
        let url = "\(baseUer)\(serviceName)"
        print("url \(url)")
        print("header \(header)")
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key,value) in param! {
                if let value = value as? String {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }
            if imageFile != nil{
                if  let imageData = imageFile.jpegData(compressionQuality:compression) {
                    multipartFormData.append(imageData, withName: fileName, fileName:fileName + ".png" , mimeType: "image/*")
                }
            }
            print(multipartFormData)
            //             print(multipartFormData)
        }, to: url, method: .post, headers: header).uploadProgress(queue: .main, closure: { progress in
            
        }).response { (response) in
            
            switch response.result {
            case .success(let resut):
                
                let json = JSON(response.data!)
                print("json data" , json)
                
                print("upload success for multipartdata-image result: \(String(describing: resut))")
                completionHandler(response.data, nil)
                
            case .failure(let err):
                print("upload err multipartdata-image: \(err)")
                completionHandler(response.data, response.error as NSError?)
            }
        }
//        Alamofire.upload(multipartFormData: { multipartFormData in
//
//            for (key,value) in param! {
//                if let value = value as? String {
//                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//                }
//            }
//            if imageFile != nil{
//                if  let imageData = imageFile.jpegData(compressionQuality:compression) {
//                    multipartFormData.append(imageData, withName: fileName, fileName:fileName + ".png" , mimeType: "image/*")
//                }
//            }
//            print(multipartFormData)
//        },to:baseUer+serviceName,headers: header)
//        { (result) in
//            switch result {
//            case .success(let upload, _, _):
//
//                upload.responseJSON { response in
//                    if response.result.value != nil{
//                        let json = JSON(response.data!)
//                        print("json data" , json)
//                        completionHandler(response.data,nil)
//                    }
//                }
//                break
//
//            case .failure(let encodingError):
//                print("fail" , encodingError)
//            }
//        }
        
        
    }
    func requestPostMultipartMain(serviceName:String,parameters: [String:Any]?,imagesArray:[UIImage],fileName:String!="photo",compression :CGFloat!, completionHandler: @escaping (Data?, NSError?) -> ()) {
        let baseUer = mainUrl
        let header = basevc.getHeaders()
            //["key":BaseVC().apiKey()]
        var param = parameters
        param?.updateValue(basevc.doGetLanguageId() , forKey: "language_id")
        let url = "\(baseUer)\(serviceName)"
        print("url \(url)")
       
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key,value) in param! {
                if let value = value as? String {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }
            print(imagesArray.count)
            for image in imagesArray {
                if  let imageData = image.jpegData(compressionQuality:compression) {
                    multipartFormData.append(imageData, withName: "\(fileName ?? "")[]", fileName: "xyz", mimeType: "image/*")
                    
                }
            }
            print(multipartFormData)
            //             print(multipartFormData)
        }, to: url, method: .post, headers: header).uploadProgress(queue: .main, closure: { progress in
            
        }).response { (response) in
            
            switch response.result {
            case .success(let resut):
                
                let json = JSON(response.data!)
                print("json data" , json)
                
                print("upload success for multipartdata-image result: \(String(describing: resut))")
                completionHandler(response.data, nil)
                
            case .failure(let err):
                print("upload err multipartdata-image: \(err)")
                completionHandler(response.data, response.error as NSError?)
            }
        }
        
//        Alamofire.upload(multipartFormData: { multipartFormData in
//
//            for (key,value) in param! {
//                if let value = value as? String {
//                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//                }
//            }
//            print(imagesArray.count)
//            for image in imagesArray {
//                if  let imageData = image.jpegData(compressionQuality:compression) {
//                    multipartFormData.append(imageData, withName: "\(fileName ?? "")[]", fileName: "xyz", mimeType: "image/*")
//
//                }
//            }
//            print(multipartFormData)
//        },to:baseUer+serviceName,headers: header)
//        { (result) in
//            switch result {
//            case .success(let upload, _, _):
//
//                upload.responseJSON { response in
//                    if response.result.value != nil{
//                        let json = JSON(response.data!)
//                        print("json data" , json)
//                        completionHandler(response.data,nil)
//                    }
//                }
//                break
//
//            case .failure(let encodingError):
//                print("fail" , encodingError)
//            }
//        }
    }
    func requestPostMultipartDocument(serviceName:String,parameters: [String:Any]?,fileURL:URL,fileParam: String,compression :CGFloat!, completionHandler: @escaping (Data?, NSError?) -> ()) {
        
        let baseUer = BaseVC().baseUrl()
        let header = basevc.getHeaders()
        var param = parameters
        param?.updateValue(basevc.doGetLanguageId() , forKey: "language_id")
      
        let url = "\(baseUer)\(serviceName)"
        print("url \(url)")
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key,value) in param! {
                if let value = value as? String {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }
            multipartFormData.append(fileURL, withName: fileParam)
            print(multipartFormData)
            //             print(multipartFormData)
        }, to: url, method: .post, headers: header).uploadProgress(queue: .main, closure: { progress in
            
        }).response { (response) in
            
            switch response.result {
            case .success(let resut):
                
                let json = JSON(response.data!)
                print("json data" , json)
                
                print("upload success for multipartdata-image result: \(String(describing: resut))")
                completionHandler(response.data, nil)
                
            case .failure(let err):
                print("upload err multipartdata-image: \(err)")
                completionHandler(response.data, response.error as NSError?)
            }
        }
        
        
//        Alamofire.upload(multipartFormData: { multipartFormData in
//
//            for (key,value) in param! {
//                if let value = value as? String {
//                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//                }
//            }
//            multipartFormData.append(fileURL, withName: fileParam)
//
//        },to:baseUer+serviceName,headers: header)
//        { (result) in
//            switch result {
//            case .success(let upload, _, _):
//
//                upload.responseJSON { response in
//                    if response.result.value != nil{
//                        let json = JSON(response.data!)
//                        print("json data" , json)
//                        completionHandler(response.data,nil)
//                    }
//                }
//                break
//
//            case .failure(let encodingError):
//                print(encodingError)
//            }
//        }
    }
    func requestPostMultipartparms(serviceName:String,parameters: [String:Any]?,fileURL:URL!,compression :CGFloat!,FileName:String!, completionHandler: @escaping (Data?, NSError?) -> ()) {
        let baseUer = BaseVC().baseUrl()
        let header = basevc.getHeaders()
            //["key":BaseVC().apiKey()]
        var param = parameters
        param?.updateValue(basevc.doGetLanguageId() , forKey: "language_id")
        let url = "\(baseUer)\(serviceName)"
        print("url \(url)")
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key,value) in param! {
                if let value = value as? String {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }
            if fileURL != nil{
                multipartFormData.append(fileURL, withName: FileName)
            }
            print(multipartFormData)
            //             print(multipartFormData)
        }, to: url, method: .post, headers: header).uploadProgress(queue: .main, closure: { progress in
            
        }).response { (response) in
            
            switch response.result {
            case .success(let resut):
                
                let json = JSON(response.data!)
                print("json data" , json)
                
                print("upload success for multipartdata-image result: \(String(describing: resut))")
                completionHandler(response.data, nil)
                
            case .failure(let err):
                print("upload err multipartdata-image: \(err)")
                completionHandler(response.data, response.error as NSError?)
            }
        }
        
        
//        Alamofire.upload(multipartFormData: { multipartFormData in
//
//            for (key,value) in param! {
//                if let value = value as? String {
//                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//                }
//            }
//            if fileURL != nil{
//                multipartFormData.append(fileURL, withName: FileName)
//            }
//
//
//        },to:baseUer+serviceName,headers: header)
//        { (result) in
//            switch result {
//            case .success(let upload, _, _):
//
//                upload.responseJSON { response in
//                    if response.result.value != nil{
//                        let json = JSON(response.data!)
//                        print("json data" , json)
//                        completionHandler(response.data,nil)
//                    }
//                }
//                break
//
//            case .failure(let encodingError):
//                print(encodingError)
//            }
//        }
    }
    
    func requestPostMultipartWithArryaImage(serviceName:String,parameters: [String:Any]?,tenant_doc:[URL],prv_doc:[URL],compression :CGFloat! , baseUrl : String! = "",Arrfname:[String]!,Arrlname:[String],Arrmobile:[String],ArrRelation:[String],ArrCountrycode:[String], completionHandler: @escaping (Data?, NSError?) -> ()) {
        let baseUer = baseUrl == "" ? BaseVC().baseUrl() : baseUrl
        let header = basevc.getHeaders()
            //["key":BaseVC().apiKey()]
        //print("base url",baseUrl)
        var param = parameters
        param?.updateValue(basevc.doGetLanguageId() , forKey: "language_id")
        let url = "\(baseUer ?? "")\(serviceName)"
        print("url \(url)")
        
      
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key,value) in param! {
                          if let value = value as? String {
                              multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                          }
                      }
                      if tenant_doc.count > 0  {
                          for image in tenant_doc {
                              //                if  let imageData = image.jpegData(compressionQuality:compression) {
                              //                    multipartFormData.append(imageData, withName: "tenant_doc[]", fileName: "xyz.png", mimeType: "image/*")
                              //
                              //                }
                              multipartFormData.append(image, withName: "tenant_doc[]")
                          }
                      }
          
                      if prv_doc.count > 0  {
                          for image in prv_doc {
                              //                if  let imageData = image.jpegData(compressionQuality:compression) {
                              //                    multipartFormData.append(imageData, withName: "prv_doc[]", fileName: "xyz.png", mimeType: "image/*")
                              //
                              //                }
                              multipartFormData.append(image, withName: "prv_doc[]")
                          }
                      }
                      for item in Arrfname {
                           multipartFormData.append(item.data(using: String.Encoding.utf8)!, withName: "family_first_name[]")
                      }
                      for item in Arrlname {
                           multipartFormData.append(item.data(using: String.Encoding.utf8)!, withName: "family_last_name[]")
                      }
                      for item in Arrmobile {
                           multipartFormData.append(item.data(using: String.Encoding.utf8)!, withName: "family_mobile[]")
                      }
                      for item in ArrRelation {
                           multipartFormData.append(item.data(using: String.Encoding.utf8)!, withName: "family_relation_name[]")
                      }
                      for item in ArrCountrycode {
                           multipartFormData.append(item.data(using: String.Encoding.utf8)!, withName: "family_country_code[]")
                      }
                      print("'tenant_doc   ", tenant_doc.count)
                      print("prv_doc  " ,prv_doc.count)
            //             print(multipartFormData)
        }, to: url, method: .post, headers: header).uploadProgress(queue: .main, closure: { progress in
            
        }).response { (response) in
            
            switch response.result {
            case .success(let resut):
                
                let json = JSON(response.data!)
                print("json data" , json)
                
                print("upload success for multipartdata-image result: \(String(describing: resut))")
                completionHandler(response.data, nil)
                
            case .failure(let err):
                print("upload err multipartdata-image: \(err)")
                completionHandler(response.data, response.error as NSError?)
            }
        }
//        Alamofire.upload(multipartFormData: { multipartFormData in
//
//            for (key,value) in param! {
//                if let value = value as? String {
//                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//                }
//            }
//            if tenant_doc.count > 0  {
//                for image in tenant_doc {
//                    //                if  let imageData = image.jpegData(compressionQuality:compression) {
//                    //                    multipartFormData.append(imageData, withName: "tenant_doc[]", fileName: "xyz.png", mimeType: "image/*")
//                    //
//                    //                }
//                    multipartFormData.append(image, withName: "tenant_doc[]")
//                }
//            }
//
//            if prv_doc.count > 0  {
//                for image in prv_doc {
//                    //                if  let imageData = image.jpegData(compressionQuality:compression) {
//                    //                    multipartFormData.append(imageData, withName: "prv_doc[]", fileName: "xyz.png", mimeType: "image/*")
//                    //
//                    //                }
//                    multipartFormData.append(image, withName: "prv_doc[]")
//                }
//            }
//            for item in Arrfname {
//                 multipartFormData.append(item.data(using: String.Encoding.utf8)!, withName: "family_first_name[]")
//            }
//            for item in Arrlname {
//                 multipartFormData.append(item.data(using: String.Encoding.utf8)!, withName: "family_last_name[]")
//            }
//            for item in Arrmobile {
//                 multipartFormData.append(item.data(using: String.Encoding.utf8)!, withName: "family_mobile[]")
//            }
//            for item in ArrRelation {
//                 multipartFormData.append(item.data(using: String.Encoding.utf8)!, withName: "family_relation_name[]")
//            }
//            for item in ArrCountrycode {
//                 multipartFormData.append(item.data(using: String.Encoding.utf8)!, withName: "family_country_code[]")
//            }
//            print("'tenant_doc   ", tenant_doc.count)
//            print("prv_doc  " ,prv_doc.count)
//
//            print(multipartFormData)
//
//
//
//        },to:baseUer!+serviceName,headers: header)
//        { (result) in
//            switch result {
//            case .success(let upload, _, _):
//
//                upload.responseJSON { response in
//                    if response.result.value != nil{
//                        let json = JSON(response.data!)
//                        print("json data" , json)
//                        completionHandler(response.data,nil)
//                    }
//                }
//                break
//
//            case .failure(let encodingError):
//                print("fail" , encodingError)
//            }
//        }
    }
    func requestPostMultipartImageAndVideo(serviceName:String,parameters: [String:Any]?,imagesArray:[UIImage],fileName:String! = "photo",compression :CGFloat!,fileURL:URL!,imageFileParam : String,fileParam : String, completionHandler: @escaping (Data?, NSError?) -> ()) {
        
        
        let baseUer = BaseVC().baseUrl()
        let header = basevc.getHeaders()
            //["key":BaseVC().apiKey()]
        var param = parameters
        param?.updateValue(basevc.doGetLanguageId() , forKey: "language_id")
      
        
        let url = "\(baseUer)\(serviceName)"
        print("url \(url)")
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key,value) in param! {
                if let value = value as? String {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }
            if fileURL != nil{
                multipartFormData.append(fileURL, withName: fileParam)
            }
            print("---------image array count",imagesArray.count,"--------")
            for image in imagesArray {
                print("------image filename \(String(describing: fileName!))")
                if  let imageData = image.jpegData(compressionQuality:compression) {
                    multipartFormData.append(imageData, withName: "\(String(describing: fileName!))", fileName: fileName!, mimeType: "image/*")
                }
            }
            
            print(multipartFormData)
            //             print(multipartFormData)
        }, to: url, method: .post, headers: header).uploadProgress(queue: .main, closure: { progress in
            
        }).response { (response) in
            
            switch response.result {
            case .success(let resut):
                
                let json = JSON(response.data!)
                print("json data" , json)
                
                print("upload success for multipartdata-image result: \(String(describing: resut))")
                completionHandler(response.data, nil)
                
            case .failure(let err):
                print("upload err multipartdata-image: \(err)")
                completionHandler(response.data, response.error as NSError?)
            }
        }
        
//        Alamofire.upload(multipartFormData: { multipartFormData in
//
//            for (key,value) in param! {
//                if let value = value as? String {
//                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//                }
//            }
//            if fileURL != nil{
//                multipartFormData.append(fileURL, withName: fileParam)
//            }
//            print("---------image array count",imagesArray.count,"--------")
//            for image in imagesArray {
//                print("------image filename \(String(describing: fileName!))")
//                if  let imageData = image.jpegData(compressionQuality:compression) {
//                    multipartFormData.append(imageData, withName: "\(String(describing: fileName!))", fileName: fileName!, mimeType: "image/*")
//                }
//            }
//            print(multipartFormData)
//        },
//                         to:baseUer+serviceName,headers: header)
//        { (result) in
//            switch result {
//            case .success(let upload, _, _):
//
//                upload.responseJSON { response in
//                    if response.result.value != nil{
//                        let json = JSON(response.data!)
//                        print("json data" , json)
//                        completionHandler(response.data,nil)
//                    }
//                }
//                break
//            case .failure(let encodingError):
//                print("fail" , encodingError)
//            }
//        }
    
    }
    
    
    func requestPostMultipartImageAndAudio(serviceName:String,parameters: [String:Any]?,fileURL:URL!,compression :CGFloat!,imageFile:UIImage! , fileParam : String,imageFileParam : String, completionHandler: @escaping (Data?, NSError?) -> ()) {

        let baseUer = BaseVC().baseUrl()
        let header = basevc.getHeaders()
            //["key":BaseVC().apiKey()]
        var param = parameters
        param?.updateValue(basevc.doGetLanguageId() , forKey: "language_id")
      
        let url = "\(baseUer)\(serviceName)"
        print("url \(url)")
        //baseUer+serviceName
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key,value) in param! {
                if let value = value as? String {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }
            if fileURL != nil{
                multipartFormData.append(fileURL, withName: fileParam)
            }
            if imageFile != nil{
                if  let imageData = imageFile.jpegData(compressionQuality:compression) {
                    multipartFormData.append(imageData, withName: imageFileParam, fileName:"xyz.png" , mimeType: "image/*")
                }
            }
           
            
            print(multipartFormData)
            //             print(multipartFormData)
        }, to: url, method: .post, headers: header).uploadProgress(queue: .main, closure: { progress in
            
        }).response { (response) in
            
            switch response.result {
            case .success(let resut):
                
                let json = JSON(response.data!)
                print("json data" , json)
                
                print("upload success for multipartdata-image result: \(String(describing: resut))")
                completionHandler(response.data, nil)
                
            case .failure(let err):
                print("upload err multipartdata-image: \(err)")
                completionHandler(response.data, response.error as NSError?)
            }
        }
        
        
        
//        Alamofire.upload(multipartFormData: { multipartFormData in
//
//            for (key,value) in param! {
//                if let value = value as? String {
//                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//                }
//            }
//            if fileURL != nil{
//                multipartFormData.append(fileURL, withName: fileParam)
//            }
//            if imageFile != nil{
//                if  let imageData = imageFile.jpegData(compressionQuality:compression) {
//                    multipartFormData.append(imageData, withName: imageFileParam, fileName:"xyz.png" , mimeType: "image/*")
//                }
//            }
//
//        },to:baseUer+serviceName,headers: header)
//        { (result) in
//            switch result {
//            case .success(let upload, _, _):
//
//                upload.responseJSON { response in
//                    if response.result.value != nil{
//                        let json = JSON(response.data!)
//                        print("json data" , json)
//                        completionHandler(response.data,nil)
//                    }
//                }
//                break
//
//            case .failure(let encodingError):
//                print(encodingError)
//            }
//        }
    }
    
    func requestPostMultipartImageAndAudioVideo(serviceName:String,parameters: [String:Any]?,fileURL:URL!,compression :CGFloat!,fileParam : String,videofile:Data , videoname : String, completionHandler: @escaping (Data?, NSError?) -> ()) {

        let baseUer = BaseVC().baseUrl()
        let header = basevc.getHeaders()
            //["key":BaseVC().apiKey()]
        var param = parameters
        param?.updateValue(basevc.doGetLanguageId() , forKey: "language_id")
      
        let url = "\(baseUer)\(serviceName)"
        print("url \(url)")
        //baseUer+serviceName
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key,value) in param! {
                if let value = value as? String {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }
            if fileURL != nil{
                multipartFormData.append(fileURL, withName: fileParam)
            }
            if videofile.count != 0{
               
                    multipartFormData.append(videofile, withName: videoname, fileName:"xyz.mp4" , mimeType: "video/mp4")
                
            }
            
            print(multipartFormData)
            //             print(multipartFormData)
        }, to: url, method: .post, headers: header).uploadProgress(queue: .main, closure: { progress in
            
        }).response { (response) in
            
            switch response.result {
            case .success(let resut):
                
                let json = JSON(response.data!)
                print("json data" , json)
                
                print("upload success for multipartdata-image result: \(String(describing: resut))")
                completionHandler(response.data, nil)
                
            case .failure(let err):
                print("upload err multipartdata-image: \(err)")
                completionHandler(response.data, response.error as NSError?)
            }
        }
        
        
        
//        Alamofire.upload(multipartFormData: { multipartFormData in
//
//            for (key,value) in param! {
//                if let value = value as? String {
//                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//                }
//            }
//            if fileURL != nil{
//                multipartFormData.append(fileURL, withName: fileParam)
//            }
//            if imageFile != nil{
//                if  let imageData = imageFile.jpegData(compressionQuality:compression) {
//                    multipartFormData.append(imageData, withName: imageFileParam, fileName:"xyz.png" , mimeType: "image/*")
//                }
//            }
//
//        },to:baseUer+serviceName,headers: header)
//        { (result) in
//            switch result {
//            case .success(let upload, _, _):
//
//                upload.responseJSON { response in
//                    if response.result.value != nil{
//                        let json = JSON(response.data!)
//                        print("json data" , json)
//                        completionHandler(response.data,nil)
//                    }
//                }
//                break
//
//            case .failure(let encodingError):
//                print(encodingError)
//            }
//        }
    }

    func requestPostCommon(serviceName:String,parameters: [String:String]?, completionHandler: @escaping (Data?, NSError?) -> ()) {
        let header = basevc.getHeaders()
            //["key":BaseVC().apiKey()]
        print("header",header)
      //  print("hgsdh" , commonURL+serviceName)
        var param = parameters
        param?.updateValue(basevc.doGetLanguageId() , forKey: "language_id")
        print("param",param ?? ["":""])
      
        let url = "\(commonURL)\(serviceName)"
       print("url \(url)")
        AF.request(url, method: .post, parameters: param, encoder: URLEncodedFormParameterEncoder.default, headers: header).response { response in
           
           switch(response.result) {
           case .success(_):
               let json = JSON(response.data!)
               print("json data" , json)
               
               completionHandler(response.data, nil)
               break
           case .failure(_):
               print("json data fails" )
               completionHandler(response.data,response.error as NSError?)
               break
           }
       }
//        Alamofire.request(commonURL+serviceName, method: .post, parameters: param, encoding: URLEncoding.default, headers: header).responseJSON { (response:DataResponse<Any>) in
//
//            switch(response.result) {
//
//            case .success(_):
//                if response.result.value != nil{
//                    print(response)
//                    let json = JSON(response.data!)
//                    print("json data" , json)
//                    completionHandler(response.data,nil)
//                }
//                break
//
//            case .failure(_):
//                print(response)
//                completionHandler(nil,response.result.error as NSError?)
//                break
//
//            }
//        }
    }
    func requestPostCommonMultipartArrayImage(serviceName:String,parameters: [String:Any]?,imageFile:UIImage!,fileName : String!,compression :CGFloat!, completionHandler: @escaping (Data?, NSError?) -> ()) {
        let header = basevc.getHeaders()
            //["key":BaseVC().apiKey()]
        var param = parameters
        param?.updateValue(basevc.doGetLanguageId() , forKey: "language_id")
        print("param",param ?? ["":""])
        let url = "\(commonURL)\(serviceName)"
        print("url \(url)")
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key,value) in param! {
                if let value = value as? String {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }
            if  let imageData = imageFile.jpegData(compressionQuality:compression) {
                multipartFormData.append(imageData, withName: fileName, fileName:fileName + ".png" , mimeType: "image/*")
            }
            print(multipartFormData)
            //             print(multipartFormData)
        }, to: url, method: .post, headers: header).uploadProgress(queue: .main, closure: { progress in
            
        }).response { (response) in
            
            switch response.result {
            case .success(let resut):
                
                let json = JSON(response.data!)
                print("json data" , json)
                
                print("upload success for multipartdata-image result: \(String(describing: resut))")
                completionHandler(response.data, nil)
                
            case .failure(let err):
                print("upload err multipartdata-image: \(err)")
                completionHandler(response.data, response.error as NSError?)
            }
        }
        
        
//        Alamofire.upload(multipartFormData: { multipartFormData in
//
//            for (key,value) in param! {
//                if let value = value as? String {
//                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//                }
//            }
//            if  let imageData = imageFile.jpegData(compressionQuality:compression) {
//                multipartFormData.append(imageData, withName: fileName, fileName:fileName + ".png" , mimeType: "image/*")
//            }
//            print(multipartFormData)
//        },to:commonURL+serviceName,headers: header)
//        { (result) in
//            switch result {
//            case .success(let upload, _, _):
//
//                upload.responseJSON { response in
//                    if response.result.value != nil{
//                        let json = JSON(response.data!)
//                        print("json data" , json)
//                        completionHandler(response.data,nil)
//                    }
//                }
//                break
//
//            case .failure(let encodingError):
//                print("fail" , encodingError)
//            }
//        }
    }
    func requestPostCommonMultipart(serviceName:String,parameters: [String:Any]?,imagesArray:[UIImage],compression :CGFloat!, completionHandler: @escaping (Data?, NSError?) -> ()) {
        let header = basevc.getHeaders()
            //["key":BaseVC().apiKey()]
        print("ddd = " , commonURL+serviceName)
        var param = parameters
        param?.updateValue(basevc.doGetLanguageId() , forKey: "language_id")
        print("param",param ?? ["":""])
        let url = "\(commonURL)\(serviceName)"
        print("url \(url)")
      
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key,value) in param! {
                if let value = value as? String {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }
            print(imagesArray.count)
            if imagesArray.count > 0 {
                for image in imagesArray {
                    if  let imageData = image.jpegData(compressionQuality:compression) {
                        multipartFormData.append(imageData, withName: "photo[]", fileName: "xyz.png", mimeType: "image/*")
                    }
                }
            }
            print(multipartFormData)
            //             print(multipartFormData)
        }, to: url, method: .post, headers: header).uploadProgress(queue: .main, closure: { progress in
            
        }).response { (response) in
            
            switch response.result {
            case .success(let resut):
                
                let json = JSON(response.data!)
                print("json data" , json)
                
                print("upload success for multipartdata-image result: \(String(describing: resut))")
                completionHandler(response.data, nil)
                
            case .failure(let err):
                print("upload err multipartdata-image: \(err)")
                completionHandler(response.data, response.error as NSError?)
            }
        }
        
//        Alamofire.upload(multipartFormData: { multipartFormData in
//
//            for (key,value) in param! {
//                if let value = value as? String {
//                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//                }
//            }
//            print(imagesArray.count)
//            if imagesArray.count > 0 {
//                for image in imagesArray {
//                    if  let imageData = image.jpegData(compressionQuality:compression) {
//                        multipartFormData.append(imageData, withName: "photo[]", fileName: "xyz.png", mimeType: "image/*")
//                    }
//                }
//            }
//
//            print(multipartFormData)
//        },
//                         to:commonURL+serviceName,headers: header)
//        { (result) in
//            switch result {
//            case .success(let upload, _, _):
//
//                upload.responseJSON { response in
//                    if response.result.value != nil{
//                        let json = JSON(response.data!)
//                        print("json data" , json)
//                        completionHandler(response.data,nil)
//                    }
//                }
//                break
//            case .failure(let encodingError):
//                print("fail" , encodingError)
//            }
//        }
    }
    

    func requestPostThirdPartyNew(serviceName:String,parameters: [String:String]?, completionHandler: @escaping (Data?, NSError?) -> ()) {
        let headers : HTTPHeaders = ["Authorization": "18d1cbe9-f4bb-47c0-b977-ca6a3abbd88f", "Content-Type": "application/json"]
        print("header",headers)
        print("hgsdh" , thirdpartyURL+serviceName)
        let url = "\(thirdpartyURL)\(serviceName)"
        AF.request(url, method: .post, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default, headers: headers).response { response in
           
           switch(response.result) {
           case .success(_):
               let json = JSON(response.data!)
               print("json data" , json)
               
               completionHandler(response.data, nil)
               break
           case .failure(_):
               print("json data fails" )
               completionHandler(response.data,response.error as NSError?)
               break
           }
       }
//        Alamofire.request(thirdpartyURL+serviceName, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
//
//            switch(response.result) {
//
//            case .success(_):
//                if response.result.value != nil{
////                    print(response)
//                    let json = JSON(response.data!)
//                    print("json data" , json)
//                    completionHandler(response.data,nil)
//                }
//                break
//
//            case .failure(_):
//                print(response)
//                completionHandler(nil,response.result.error as NSError?)
//                break
//
//            }
//        }
    }
    
    func requestPostThirdPartyForRawData(serviceName:String,parameters: [String:String]?, completionHandler: @escaping (Data?, NSError?) -> ()) {
        let headers : HTTPHeaders = ["Authorization": "18d1cbe9-f4bb-47c0-b977-ca6a3abbd88f", "Content-Type": "application/json"]
        print("header",headers)
        print("hgsdh" , thirdpartyURL+serviceName)
        
        let url = "\(thirdpartyURL)\(serviceName)"
        AF.request(url, method: .post, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default, headers: headers).response { response in
           
           switch(response.result) {
           case .success(_):
               let json = JSON(response.data!)
               print("json data" , json)
               
               completionHandler(response.data, nil)
               break
           case .failure(_):
               print("json data fails" )
               completionHandler(response.data,response.error as NSError?)
               break
           }
       }
//        Alamofire.request(thirdpartyURL+serviceName, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
//            switch(response.result) {
//            case .success(_):
//                if response.result.value != nil{
//                    print(response)
//                    let json = JSON(response.data!)
//                    print("json data" , json)
//                    completionHandler(response.data,nil)
//                }
//                break
//
//            case .failure(_):
//                print(response)
//                completionHandler(nil,response.result.error as NSError?)
//                break
//
//            }
//        }
    }
    
    func requestPostMultipartWithParam(serviceName:String, baseUer:String! = BaseVC().baseUrl(),parameters: [String:Any]?,doc_array:[UIImage],fileNameParam : String,compression :CGFloat!,mesgData : [String], completionHandler: @escaping (Data?, NSError?) -> ()) {
           let header = basevc.getHeaders()
            //["key":BaseVC().apiKey()]
           
        var param = parameters
        param?.updateValue(basevc.doGetLanguageId() , forKey: "language_id")
        print("param",param ?? ["":""])
        let url = "\(baseUer ?? "")\(serviceName)"
        print("url \(url)")
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key,value) in param! {
                if let value = value as? String {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }
            print(doc_array.count)
//            for image in doc_array {
//                print("ddd path " , image)
//                multipartFormData.append(image, withName: fileNameParam)
//            }
            for image in doc_array {
                            //print("------image filename \(String(describing: fileNameParam!))[]")
                            if  let imageData = image.jpegData(compressionQuality:compression) {
                                multipartFormData.append(imageData, withName: "\(String(describing: fileNameParam))", fileName: fileNameParam, mimeType: "image/*")
                            }
                        }
            for item in mesgData {
                multipartFormData.append(item.data(using: String.Encoding.utf8)!, withName: "msg_data[]")
            }
            
            print(multipartFormData)
            //             print(multipartFormData)
        }, to: url, method: .post, headers: header).uploadProgress(queue: .main, closure: { progress in
            
        }).response { (response) in
            
            switch response.result {
            case .success(let resut):
                
                let json = JSON(response.data!)
                print("json data" , json)
                
                print("upload success for multipartdata-image result: \(String(describing: resut))")
                completionHandler(response.data, nil)
                
            case .failure(let err):
                print("upload err multipartdata-image: \(err)")
                completionHandler(response.data, response.error as NSError?)
            }
        }
//           Alamofire.upload(multipartFormData: { multipartFormData in
//
//               for (key,value) in param! {
//                   if let value = value as? String {
//                       multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//                   }
//               }
//               print(doc_array.count)
//            for image in doc_array {
//                print("ddd path " , image)
//                multipartFormData.append(image, withName: fileNameParam)
//            }
//            for item in mesgData {
//                 multipartFormData.append(item.data(using: String.Encoding.utf8)!, withName: "msg_data[]")
//            }
//               print(multipartFormData)
//           },
//                            to:baseUer+serviceName,headers: header)
//           { (result) in
//               switch result {
//               case .success(let upload, _, _):
//
//                   upload.responseJSON { response in
//                       if response.result.value != nil{
//                           let json = JSON(response.data!)
//                           print("json data" , json)
//                           completionHandler(response.data,nil)
//                       }
//                   }
//                   break
//               case .failure(let encodingError):
//                   print("fail" , encodingError)
//               }
//           }
       }
    
    func requestPostMultipartParmsCommon(serviceName:String,parameters: [String:Any]?,fileURL:URL,compression :CGFloat!,FileName:String!, completionHandler: @escaping (Data?, NSError?) -> ()) {
        let baseUer = commonURL
        let header = basevc.getHeaders()
            //["key":BaseVC().apiKey()]
        var param = parameters
        param?.updateValue(basevc.doGetLanguageId() , forKey: "language_id")
        print("param",param ?? ["":""])
        let url = "\(baseUer)\(serviceName)"
        print("url \(url)")
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key,value) in param! {
                if let value = value as? String {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }
            multipartFormData.append(fileURL, withName: FileName)
            
            print(multipartFormData)
            //             print(multipartFormData)
        }, to: url, method: .post, headers: header).uploadProgress(queue: .main, closure: { progress in
            
        }).response { (response) in
            
            switch response.result {
            case .success(let resut):
                
                let json = JSON(response.data!)
                print("json data" , json)
                
                print("upload success for multipartdata-image result: \(String(describing: resut))")
                completionHandler(response.data, nil)
                
            case .failure(let err):
                print("upload err multipartdata-image: \(err)")
                completionHandler(response.data, response.error as NSError?)
            }
        }
//        Alamofire.upload(multipartFormData: { multipartFormData in
//
//            for (key,value) in param! {
//                if let value = value as? String {
//                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//                }
//            }
//            multipartFormData.append(fileURL, withName: FileName)
//
//        },to:baseUer+serviceName,headers: header)
//        { (result) in
//            switch result {
//            case .success(let upload, _, _):
//
//                upload.responseJSON { response in
//                    if response.result.value != nil{
//                        let json = JSON(response.data!)
//                        print("json data" , json)
//                        completionHandler(response.data,nil)
//                    }
//                }
//                break
//
//            case .failure(let encodingError):
//                print(encodingError)
//            }
//        }
    }
 
    func requestPostMultipartWithFileArryaReg(serviceName:String,parameters: [String:Any]?,joining_doc:[URL],paramName : String ,compression :CGFloat!, completionHandler: @escaping (Data?, NSError?) -> ()) {
        let baseUer = BaseVC().baseUrl()
        let header = basevc.getHeaders()
        //["key":BaseVC().apiKey()]
        var param = parameters
        param?.updateValue(basevc.doGetLanguageId() , forKey: "language_id")
        print("param",param ?? ["":""])
        let url = "\(baseUer)\(serviceName)"
        print("url \(url)")
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in param! {
                if let value = value as? String {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }
            for image in joining_doc {
                print("ddd path " , image)
                multipartFormData.append(image, withName: "joining_doc[]")
            }
          
            print(multipartFormData)
            //             print(multipartFormData)
        }, to: url, method: .post, headers: header).uploadProgress(queue: .main, closure: { progress in
            
        }).response { (response) in
            
            switch response.result {
            case .success(let resut):
                
                let json = JSON(response.data!)
                print("json data" , json)
                
                print("upload success for multipartdata-image result: \(String(describing: resut))")
                completionHandler(response.data, nil)
                
            case .failure(let err):
                print("upload err multipartdata-image: \(err)")
                completionHandler(response.data, response.error as NSError?)
            }
        }

       }
    
    func requestPostMultipartWithFileArry(serviceName:String,parameters: [String:Any]?,file_doc:[URL],file_name:String,compression :CGFloat!, completionHandler: @escaping (Data?, NSError?) -> ()) {
        let baseUer = BaseVC().baseUrl()
        let header = basevc.getHeaders()
        //["key":BaseVC().apiKey()]
        var param = parameters
        param?.updateValue(basevc.doGetLanguageId() , forKey: "language_id")
        print("param",param ?? ["":""])
        let url = "\(baseUer)\(serviceName)"
        print("url \(url)")
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in param! {
                if let value = value as? String {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }
            for image in file_doc{
                print("ddd path " , image)
                multipartFormData.append(image, withName: file_name)
            }
          
            print(multipartFormData)
            //             print(multipartFormData)
        }, to: url, method: .post, headers: header).uploadProgress(queue: .main, closure: { progress in
            
        }).response { (response) in
            
            switch response.result {
            case .success(let resut):
                
                let json = JSON(response.data!)
                print("json data" , json)
                
                print("upload success for multipartdata-image result: \(String(describing: resut))")
                completionHandler(response.data, nil)
                
            case .failure(let err):
                print("upload err multipartdata-image: \(err)")
                completionHandler(response.data, response.error as NSError?)
            }
        }

       }
    
    
    func requestPostMultipartWithFileArryaImage(serviceName:String,parameters: [String:Any]?,doc_array:[URL],paramName : String ,compression :CGFloat!, completionHandler: @escaping (Data?, NSError?) -> ()) {
        let baseUer = BaseVC().baseUrl()
        let header = basevc.getHeaders()
        //["key":BaseVC().apiKey()]
        var param = parameters
        param?.updateValue(basevc.doGetLanguageId() , forKey: "language_id")
        print("param",param ?? ["":""])
        let url = "\(baseUer)\(serviceName)"
        print("url \(url)")
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in param! {
                if let value = value as? String {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }
            for image in doc_array {
                print("ddd path " , image)
                multipartFormData.append(image, withName: paramName)
            }
          
            print(multipartFormData)
            //             print(multipartFormData)
        }, to: url, method: .post, headers: header).uploadProgress(queue: .main, closure: { progress in
            
        }).response { (response) in
            
            switch response.result {
            case .success(let resut):
                
                let json = JSON(response.data!)
                print("json data" , json)
                
                print("upload success for multipartdata-image result: \(String(describing: resut))")
                completionHandler(response.data, nil)
                
            case .failure(let err):
                print("upload err multipartdata-image: \(err)")
                completionHandler(response.data, response.error as NSError?)
            }
        }
//        Alamofire.upload(multipartFormData: { multipartFormData in
//
//               for (key,value) in param! {
//                   if let value = value as? String {
//                       multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//                   }
//               }
//               for image in doc_array {
//                   print("ddd path " , image)
//                   multipartFormData.append(image, withName: paramName)
//               }
//
//
//            print(multipartFormData)
//
//           },to:baseUer+serviceName,headers: header)
//           { (result) in
//               switch result {
//               case .success(let upload, _, _):
//
//                   upload.responseJSON { response in
//                       if response.result.value != nil{
//                           let json = JSON(response.data!)
//                           print("json data" , json)
//                           completionHandler(response.data,nil)
//                       }
//                   }
//                   break
//
//               case .failure(let encodingError):
//                   print("fail" , encodingError)
//               }
//           }
       }
    
    func requestPostMultipartArray(serviceName:String,parameters: [String:Any]?,family_user_id : [String],member_relation : [String],paramArray:String, completionHandler: @escaping (Data?, NSError?) -> ()) {
        let baseUer = BaseVC().baseUrl()
        let header = basevc.getHeaders()
            //["key":BaseVC().apiKey()]
        var param = parameters
        param?.updateValue(basevc.doGetLanguageId() , forKey: "language_id")
        print("param",param ?? ["":""])
        let url = "\(baseUer)\(serviceName)"
        print("url \(url)")
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key,value) in param! {
                if let value = value as? String {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }
            if family_user_id.count > 0 {
                for item in family_user_id {
                    multipartFormData.append(item.data(using: String.Encoding.utf8)!, withName: paramArray)
                }
            }
            if member_relation.count > 0 {
                for item in member_relation {
                    multipartFormData.append(item.data(using: String.Encoding.utf8)!, withName: "member_relation[]")
                }
            }
            
            print(multipartFormData)
            //             print(multipartFormData)
        }, to: url, method: .post, headers: header).uploadProgress(queue: .main, closure: { progress in
            
        }).response { (response) in
            
            switch response.result {
            case .success(let resut):
                
                let json = JSON(response.data!)
                print("json data" , json)
                
                print("upload success for multipartdata-image result: \(String(describing: resut))")
                completionHandler(response.data, nil)
                
            case .failure(let err):
                print("upload err multipartdata-image: \(err)")
                completionHandler(response.data, response.error as NSError?)
            }
        }
//        Alamofire.upload(multipartFormData: { multipartFormData in
//
//            for (key,value) in param! {
//                if let value = value as? String {
//                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//                }
//            }
//            if family_user_id.count > 0 {
//            for item in family_user_id {
//                 multipartFormData.append(item.data(using: String.Encoding.utf8)!, withName: paramArray)
//            }
//            }
//            if member_relation.count > 0 {
//            for item in member_relation {
//                 multipartFormData.append(item.data(using: String.Encoding.utf8)!, withName: "member_relation[]")
//            }
//            }
//
//            print(multipartFormData)
//        },to:baseUer+serviceName,headers: header)
//        { (result) in
//            switch result {
//            case .success(let upload, _, _):
//
//                upload.responseJSON { response in
//                    if response.result.value != nil{
//                        let json = JSON(response.data!)
//                        print("json data" , json)
//                        completionHandler(response.data,nil)
//                    }
//                }
//                break
//
//            case .failure(let encodingError):
//                print("fail" , encodingError)
//            }
//        }
    }
    
/// ---------------------------
    //   func sendPushNotification(title: String ,body: String ,device:String, completionHandler: @escaping (Data?, NSError?) -> ()) {
//         let   header = ["content_type":"application/json", "Authorization":"key=\(StringConstants.SERVER_KEY)"]
//            let FCM_API = "https://fcm.googleapis.com/fcm/send"
//
//            let notification = ["to":"\(device)",
//                                "notification":["body":body, "title":title, "badge":"0", "sound":"default"],
//                                "data":["body":body, "title":title]] as [String : Any]
//
//
//
//            print("parmas :  \(notification)")
//
//
//            let url = "\(FCM_API)"
//            print("url \(url)")
//            AF.request(url, method: .post, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default, headers: headers).response { response in
//
//               switch(response.result) {
//               case .success(_):
//                   let json = JSON(response.data!)
//                   print("json data" , json)
//
//                   completionHandler(response.data, nil)
//                   break
//               case .failure(_):
//                   print("json data fails" )
//                   completionHandler(response.data,response.error as NSError?)
//                   break
//               }
//           }
            
            
//            Alamofire.request(FCM_API, method: .post, parameters: notification, encoding: JSONEncoding.default, headers: header).responseJSON { (response:DataResponse<Any>) in
//                switch(response.result) {
//                case .success(_):
//                    if response.result.value != nil {
//                        let json = JSON(response.data!)
//                        print("json data" , json)
//                        completionHandler(response.data,nil)
//                    }
//                    break
//                case .failure(_):
//    //                let json = JSON(response.data!)
//    //                print("json data" , json)
//                    completionHandler(response.data,response.result.error as NSError?)
//                    break
//                }
  //          }
   //     }
        
    
    
    
    func doGetLanguageData(serviceName:String,parameters: [String:String]?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        
        let header = basevc.getHeaders()
            //["key":BaseVC().apiKey()]
        print("header",header)
        print("hgsdh" , commonURL+serviceName)
       
        let url = "\(commonURL)\(serviceName)"
        print("url \(url)")
        AF.request(url, method: .post, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default, headers: header).responseJSON { response in
            
            switch(response.result) {
            case .success(_):
                let json = JSON(response.data!)
                print("json data" , json)
                
                if let json = response.value{
                    let dict :NSDictionary = json as! NSDictionary
                   // UserDefaults.standard.set(dict, forKey: StringConstants.LANGUAGE_DATA)
                    completionHandler(dict, nil)
                }
                
                break
            case .failure(let error):
                print("json data fails" )
                completionHandler(nil,error as NSError?)
                break
            }
        }
        
//        Alamofire.request(commonURL+serviceName, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: header).responseJSON { (response:DataResponse<Any>) in
//
//            switch(response.result) {
//
//            case .success(_):
//
//                if let json = response.result.value{
//                    let dict :NSDictionary = json as! NSDictionary
//
//                    UserDefaults.standard.set(dict, forKey: StringConstants.LANGUAGE_DATA)
//                    completionHandler(true, nil)
//                }
//
//                break
//
//            case .failure(_):
//                print(response)
//                completionHandler(false,response.result.error as NSError?)
//                break
//
//            }
//        }
        
        
        
        
    }
    
}

