import Foundation

extension  String {

  // MARK: URL Encoding
  
  public var urlDecoded: String? {
    return removingPercentEncoding
  }

  public func urlEncoded(_ allowedChacaterSet: CharacterSet) -> String? {
    return addingPercentEncoding(withAllowedCharacters: allowedChacaterSet)!
  }
  
  // MARK: Base64 Encoding
  
  public var base64Decoded: String? {
    guard let data = Data(base64Encoded: self) else { return nil }
    return String(data: data, encoding: .utf8)
  }
  
  public var base64Encoded: String? {
    return data(using: .utf8)?.base64EncodedString()
  }
  
}
