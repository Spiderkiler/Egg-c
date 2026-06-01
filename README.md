# 🥚 咸蛋时钟 | Salted Egg Clock

> 专注每一分钟，像咸蛋一样沉淀自己。

一款以"咸蛋"为主题的现代化 Windows 桌面专注工具，帮助你高效管理时间、完成任务。

## ✨ 功能特性

- 🍅 **番茄时钟** - 自定义专注/休息时间，圆形进度环
- 📝 **任务管理** - 创建、编辑、删除任务，关联番茄钟
- 📊 **数据统计** - 今日/本周/本月/累计专注时长，含图表
- 🏆 **成就系统** - 10个成长成就，追踪你的进步
- 🎵 **白噪音** - 内置雨声、森林、咖啡馆、海浪、风声
- 🔔 **桌面通知** - 专注/休息结束提醒
- 🌙 **深色模式** - 支持浅色/深色/跟随系统
- ⌨️ **快捷键** - Space 开始/暂停，R 重置

## 🚀 快速开始

### 环境要求

- Flutter 3.x (Dart 3.x)
- Visual Studio 2022 (含"使用C++的桌面开发"工作负载)
- Windows 10 / Windows 11

### 安装与运行

```bash
# 1. 克隆项目
cd D:\CODE\EggTimer

# 2. 安装依赖
flutter pub get

# 3. 运行应用
flutter run -d windows
```

### 构建发布版本

```bash
# 构建 Release 版本
flutter build windows --release

# 可执行文件位于
# build\windows\x64\runner\Release\salted_egg_clock.exe
```

## 📁 项目结构

```
lib/
├── main.dart                          # 应用入口
├── core/
│   ├── constants/                     # 常量定义
│   │   ├── app_colors.dart            # 颜色主题
│   │   ├── app_strings.dart           # 字符串常量
│   │   └── app_constants.dart         # 通用常量
│   └── theme/                         # 主题管理
│       ├── app_theme.dart             # 主题切换
│       └── theme_viewmodel.dart       # 主题ViewModel
├── models/                            # 数据模型
│   ├── task_model.dart                # 任务模型
│   ├── focus_record_model.dart        # 专注记录模型
│   ├── achievement_model.dart         # 成就模型
│   ├── user_settings_model.dart       # 用户设置模型
│   └── sound_model.dart               # 白噪音模型
├── services/                          # 服务层
│   ├── storage_service.dart           # 本地存储(Hive)
│   ├── notification_service.dart      # 通知服务
│   ├── sound_service.dart             # 音频播放
│   ├── timer_service.dart             # 计时核心
│   └── achievement_service.dart       # 成就追踪
├── repositories/                      # 数据仓库
│   ├── task_repository.dart
│   ├── focus_repository.dart
│   └── settings_repository.dart
├── viewmodels/                        # ViewModel层(MVVM)
│   ├── home_viewmodel.dart
│   ├── focus_viewmodel.dart
│   ├── task_viewmodel.dart
│   ├── statistics_viewmodel.dart
│   ├── achievement_viewmodel.dart
│   └── settings_viewmodel.dart
├── views/                             # 页面
│   ├── home_page.dart                 # 首页
│   ├── focus_page.dart                # 专注页(核心)
│   ├── task_page.dart                 # 任务页
│   ├── statistics_page.dart           # 统计页
│   ├── achievement_page.dart          # 成就页
│   └── settings_page.dart             # 设置页
├── widgets/                           # 可复用组件
│   ├── app_shell.dart                 # 主框架
│   ├── navigation_rail.dart           # 侧边导航
│   ├── custom_title_bar.dart          # 自定义标题栏
│   ├── glass_card.dart                # 毛玻璃卡片
│   ├── circular_timer.dart            # 圆形计时器
│   ├── task_tile.dart                 # 任务列表项
│   ├── stat_card.dart                 # 统计卡片
│   ├── achievement_badge.dart         # 成就徽章
│   ├── sound_picker.dart              # 声音选择器
│   ├── animated_counter.dart          # 数字动画
│   └── welcome_header.dart            # 欢迎头部
└── utils/                             # 工具类
    ├── time_utils.dart                # 时间工具
    └── id_utils.dart                  # ID生成

```

## 🎨 设计规范

- **设计风格**：Apple HIG / Glassmorphism / Neumorphism
- **主色调**：#FFC93C (咸蛋黄)
- **圆角**：卡片24px / 按钮16px
- **窗口**：1200×800 居中启动

## 📦 技术栈

| 类别 | 技术 |
|------|------|
| 框架 | Flutter 3.x |
| 语言 | Dart 3.x |
| 状态管理 | Provider |
| 本地存储 | Hive |
| 图表 | fl_chart |
| 音频 | audioplayers |
| 通知 | flutter_local_notifications |
| 窗口 | window_manager |
| 动画 | flutter_animate |

## 🎵 白噪音资源

需要在 `assets/sounds/` 目录下放置以下音频文件（.mp3格式）：
- `rain.mp3` - 雨声
- `forest.mp3` - 森林
- `cafe.mp3` - 咖啡馆
- `ocean.mp3` - 海浪
- `wind.mp3` - 风声

> 提示：可从 [pixabay.com](https://pixabay.com/music/) 或 [freesound.org](https://freesound.org/) 下载免费白噪音素材。

## 📄 License

MIT License
