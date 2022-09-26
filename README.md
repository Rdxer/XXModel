# XXModel

[![CI Status](http://img.shields.io/travis/LXF/XXModel.svg?style=flat)](https://travis-ci.org/LXF/XXModel)
[![Version](https://img.shields.io/cocoapods/v/XXModel.svg?style=flat)](http://cocoapods.org/pods/XXModel)
[![License](https://img.shields.io/cocoapods/l/XXModel.svg?style=flat)](http://cocoapods.org/pods/XXModel)
[![Platform](https://img.shields.io/cocoapods/p/XXModel.svg?style=flat)](http://cocoapods.org/pods/XXModel)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

XXModel is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "XXModel"
```

1. 序列化内的所有模型遵守 <XXParseModel> 协议
  
2. 模型的字段对应的class，除了遵守协议外，还需要对字段指定类型，因为OC的类型机制是编译时的范型
 
  +(NSDictionary *)xx_ModelKeys{
      return @{@"cat":@"Cat"};
  }

  +(NSDictionary *)xx_ArrayModelKeys{
      return @{@"phone":[Phone class]};
  }
  

  
## Author

LXF, rdxer@foxmail.com

## License

XXModel is available under the MIT license. See the LICENSE file for more info.
