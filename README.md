# 数学分层教学小助手

这是一个给小学老师使用的 React Native 小程序示例。第一版聚焦“单个学生 + 数学方向”，可以根据学生测验分数、常见问题、作业情况和学习态度，自动生成：

- A/B/C 分层结果
- 本周小目标
- 个性化数学练习建议
- 监督反馈机制
- 教师反馈话术

## 分层规则

- 0-59 分：A组，基础巩固型
- 60-84 分：B组，稳定提升型
- 85-100 分：C组，能力拓展型

## Mac 上如何运行

### 方式一：先快速查看效果，不需要安装依赖

如果你只是想先看到运行结果，可以直接双击打开：

```text
preview.html
```

这个页面会在浏览器里运行，适合先确认功能和文案是否符合教学场景。

### 方式二：用 Xcode / iPhone 模拟器运行 App

当前 iOS 版本已经改成原生 UIKit 页面，Xcode 可以直接显示小助手内容，不需要先启动 `yarn start`。

1. 用 Xcode 打开：

   ```text
   ios/ReactNativeDemo.xcodeproj
   ```

2. 选择一个 iPhone 模拟器。
3. 点击左上角运行按钮。

如果 Xcode 还显示旧页面，可以先执行：

```text
Product > Clean Build Folder
```

快捷键是 `Shift + Command + K`，然后重新运行。

React Native 页面和测试逻辑仍保留在项目里；如果以后继续开发跨平台版本，再安装 Node.js、Yarn 并运行 `yarn install`。

### 如果遇到 fsevents 报错

这个项目使用的是较旧版本的 React Native，在新 Mac 环境里可能出现 `fsevents unavailable`。可以先尝试：

```bash
brew install watchman
rm -rf node_modules
yarn install
yarn start --reset-cache
```

如果只是想先看功能效果，建议直接打开 `preview.html`；如果要在 Xcode 里看，使用上面的原生 iOS 方式。

### 如果遇到 fishhook / EXC_BAD_ACCESS 崩溃

如果 Xcode 停在类似下面的位置：

```text
indirect_symbol_bindings[i] = cur->rebindings[j].replacement;
Thread 1: EXC_BAD_ACCESS
```

这是旧 React Native 运行时代码在新系统上的兼容问题。当前 iOS 主 App 已经移除 React Native 静态库链接，使用原生 UIKit 页面运行。更新代码后请执行：

```text
Product > Clean Build Folder
```

然后在模拟器里删除旧 App，再重新运行。

如果只是想确认分层逻辑是否正确，可以运行：

```bash
yarn test
```

## 下一步可以增加的功能

- 保存多个学生档案
- 批量导入 30 名学生
- 按周记录反馈
- 导出 Excel 或 PDF
- 接入 AI 生成更自然的评语
