# Swifty Open Chinese Convert

[![Build Status](https://travis-ci.org/ddddxxx/SwiftyOpenCC.svg?branch=master)](https://travis-ci.org/ddddxxx/SwiftyOpenCC)
![pm](https://img.shields.io/badge/supports-SwiftPM%20%7C%20Carthage-brightgreen.svg?)
![platforms](https://img.shields.io/badge/platforms-macOS%20%7C%20iOS%20%7C%20tvOS-lightgrey.svg)
[![license](https://img.shields.io/github/license/ddddxxx/SwiftyOpenCC.svg)](LICENSE)
[![codebeat badge](https://codebeat.co/badges/39f17620-4f1c-4a46-b3f9-8f5b248ac28f)](https://codebeat.co/projects/github-com-ddddxxx-swiftyopencc-master)

Swift port of [Open Chinese Convert](https://github.com/BYVoid/OpenCC)

## Requirements

- macOS 10.10+ / iOS 8.0+ / tvOS 9.0+
- Swift 5.0

## Usage

### Quick Start

```swift
import OpenCC

let str = "鼠标里面的硅二极管坏了，导致光标分辨率降低。"
let converter = try! ChineseConverter(option: [.traditionalize, .TWStandard, .TWIdiom])
converter.convert(str)
// 滑鼠裡面的矽二極體壞了，導致游標解析度降低。
```

Note: The resource files is **not** shipped with the framework (as you may want to download it while needed). You are responsible for passing a valid resource bundle. 

Here is a [precompiled bundle](./OpenCCDictionary.bundle). or you may put the [dictionary files](./OpenCCDictionary/Dictionary) into the main bundle.

## Documentation

[Github Pages](http://ddddxxx.github.io/SwiftyOpenCC) (100% Documented)

## License

SwiftyOpenCC is available under the MIT license. See the [LICENSE file](LICENSE).
