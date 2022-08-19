# 修改OpenCore配置文件

编译修改过的OpenCore，将config.plist文件名扩展到49字母，可以通过二进制修改加载配置文件名。

## 一、 起因

- 想在一个OC目录里建两个启动文件，OpenCore.efi复制一份后，默认仍然读取config.plist，所以复制efi文件需要修改config.plist
- 原始OpenCore中配置文件名仅能容纳12个字母，很难修改，因此重新编译一个可以容纳49个字母的

## 二、解决方案

### 1）修改原始OpenCore.efi（文件名不能超过12个字符）

```shell
./change_org_OC_config.sh Debug.plist OpenCore.efi
mv OpenCore.efi OpenCore-Debug.efi
```

可用布局

```txt
EFI分区
    |
    |---EFI
    |    |
    |    |--OC（该目录中OC配置文件独立，但其他文件均为共用）
    |    |     |
    |    |     |--OpenCore.efi
    |    |     |--config.plist
    |    |     |
    |    |     |--OpenCore-Debug.efi  （通过以上命令修改过）
    |    |     |--cdebug.plist
    |    |     |-- ......
```

### 2）修改老之昂编译版OpenCore.efi（文件名不能超过49个字符）

```shell
./change_OC_config.sh config-Debug.plist OpenCore.efi
mv OpenCore.efi OpenCore-Debug.efi
```

最终布局

```txt
EFI分区
    |
    |---EFI
    |    |
    |    |--OC（该目录中OC配置文件独立，但其他文件均为共用）
    |    |     |
    |    |     |--OpenCore.efi
    |    |     |--config.plist
    |    |     |
    |    |     |--OpenCore-Debug.efi  （通过以上命令修改过）
    |    |     |--config-Debug.plist
    |    |     |-- ......
```



