# tl2swift

This project designated for parsing Telegram Type Language (.tl) specification for [TDLib](https://github.com/tdlib/td) and generating Swift code. <br>
`tl2swift` generates swift structures, enums and methods for working with TDLib json interface. See example in project [tdlib-swift](https://github.com/modestman/tdlib-swift)


### Build
```shell
$ make release
```

### Usage 
```shell
$ tl2swift td_api.tl ./output/
```
