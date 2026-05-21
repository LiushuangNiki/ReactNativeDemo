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

如果你不会写代码，可以先按下面顺序准备环境：

1. 安装 Node.js
   - 推荐从 <https://nodejs.org/> 下载 LTS 版本。
2. 安装 Yarn
   - 打开“终端”，输入：`npm install -g yarn`
3. 安装 Xcode
   - 从 Mac App Store 安装 Xcode，用来运行 iPhone 模拟器。
4. 在项目文件夹安装依赖
   - 输入：`yarn install`
5. 启动项目
   - 输入：`yarn start`
6. 另开一个终端运行 iOS 版本
   - 输入：`npx react-native run-ios`

### 如果遇到 fsevents 报错

这个项目使用的是较旧版本的 React Native，在新 Mac 环境里可能出现 `fsevents unavailable`。可以先尝试：

```bash
brew install watchman
rm -rf node_modules
yarn install
yarn start --reset-cache
```

如果只是想先看功能效果，建议直接打开 `preview.html`。

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
