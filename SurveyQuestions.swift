class open func load(_ jsonFileName : String, surveyTheme: SurveyTheme) -> SurveyQuestions? {
    var loadedQuestions : SurveyQuestions? = nil
    
    let file = jsonFileName+".json" //this is the file. we will write to and read from it
    
    let logPath: String = {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let filePath = (documentsPath as NSString).appendingPathComponent(file)
        
        if !FileManager.default.fileExists(atPath: filePath) {
            FileManager.default.createFile(atPath: filePath, contents: nil, attributes: nil)
        }
        print(filePath)
        return filePath
        
    }()
    
    if let data = try? Data(contentsOf: URL(fileURLWithPath: logPath)) {
        do {
            let dict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String : Any?]
            Logger.log(dict)
            loadedQuestions = SurveyQuestions(dict["questions"] as! [[String : Any?]], submitData: dict["submit"] as! [String : String], surveyTheme: surveyTheme)
            if let autoFocus = dict["auto_focus_text"] as? Bool {
                loadedQuestions?.autoFocusText = autoFocus
            }
        } catch {
            Logger.log(error.localizedDescription, level: .error)
        }
    } else {
        Logger.log("Error: Could not find questions file", level: .error)
    }
    
    return loadedQuestions
}
