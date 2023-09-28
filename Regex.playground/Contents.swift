import UIKit

var greeting = "Hello, playground"

// @:?!()$#,./\
let text = "@:?!()$#,./\\"
let specialCharacterRegex = "[@:?!()\\\\]+"
text.range(of: specialCharacterRegex, options: .regularExpression) != nil
