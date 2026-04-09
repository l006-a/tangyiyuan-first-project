# 剧本杀门店管理系统

一个基于 `JSP + Servlet + MySQL` 的 Web 课程项目，用于模拟剧本杀门店的日常运营管理。系统围绕三类角色展开：

- 管理员：负责场次调度、剧本库维护、用户管理、财务报表
- 玩家：负责注册登录、查看组局、加入房间、充值、查看行程、评价
- DM：负责查看排班、开局、结算、查看剧本资料

项目当前更适合作为课程设计 / 练手项目展示，仓库内仍保留一些待完善问题，不建议直接用于生产环境。

## 功能概览

### 1. 通用能力

- 用户登录、注册、退出登录
- 基于角色的菜单加载与权限区分
- 剧本大厅数据查询
- 公共数据接口：剧本列表、热门剧本、DM 列表、进行中场次

### 2. 管理员端

- 仪表盘：今日场次、热门剧本、待处理事项
- 场次调度：创建房间、查询排期、删除未预约房间、查询空闲 DM、指派 DM
- 剧本管理：新增 / 编辑 / 删除剧本，支持封面上传
- 用户管理：新增 / 编辑 / 删除用户，按用户名和角色筛选
- 财务报表：用户流水、本店营收、剧本热度排行、Excel 导出

### 3. 玩家端

- 浏览组局大厅并查看待开局房间
- 加入房间并冻结金额
- 查看我的行程 / 历史场次
- 充值、查看钱包流水
- 查看与修改个人资料
- 对已结束场次提交评价

### 4. DM 端

- 查看个人排班
- 查看最近一场待开局场次
- 开始游戏
- 结束游戏并结算冻结金额

## 技术栈

- 后端：`Jakarta Servlet 6`、`JSP`
- 数据库：`MySQL`
- 构建：`Maven`
- 工具库：`Hutool`、`Gson`、`JSTL`
- 报表导出：`Apache POI`
- 运行方式：更偏向 `IntelliJ IDEA + Tomcat Web Exploded`

## 项目结构

```text
JAVA_WEB_Work
├── src/main/java/Servlet
│   ├── Admin               # 管理员相关 Servlet
│   ├── DM                  # DM 相关 Servlet
│   ├── Player              # 玩家相关 Servlet
│   └── Universal           # 登录、大厅、公共数据
├── src/main/resources
│   ├── db.setting          # 数据库连接配置
│   ├── sound               # 音效资源
│   ├── svg                 # SVG 资源
│   └── upload              # 上传图片目录
├── web
│   ├── Login.jsp           # 登录 / 注册入口
│   ├── Index.jsp           # 主页面
│   └── WEB-INF/web.xml
```

## 核心接口入口

| 路径 | 说明 |
| --- | --- |
| `/Auth` | 登录、注册、初始化、退出 |
| `/Lobby` | 组局大厅数据 |
| `/UniversalData` | 公共数据查询 |
| `/Player` | 玩家侧业务 |
| `/DM` | DM 工作台业务 |
| `/AdminRoom` | 房间 / 排期管理 |
| `/AdminScript` | 剧本管理 |
| `/AdminUser` | 用户管理 |
| `/AdminFinance` | 财务报表与导出 |

## 数据库设计

项目围绕以下核心表展开：

- `users`
- `scripts`
- `rooms`
- `bookings`
- `wallet_logs`
- `reviews`

仓库中目前没有独立提供建表 SQL 文件。如果需要完整跑通数据库，请结合以下内容自行补齐：

- 各 `Servlet` 中的 SQL 语句

默认数据库名为 `scripthub`。

## 运行环境

- JDK：`25`（按 `pom.xml` 当前配置）
- Maven：`3.9+`
- Tomcat：`10.1+`
- MySQL：`8.x`

## 本地运行

### 1. 配置数据库

编辑 `src/main/resources/db.setting`：

```properties
url = jdbc:mysql://localhost:3306/scripthub?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true
user = root
pass = 123
```

请按你的本地环境修改数据库地址、用户名和密码。

### 2. 修改上传资源路径

项目中多个 Servlet 写死了 Windows 本地绝对路径，用于保存头像和剧本封面：

- `src/main/java/Servlet/Universal/AuthServlet.java`
- `src/main/java/Servlet/Player/PlayerServlet.java`
- `src/main/java/Servlet/Admin/AdminScriptServlet.java`
- `src/main/java/Servlet/Admin/AdminUserServlet.java`

默认值类似：

```java
private static final String ABSOLUTE_RESOURCE_PATH = "C:\\Users\\480900462\\IdeaProjects\\JAVA_WEB_Work\\src\\main\\resources";
```

如果你的机器路径不同，启动前需要先改成你自己的本地路径。

### 3. 部署项目

推荐方式：

1. 使用 IntelliJ IDEA 打开项目
2. 配置本地 Tomcat
3. 以 `Web Application: Exploded` 方式部署
4. 启动后访问 `Login.jsp`

访问路径通常类似：

```text
http://localhost:8080/JAVA_WEB_Work_war_exploded/Login.jsp
```

说明：

- 当前仓库更接近 IDEA 工程，Maven 主要用于依赖管理
- `pom.xml` 目前未显式配置标准 `war` 打包流程

## 已知限制

- 当前版本仍有部分业务逻辑和边界场景问题，属于未完全收尾状态
- 上传资源路径依赖本地绝对路径，迁移环境时需要手动修改
- 数据库初始化脚本未随仓库提供
- 前端页面主要集中在 `web/Index.jsp` 中，单文件体量较大，后续仍可继续拆分

## 适用场景

- JSP / Servlet 课程作业
- Java Web 入门练手项目
- 门店预约 / 场次调度类系统的原型参考
