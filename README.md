# Temp Loading Animation

## 项目介绍

这是一个基于 HTML、CSS 和 JavaScript 的可控加载动画示例，适合直接放到静态页面里使用，也适合复制其中的遮罩层、样式和 `tempLoadingApi` 接口到你自己的项目中，用来统一处理“加载中”“提交中”“同步中”等等待状态的展示。

## 使用方法

1. 打开 `loading-animation.html` 预览效果，或者把其中的 HTML、CSS 和 JavaScript 复制到你的页面中。
2. 在需要显示加载状态时调用 `tempLoadingApi.show(...)`，在任务完成后调用 `tempLoadingApi.hide()`，如果中途需要替换提示文案，可以调用 `tempLoadingApi.update(...)`。

```js
tempLoadingApi.show("正在加载数据...", 3000, 8, 0.45);
tempLoadingApi.update("马上完成...");
tempLoadingApi.hide();
```
