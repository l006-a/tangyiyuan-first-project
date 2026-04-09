<%--
  Created by IntelliJ IDEA.
  User: 480900462
  Date: 2026/1/8
  Time: 20:36
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>

        /*这是简单的初始化，统一样式*/
        *{
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        /*给HTML设置背景色*/
        body{
            background-color: #EDEEF1;
        }

        /*body里一个重要的div*/
        .main-body-wrapper{
            display: flex;
            flex-direction: column;
            height: 100vh;
            overflow: hidden;
        }


        :root {
            --md-sys-color-surface: #fdf8fd;
            --md-sys-color-surface-variant: #f0f0f0;
            --md-sys-color-primary-container: #ffeb99; /* 黄色卡片 */
            --md-sys-color-secondary-container: #b2f0de; /* 绿色 */
            --md-sys-color-on-surface: #1d1b20;
            --sidebar-width: 250px;
        }

        /*加载动画遮盖层-----开始---*/
        .gx-root-final {
            position: fixed;/*加载动画需要fixed定位*/
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;/*覆盖所有*/
            background-color: #FFF5EA;/*设置为指定的米色*/
            z-index: 9999;/*在最上面*/
            pointer-events: none;/*没有点击事件*/
            overflow: hidden;
            font-family: 'Impact', sans-serif;/*
            ，设置了一个看不懂的字体样式？*/
        }
        .gx-origin {
            position: absolute;
            top: -8vh;
            left: 50%;
            width: 0;
            height: 0;
        }
        .gx-stream-line {
            position: absolute;
            width: 300vmax;
            height: 12vh;
            top: -6vh;
            left: -150vmax;
            display: flex;
            align-items: center;
            justify-content: center; /* 这就是之前可能导致空白的原因之一，但在无限长文本下不是问题 */
        }
        .gx-stream-left {/*这应该是左边的文字，设置角度*/
            transform: rotate(-45deg);
        }
        .gx-stream-right {/*那这是右边的文字*/
            transform: rotate(45deg);
        }
        .gx-text-huge {
            font-size: 10vh;
            font-weight: 900;
            color: transparent;
            -webkit-text-stroke: 2px #E0C0A8;
            opacity: 0.5;
            white-space: nowrap;
            animation: gx-flow-move 720s linear infinite;
            width: max-content;
            display: flex;
        }
        @keyframes gx-flow-move {
            0% { transform: translateX(0%); }
            100% { transform: translateX(-50%); }
        }
        .gx-gap {
            padding-right: 60px;
        }

        #loadingDiv{/*这个应该是控制显示与否 */
            opacity: 0;
            pointer-events: none;
            transition: opacity .4s;
        }
        /*遮盖层-----end*/

        /*吐司通知-----开始*/
        :root {
            --toast-bg: #ffffff;
            --toast-text: #334155;
            --toast-success-bg: #dcfce7;
            --toast-error-bg: #fee2e2;
            --toast-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
        }
        #toast-container {
            position: fixed;
            bottom: 30px;
            right: 30px;
            z-index: 9999;
            display: flex;
            align-items: center;
            padding: 16px 24px;
            background: var(--toast-bg);
            color: var(--toast-text);
            border-radius: 16px;
            box-shadow: var(--toast-shadow);
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            font-size: 15px;
            font-weight: 500;
            max-width: 400px;
            opacity: 0;
            transform: translateY(20px) scale(0.95);
            transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1);
            pointer-events: none;
        }
        #toast-container.show {
            opacity: 1;
            transform: translateY(0) scale(1);
            pointer-events: auto;
        }
        .toast-icon-wrapper {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 32px;
            height: 32px;
            border-radius: 50%;
            margin-right: 12px;
            flex-shrink: 0;
            background-color: #f1f5f9;
            transition: background-color 0.3s ease;
        }
        .toast-svg-img {
            width: 20px;
            height: 20px;
            display: none;
        }
        #toast-container.success .icon-success {
            display: block;
        }
        #toast-container.success .toast-icon-wrapper {
            background-color: var(--toast-success-bg);
        }
        #toast-cont
        ner.error .icon-error {
            display: block;
        }
        #toast-container.error .toast-icon-wrapper {
            background-color: var(--toast-error-bg);
        }
        /*吐司通知-----end*/

        /*侧边栏-----start*/
        .sidebar {
            background: var(--md-sys-color-surface-variant);
            padding: 20px;
            display: flex;
            flex-direction: column;
            border-right: 1px solid rgba(0,0,0,0.05);
            overflow-y: auto;
            overscroll-behavior: contain;
        }
        .sidebar::-webkit-scrollbar {/*这是滚动栏*/
            width: 0;
            background: transparent;
        }
        .sidebar-logo-area {/*在侧边栏给Logo流的区域*/
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 40px;
        }
        .sidebar-logo {/*侧边栏Logo*/
            font-size: 24px;
            font-weight: bold;
            color: #333;
        }
        .sidebar-close-btn {
            display: none;
            background: none;
            border: none;
            font-size: 28px;
            cursor: pointer;
            color: #666;
        }
        .sidebar-menu li {/*侧边栏是ul，里面的li的样式*/
            padding: 12px 16px;
            margin-bottom: 8px;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.2s;
            font-weight: 500;
            display: flex;
            align-items: center;
            color: #666;
        }

        .sidebar-overlay {/* 侧边栏遮罩层，only移动端，就是灰色的背景 */
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 999; /* 比侧边栏(1000)低，比内容高 */
            opacity: 0;
            pointer-events: none; /* 默认不阻挡点击 */
            transition: opacity 0.3s cubic-bezier(0.4, 0, 0.2, 1);/*  写的css平滑效果，看不懂cubic-bezier的意思 */
        }


        .sidebar-menu li.sidebar-active {/*当前已选择的li，浅蓝色*/
            background: #CDDEF6;
            color: #3A4969;
            font-weight: bold;
        }

        .sidebar-menu li:hover:not(.sidebar-active) {/*鼠标移动到未激活的li上，变灰*/
            background: rgba(0,0,0,0.05);
            color: #333;
        }
        /*侧边栏-----end*/

        /*Admin的仪表盘页面-----start----*/
        .ScriptHub-Main {
            display: grid;
            grid-template-columns: var(--sidebar-width) 1fr;
            min-height: 100vh;
            transition: all 0.3s;/*平滑效果*/
            width: 100%;
        }
        /*admin的右侧下面的界面*/
        .AdminDashboard-main-content {
            padding: 24px;
            overflow-y: auto;
            height: 100%;
        }
        /* 的响应式布局 ,移动端右上角显示菜单选项*/
        .AdminDashboard-header-actions {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        /*统一admin页搜索栏的样式*/
        .AdminDashboard-search-bar {
            background: #eee;
            padding: 8px 16px;
            border-radius: 20px;
            color: #666;
            font-size: 0.9rem;
        }
        /* 的响应式布局 ,移动端右上角显示菜单选项，更加的“精细”*/
        .AdminDashboard-menu-toggle {
            display: none;
            background: none;
            border: none;
            font-size: 24px;
            cursor: pointer;
            padding: 5px;
        }
        /* 的响应式布局+grid，我不知道*/
        .AdminDashboard-stats-grid {
            display: grid;
            gap: 16px;
            grid-template-columns: repeat(3, 1fr);
            margin-bottom: 24px;
        }
        /*设置“卡片”的样式，例如，仪表盘最上面的两个*/
        .AdminDashboard-card {
            background: #F8F6FB;
            border: 1px solid rgba(0,0,0,0.02);
            border-radius: 16px;
            padding: 20px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            position: relative;
            overflow: hidden;
            box-shadow: 0 2px 6px rgba(0,0,0,0.02);
        }

        /*右边监控栏*/
        .AdminDashboard-insights-panel {
            background: #fff;
            border-radius: 20px;
            padding: 20px;
            position: relative;
            min-height: 300px;
        }



        .AdminDashboard-content-split {
            display: grid;
            gap: 24px;
            grid-template-columns: 2fr 1fr; /* 左2 右1 */
        }

        .AdminDashboard-rooms-grid {
            display: grid;
            gap: 16px;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
        }

        .AdminDashboard-room-card {
            background: #F8F6FB;
            border-radius: 16px;
            padding: 12px;
            display: flex;
            flex-direction: row;
            gap: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            border: 1px solid rgba(0,0,0,0.05);
            transition: transform 0.2s;
        }
        /*鼠标放上去，上移的动画*/
        .AdminDashboard-room-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }
        /*卡片里面写死的标签*/
        .AdminDashboard-label {
            font-size: 0.9rem;
            color: #666;
            margin-bottom: 8px;
        }
        /*卡片里面需要查数据库才知道的值*/
        .AdminDashboard-value {
            font-size: 1.5rem;
            font-weight: bold;
        }
        /*代办事项的卡片*/
        .card-action-required {
            background: #FFF8E1;
            border-left: 5px solid #FFC107;
        }

        /* 橙色 - 待开局 */
        .badge-locked {
            background: #FFF3E0;
            color: #E65100;
        }
        /* 绿色 - 游戏中 */
        .badge-playing {
            background: #E8F5E9;
            color: #2E7D32;
        }
        /* 蓝色 - 拼车中 */
        .badge-waiting {
            background: #E3F2FD;
            color: #1565C0;
        }

        .btn-primary-ghost {
            color: #3D77DD;
            border-color: #3D77DD;
        }

        /*创建房间的按钮*/
        .btn-create-room {
            width: 100%;
            padding: 12px;
            background: #DCE8F8;
            color: #2b5cace8;
            border: none;
            border-radius: 12px;
            font-weight: bold;
            cursor: pointer;
            margin-top: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-create-room:hover {
            background: #d0e0f5;
        }

        /*红点*/
        .dot-red {
            width: 8px;
            height: 8px;
            background: #FF5252;
            border-radius: 50%;
        }
        /*黄点*/
        .dot-yellow {
            width: 8px;
            height: 8px;
            background: #FFC107;
            border-radius: 50%;
        }

        .insight-list-item {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid #f0f0f0;
            font-size: 0.9rem;
            color: #555;
        }

        .insight-list-item:last-child {
            border-bottom: none;
        }
        .insight-alert-item {
            padding: 8px 0;
            font-size: 0.85rem;
            color: #666;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .room-cover-img {
            width: 80px;
            height: 110px;
            border-radius: 8px;
            object-fit: cover;
            background-color: #eee;
            flex-shrink: 0;
        }
        .room-info-col {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        /*房间的标题*/
        .room-title {
            font-size: 1rem;
            font-weight: bold;
            color: #333;
            margin-bottom: 4px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .room-badge {
            display: inline-block;
            padding: 2px 8px;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 600;
            margin-bottom: 8px;
            width: fit-content;
        }
        .room-progress-bg {
            height: 6px;
            width: 100%;
            background: #f0f0f0;
            border-radius: 3px;
            margin-bottom: 8px;
            overflow: hidden;
        }
        .room-progress-fill {
            height: 100%;
            background: #3D77DD;
            border-radius: 3px;
        }

        .room-meta-text {
            font-size: 0.8rem;
            color: #888;
        }
        .room-action-btn {
            padding: 6px 12px;
            border-radius: 20px;
            border: 1px solid #ddd;
            background: #fff;
            font-size: 0.8rem;
            cursor: pointer;
            font-weight: 500;
            text-align: center;
            transition: all 0.2s;
            margin-top: auto;
        }
        .room-action-btn:hover {
            background: #f5f5f5;
            border-color: #ccc;
        }
        /*添加房间的样式*/
        .room-card-add {
            background: #fff;
            border: 2px dashed #E0E0E0;
        }
        /*添加房间的样式，鼠标放上去变色*/
        .room-card-add:hover {
            background: #f0f0f0;
            color: #999;
        }

        .header-container {
            padding: 24px 24px 10px 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            width: 100%;
            background-color: transparent;
        }

        .modal-overlay {
            /*fixed，显示在屏幕中间*/
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0, 0, 0, 0.4);
            z-index: 2000;
            /* 默认隐藏 */
            display: none;
            justify-content: center;
            align-items: center;
            opacity: 0;
            /*0.3s的透明渐变*/
            transition: opacity 0.3s;
        }
        /*显示时不透明*/
        .modal-overlay.show {
            opacity: 1;
        }
        .modal-card {
            background: #fff;
            width: 500px;
            max-width: 90%;
            border-radius: 24px;
            padding: 24px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            transform: scale(0.9);
            transition: transform 0.3s;
            display: flex;
            flex-direction: column;
            gap: 16px;
        }
        .modal-overlay.show .modal-card {
            transform: scale(1);
        }
        /*头部，显示此框的标题*/
        .modal-header {
            font-size: 1.2rem;
            font-weight: bold;
            color: #333;
            margin-bottom: 8px;
        }
        .form-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }
        .form-label {
            font-size: 0.85rem;
            color: #666;
            font-weight: 500;
        }
        .form-input, .form-select {
            padding: 12px;
            border-radius: 12px;
            border: 1px solid #E0E0E0;
            background: #F8F9FA;
            font-size: 0.95rem;
            outline: none;
            transition: border-color 0.2s;
            width: 100%;
        }
        .form-input:focus, .form-select:focus {
            border-color: #3D77DD;
            background: #fff;
        }
        .input-readonly {
            background: #EBEBEB;
            color: #888;
            cursor: not-allowed;
            border-color: transparent;
        }
        .modal-actions {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            margin-top: 16px;
        }
        .btn-cancel {
            background: transparent;
            color: #666;
            border: none;
            padding: 10px 20px;
            border-radius: 12px;
            cursor: pointer;
            font-weight: bold;
        }
        .btn-confirm {
            background: #3D4C6C;
            color: #fff;
            border: none;
            padding: 10px 30px;
            border-radius: 12px;
            cursor: pointer;
            font-weight: bold;
            box-shadow: 0 4px 12px rgba(61, 76, 108, 0.2);
        }
        .btn-confirm:hover {
            background: #2c3852;
        }


        /* --- 响应式适配 (Mobile)  */
        @media (max-width: 768px) {
            .ScriptHub-Main {
                grid-template-columns: 1fr;
            }

            #userSearchInput {
                display: none !important;
            }

            .AdminDashboard-stats-grid {
                grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            }
            .sidebar-overlay.active {
                opacity: 1;
                pointer-events: auto; /* 激活时允许点击 */
            }

            .sidebar {
                position: fixed;
                top: 0; left: -280px;
                width: 260px;
                height: 100vh;
                z-index: 1000;
                transition: left 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                box-shadow: 4px 0 16px rgba(0,0,0,0.1);
            }
            .sidebar.active { left: 0; }

            .AdminDashboard-menu-toggle { display: block; }
            .sidebar-close-btn { display: block; }
            .AdminDashboard-content-split { grid-template-columns: 1fr; }
        }

        /*按不同需求显示不同内容*/
        .SPAContent{
            flex: 1;
            overflow-y: auto;
            -webkit-overflow-scrolling: touch;
        }

         /*场次调度页面-----start*/
        /*右（下）角大盒子*/
        .schedule-container {
            padding: 24px;
            height: 100%;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        /*显示日期的大盒子*/
        .calendar-card {
            background: #fff;
            border-radius: 16px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        /*右（上）角*/
        .calendar-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        /*显示月份*/
        .calendar-title {
            font-size: 1.2rem;
            font-weight: bold;
            color: #333;
        }
        /*切换月份的按钮*/
        .calendar-btn {
            background: #F0F0F0;
            border: none;
            padding: 8px 16px;
            border-radius: 8px;
            cursor: pointer;
            font-weight: bold;
            color: #555;
            transition: all 0.2s;
        }
        /*可以点击*/
        .calendar-btn:hover:not(:disabled) {
            background: #e0e0e0;
        }
        /*无法点击*/
        .calendar-btn:disabled {
            opacity: 0.3;
            cursor: not-allowed;
        }
        /*优化日历显示的代码*/
        .calendar-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            text-align: center;
            gap: 8px;
        }
        .calendar-weekday {
            font-weight: bold;
            color: #888;
            padding-bottom: 10px;
            font-size: 0.9rem;
        }
        .calendar-day {
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 8px;
            cursor: pointer;
            font-size: 1rem;
            transition: all 0.2s;
            position: relative;
        }
        .calendar-day:hover:not(.empty):not(.active) {
            background-color: #f5f5f5;
        }
        .calendar-day.active {
            background-color: #3D77DD; /* 选中蓝 */
            color: white;
            font-weight: bold;
            box-shadow: 0 4px 10px rgba(61, 119, 221, 0.3);
        }
        .calendar-day.active:hover {
            background-color: #2b5cace8;
            cursor: pointer;
        }
        .calendar-day.today {
            border: 1px solid #3D77DD;
        }
        .schedule-list-header {
            font-size: 1.1rem;
            font-weight: bold;
            color: #333;
            margin-top: 10px;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
         /*场次调度页面-----end*/


         /*剧本库页面-----start*/
        /*包含所有剧本的大盒子*/
        .script-list-container {
            display: flex;
            flex-direction: column;
            gap: 16px;
            padding-bottom: 80px; /* 给悬浮按钮留位置 */
        }
        /*每个剧本的中盒子*/
        .script-item-card {
            background: #fff;
            border-radius: 16px;
            padding: 16px;
            display: flex;
            gap: 16px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.02);
            transition: all 0.2s;
            border: 1px solid rgba(0,0,0,0.05);
            align-items: center;
        }
        /*动画*/
        .script-item-card:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            transform: translateX(4px);
        }
        /*没有图片，就是紫色的表示没图片*/
        .script-cover-placeholder {
            width: 80px;
            height: 100px;
            background-color: #6200EE;
            border-radius: 12px;
            flex-shrink: 0;
        }
        /*图片的样式*/
        .script-cover-img {
            width: 80px;
            height: 100px;
            border-radius: 12px;
            object-fit: cover;
            background-color: #eee;
            flex-shrink: 0;
        }
        /*每个剧本右边文字信息，需要竖着排列*/
        .script-info-main {
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 6px;
        }
        /*剧本名字，横向一排*/
        .script-title-row {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        /*剧本名字，宽度按文字的多少来*/
        .script-title {
            font-size: 1.1rem;
            font-weight: bold;
            color: #333;
        }
        /*剧本标签行*/
        .script-tags-row {
            display: flex;
            gap: 8px;
        }
        /*剧本标签*/
        .script-tag {
            background: #E8DEF8;
            color: #1D192B;
            padding: 2px 8px;
            border-radius: 6px;
            font-size: 0.8rem;
            font-weight: 500;
        }
        /*剧本其他信息*/
        .script-meta-row {
            font-size: 0.85rem;
            color: #666;
            margin-top: 4px;
        }
        /*右边按钮区*/
        .script-actions {
            display: flex;
            flex-direction: column;
            gap: 8px;
            align-items: flex-end;
        }
        /*按钮*/
        .btn-script-action {
            padding: 6px 16px;
            border-radius: 20px;
            border: 1px solid #ddd;
            background: transparent;
            font-size: 0.85rem;
            cursor: pointer;
            color: #555;
            transition: all 0.2s;
        }
        /*放按钮上变色*/
        .btn-script-action:hover {
            background: #f5f5f5;
            border-color: #999;
        }
        /*右下角的添加按钮*/
        .fab-add-script {
            position: fixed;
            bottom: 30px;
            right: 30px;
            background: #3D4C6C;
            color: white;
            padding: 12px 24px;
            border-radius: 28px;
            box-shadow: 0 4px 12px rgba(61, 76, 108, 0.4);
            border: none;
            font-weight: bold;
            font-size: 1rem;
            cursor: pointer;
            z-index: 100;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: transform 0.2s;
        }
        /*放上去加大和变色*/
        .fab-add-script:hover {
            transform: scale(1.05);
            background: #2c3852;
        }
         /*剧本库页面-----end*/

        /* --- 组局大厅 ---start */
        /*右上角的栏*/
        .lobby-filter-bar {
            display: flex;
            gap: 15px;
            margin-bottom: 24px;
            flex-wrap: wrap;
            align-items: center;
        }

        /*grid布局*/
        .lobby-grid {
            display: grid;
            gap: 20px;
            grid-template-columns: repeat(auto-fill, minmax(340px, 1fr)); /* 响应式网格 */
            padding-bottom: 40px;
        }

        /*显示组局的卡片*/
        .lobby-card {
            background: #fff;
            border-radius: 20px;
            padding: 16px;
            display: flex;
            gap: 16px;
            cursor: pointer;
            box-shadow: 0 4px 12px rgba(0,0,0,0.03);
            transition: transform 0.2s, box-shadow 0.2s;
            border: 1px solid rgba(0,0,0,0.05);
            position: relative;
            overflow: hidden;
        }

        /*动画*/
        .lobby-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 20px rgba(98, 0, 238, 0.15); /* 紫色阴影 */
        }

        /* 紫色封面，表示没有封面 */
        .lobby-cover-placeholder {
            width: 100px;
            height: 130px;
            background-color: #6200EE;
            border-radius: 12px;
            flex-shrink: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            color: rgba(255,255,255,0.8);
            font-weight: bold;
            font-size: 1.5rem;
            text-align: center;
            padding: 5px;
            box-shadow: 0 4px 8px rgba(98, 0, 238, 0.3);
        }

        /* 真实图片封面 */
        .lobby-cover-img {
            width: 100px;
            height: 130px;
            border-radius: 12px;
            object-fit: cover;
            flex-shrink: 0;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        /*右边的信息*/
        .lobby-info {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        /*标题*/
        .lobby-title {
            font-size: 1.2rem;
            font-weight: bold;
            color: #333;
            margin-bottom: 4px;
            line-height: 1.3;
        }

        /*标签*/
        .lobby-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
            margin-bottom: 8px;
        }

        .lobby-tag {
            background: #F3E5F5; /* 浅紫色背景 */
            color: #7B1FA2;      /* 深紫色文字 */
            padding: 2px 8px;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        /*人数的进度条*/
        .lobby-progress-row {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-top: auto; /* 推到底部 */
            margin-bottom: 12px;
        }

        .lobby-progress-bar {
            flex: 1;
            height: 8px;
            background: #EDE7F6;
            border-radius: 4px;
            overflow: hidden;
        }

        .lobby-progress-fill {
            height: 100%;
            background: #FF9800; /* 橙色进度条，醒目 */
            border-radius: 4px;
        }

        /*按钮*/
        .btn-lobby-action {
            width: 100%;
            padding: 10px;
            border: none;
            border-radius: 12px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.2s;
            text-align: center;
            font-size: 0.95rem;
        }

        /*如果时加入*/
        .btn-join {
            background: #3D4C6C; /* 深蓝按钮，配合整体 */
            color: white;
            box-shadow: 0 4px 10px rgba(61, 76, 108, 0.3);
        }
        .btn-join:hover { background: #2c3852; }

        /*已经加入*/
        .btn-joined {
            background: #E0E0E0;
            color: #757575;
            cursor: default; /* 实际上允许点击退出，但视觉上做区分 */
        }

        .btn-full {
            background: #eee;
            color: #aaa;
            cursor: not-allowed;
        }

        /* --- 我的行程 --- */
        /*上面的栏，待开始那些*/
        .schedule-tabs {
            display: flex;
            border-bottom: 2px solid #E0E0E0;
            margin-bottom: 20px;
        }
        /*栏的盒子*/
        .schedule-tab {
            padding: 12px 30px;
            font-size: 1rem;
            font-weight: bold;
            color: #888;
            cursor: pointer;
            border-bottom: 3px solid transparent;
            transition: all 0.2s;
            margin-bottom: -2px; /* 压住底边线 */
        }
        /*选择的栏，蓝色效果*/
        .schedule-tab.active {
            color: #3D77DD;
            border-bottom-color: #3D77DD;
        }
        /*没选的，就是灰色*/
        .schedule-tab:hover:not(.active) {
            color: #555;
            background: #f9f9f9;
        }
        /*行程卡片*/
        .session-card {
            background: #fff;
            border-radius: 16px;
            padding: 20px;
            display: flex;
            gap: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.03);
            margin-bottom: 16px;
            border: 1px solid rgba(0,0,0,0.05);
            align-items: stretch;
        }
        /*封面图*/
        .session-cover {
            width: 100px;
            height: 135px;
            border-radius: 12px;
            object-fit: cover;
            background: #6200EE;
            flex-shrink: 0;
        }
        /*右边的文字信息*/
        .session-info {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .session-title {
            font-size: 1.2rem;
            font-weight: bold;
            color: #333;
            margin-bottom: 6px;
        }
        .session-tag {
            background: #E8EAF6;
            color: #3949AB;
            padding: 2px 8px;
            border-radius: 6px;
            font-size: 0.75rem;
            margin-right: 6px;
        }
        .session-meta {
            margin-top: 8px;
            font-size: 0.9rem;
            color: #555;
            line-height: 1.6;
        }
        /*这是输入法的emojo表情*/
        .session-icon {
            display: inline-block;
            width: 16px;
            text-align: center;
            margin-right: 5px;
        }
        /*下面的栏*/
        .session-status-row {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-top: 15px;
        }
        /*药丸样式*/
        .status-pill {
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: bold;
        }
        /*不同状态的药丸样式， 设计*/
        .status-waiting {
            background: #E0E0E0;
            color: #616161;
        } /* 灰色背景用于进度条外壳 */
        .status-locked {
            background: #FFF3E0;
            color: #E65100;
            border: 1px solid #FFE0B2;
        }
        .status-finished {
            background: #E8F5E9;
            color: #2E7D32;
        }

        /* 按钮样式 */
        .btn-action-outline {
            padding: 8px 20px;
            border-radius: 20px;
            font-size: 0.9rem;
            cursor: pointer;
            background: transparent;
            font-weight: bold;
            transition: all 0.2s;
        }
        .btn-cancel-red {
            border: 1px solid #FF5252;
            color: #FF5252;
        }
        .btn-cancel-red:hover {
            background: #FFEBEE;
        }
        .btn-rate-blue {
            background: #3D77DD;
            color: white;
            border: none;
            box-shadow: 0 4px 10px rgba(61, 119, 221, 0.3);
        }
        .btn-rate-blue:hover {
            background: #2b5cace8;
        }
        .btn-view-gray {
            background: #E0E0E0;
            color: #757575;
            border: none;
        }
        .btn-view-gray:hover {
            background: #D6D6D6;
        }

        /*评价弹窗*/
        .rating-group {
            display: flex;
            gap: 10px;
            margin-bottom: 10px;
            align-items: center;
        }
        /*星星图标*/
        .star-btn {
            font-size: 1.5rem;
            color: #ddd;
            cursor: pointer;
            transition: color 0.2s;
        }
        /*选择的变黄*/
        .star-btn.active {
            color: #FFC107;
        }

        /* --- 个人中心---- start */

        .profile-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 24px;
        }
        /*卡片*/
        .profile-card {
            background: #fff;
            border-radius: 20px;
            padding: 24px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.03);
            border: 1px solid rgba(0,0,0,0.05);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            position: relative;
        }

        .profile-avatar-large {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid #fff;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            margin-bottom: 16px;
            background-color: #eee;
        }

        /*名字*/
        .profile-name {
            font-size: 1.5rem;
            font-weight: bold;
            color: #333;
            margin-bottom: 4px;
        }

        /*注册时间*/
        .profile-meta {
            color: #888;
            font-size: 0.9rem;
            margin-bottom: 20px;
        }

        /* 环形进度条 (信誉分) */
        .reputation-ring {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: conic-gradient(var(--ring-color) var(--percent), #f0f0f0 0);
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 10px;
        }


        .reputation-ring::after {
            content: "";
            position: absolute;
            width: 100px;
            height: 100px;
            background: #fff;
            border-radius: 50%;
        }

        .reputation-value {
            position: absolute;
            z-index: 2;
            font-size: 2rem;
            font-weight: bold;
            color: #333;
        }

        /*显示金额*/
        .wallet-balance-huge {
            font-size: 2.5rem;
            font-weight: bold;
            color: #333;
            margin: 10px 0;
        }

        /*显示冻结中的钱*/
        .wallet-frozen {
            background: #FFF3E0;
            color: #E65100;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: bold;
            display: inline-block;
            margin-bottom: 20px;
        }

        /*资金变动，表*/
        .log-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.9rem;
        }
        .log-table th {
            text-align: left;
            padding: 12px;
            color: #888;
            border-bottom: 1px solid #eee;
        }
        .log-table td {
            padding: 12px;
            border-bottom: 1px solid #f9f9f9;
            color: #444;
        }

        /*响应式布局*/
        @media (max-width: 768px) {
            .profile-grid { grid-template-columns: 1fr; }
        }

        /*DM顶部卡片(黄色背景)*/
        .dm-hero-card {
            background-color: var(--md-sys-color-primary-container);
            border-radius: 24px;
            padding: 24px 32px;
            position: relative;
            margin-bottom: 32px;
            box-shadow: 0 4px 12px rgba(255, 235, 153, 0.4);
            border: 1px solid rgba(0,0,0,0.05);
        }

        /*DM开始游戏的按钮*/
        .dm-start-btn {
            position: absolute;
            right: 32px;
            bottom: 32px;
            background: #3D77DD;
            color: white;
            padding: 10px 24px;
            border-radius: 50px;
            border: none;
            font-size: 1rem;
            font-weight: bold;
            cursor: pointer;
            box-shadow: 0 4px 10px rgba(61, 119, 221, 0.3);
            transition: transform 0.2s;
        }
        /*动画*/
        .dm-start-btn:hover {
            transform: translateY(-2px);
            background: #2b5cace8;
        }

        /*排班列表(卡片)*/
        .dm-schedule-card {
            background: #fff;
            border: 1px solid #E0E0E0;
            border-radius: 24px; /* 大圆角，还原设计图 */
            padding: 16px 24px;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            transition: all 0.2s;
        }

        /*动画*/
        .dm-schedule-card:hover {
            border-color: #3D77DD;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }

        /*右侧日历*/
        .dm-calendar-box {
            background: #fff;
            border-radius: 20px;
            border: 1px solid #E0E0E0;
            padding: 20px;
            margin-bottom: 24px;
        }

        /*背景摘要*/
        .dm-shortcut-box {
            background: #fff;
            border-radius: 20px;
            border: 1px solid #E0E0E0;
            padding: 20px;
        }

        /*dm的日历样式*/
        .dm-cal-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 4px;
            table-layout: fixed;
        }

        .dm-cal-header th {
            font-size: 0.85rem;
            color: #888;
            font-weight: normal;
            padding-bottom: 12px;
            text-align: center;
        }

        /*dm的日历样式*/
        .dm-cal-cell {
            height: 36px;
            width: 36px;
            text-align: center;
            vertical-align: middle;
            font-size: 0.95rem;
            color: #333;
            cursor: default;
            border-radius: 50%; /* 圆形效果 */
            transition: background 0.2s;
            margin: 0 auto; /* 居中 */
        }

        .dm-cal-cell:hover:not(.dm-cal-empty):not(.dm-cal-today) {
            background-color: #f0f0f0; /* 鼠标悬停微微变灰 */
        }

        /* 今天的样式 */
        .dm-cal-today {
            background-color: #3D77DD; /* 你的主色蓝 */
            color: white;
            font-weight: bold;
            box-shadow: 0 2px 6px rgba(61, 119, 221, 0.4);
        }

        /* 空白格 */
        .dm-cal-empty {
            pointer-events: none;
        }

        /* --- DM剧本资料页面 --- */
        /*大盒子*/
        .dm-materials-container {
            padding: 24px;
            background-color: #f8f9fa; /* 整体淡灰色背景 */
            min-height: 100%;
        }

        /*头*/
        .dm-materials-header {
            margin-bottom: 24px;
        }

        /*右上角大标题*/
        .dm-materials-header h2 {
            font-size: 1.8rem;
            font-weight: bold;
            color: #333;
            margin: 0 0 8px 0;
        }

        /*小段文字*/
        .dm-materials-header p {
            color: #666;
            margin: 0;
        }

        /* 卡片网格布局 */
        .dm-materials-grid {
            display: grid;
            /* 响应式列宽，最小280px，自动填满 */
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 24px;
        }

        /*单个卡片*/
        .dm-material-card {
            background: #fff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            transition: all 0.3s ease;
            border: 1px solid #eee;
            display: flex;
            flex-direction: column;
            cursor: pointer;
            position: relative; /* 为可能的绝对定位元素做准备 */
        }

        /*动画*/
        .dm-material-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0,0,0,0.12);
        }

        /*封面图区域*/
        .dm-mat-cover-box {
            height: 160px;
            overflow: hidden;
            position: relative;
            background-color: #e0e0e0;
        }
        /*图片*/
        .dm-mat-cover-img {
            width: 100%;
            height: 100%;
            object-fit: cover; /* 保证图片填满且不变形 */
        }

        /*卡片内容区域*/
        .dm-mat-content {
            padding: 16px;
            /* 让内容区撑开高度，保证底部按钮对齐 */
            flex-grow: 1;
        }

        /*标题*/
        .dm-mat-title {
            font-size: 1.2rem;
            font-weight: bold;
            color: #333;
            margin-bottom: 12px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis; /* 标题过长省略 */
        }

        /*数据标签(人数、时长等)*/
        .dm-mat-meta-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }

        /*标签*/
        .dm-mat-tag {
            background: #f0f2f5;
            color: #555;
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 0.85rem;
            display: flex;
            align-items: center;
        }

        /*鼠标悬停，封面图放大一点 */
        .dm-material-card:hover .dm-mat-cover-img {
            transform: scale(1.05);
            transition: transform 0.3s ease;
        }

        /*阅读模式模态框*/
        .dm-read-modal-body {
            display: flex;
            gap: 24px;
            height: 60vh; /* 固定高度，让文字区域可以滚动 */
            margin-top: 10px;
        }

        .dm-read-sidebar {
            width: 140px;
            flex-shrink: 0;
            display: flex;
            flex-direction: column;
            gap: 15px;
            align-items: center;
            text-align: center;
            border-right: 1px solid #eee;
            padding-right: 20px;
        }

        .dm-read-cover {
            width: 100%;
            aspect-ratio: 3/4;
            border-radius: 8px;
            background-color: #eee;
            object-fit: cover;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }

        .dm-read-content-box {
            flex: 1;
            background: #fdfdfd;
            padding: 20px;
            border-radius: 12px;
            border: 1px solid #e0e0e0;
            overflow-y: auto;
            font-size: 1rem;
            line-height: 1.8;
            color: #333;
            white-space: pre-wrap;
            font-family: 'Segoe UI', Roboto, 'Helvetica Neue', sans-serif;
        }

        /*dm页的模态框*/
        .dm-schedule-card-modern {
            background: #fff;
            border-radius: 16px;
            padding: 16px 24px;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            border: 1px solid rgba(0,0,0,0.02);
            transition: transform 0.2s, box-shadow 0.2s;
        }
        /*dm页的模态框*/
        .dm-schedule-card-modern:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        /* 紫色竖条指示器 (模仿场次调度) */
        .dm-indicator-bar {
            width: 6px;
            height: 40px;
            background: #673AB7;
            border-radius: 10px;
            margin-right: 16px;
            flex-shrink: 0;
        }

        .dm-hero-card {
            /* 使用渐变色提升质感 */
            background: linear-gradient(135deg, #FFF8E1 0%, #FFECB3 100%);
            border-radius: 20px;
            padding: 24px 32px;
            position: relative;
            margin-bottom: 32px;
            box-shadow: 0 4px 15px rgba(255, 193, 7, 0.15); /* 金色光晕 */
            border: none; /* 去掉边框 */
        }

        /*美化右侧日历 (去除老式表格线)*/
        .dm-calendar-box {
            background: #fff;
            border-radius: 20px;
            padding: 24px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.03);
            border: none; /* 去掉边框 */
            margin-bottom: 24px;
        }

        .dm-cal-table {
            border-spacing: 0 6px; /* 增加行间距 */
        }

        .dm-cal-cell {
            width: 36px;
            height: 36px;
            font-size: 0.9rem;
            color: #555;
            border-radius: 10px; /* 变成圆角矩形，像场次调度那样 */
            font-weight: 500;
        }

        /* 选中的日期 (模仿场次调度的深蓝色块)*/
        .dm-cal-active-day {
            background-color: #3D77DD !important;
            color: #fff !important;
            box-shadow: 0 4px 10px rgba(61, 119, 221, 0.3);
        }

        /*今天的日期 (如果是选中状态，显示 active，否则显示浅蓝圈)*/
        .dm-cal-today-dot {
            position: relative;
        }
        .dm-cal-today-dot::after {
            content: '';
            position: absolute;
            bottom: 2px;
            left: 50%;
            transform: translateX(-50%);
            width: 4px;
            height: 4px;
            background: #3D77DD;
            border-radius: 50%;
        }

        /*资料盒子*/
        .dm-shortcut-box {
            background: #fff;
            border-radius: 20px;
            padding: 24px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.03);
            border: none;
        }

        /* 响应式：手机端上下布局 */
        @media (max-width: 768px) {
            .dm-read-modal-body {
                flex-direction: column;
                height: auto;
                max-height: 70vh;
            }
            .dm-read-sidebar {
                width: 100%;
                flex-direction: row;
                border-right: none;
                border-bottom: 1px solid #eee;
                padding-bottom: 10px;
                padding-right: 0;
            }
            .dm-read-cover {
                width: 60px;
                height: 80px;
            }
        }

        /* 响应式调整 */
        @media (max-width: 768px) {
            .dm-hero-card { padding: 20px; }
            .dm-start-btn { position: static; margin-top: 15px; width: 100%; }
        }

    </style>
</head>
<body>
<%--这是遮盖层--%>
<div class="gx-root-final" id="loadingDiv">
    <div class="gx-origin">
        <div class="gx-stream-line gx-stream-left">
            <div class="gx-text-huge" id="gx-text-sw"></div>
        </div>
        <div class="gx-stream-line gx-stream-right">
            <div class="gx-text-huge" id="gx-text-nw"></div>
        </div>
    </div>
</div>

<%--这是内容区--%>
<div class="ScriptHub-Main">

    <%--这是左侧菜单栏--%>
    <nav class="sidebar" id="sidebar">
        <%--logo区--%>
        <div class="sidebar-logo-area">
            <%--logo--%>
            <div class="sidebar-logo">ScriptHub</div>
            <%--右边的关闭按钮， 加的，only移动端--%>
            <button class="sidebar-close-btn" onclick="toggleMenu()">×</button>
        </div>

        <%--菜单栏，我们使用空的，按照不同身份，动态添加不同内容--%>
        <ul class="sidebar-menu"></ul>

        <%--下面的菜单，名称，设置--%>
        <div style="margin-top: auto;">
            <ul class="sidebar-menu">
                <li class="sidebar-username"></li>
                <li onclick="openSettingsModal()">设置</li>
            </ul>
        </div>
    </nav>
    <div class="sidebar-overlay" id="sidebarOverlay" onclick="toggleMenu()"></div>

    <div class="main-body-wrapper">
        <%--这是顶栏，按不同页面，不一样--%>
        <div class="top-nav"></div>
        <%--这里才是真正按不同需求显示不同内容的地方--%>
            <div class="SPAContent"></div>
    </div>

</div>

<%--这是通知 --%>
<div id="toast-container">
    <div class="toast-icon-wrapper">
        <img class="toast-svg-img icon-success" src="${pageContext.request.contextPath}/resources/svg/Information_good.svg" alt="Success Icon">
        <img class="toast-svg-img icon-error" src="${pageContext.request.contextPath}/resources/svg/Information_bad.svg" alt="Error Icon">
    </div>
    <span id="toast-message"></span>
</div>
</body>
<script>
    //这是主要的显示区域
    const SPAContent=document.querySelector('.SPAContent')
    //这个绑定的是遮盖层
    const CoveringLayer=document.querySelector('#loadingDiv')
    //这个是通知音
    const notificationSound=new Audio('${pageContext.request.contextPath}/resources/sound/notificationSound.ogg')
    //这个绑定的是通知的大div
    const toastContainer = document.querySelector('#toast-container')
    //这个绑定的是通知的文字信息div
    const toastMessage = document.querySelector('#toast-message')
    //这个是显示在左边栏的用户名
    const sidebar_username=document.querySelector('.sidebar-username')
    //这个是显示在左边栏的菜单项
    const sidebar_menu=document.querySelector('.sidebar-menu')
    //这个是顶栏
    const top_nav=document.querySelector('.top-nav')
    //通知显示的计时器
    let toastTimeout
    // 全局变量，记录当前 DM 选中的日期
    let CurrentDMDate = new Date()
    // 全局状态变量
    let ScheduleState = {
        viewYear: new Date().getFullYear(),
        viewMonth: new Date().getMonth(), // 0-11
        selectedDateStr: null, // "2026-01-09"
        baseDate: new Date() // 用于计算上下限
    };
    // 全局变量存储大厅数据，用于前端筛选
    let LobbyDataList = []
    // 存储后端返回的原始数据
    let MySessionData = [];
    // 'pending' 或 'history'
    let CurrentSessionTab = 'pending';

    //设置动画文字， 的高级动画
    function setLoaderText(text) {
        const unitHtml = '<span class="gx-gap">' + text + '</span>'
        const countPerChunk = 160
        let singleChunk = ''
        for (let i = 0; i < countPerChunk; i++) {
            singleChunk += unitHtml
        }
        const finalContent = singleChunk + singleChunk
        const elSW = document.getElementById('gx-text-sw')
        const elNW = document.getElementById('gx-text-nw')

        if (elSW) elSW.innerHTML = finalContent
        if (elNW) elNW.innerHTML = finalContent
    }

    //显示遮盖层（需要传入文字）
    function ShowCoveringLayer(text){
        setLoaderText(text)
        CoveringLayer.style.opacity = 1
        CoveringLayer.style.pointerEvents = 'auto'
    }

    //隐藏遮盖层
    function HiddenCoveringLayer(){
        CoveringLayer.style.opacity = 0
        CoveringLayer.style.pointerEvents = 'none'
    }

    //这是通信的方法,传入url和数据（自动转json格式）,返回结果。如果超时会报错，到trycatch的catch里捕获
    function request(url,data=null){
        return new Promise((resolve,reject)=>{
            const xhr = new XMLHttpRequest()
            xhr.open('POST', `${pageContext.request.contextPath}/\${url}`)
            xhr.setRequestHeader('Content-type', 'application/json;charset=UTF-8')
            xhr.timeout=4000//设置，4秒连接不上，就有问题
            xhr.ontimeout = function() {//挺好，超时了
                reject("连接服务器超时")
            }
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4) {
                    if (xhr.status === 200){
                        let temp1=xhr.responseText
                        let r=JSON.parse(temp1)
                        if(r.info==='SUCCESS') resolve(r)
                        else if(r.info==='NOT_LOGGED_IN'){//发现没登录，回到登录页
                            window.location.href = "${pageContext.request.contextPath}/Login.jsp"
                        }else reject(r.info)
                    }else if(xhr.status === 404){
                        reject('我们似乎找不到服务器？-404')
                    }else if(xhr.status === 500) {
                        reject("我们的服务器坏了，请耐心等待维修 -500")
                    }else reject("我们无法确认问题出现在哪了")
                }
            }
            if(data){
                xhr.send(JSON.stringify(data))
            }else{
                xhr.send()
            }
        })
    }

    //这个是显示通知的function，message是文字，isSuccess表示这个通知是好消息还是坏消息
    function showToast(message, isSuccess) {
        if (toastTimeout) {//如果有通知正在显示，清空计时器
            clearTimeout(toastTimeout);
        }
        toastMessage.textContent = message;//改通知内容
        toastContainer.classList.remove('success', 'error');//无论怎样，先清空classList
        if (isSuccess) {
            toastContainer.classList.add('success');//添加成功的样式
        } else {
            toastContainer.classList.add('error');//添加失败的样式
        }
        notificationSound.currentTime = 0;//重置播放进度到开头 (防止上一次没播完，这次接着播)
        // 代码. 执行播放  .play() 返回一个 Promise，最好处理一下异常（比如浏览器拦截）
        notificationSound.play().catch(function(error) {
            console.log("播放失败，可能是因为用户还没有与页面交互:", error);
        });

        // 使用 setTimeout 确保浏览器捕捉到状态变化以触发动画, 的
        setTimeout(() => {
            toastContainer.classList.add('show');
        }, 10);

        toastTimeout = setTimeout(() => {
            toastContainer.classList.remove('show');
        }, 5000);
    }

    // 清理网页右侧的内容
    function clearWeb(){
        SPAContent.innerHTML=''
        top_nav.innerHTML=''
        resetPageLayout()
    }

    //切换页面时重置SPAContent的样式
    function resetPageLayout() {
        //恢复默认的滚动行为，因为在一些页面中有BUG，会有两个滚动条，所以添加此方法
        SPAContent.style.overflowY = 'auto';
        SPAContent.style.display = 'block';
        SPAContent.style.height = 'auto';
    }

    //获取目前正在进行的游戏数
    async function AdminGetTheNumberOfOngoingGames(){
        try {
            let information={
                action: 'get_ongoing_games_count'
            }
            return await request('UniversalData',information)
        }catch(error){
            showToast(error,false)
        }
    }

    //获取代办事项数据 (48小时内急单)
    async function AdminGetActionRequired() {
        try {
            let information={
                action: 'get_action_required'
            }
            return await request('AdminRoom',information);
        } catch(error) {
            let information={
                info: "ERROR",
                count: 0,
                list: []
            }
            return information
        }
    }


    async function AdminGetReputationAlerts() {
        try {
            let information={
                action: 'get_reputation_alerts'
            }
            return await request('AdminUser',information)
        } catch(error) {
            let infomation={
                info: "ERROR",
                list: []
            }
            return infomation
        }
    }

    //获取前三条热门剧本
    async function getPopularScripts(){
        try {
            let information={
                action: 'get_popular_scripts'
            }
            return await request('UniversalData',information)
        }catch(error){
            showToast(error,false)
        }
    }

    //这是获取所有剧本的基础信息（id，名称，描述，价格，时间等等），在初始化时以及更新时手动调用获取一次即可
    async function getScriptData(){
        try {
            let information={
                action: 'get_script_list'
            }
            ScriptData = await request('UniversalData', information)
        }catch(error){
            showToast(error,false)
        }
    }

    //获取今日营收
    async function getCashInflowsToday(){
        try {
            let information={
                action: 'get_cash_inflows_today'
            }
            return await request('AdminFinance', information)
        }catch(error){
            showToast(error,false)
        }
    }

    //生成设置模态框的 HTML
    function getSettingsModalHTML() {
        return `
        <div class="modal-overlay" id="settingsModal" onclick="onOverlayClick(event)">
            <div class="modal-card" style="width: 360px;">
                <div class="modal-header">系统设置 (Settings)</div>

                <div style="display: flex; flex-direction: column; gap: 16px; padding: 20px 0;">

                    <div style="font-size: 0.9rem; color: #666; text-align: center; margin-bottom: 10px;">
                        当前用户: <span style="font-weight: bold; color: #333;">${sessionScope.username != null ? sessionScope.username : '未知'}</span>
                    </div>

                    <button onclick="handleLogout()"
                        style="width: 100%; padding: 14px; background-color: #FFEBEE; color: #D32F2F;
                               border: 1px solid #FFCDD2; border-radius: 12px; font-weight: bold;
                               cursor: pointer; display: flex; align-items: center; justify-content: center; gap: 10px;
                               transition: all 0.2s;">
                        <span>👋</span> 退出登录 (Logout)
                    </button>

                    </div>

                <div class="modal-actions" style="justify-content: center;">
                    <button class="btn-cancel" onclick="closeSettingsModal()">关闭菜单</button>
                </div>
            </div>
        </div>`;
    }

    //打开设置模态框
    function openSettingsModal() {
        let modal = document.getElementById('settingsModal');
        // 如果没有这个弹窗，动态插入
        if (!modal) {
            document.body.insertAdjacentHTML('beforeend', getSettingsModalHTML());
            modal = document.getElementById('settingsModal');
        }
        // 修改display
        modal.style.display = 'flex';
        // 延时添加 show 类以触发 CSS淡入动画
        function temp(){
            modal.classList.add('show')
        }
        setTimeout(temp,10)
    }

    //关闭设置模态框
    function closeSettingsModal() {
        const modal = document.getElementById('settingsModal');
        if (modal) {
            modal.classList.remove('show');
            function temp(){
                modal.style.display = 'none'
            }
            setTimeout(temp,300)
        }
    }

    //处理注销逻辑
    async function handleLogout() {
        //二次确认，防止误触
        if(!confirm("确定要退出当前账号吗？")) return;
        try {
            ShowCoveringLayer("正在注销...");
            //请求AuthServlet执行logout 操作
            let information={
                action: 'logout'
            }
            await request('Auth',information);
            function temp(){
                HiddenCoveringLayer();
                //跳转回登录页
                window.location.href = "${pageContext.request.contextPath}/Login.jsp";
            }
            setTimeout(temp, 500);
        } catch (e) {
            HiddenCoveringLayer();
            showToast("注销失败: " + e, false);
        }
    }

    //开设新房间-动态模态框
    function getCreateRoomModalHTML() {
        return `
        <div class="modal-overlay" id="createRoomModal" onclick="onOverlayClick(event)">
            <div class="modal-card">
                <div class="modal-header">开设新房间 (Create New Session)</div>

                <div class="form-group">
                    <label class="form-label">选择剧本 (Select Script)</label>
                    <select id="modalScriptSelect" class="form-select" onchange="onScriptSelectChange(); refreshAvailableDMs()">
                        <option value="" disabled selected>请选择剧本...</option>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label">设计开始时间 (Start Time)</label>
                    <input type="datetime-local" id="modalStartTime" class="form-input" onchange="calculateEndTime(); refreshAvailableDMs()">
                </div>

                <div class="form-group">
                    <label class="form-label">预计结束时间 (End Time)</label>
                    <input type="text" id="modalEndTime" class="form-input input-readonly" readonly placeholder="自动计算">
                </div>

                <div class="form-group">
                    <label class="form-label">指派DM (必选)</label>
                    <select id="modalDMSelect" class="form-select">
                        <option value="" disabled selected>-- 请先选择剧本和时间 --</option>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label">限定人数</label>
                    <input type="text" id="modalPlayerCount" class="form-input input-readonly" readonly>
                </div>

                 <div class="form-group">
                    <label class="form-label">单人价格</label>
                    <input type="text" id="modalPrice" class="form-input input-readonly" readonly>
                </div>

                <div class="modal-actions">
                     <button class="btn-cancel" onclick="closeCreateRoomModal()">取消</button>
                    <button class="btn-confirm" onclick="submitCreateRoom()">创建</button>
                </div>
            </div>
        </div>`;
    }

    //打开模态框
    async function openCreateRoomModal(targetDateStr = null) {
        //检查页面上是否已经有这个模态框，没有则动态插入
        let modal = document.getElementById('createRoomModal');
        if (!modal) {
            document.body.insertAdjacentHTML('beforeend', getCreateRoomModalHTML());
            modal = document.getElementById('createRoomModal');
        }

        //准备数据
        if(!ScriptData || !ScriptData.list) await getScriptData();

        //渲染剧本下拉框
        const scriptSelect = document.getElementById('modalScriptSelect');
        scriptSelect.innerHTML = '<option value="" disabled selected>请选择剧本...</option>';
        ScriptData.list.forEach(s => {
            const option = document.createElement('option');
            option.value = s.id;
            const title = s.title ? s.title : "无标题";
            const count = s.player_count;
            const duration = (s.duration_minutes / 60).toFixed(1);
            option.innerHTML = `《\${title}》| \${count}人 | \${duration}小时`;
            option.dataset.price = s.price;
            option.dataset.duration = s.duration_minutes;
            option.dataset.count = s.player_count;
            scriptSelect.appendChild(option);
        });

        //设置默认开始时间
        const now = new Date();
        const defaultTime = new Date();
        // 如果传入了特定日期
        if (targetDateStr) {
            const [y, m, d] = targetDateStr.split('-');
            // 注意：Date构造器里月份是 0-11，所以要减 1
            defaultTime.setFullYear(y, m - 1, d);
        }
        defaultTime.setHours(now.getHours() + 1);
        defaultTime.setMinutes(0, 0, 0);

        // 转换为 ISO 格式供 input 使用
        const offset = defaultTime.getTimezoneOffset() * 60000;
        const localISOTime = (new Date(defaultTime - offset)).toISOString().slice(0, 16);
        document.getElementById('modalStartTime').value = localISOTime;

        //清空旧数据
        document.getElementById('modalEndTime').value = '';
        document.getElementById('modalPlayerCount').value = '';
        document.getElementById('modalPrice').value = '';
        document.getElementById('modalScriptSelect').value = "";

        //显示模态框
        modal.style.display = 'flex';
        function temp(){
            modal.classList.add('show')
        }
        setTimeout(temp, 10);
    }


    //关闭模态框
    function closeCreateRoomModal() {
        const modal = document.getElementById('createRoomModal');
        if(!modal) return;
        modal.classList.remove('show');
        function temp(){
            modal.style.display = 'none';
        }
        setTimeout(temp, 300);
    }

    //点击灰色遮罩层关闭模态框
    function onOverlayClick(event) {
        // event.target 是你实际点击的元素
        // event.currentTarget 是绑定了事件的元素 (即 modal-overlay)
        // 只有当两者相等时，说明你点的是灰色背景，而不是中间的白卡片
        if (event.target === event.currentTarget) {
            const modalId = event.target.id;

            // 根据 ID 判断要关闭哪个模态框
            if (modalId === 'createRoomModal') {
                closeCreateRoomModal();
            }else if (modalId === 'lobbyDetailModal') {
                closeLobbyDetailModal();
            }else if (modalId === 'userModal') {
                closeUserModal(); // 关闭用户管理弹窗
            }else if (modalId === 'manageScriptModal') {
                closeManageScriptModal(); // 关闭剧本管理弹窗
            }else if (modalId === 'assignDMModal') {
                closeAssignDMModal(); // 关闭指派DM弹窗
            }else if (modalId === 'dmReadModal') {
                closeDMMaterialModal();
            }else if (modalId === 'settingsModal') {
                closeSettingsModal(); //关闭设置弹窗
            }else if (modalId === 'rechargeModal') {
                closeRechargeModal();
            }else if (modalId === 'editProfileModal') {
                closeEditProfileModal();
            }
        }
    }

    //剧本选择改变时的联动逻辑
    function onScriptSelectChange() {
        const select = document.getElementById('modalScriptSelect');
        const option = select.options[select.selectedIndex];
        if (!option.dataset.price) return;

        // 填充“限定人数”和“单人价格”
        document.getElementById('modalPlayerCount').value = option.dataset.count + " 人"
        document.getElementById('modalPrice').value = "¥ " + option.dataset.price

        calculateEndTime()
    }

    //自动计算结束时间
    function calculateEndTime() {
        const select = document.getElementById('modalScriptSelect')
        const startTimeInput = document.getElementById('modalStartTime')
        const endTimeInput = document.getElementById('modalEndTime')
        // 如果没填完整，不计算
        if (select.selectedIndex <= 0 || !startTimeInput.value) return
        const startTime = new Date(startTimeInput.value)
        const now = new Date()

        //只能在6小时后开新房间
        const minValidTime = new Date(now.getTime() + 6 * 60 * 60 * 1000);
        if (startTime < minValidTime) {
            showToast("错误：只能安排 6小时之后 的场次！", false)
            endTimeInput.value = "时间无效 (太早)"
            endTimeInput.style.color = "red"
            return;
        }

        //不能超过下个月
        // 逻辑：计算出“下下个月的1号”，比如现在1月，允许1月、2月，不允许3月1号及以后
        const maxValidDate = new Date(now.getFullYear(), now.getMonth() + 2, 1)
        // 将时分秒清零，确保对比准确
        maxValidDate.setHours(0, 0, 0, 0)

        if (startTime >= maxValidDate) {
            showToast("错误：只能安排 本月 或 下个月 的场次！", false);
            endTimeInput.value = "时间无效 (太远)";
            endTimeInput.style.color = "red";
            return;
        }

        // 验证通过，恢复颜色
        endTimeInput.style.color = "#888";
        const option = select.options[select.selectedIndex]
        if (!option.dataset.duration) return;

        const durationMinutes = parseInt(option.dataset.duration)
        // 计算结束时间
        const endTime = new Date(startTime.getTime() + durationMinutes * 60000)
        const endStr = endTime.getFullYear() + "年" +
            (endTime.getMonth()+1) + "月" +
            endTime.getDate() + "日 " +
            String(endTime.getHours()).padStart(2, '0') + ":" +
            String(endTime.getMinutes()).padStart(2, '0');
        endTimeInput.value = endStr
    }

    //动态获取空闲 DM 列表
    async function refreshAvailableDMs() {
        const scriptId = document.getElementById('modalScriptSelect').value
        const startTimeVal = document.getElementById('modalStartTime').value
        const dmSelect = document.getElementById('modalDMSelect');
        // 如果还没选完，就清空 DM 列表并提示
        if (!scriptId || !startTimeVal) {
            dmSelect.innerHTML = '<option value="" disabled selected>-- 请先选择剧本和时间 --</option>';
            return
        }
        try {
            dmSelect.innerHTML = '<option value="" disabled selected>正在加载空闲人员...</option>';
            //格式化时间：把 ISO 格式的 'T' 换成空格，确保后端解析万无一失
            const formattedTime = startTimeVal.replace('T', ' ')

            // 2. 发起请求
            let information={
                action: 'get_available_dms',
                script_id: scriptId,
                start_time: formattedTime
            }
            const res = await request('AdminRoom',information);

            // 3. 渲染列表
            let html = '<option value="" disabled selected>-- 请选择主持人 --</option>'

            if (res.list && res.list.length > 0) {
                res.list.forEach(dm => {
                    html += `<option value="\${dm.id}">\${dm.username} (空闲)</option>`
                });
            } else {
                html += '<option value="" disabled>该时段无空闲 DM</option>'
            }
            dmSelect.innerHTML = html;

        } catch (e) {
            dmSelect.innerHTML = '<option value="" disabled selected>加载失败</option>'
            showToast("DM加载失败: " + e, false)
        }
    }

    // 尝试创建房间
    async function submitCreateRoom() {
        const scriptId = document.getElementById('modalScriptSelect').value
        const startTimeVal = document.getElementById('modalStartTime').value
        const dmId = document.getElementById('modalDMSelect').value
        if (!scriptId || !startTimeVal|| !dmId) {
            showToast("请完整填写信息", false)
            return
        }
        const startTime = new Date(startTimeVal)
        const now = new Date()

        //6小时验证
        const minValidTime = new Date(now.getTime() + 6 * 60 * 60 * 1000)
        if (startTime < minValidTime) {
            showToast("创建失败：开始时间必须在当前时间 6小时 之后！", false)
            return
        }

        //月份范围验证，最久下个月
        const maxValidDate = new Date(now.getFullYear(), now.getMonth() + 2, 1)
        maxValidDate.setHours(0, 0, 0, 0)

        if (startTime >= maxValidDate) {
            showToast("创建失败：只能安排本月或下个月的场次！", false)
            return
        }
        // 把T换成空格
        const formattedStartTime = startTimeVal.replace('T', ' ')
        const information = {
            action: 'create',
            script_id: scriptId,
            start_time: formattedStartTime,
            dm_id: dmId || null
        };

        try {
            ShowCoveringLayer("正在创建...")
            await request('AdminRoom', information)
            HiddenCoveringLayer()
            showToast("房间创建成功！", true)
            closeCreateRoomModal()
            ShowAdminDashboard()
        } catch (error) {
            HiddenCoveringLayer()
            showToast(error, false)
        }
    }


    //用户数据
    let UserDataList = []
    //用户管理页
    async function ShowUserManagement() {
        clearWeb()
        setMenuHighLight('用户管理')
        ShowCoveringLayer("加载用户数据...")

        SPAContent.style.display = 'flex';
        SPAContent.style.flexDirection = 'column';
        SPAContent.style.height = '100%';       // 强制占满高度
        SPAContent.style.overflow = 'hidden';   // 杀掉外层滚动条

        try {
            let information={
                action: 'list',
                search: '',
                role: 'ALL'
            }
            const res = await request('AdminUser',information)
            UserDataList = res.list || []
        } catch (e) {
            showToast("获取用户列表失败: " + e, false)
            UserDataList = []
        }

        SPAContent.innerHTML = `
        <div class="header-container" style="flex-shrink: 0;">
            <h2 style="font-size:1.5rem; color:#333; font-weight:bold;">用户管理</h2>
            <div class="AdminDashboard-header-actions">
                <select id="userRoleFilter" class="AdminDashboard-search-bar" style="width:120px;" onchange="filterUserList()">
                    <option value="ALL">全部角色</option>
                    <option value="PLAYER">仅看 Player</option>
                    <option value="DM">仅看 DM</option>
                </select>
                <input type="text" id="userSearchInput" class="AdminDashboard-search-bar"
                    placeholder="搜索用户名..." oninput="filterUserList()" autocomplete="off">
                <button class="AdminDashboard-menu-toggle" onclick="toggleMenu()">☰</button>
            </div>
        </div>

        <div class="AdminDashboard-main-content" style="flex: 1; overflow: hidden; display: flex; flex-direction: column; padding-bottom: 20px;">

            <div style="background:#fff; border-radius:16px; box-shadow:0 2px 8px rgba(0,0,0,0.05); overflow:hidden; display: flex; flex-direction: column; flex: 1;">

                <div style="flex-shrink: 0; display:grid; grid-template-columns: 80px 2fr 1fr 1fr 1fr 150px; padding:16px; background:#f9fafb; font-weight:bold; color:#666; font-size:0.9rem; border-bottom: 1px solid #eee;">
                    <div>ID</div>
                    <div>用户</div>
                    <div>角色</div>
                    <div>信誉分</div>
                    <div>余额</div>
                    <div style="text-align:right;">操作</div>
                </div>

                <div id="UserListContainer" style="flex: 1; overflow-y: auto; min-height:0;">
                    </div>
            </div>
        </div>

        <button class="fab-add-script" onclick="openManageUserModal('add')">
            <span style="font-size:1.2rem;">+</span> 新增用户
        </button>
    `

        renderUserList(UserDataList)
        HiddenCoveringLayer()
    }

    //渲染用户列表
    function renderUserList(list) {
        const container = document.getElementById('UserListContainer')
        //空数据处理
        if (!list || list.length === 0) {
            container.innerHTML = '<div style="padding:40px; text-align:center; color:#999;">暂无用户数据</div>'
            return
        }
        let html = ''
        list.forEach(u => {
            //角色身份显示逻辑,DM和Player
            let roleBadge = ''
            if (u.role === 'DM') roleBadge = '<span style="background:#E3F2FD; color:#1976D2; padding:2px 8px; border-radius:4px; font-size:0.8rem; font-weight:bold;">DM</span>'
            else roleBadge = '<span style="background:#F5F5F5; color:#666; padding:2px 8px; border-radius:4px; font-size:0.8rem;">Player</span>'

            //信誉分与余额逻辑 (DM显示—，玩家显示数值)，先都设置为-，之后如果是玩家，再改成具体数字
            let reputationHTML = '<span style="color:#ccc;">—</span>'
            let balanceHTML = '<span style="color:#ccc;">—</span>'

            if (u.role === 'PLAYER') {
                //信誉分颜色判断
                let color = '#4CAF50' // 80-100 绿色
                if (u.reputation_score < 60) color = '#F44336' // <60 红色
                else if (u.reputation_score < 80) color = '#FF9800' // 60-79 黄色

                reputationHTML = `<span style="font-weight:bold; color:\${color};">\${u.reputation_score}</span>`

                //余额显示
                balanceHTML = `<div><div style="font-weight:bold;">¥ \${u.balance}</div>`
                if(u.frozen_balance > 0) {
                    balanceHTML += `<div style="font-size:0.75rem; color:#FF9800;">冻结: ¥\${u.frozen_balance}</div>`
                }
                balanceHTML += `</div>`
            }

            //头像显示逻辑
            let avatarDisplay = ''
            if (u.avatar_url && u.avatar_url.trim() !== '') {
                const fullPath = "${pageContext.request.contextPath}/" + u.avatar_url
                avatarDisplay = `<img src="\${fullPath}" style="width:36px; height:36px; border-radius:50%; object-fit:cover; border:1px solid #eee;">`
            } else {
                const firstLetter = u.username ? u.username.substring(0,1).toUpperCase() : '?'
                avatarDisplay = `<div style="width:36px; height:36px; background:#eee; border-radius:50%; display:flex; align-items:center; justify-content:center; color:#999; font-weight:bold;">\${firstLetter}</div>`;
            }

            //拼接单行 HTML
            html += `
                <div style="display:grid; grid-template-columns: 80px 2fr 1fr 1fr 1fr 150px; padding:16px; border-bottom:1px solid #eee; align-items:center; font-size:0.95rem;">
                    <div style="color:#888;">#\${u.id}</div>

                    <div style="display:flex; align-items:center; gap:10px;">
                        \${avatarDisplay}
                        <div style="font-weight:600; color:#333;">\${u.username}</div>
                    </div>

                    <div>\${roleBadge}</div>
                    <div>\${reputationHTML}</div>
                    <div>\${balanceHTML}</div>

                    <div style="text-align:right;">
                        <button style="color:#3D77DD; border:none; background:none; cursor:pointer; font-weight:600; margin-right:10px;"
                            onclick="openManageUserModal('edit', '\${u.id}')">编辑</button>
                        <button style="color:#FF5252; border:none; background:none; cursor:pointer;"
                            onclick="deleteUser('\${u.id}')">删除</button>
                    </div>
                </div>
            `
        });

        container.innerHTML = html;
    }

    // 筛选用户
    async function filterUserList() {
        const keyword = document.getElementById('userSearchInput').value.toLowerCase()
        const role = document.getElementById('userRoleFilter').value

        const filtered = UserDataList.filter(u => {
            const matchName = u.username.toLowerCase().includes(keyword)
            const matchRole = (role === 'ALL') || (u.role === role)
            return matchName && matchRole;
        });
        renderUserList(filtered);
    }

    //admin页的新增用户弹窗
    function getUserModalHTML() {
        return `
        <div class="modal-overlay" id="userModal" onclick="onOverlayClick(event)">
            <div class="modal-card" style="width: 480px;">
                <div class="modal-header" id="userModalTitle">新增用户</div>
                <input type="hidden" id="editUserId">

                <div style="display:flex; gap:20px;">
                    <div style="display:flex; flex-direction:column; align-items:center; gap:10px; padding-top:10px;">
                        <div id="avatarPreview" style="width:80px; height:80px; border-radius:50%; background:#eee; background-size:cover; background-position:center; border:2px solid #ddd; display:flex; align-items:center; justify-content:center; color:#aaa; font-size:0.8rem; overflow:hidden;">无头像</div>
                        <input type="hidden" id="userAvatarBase64">
                        <input type="file" id="avatarFileInput" accept="image/*" style="display:none;" onchange="handleAvatarUpload(this)">
                        <button type="button" onclick="document.getElementById('avatarFileInput').click()" style="font-size:0.8rem; padding:4px 8px; border-radius:4px; border:1px solid #ccc; background:white; cursor:pointer;">上传图片</button>
                        <div style="font-size:0.7rem; color:#999; text-align:center;">支持jpg/png<br>建议正方形</div>
                    </div>

                    <div style="flex:1;">
                        <div class="form-group">
                            <label class="form-label">角色</label>
                            <select id="userRole" class="form-select" onchange="toggleUserFields()">
                                <option value="PLAYER">Player</option>
                                <option value="DM">DM (员工)</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">用户名</label>
                            <input type="text" id="userName" class="form-input">
                        </div>
                        <div class="form-group">
                            <label class="form-label">密码 <span id="pwdHint" style="font-weight:normal; color:#999; font-size:0.8rem;"></span></label>
                            <input type="password" id="userPwd" class="form-input">
                        </div>
                    </div>
                </div>

                <div id="playerFields" style="margin-top:10px; border-top:1px solid #eee; padding-top:10px;">
                    <div style="display:grid; grid-template-columns: 1fr 1fr; gap:10px;">
                        <div class="form-group">
                            <label class="form-label">余额 (¥)</label>
                            <input type="number" id="userBalance" class="form-input" placeholder="0.00">
                        </div>
                        <div class="form-group">
                            <label class="form-label">信誉分</label>
                            <input type="number" id="userReputation" class="form-input" value="100">
                        </div>
                    </div>
                </div>

                <div class="modal-actions">
                    <button class="btn-cancel" onclick="closeUserModal()">取消</button>
                    <button class="btn-confirm" onclick="submitManageUser()">保存</button>
                </div>
            </div>
        </div>`
    }

    // 处理图片转 Base64
    function handleAvatarUpload(input) {
        // 1. 获取按钮元素，准备改状态
        const btn = input.nextElementSibling // 获取到那个 "上传图片" 的按钮
        const originalText = btn.innerText

        if (input.files && input.files[0]) {
            // 限制一下大小 (2MB)
            if(input.files[0].size > 2 * 1024 * 1024) {
                showToast("图片太大，请选择 2MB 以下的图片", false)
                input.value = '' // 清空选择
                return;
            }

            // 2. 界面反馈：禁用按钮，变文字
            btn.disabled = true
            btn.innerText = "处理中..."
            btn.style.opacity = "0.6"
            btn.style.cursor = "not-allowed"

            const reader = new FileReader()

            reader.onload = function(e) {
                const base64 = e.target.result;
                const preview = document.getElementById('avatarPreview')

                // 显示预览
                preview.innerHTML = '';
                preview.style.backgroundImage = 'url(' + base64 + ')'

                // 存入隐藏域
                document.getElementById('userAvatarBase64').value = base64

                // 3. 恢复按钮状态
                btn.disabled = false
                btn.innerText = "更换图片" // 变成“更换”
                btn.style.opacity = "1"
                btn.style.cursor = "pointer"

                showToast("图片读取成功，点击[保存]后生效", true)
            }

            reader.onerror = function() {
                showToast("图片读取失败", false)
                btn.disabled = false
                btn.innerText = originalText
                btn.style.opacity = "1"
                btn.style.cursor = "pointer"
            }

            // 开始读取
            reader.readAsDataURL(input.files[0])
        }
    }

    //admin打开模态框
    function openManageUserModal(mode, userId = null) {
        let modal = document.getElementById('userModal')
        if (!modal) {
            document.body.insertAdjacentHTML('beforeend', getUserModalHTML())//插入模态框的HTML
            modal = document.getElementById('userModal')
        }

        const title = document.getElementById('userModalTitle')
        const idInput = document.getElementById('editUserId')
        const roleSelect = document.getElementById('userRole')
        const pwdHint = document.getElementById('pwdHint')
        const avatarPrev = document.getElementById('avatarPreview')
        const avatarInput = document.getElementById('userAvatarBase64')
        const nameInput = document.getElementById('userName')

        //清空表单
        nameInput.value = ''
        document.getElementById('userPwd').value = ''
        document.getElementById('userBalance').value = ''
        document.getElementById('userReputation').value = '100'
        avatarInput.value = ''
        avatarPrev.style.backgroundImage = ''
        avatarPrev.innerHTML = '无头像'

        //重置上传按钮文字，防止上次关闭时是“处理中”
        const uploadBtn = document.querySelector('#avatarFileInput').nextElementSibling
        if(uploadBtn) uploadBtn.innerText = "上传图片"

        if (mode === 'edit' && userId) {//现在要编辑
            const u = UserDataList.find(x => x.id == userId)
            if (!u) return
            title.innerText = "编辑用户"
            idInput.value = userId
            nameInput.value = u.username
            nameInput.readOnly = true          //禁止输入
            nameInput.style.backgroundColor = "#e9ecef" //变灰
            nameInput.style.color = "#6c757d"   //文字变淡
            nameInput.title = "用户名不可修改"    //提示
            roleSelect.value = u.role
            roleSelect.disabled = true

            if(u.avatar_url) {
                avatarInput.value = u.avatar_url
                avatarPrev.innerHTML = ''
                // 加上 contextPath 防止路径错误
                const fullPath = "${pageContext.request.contextPath}/" + u.avatar_url
                avatarPrev.style.backgroundImage = 'url(' + fullPath + ')'
            }

            if (u.role === 'PLAYER') {
                document.getElementById('userBalance').value = u.balance
                document.getElementById('userReputation').value = u.reputation_score
            }
            pwdHint.innerText = "(空则不改)"

        } else {
            title.innerText = "新增用户"
            idInput.value = ""
            //新增的模式下，允许输入
            nameInput.readOnly = false
            nameInput.style.backgroundColor = "#F8F9FA"
            nameInput.style.color = "#333"
            nameInput.title = ""
            roleSelect.disabled = false
            roleSelect.value = "PLAYER"
            pwdHint.innerText = "(必填)"
        }
        toggleUserFields();
        modal.style.display = 'flex'
        function temp(){
            modal.classList.add('show')
        }
        setTimeout(temp, 10)
    }

    //关闭模态框
    function closeUserModal() {
        const modal = document.getElementById('userModal')
        if (modal) {
            modal.classList.remove('show')
            function temp(){
                modal.style.display = 'none'
            }
            setTimeout(temp, 300)
        }
    }

    //根据管理员选择的用户角色Player,DM,显示隐藏“余额”和“信誉分”输入框
    function toggleUserFields() {
        const role = document.getElementById('userRole').value
        const playerFields = document.getElementById('playerFields')
        playerFields.style.display = (role === 'DM') ? 'none' : 'block'
    }

    async function submitManageUser() {
        const id = document.getElementById('editUserId').value
        const role = document.getElementById('userRole').value
        const username = document.getElementById('userName').value
        const password = document.getElementById('userPwd').value
        const balance = document.getElementById('userBalance').value
        const reputation = document.getElementById('userReputation').value
        const avatarUrl = document.getElementById('userAvatarBase64').value // 获取 Base64

        if (!username) {
            showToast("用户名必填", false)
            return
        }
        if (!id && !password) {
            showToast("密码必填", false)
            return
        }

        if (role === 'PLAYER' && balance && parseFloat(balance) < 0) {
            showToast("余额不能为负数！", false);
            return;
        }

        const information = {
            action: id ? 'edit' : 'add',
            id: id,
            username: username,
            password: password,
            role: role,
            avatar_url: avatarUrl, // 发送头像数据
            balance: role === 'PLAYER' ? (balance || 0) : 0,
            reputation_score: role === 'PLAYER' ? (reputation || 100) : 100
        };

        try {
            ShowCoveringLayer("保存中...")
            await request('AdminUser', information)
            HiddenCoveringLayer()
            showToast("成功", true)
            closeUserModal()
            ShowUserManagement()
        } catch (e) {
            HiddenCoveringLayer()
            showToast(e, false)
        }
    }

    //删除用户的逻辑
    async function deleteUser(id) {
        if (!confirm("确定要删除该用户吗？")) return
        try {
            ShowCoveringLayer("删除中...")
            let temp={
                action: 'delete',
                id: id
            }
            await request('AdminUser',temp)
            HiddenCoveringLayer()
            showToast("已删除", true)
            ShowUserManagement();
        } catch (e) {
            HiddenCoveringLayer()
            showToast(e, false)
        }
    }

    //安全解析时间 (兼容 时间戳数字 和 字符串)
    function safeDateFormat(val) {
        if (!val) return '未知时间'
        let date
        if (typeof val === 'number') {
            date = new Date(val) // 处理时间戳
        } else {
            // 处理字符串
            let s = val.toString().replace('T', ' ').replace(/-/g, "/")
            date = new Date(s)
        }
        if (isNaN(date.getTime())) return val // 解析失败返回原值

        const y = date.getFullYear()
        const m = String(date.getMonth() + 1).padStart(2, '0')
        const d = String(date.getDate()).padStart(2, '0')
        const h = String(date.getHours()).padStart(2, '0')
        const min = String(date.getMinutes()).padStart(2, '0')
        return y + '-' + m + '-' + d + ' ' + h + ':' + min
    }

    //辅助工具：只提取 HH:mm
    function safeTimeOnly(val) {
        if (!val) return '--:--'
        let date
        if (typeof val === 'number') {
            date = new Date(val)
        } else {
            let s = val.toString().replace('T', ' ').replace(/-/g, "/")
            date = new Date(s)
        }
        if (isNaN(date.getTime())) return '--:--'
        return String(date.getHours()).padStart(2, '0') + ':' + String(date.getMinutes()).padStart(2, '0')
    }



    //显示DM的工作台，可传入 dateStr (YYYY-MM-DD)
    async function ShowDMDashboard(dateStr = null) {
        setMenuHighLight('DM工作台')

        // 如果没有传参，默认使用今天
        if (!dateStr) {
            const now = new Date()
            const m = String(now.getMonth() + 1).padStart(2, '0')
            const d = String(now.getDate()).padStart(2, '0')
            dateStr = now.getFullYear() + '-' + m + '-' + d
            CurrentDMDate = now // 更新全局状态
        } else {
            CurrentDMDate = new Date(dateStr) // 更新全局状态
        }

        ShowCoveringLayer("数据加载中...")
        try {
            let information={
                action: 'get_dashboard_data',
                target_date: dateStr
            }
            const res = await request('DM',information)
            // 渲染时也把选中的日期传进去
            renderWorkbench(res, dateStr)
            HiddenCoveringLayer()
        } catch (err) {
            HiddenCoveringLayer()
            showToast("加载数据失败: " + err, false)
        }
    }

    //按钮操作,dm开始游戏
    async function StartGame(roomId) {
        if(!confirm('确定全员已到齐，开始游戏吗？状态将变更为 PLAYING')) return

        try {
            let information={
                action: 'start_game',
                room_id: roomId
            }
            const res = await request('DM',information)
            showToast(res.info, true)
            ShowDMDashboard(); // 刷新
        } catch (error) {
            showToast(error, false);
        }
    }

    // DM完成游戏
    async function FinishGame(roomId) {
        if(!confirm('确定游戏结束并进行结算吗？\n警告：将扣除玩家冻结资金，此操作不可逆！')) return

        try {
            const res = await request('DM', { action: 'finish_game', room_id: roomId })
            showToast('成功', true)
            ShowDMDashboard() // 刷新
        } catch (error) {
            showToast(error, false)
        }
    }

    //显示场次调度页面
    async function ShowSchedulePage() {
        top_nav.innerHTML = ''
        setMenuHighLight('场次调度')
        ShowCoveringLayer("Loading...")

        if(!ScriptData) await getScriptData()

        //默认选中今天
        const now = new Date()
        ScheduleState.viewYear = now.getFullYear()
        ScheduleState.viewMonth = now.getMonth()
        ScheduleState.selectedDateStr = formatDate(now)
        ScheduleState.baseDate = new Date(now.getFullYear(), now.getMonth(), 1)

        // 渲染页面框架
        SPAContent.innerHTML = `
            <div class="header-container">
                <h2 style="font-size:1.5rem; color:#333; font-weight:bold;">场次调度 (Schedule)</h2>
                <div class="AdminDashboard-header-actions">
                    <button class="AdminDashboard-menu-toggle" onclick="toggleMenu()">☰</button>
                </div>
            </div>

            <div class="schedule-container" style="padding-top: 10px;">
                <div class="calendar-card">
                    <div class="calendar-header">
                        <button class="calendar-btn" id="calPrevBtn" onclick="changeMonth(-1)">&lt;</button>
                        <div class="calendar-title" id="calTitle">2026年 1月</div>
                        <button class="calendar-btn" id="calNextBtn" onclick="changeMonth(1)">&gt;</button>
                    </div>
                    <div class="calendar-grid" id="calendarGrid">
                    </div>
                </div>

                <div>
                    <div class="schedule-list-header" id="scheduleListHeader">
                        今日场次 (2026-01-09)
                    </div>
                    <div class="AdminDashboard-rooms-grid" id="scheduleRoomList">
                    </div>
                </div>
            </div>
        `

        // 渲染日历和数据
        renderCalendar()
        await loadScheduleData(ScheduleState.selectedDateStr)
        HiddenCoveringLayer()
    }

    //渲染日历网格的核心算法
    function renderCalendar() {
        const grid = document.getElementById('calendarGrid')
        const title = document.getElementById('calTitle')
        const prevBtn = document.getElementById('calPrevBtn')
        const nextBtn = document.getElementById('calNextBtn')
        if(!grid) return
        const year = ScheduleState.viewYear
        const month = ScheduleState.viewMonth

        // 更新标题
        title.innerText = `\${year}年 \${month + 1}月`
        // 处理翻页按钮限制 (只允许 上个月，本月，下月)
        // 逻辑：计算当前 viewMonth 与 baseDate 的月份差
        // 简化算法：转成绝对月份值 (Year * 12 + Month)
        const currentAbs = year * 12 + month
        const baseAbs = ScheduleState.baseDate.getFullYear() * 12 + ScheduleState.baseDate.getMonth()
        prevBtn.disabled = (currentAbs <= baseAbs - 1)
        nextBtn.disabled = (currentAbs >= baseAbs + 1)

        // 清空网格并添加表头
        grid.innerHTML = ''
        const weekDays = ['日', '一', '二', '三', '四', '五', '六']
        weekDays.forEach(day => {
            grid.innerHTML += `<div class="calendar-weekday">\${day}</div>`
        })
        // 计算当月第一天是星期几
        const firstDay = new Date(year, month, 1).getDay()
        // 计算当月有多少天
        const daysInMonth = new Date(year, month + 1, 0).getDate()
        // 填充空白 (上个月的残留)
        for (let i = 0; i < firstDay; i++) {
            grid.innerHTML += `<div class="calendar-day empty"></div>`
        }

        // 填充日期
        const todayStr = formatDate(new Date());

        for (let d = 1; d <= daysInMonth; d++) {
            const dateStr = `\${year}-\${String(month + 1).padStart(2, '0')}-\${String(d).padStart(2, '0')}`
            const el = document.createElement('div')
            el.className = 'calendar-day'
            el.innerText = d
            // 状态判断
            if (dateStr === ScheduleState.selectedDateStr) {
                el.classList.add('active')
            }
            if (dateStr === todayStr) {
                el.classList.add('today')
            }

            // 点击事件
            el.onclick = () => {
                ScheduleState.selectedDateStr = dateStr
                renderCalendar() // 重新渲染以更新高亮
                loadScheduleData(dateStr) // 加载数据
            };
            grid.appendChild(el)
        }
    }

    function changeMonth(offset) {
        let newMonth = ScheduleState.viewMonth + offset
        let newYear = ScheduleState.viewYear;

        if (newMonth > 11) {
            newMonth = 0
            newYear++
        } else if (newMonth < 0) {
            newMonth = 11
            newYear--
        }

        ScheduleState.viewMonth = newMonth
        ScheduleState.viewYear = newYear
        renderCalendar()
    }

    //删除房间
    async function deleteScheduleRoom(roomId) {
        if (!confirm("确定要删除这个场次吗？\n（只有该场次没有任何玩家时才能删除）")) return

        try {
            ShowCoveringLayer("删除中...")
            let information={
                action: 'delete',
                id: roomId
            }
            await request('AdminRoom', information)
            HiddenCoveringLayer()
            showToast("删除成功", true)
            loadScheduleData(ScheduleState.selectedDateStr)
        } catch (error) {
            HiddenCoveringLayer();
            showToast(error, false)
            loadScheduleData(ScheduleState.selectedDateStr)
        }
    }

    //加载特定日期的排班数据
    async function loadScheduleData(dateStr) {
        const listHeader = document.getElementById('scheduleListHeader')
        const listContainer = document.getElementById('scheduleRoomList')
        const [y, m, d] = dateStr.split('-')
        listHeader.innerHTML = `📅 \${parseInt(m)}月\${parseInt(d)}日 安排`
        listContainer.innerHTML = '<div style="width:100%; text-align:center; padding:20px; color:#999;">加载中...</div>'
        try {
            let information={
                action: 'get_schedule',
                date: dateStr
            }
            const res = await request('AdminRoom',information)
            if (!res.list || res.list.length === 0) {
                //计算日期差异 (只比较年月日，忽略时分秒)
                const checkDate = new Date(dateStr.replace(/-/g, '/'))
                checkDate.setHours(0, 0, 0, 0)
                const today = new Date();
                today.setHours(0, 0, 0, 0)
                //根据日期决定显示的按钮 HTML
                let actionHTML = ''
                if (checkDate >= today) {
                    // 情况A: 今天或未来 -> 显示【安排一场】按钮
                    actionHTML = `<button class="btn-create-room" onclick="openCreateRoomModal('\${dateStr}')" style="width:auto; margin: 15px auto; padding: 8px 20px;">+ 安排一场</button>`
                } else {
                    // 情况B: 过去 -> 显示提示文本
                    actionHTML = `<div style="margin-top:15px; color:#ccc; font-size:0.9rem; cursor:default;">(历史日期无法新增排期)</div>`
                }

                //渲染
                listContainer.innerHTML = `
                    <div style="grid-column: 1/-1; text-align: center; padding: 40px; color: #999; background: #f9f9f9; border-radius: 12px;">
                        <img src="${pageContext.request.contextPath}/resources/svg/Information_bad.svg" style="width:40px; opacity:0.3; margin-bottom:10px;">
                        <div>本日暂无任何场次安排</div>
                        \${actionHTML}
                    </div>`
                return
            }

            // 渲染列表 (复用仪表盘的卡片样式，稍微改动)
            let html = ''
            res.list.forEach(room => {
                const script = ScriptData.list.find(s => s.id === room.script_id) || { title: '未知剧本' }

                // 计算时间段
                const start = new Date(room.start_time)
                const end = new Date(room.end_time)
                const timeText = `\${formatTime(start)} - \${formatTime(end)}`

                // 状态颜色
                let statusBadge = ''
                if(room.status === 'WAITING') statusBadge = '<span class="room-badge badge-waiting">WAITING (拼车中)</span>'
                else if(room.status === 'LOCKED') statusBadge = '<span class="room-badge badge-locked">LOCKED (待开局)</span>'
                else if(room.status === 'PLAYING') statusBadge = '<span class="room-badge badge-playing">PLAYING (游戏中)</span>'
                else statusBadge = '<span class="room-badge" style="background:#eee; color:#666">FINISHED</span>'

                // DM 按钮逻辑
                let dmAction = ''
                if(room.dm_id) {
                    dmAction = `<div style="font-size:0.85rem; font-weight:bold; color:#333;">DM: (ID:\${room.dm_id})</div>`
                } else {
                    let safeTitle = script.title ? script.title.replace(/['"]/g, '') : '未知';
                    dmAction = `<button class="room-action-btn" onclick="openAssignDMModal('\${room.id}', '\${safeTitle}')">指派 DM</button>`
                }

                let deleteBtnHTML = ''
                if (room.current_num === 0) {
                    deleteBtnHTML = `
                        <button class="room-action-btn"
                                style="color:#FF5252; border-color:#FF5252; margin-top:4px;"
                                onclick="deleteScheduleRoom('\${room.id}')">
                            删除
                        </button>`
                }

                html += `
                <div class="AdminDashboard-room-card" style="align-items:center;">
                    <div style="width: 8px; height: 40px; background: #673AB7; border-radius: 4px; margin-right: 12px;"></div>
                    <div style="flex:1;">
                        <div style="font-size: 1.1rem; font-weight: bold; color: #333;">《\${script.title}》</div>
                        <div style="font-size: 0.9rem; color: #666; margin-top: 4px;">\${timeText}</div>
                        <div style="font-size: 0.8rem; color: #999; margin-top: 2px;">当前人数: \${room.current_num} / \${room.max_num}</div>
                    </div>
                    <div style="display:flex; flex-direction:column; align-items:flex-end; gap:5px;">
                        \${statusBadge}
                        \${dmAction}
                        \${deleteBtnHTML} </div>
                </div>
                `
            });
            listContainer.innerHTML = html

        } catch (error) {
            showToast("获取场次失败: " + error, false);
            listContainer.innerHTML = '<div style="text-align:center; color:red;">加载失败</div>'
        }
    }

    // 辅助工具：格式化日期 YYYY-MM-DD
    function formatDate(date) {
        const y = date.getFullYear()
        const m = String(date.getMonth() + 1).padStart(2, '0')
        const d = String(date.getDate()).padStart(2, '0')
        return `\${y}-\${m}-\${d}`
    }

    // 辅助工具：格式化时间 HH:mm
    function formatTime(date) {
        return String(date.getHours()).padStart(2, '0') + ':' + String(date.getMinutes()).padStart(2, '0')
    }

    //指派DM的模态框
    function getAssignDMModalHTML() {
        return `
        <div class="modal-overlay" id="assignDMModal" onclick="onOverlayClick(event)">
            <div class="modal-card" style="width: 400px;">
                <div class="modal-header">指派主持人 (Assign DM)</div>
                <input type="hidden" id="assignRoomId">

                <div style="padding: 10px 0; color: #666; font-size: 0.9rem;" id="assignRoomInfo"></div>

                <div class="form-group">
                    <label class="form-label">选择空闲 DM</label>
                    <select id="assignDMSelect" class="form-select">
                        <option value="" disabled selected>加载中...</option>
                    </select>
                    <div style="font-size: 0.8rem; color: #999; margin-top: 5px;">
                        * 系统已自动过滤掉该时段有排期的员工
                    </div>
                </div>

                <div class="modal-actions">
                    <button class="btn-cancel" onclick="closeAssignDMModal()">取消</button>
                    <button class="btn-confirm" onclick="submitAssignDM()">确认指派</button>
                </div>
            </div>
        </div>`
    }

    //打开模态框
    async function openAssignDMModal(roomId, scriptTitle){
        let modal = document.getElementById('assignDMModal')
        if (!modal) {//页面没有模态框就插入
            document.body.insertAdjacentHTML('beforeend', getAssignDMModalHTML())
            modal = document.getElementById('assignDMModal')
        }

        document.getElementById('assignRoomId').value = roomId
        document.getElementById('assignRoomInfo').innerHTML =
            `目标房间：<span style="color:#333; font-weight:bold;">#\${roomId}</span><br>剧本名称：<span style="color:#3D77DD; font-weight:bold;">《\${scriptTitle}》</span>`;

        const select = document.getElementById('assignDMSelect')
        select.innerHTML = '<option>正在检查冲突...</option>'
        select.disabled = true

        //显示弹窗
        modal.style.display = 'flex'
        function temp(){
            modal.classList.add('show')
        }
        setTimeout(temp , 10)

        try {
            let information={
                action: 'get_available_dms',
                room_id: roomId
            }
            const res = await request('AdminRoom',information);

            select.disabled = false
            if (res.list && res.list.length > 0) {
                select.innerHTML = '<option value="" disabled selected>请选择...</option>'
                res.list.forEach(dm => {
                    select.innerHTML += `<option value="\${dm.id}">\${dm.username}</option>`
                });
            } else {
                select.innerHTML = '<option value="" disabled>⚠️ 无空闲员工</option>'
            }
        } catch (e) {
            select.innerHTML = '<option disabled>加载失败</option>'
            showToast(e, false)
        }
    }

    //关闭指派DM模态框
    function closeAssignDMModal() {
        const modal = document.getElementById('assignDMModal')
        if (modal) {
            modal.classList.remove('show')
            function temp(){
                modal.style.display = 'none'
            }
            // 2. 设置定时器完全隐藏
            setTimeout(temp, 300)
        }
    }

    //提交指派
    async function submitAssignDM() {
        const roomId = document.getElementById('assignRoomId').value
        const dmId = document.getElementById('assignDMSelect').value

        if (!dmId) {
            showToast("请先选择一名 DM", false)
            return
        }

        try {
            ShowCoveringLayer("正在指派...")
            await request('AdminRoom', {
                action: 'assign_dm',
                room_id: roomId,
                dm_id: dmId
            });
            HiddenCoveringLayer();

            closeAssignDMModal();
            showToast("指派成功！", true);

            //刷新数据
            function temp(){
                // 如果当前在场次调度页面
                if (document.getElementById('scheduleRoomList')) {
                    loadScheduleData(ScheduleState.selectedDateStr)
                }
                // 如果当前在仪表盘页面
                else if (document.getElementById('LiveRoomGrid')) {
                    ShowAdminDashboard()
                }
            }
            setTimeout(temp, 100);

        } catch (e) {
            HiddenCoveringLayer();
            showToast(e, false);
        }
    }

        async function ShowAdminDashboard() {
            setMenuHighLight('仪表盘')
            ShowCoveringLayer("Load")

            //获取数据
            if(!ScriptData) await getScriptData()
            await AdminGetTodayArrangement()
            const revenueData = await getCashInflowsToday()
            const activeGamesData = await AdminGetTheNumberOfOngoingGames()
            const popularScriptsData = await getPopularScripts()
            const actionData = await AdminGetActionRequired()
            const alertData = await AdminGetReputationAlerts()

            let headerHTML = `
            <div class="header-container">
                <h2 style="font-size:1.5rem; color:#333; font-weight:bold;">长沙A店管理后台</h2>
                <div class="AdminDashboard-header-actions">

                    <button class="AdminDashboard-menu-toggle" onclick="toggleMenu()">☰</button>
                </div>
            </div>
        `
            top_nav.innerHTML = headerHTML

            //准备数据
            const revenueText = (revenueData.list && revenueData.list.length > 0) ? '¥ ' + revenueData.list[0].total_recharge : '¥ 0.00'
            const activeCount = activeGamesData.list ? activeGamesData.list.length : 0
            const lockedCount = AdminTodayArrangement.list.filter(r => r.status === 'LOCKED').length
            const playingCount = AdminTodayArrangement.list.filter(r => r.status === 'PLAYING').length

            let contentHTML = `
            <div class="AdminDashboard-main-content">
                <section class="AdminDashboard-stats-grid">
                    <div class="AdminDashboard-card">
                        <div class="AdminDashboard-label">今日营收 (Today's Revenue)</div>
                        <div class="AdminDashboard-value" style="color:#333;">\${revenueText}</div>
                        <div class="AdminDashboard-label" style="font-size:0.8rem; margin-top:5px; color:#888;">已结算订单</div>
                    </div>
                    <div class="AdminDashboard-card">
                        <div class="AdminDashboard-label">进行中场次 (Active Sessions)</div>
                        <div class="AdminDashboard-value" style="color:#333;">\${activeCount} 场</div>
                        <div class="AdminDashboard-label" style="font-size:0.8rem; margin-top:5px; color:#888;">
                            \${playingCount} 场游戏中, \${lockedCount} 场锁定中
                        </div>
                    </div>
                    <div class="AdminDashboard-card card-action-required">
                        <div class="AdminDashboard-label" style="color:#856404;">待办事项 (Action Required)</div>
                        <div style="font-size:1.1rem; font-weight:bold; color:#856404; margin-top:8px; display:flex; align-items:center;" class="DMActionRequired">
                            <span style="margin-right:8px;">⚠️</span>
                            \${actionData.count} 个房间待指派 DM
                        </div>
                    </div>
                </section>

                <section class="AdminDashboard-content-split">
                    <div style="display:flex; flex-direction:column; gap:16px;">
                        <h3 style="font-size:1rem; font-weight:bold; color:#333;">今日实时场次 (Live Status)</h3>
                        <div class="AdminDashboard-rooms-grid" id="LiveRoomGrid">
                            </div>
                    </div>

                    <aside class="AdminDashboard-insights-panel" style="background:#F8F6FB;">
                        <h3 style="margin-bottom:16px; font-size:1rem; font-weight:bold;">数据洞察 (Quick Insights)</h3>

                        <h4 style="margin-bottom:10px; font-size:0.85rem; color:#333; font-weight:600;">Top 3 热销剧本 (本周)</h4>
                        <div id="HotScriptsList" style="margin-bottom:24px;"></div>

                        <h4 style="margin-bottom:10px; font-size:0.85rem; color:#333; font-weight:600;">近期信誉预警</h4>
                        <div id="ReputationAlertList"></div>

                    </aside>
                </section>
            </div>
        `

            SPAContent.innerHTML = contentHTML
            if(actionData.count==0) document.querySelector('.DMActionRequired').innerHTML='无'

            //房间卡片
            const roomGrid = document.getElementById('LiveRoomGrid')
            let roomHTML = ''

            if (AdminTodayArrangement.list && AdminTodayArrangement.list.length > 0) {
                AdminTodayArrangement.list.forEach(room => {
                    const script = ScriptData.list.find(s => s.id === room.script_id) || { title: '未知剧本', cover_url: '', player_count: 0 }

                    let badgeClass = ''
                    let statusText = ''
                    let actionBtnHTML = ''
                    let progressHTML = ''
                    let metaText = ''

                    // 状态判断
                    if (room.status === 'LOCKED') {
                        badgeClass = 'badge-locked'
                        statusText = 'LOCKED (待开局)'
                        progressHTML = `<div class="room-progress-bg"><div class="room-progress-fill" style="width: 100%; background:#FF9800;"></div></div>`
                        metaText = `\${room.current_num}/\${room.max_num} 人满`
                        if (!room.dm_id) {
                            let safeTitle = script.title ? script.title.replace(/['"]/g, '') : '未知'
                            actionBtnHTML = `<button class="room-action-btn btn-primary-ghost" onclick="openAssignDMModal('\${room.id}', '\${safeTitle}')">指派 DM</button>`;
                        } else {
                            actionBtnHTML = `<p style="font-size:0.8rem; color:#666; margin-top:auto;">DM: 已指派</p >`
                        }
                    } else if (room.status === 'PLAYING') {
                        badgeClass = 'badge-playing'
                        statusText = 'PLAYING (游戏中)'
                        metaText = 'DM: 小王'
                        actionBtnHTML = `<p style="font-size:0.8rem; color:#2E7D32; margin-top:auto;">已开始 1h 20m</p >`
                    } else if (room.status === 'WAITING') {
                        badgeClass = 'badge-waiting'
                        statusText = 'WAITING (拼车中)'
                        const pct = (room.current_num / room.max_num) * 100;
                        progressHTML = `<div class="room-progress-bg"><div class="room-progress-fill" style="width: \${pct}%;"></div></div>`
                        metaText = `\${room.current_num}/\${room.max_num} 人`
                        actionBtnHTML = `<span style="font-size:0.8rem; color:#aaa; margin-top:auto;">等待拼满...</span>`
                    } else {
                        statusText = 'FINISHED'
                    }

                    let imgDisplay = ''
                    if(script.cover_url){
                        imgDisplay = '<img src="' + script.cover_url + '" class="room-cover-img" alt="cover">'
                    } else {
                        imgDisplay = '<div class="room-cover-img" style="display:flex;align-items:center;justify-content:center;color:#999;font-size:0.8rem;">无封面</div>'
                    }

                    roomHTML += `
                    <div class="AdminDashboard-room-card">
                        \${imgDisplay}
                        <div class="room-info-col">
                            <div>
                                <div class="room-title" title="\${script.title}">\${script.title}</div>
                                <span class="room-badge \${badgeClass}">\${statusText}</span>
                                \${progressHTML}
                                <div class="room-meta-text">\${metaText}</div>
                            </div>
                            \${actionBtnHTML}
                        </div>
                    </div>
                `
                })
            }
            roomGrid.innerHTML = roomHTML

            //渲染右侧列表
            const hotScriptsContainer = document.getElementById('HotScriptsList')
            if(popularScriptsData.list){
                hotScriptsContainer.innerHTML = popularScriptsData.list.map((s, idx) => `
                <div class="insight-list-item">
                    <span>\${idx + 1}. \${s.title}</span>
                    <span style="color:#aaa; font-size:0.8rem">Top</span>
                </div>
            `).join('')
            }

            const alertContainer = document.getElementById('ReputationAlertList')
            if(alertData.list){
                alertContainer.innerHTML = alertData.list.map(item => `
                <div class="insight-alert-item">
                    <div class="\${item.level === 'critical' ? 'dot-red' : 'dot-yellow'}"></div>
                    <span>\${item.msg}</span>
                </div>
            `).join('')
                if(alertData.list.length==0) alertContainer.innerHTML =` <div class="insight-alert-item"><span>无</span></div>`
            }

            HiddenCoveringLayer()
        }

    //专门用于设置左侧菜单高亮的功能
    function setMenuHighLight(menuName) {
        const items = document.querySelectorAll('.sidebar-menu li')
        items.forEach(item => {
            const text = item.innerText.trim()
            if (text.includes(menuName)) {
                item.classList.add('sidebar-active')
            } else {
                item.classList.remove('sidebar-active')
            }
        });
    }

    //侧边栏切换，移动端，侧边栏的开关控制逻辑
    function toggleMenu() {
        const sidebar = document.getElementById('sidebar')
        const overlay = document.getElementById('sidebarOverlay')
        // 同时切换侧边栏和遮罩层的状态
        sidebar.classList.toggle('active')
        if(overlay) {
            overlay.classList.toggle('active')
        }
    }

    // 组局大厅
    async function ShowOrganizingHall() {
        clearWeb();
        setMenuHighLight('组局大厅');
        ShowCoveringLayer("加载组局大厅...");

        const currentUserRole = `${sessionScope.role}`;

        SPAContent.innerHTML = `
            <div class="header-container">
                <h2 style="font-size:1.5rem; color:#333; font-weight:bold;">组局大厅 (Lobby)</h2>
                <div class="AdminDashboard-header-actions">
                    <button class="AdminDashboard-menu-toggle" onclick="toggleMenu()">☰</button>
                </div>
            </div>

            <div class="AdminDashboard-main-content">
                <div class="lobby-filter-bar">
                    <div style="position:relative;">
                        <span style="position:absolute; left:12px; top:10px; color:#999;">🔍</span>
                        <input type="text" id="lobbySearch" class="form-input"
                               style="padding-left: 36px; width: 200px;"
                               placeholder="搜索剧本名..." oninput="filterLobbyList()" autocomplete="off">
                    </div>

                    <select id="lobbyDifficultyFilter" class="form-select" style="width: 120px;" onchange="filterLobbyList()">
                        <option value="ALL">全部难度</option>
                        <option value="1">新手 (1)</option>
                        <option value="3">进阶 (3)</option>
                        <option value="5">硬核 (5)</option>
                    </select>
                </div>

                <div id="LobbyRoomGrid" class="lobby-grid">
                    </div>
            </div>
        `

        try {
            let information={
                action: 'get_lobby_data'
            }
            const res = await request('Lobby',information)
            LobbyDataList = res.list || []

            filterLobbyList()
            HiddenCoveringLayer()

        } catch (e) {
            HiddenCoveringLayer()
            showToast("加载失败: " + e, false)
            document.getElementById('LobbyRoomGrid').innerHTML = '<div style="text-align:center; color:#999;">无法连接到大厅服务</div>'
        }
    }

    //前端筛选
    function filterLobbyList() {
        const keyword = document.getElementById('lobbySearch').value.toLowerCase();
        const difficulty = document.getElementById('lobbyDifficultyFilter').value;

        const filtered = LobbyDataList.filter(room => {
            const matchKeyword = room.title.toLowerCase().includes(keyword) ||
                (room.tag_list && room.tag_list.toLowerCase().includes(keyword));

            const isNotFull = room.current_num < room.max_num;
            const isJoined = room.is_joined === 1;

            const matchStatus = isNotFull || isJoined;

            let matchDiff = true;
            if (difficulty !== 'ALL') {
                matchDiff = (room.difficulty == difficulty);
            }
            return matchKeyword && matchStatus && matchDiff;
        });
        renderLobbyList(filtered);
    }



    //显示数据
    function renderLobbyList(list) {
        const container = document.getElementById('LobbyRoomGrid')
        const userRole = `${sessionScope.role}` // 获取角色

        if (list.length === 0) {
            container.innerHTML = '<div style="grid-column: 1/-1; text-align: center; padding: 60px; color: #999;">没有找到符合条件的房间</div>'
            return
        }

        let html = ''
        list.forEach(room => {
            let coverHTML = '';
            if (room.cover_url && room.cover_url.trim() !== '') {
                const fullPath = room.cover_url.startsWith('http') ? room.cover_url : `${pageContext.request.contextPath}/\${room.cover_url}`;
                coverHTML = `<img src="\${fullPath}" class="lobby-cover-img" alt="cover">`;
            } else {
                // 截取前两个字作为缩写
                const shortTitle = room.title.substring(0, 2);
                coverHTML = `<div class="lobby-cover-placeholder">\${shortTitle}</div>`;
            }

            let tagsHTML = '';
            if (room.tag_list) {
                const tags = room.tag_list.split(/[,，\s]+/)
                tags.slice(0, 3).forEach(t => {
                    if (t) tagsHTML += `<span class="lobby-tag">\${t}</span>`
                });
            }

            //计算时间和进度
            const startTime = new Date(room.start_time)
            //格式化为: 01-12 14:00
            const timeStr = String(startTime.getMonth() + 1).padStart(2, '0') + '-' +
                String(startTime.getDate()).padStart(2, '0') + ' ' +
                String(startTime.getHours()).padStart(2, '0') + ':' +
                String(startTime.getMinutes()).padStart(2, '0')

            const progressPct = (room.current_num / room.max_num) * 100
            const isFull = room.current_num >= room.max_num;

            //按钮状态逻辑
            let btnHTML = ''

            // 如果是 DM，直接不显示按钮
            if (userRole === 'DM' || userRole === 'ADMIN') {
                btnHTML = `
                   <div style="font-size:0.8rem; color:#999; text-align:center; padding:8px; background:#f5f5f5; border-radius:8px;">
                       仅供查看 (ID: \${room.room_id})
                   </div>`
            }
            else {
                // 如果是 PLAYER
                if (room.is_joined === 1) {
                    btnHTML = `<button class="btn-lobby-action btn-joined" onclick="handleQuitRoom(event, '\${room.room_id}')">已加入 (退出)</button>`
                } else if (isFull) {
                    btnHTML = `<button class="btn-lobby-action btn-full" disabled>已满员</button>`
                } else {
                    btnHTML = `<button class="btn-lobby-action btn-join" onclick="handleJoinRoom(event, '\${room.room_id}', '\${room.title}', \${room.price})">
                    立即加入 (¥  \${room.price})
                    </button>`
                }
            }

            html += `
    <div class="lobby-card" onclick="openLobbyDetailModal('\${room.room_id}')">
        \${coverHTML}
        <div class="lobby-info">
            <div>
                <div class="lobby-title">《\${room.title}》</div>
                <div class="lobby-tags">\${tagsHTML}</div>
                <div style="font-size: 0.85rem; color: #666; margin-bottom: 4px;">
                    📅 \${timeStr} | ⏳ \${(room.duration_minutes/60).toFixed(1)}h
                </div>
                <div style="font-size: 0.85rem; color: #666;">
                    难度: \${'⭐'.repeat(room.difficulty)}
                </div>
            </div>

            <div>
                <div class="lobby-progress-row">
                    <div class="lobby-progress-bar">
                        <div class="lobby-progress-fill" style="width: \${progressPct}%;"></div>
                    </div>
                    <div style="font-size: 0.8rem; font-weight: bold; color: #FF9800;">
                        \${room.current_num} / \${room.max_num}
                    </div>
                </div>
                \${btnHTML}
            </div>
        </div>
    </div>
    `
        })
        container.innerHTML = html
    }

    //加入房间
    async function handleJoinRoom(event, roomId, title, price) {
        event.stopPropagation()
        if (!confirm(`【确认加入】\n\n剧本：《\${title}》\n费用：¥ \${price}\n\n加入后系统将暂时冻结这笔费用。\n是否确认加入？`)) {
            return
        }

        try {
            ShowCoveringLayer("正在加入...")
            let information={
                action: 'join_room',
                room_id: roomId
            }

            await request('Player',information)

            HiddenCoveringLayer()
            showToast("加入成功！", true)

            // 刷新大厅数据
            ShowOrganizingHall()

        } catch (e) {
            HiddenCoveringLayer();
            showToast(e, false);
        }
    }

    //退出房间
    async function handleQuitRoom(event, roomId) {
        event.stopPropagation()
        alert("请前往左侧菜单【我的行程】页面进行退车操作。\n那里可以查看到详细的订单编号。")
    }

    //Admin获取今天的剧本情况,将数据写入AdminTodayArrangement
    let AdminTodayArrangement
    async function AdminGetTodayArrangement(){
        try {
            let information={
                action: 'get_today_dashboard'
            }
            AdminTodayArrangement = await request('AdminRoom',information)
        }catch(error){
            showToast(error,false)
        }
    }

    //显示剧本库页面
    async function ShowScriptLibrary() {
        top_nav.innerHTML = ''
        setMenuHighLight('剧本库')
        ShowCoveringLayer("加载剧本库...")

        await getScriptData()

        let html = `
            <div class="header-container">
                <h2 style="font-size:1.5rem; color:#333; font-weight:bold;">剧本库</h2>
                <div class="AdminDashboard-header-actions">
                    <input type="text" class="AdminDashboard-search-bar"
                           placeholder="搜索剧本..." oninput="filterScriptList(this.value)" autocomplete="off">
                    <button class="AdminDashboard-menu-toggle" onclick="toggleMenu()">☰</button>
                </div>
            </div>

            <div class="AdminDashboard-main-content">
                <div id="ScriptListContainer" class="script-list-container">
                    </div>
            </div>

            <button class="fab-add-script" onclick="openManageScriptModal('add')">
                <span style="font-size:1.2rem;">+</span> 录入新剧本
            </button>
        `

        SPAContent.innerHTML = html
        renderScriptList(ScriptData.list)
        HiddenCoveringLayer()
    }

    //渲染列表
    function renderScriptList(dataList) {
        const container = document.getElementById('ScriptListContainer')
        if(!dataList || dataList.length === 0) {
            container.innerHTML = '<div style="text-align:center; color:#999; margin-top:50px;">暂无剧本数据</div>'
            return
        }

        let listHTML = ''
        dataList.forEach(s => {
            // 处理标签显示
            let tagsHTML = ''
            if(s.tag_list) {
                const tags = s.tag_list.split(/[,，\s]+/)
                tags.forEach(t => {
                    if(t) tagsHTML += `<span class="script-tag">\${t}</span>`
                });
            }

            // 处理封面：如果有url显示图片，没有显示紫色块
            let coverHTML = `<div class="script-cover-placeholder"></div>`
            if(s.cover_url && s.cover_url.trim() !== "") {
                coverHTML = `<img src="\${s.cover_url}" class="script-cover-img" alt="cover">`
            }

            const durationHours = (s.duration_minutes / 60).toFixed(1)

            listHTML += `
                <div class="script-item-card">
                    \${coverHTML}
                    <div class="script-info-main">
                        <div class="script-title-row">
                            <div class="script-title">《\${s.title}》</div>
                        </div>
                        <div class="script-tags-row">
                            \${tagsHTML}
                        </div>
                        <div class="script-meta-row">
                            \${s.player_count}人 | \${durationHours}小时 | 难度: \${s.difficulty}/5 | ¥ \${s.price}/人
                        </div>
                    </div>
                    <div class="script-actions">
                        <button class="btn-script-action" onclick="openManageScriptModal('edit', '\${s.id}')">编辑</button>
                        <button class="btn-script-action" style="color:#FF5252; border-color:#FF5252;" onclick="deleteScript('\${s.id}')">下架</button>
                    </div>
                </div>
            `
        })
        container.innerHTML = listHTML
    }

    //搜索过滤功能
    function filterScriptList(keyword) {
        if(!ScriptData || !ScriptData.list) return
        if(!keyword) {
            renderScriptList(ScriptData.list)
            return
        }
        const lowerKey = keyword.toLowerCase()
        const filtered = ScriptData.list.filter(s =>
            s.title.toLowerCase().includes(lowerKey) ||
            (s.tag_list && s.tag_list.toLowerCase().includes(lowerKey))
        )
        renderScriptList(filtered)
    }

    //剧本管理模态框 HTML
    function getManageScriptModalHTML() {
        return `
        <div class="modal-overlay" id="manageScriptModal" onclick="onOverlayClick(event)">
            <div class="modal-card" style="width: 650px;">
                <div class="modal-header" id="scriptModalTitle">录入新剧本</div>
                <input type="hidden" id="editScriptId">

                <div style="display: flex; gap: 20px;">
                    <div style="display:flex; flex-direction:column; align-items:center; gap:10px; width: 140px;">
                        <div id="scriptCoverPreview" style="width:120px; height:160px; background:#f0f0f0; border-radius:8px;
                                border:2px dashed #ddd; display:flex; align-items:center; justify-content:center;
                                background-size:cover; background-position:center; color:#999; font-size:0.8rem; overflow:hidden;">
                            无封面
                        </div>
                        <input type="file" id="scriptCoverInput" accept="image/*" style="display:none;" onchange="handleScriptCoverUpload(this)">
                        <input type="hidden" id="scriptCoverBase64">

                        <button type="button" onclick="document.getElementById('scriptCoverInput').click()"
                            style="font-size:0.85rem; padding:6px 12px; border-radius:6px; border:1px solid #ccc; background:white; cursor:pointer;">
                            上传封面
                        </button>
                        <div style="font-size:0.7rem; color:#999;">建议比例 3:4</div>
                    </div>

                    <div style="flex: 1;">
                        <div class="form-group">
                            <label class="form-label">剧本名称 (Title)</label>
                            <input type="text" id="scriptTitle" class="form-input" placeholder="如：古木吟">
                        </div>

                        <div class="content-split" style="display:grid; grid-template-columns: 1fr 1fr; gap:12px;">
                            <div class="form-group">
                                <label class="form-label">游戏人数</label>
                                <input type="number" id="scriptCount" class="form-input" placeholder="如：6">
                            </div>
                            <div class="form-group">
                                <label class="form-label">单人价格 (¥)</label>
                                <input type="number" id="scriptPrice" class="form-input" placeholder="如：128">
                            </div>
                        </div>

                        <div class="content-split" style="display:grid; grid-template-columns: 1fr 1fr; gap:12px;">
                            <div class="form-group">
                                <label class="form-label">时长 (分钟)</label>
                                <input type="number" id="scriptDuration" class="form-input" placeholder="4小时填 240">
                            </div>
                            <div class="form-group">
                                <label class="form-label">难度 (1-5)</label>
                                <select id="scriptDifficulty" class="form-select">
                                    <option value="1">1 - 新手</option>
                                    <option value="2">2 - 简单</option>
                                    <option value="3" selected>3 - 进阶</option>
                                    <option value="4">4 - 烧脑</option>
                                    <option value="5">5 - 硬核</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">标签 (空格分隔)</label>
                            <input type="text" id="scriptTags" class="form-input" placeholder="如：#古风 #情感">
                        </div>
                    </div>
                </div>

                <div class="form-group" style="margin-top: 10px;">
                    <label class="form-label">简介</label>
                    <textarea id="scriptDesc" class="form-input" rows="3" style="resize:none; font-family:inherit;"></textarea>
                </div>

                <div class="modal-actions">
                    <button class="btn-cancel" onclick="closeManageScriptModal()">取消</button>
                    <button class="btn-confirm" onclick="submitManageScript()">保存</button>
                </div>
            </div>
        </div>`
    }

    //剧本封面上传
    function handleScriptCoverUpload(input) {
        if (input.files && input.files[0]) {
            const file = input.files[0];
            if(file.size > 2 * 1024 * 1024) {
                showToast("封面图片太大，请小于 2MB", false)
                return
            }
            const reader = new FileReader()
            reader.onload = function(e) {
                // 存入隐藏域
                document.getElementById('scriptCoverBase64').value = e.target.result
                // 显示预览
                const preview = document.getElementById('scriptCoverPreview')
                preview.style.backgroundImage = 'url(' + e.target.result + ')'
                preview.innerHTML = '';
            }
            reader.readAsDataURL(file)
        }
    }

    //打开模态框
    function openManageScriptModal(mode, scriptId = null) {
        let modal = document.getElementById('manageScriptModal')
        if (!modal) {
            document.body.insertAdjacentHTML('beforeend', getManageScriptModalHTML());
            modal = document.getElementById('manageScriptModal')
        }

        const titleEl = document.getElementById('scriptModalTitle')
        const idEl = document.getElementById('editScriptId')

        // 获取图片相关元素
        const coverBase64 = document.getElementById('scriptCoverBase64')
        const coverPreview = document.getElementById('scriptCoverPreview')
        const coverInput = document.getElementById('scriptCoverInput')

        // 清空表单
        document.querySelectorAll('#manageScriptModal input, #manageScriptModal textarea').forEach(i => i.value = '')
        document.getElementById('scriptDifficulty').value = '3'

        // 重置图片预览
        coverPreview.style.backgroundImage = ''
        coverPreview.innerHTML = '无封面'
        coverInput.value = ''; // 清空文件选择

        if(mode === 'edit' && scriptId) {
            titleEl.innerText = "编辑剧本信息"
            idEl.value = scriptId

            const s = ScriptData.list.find(item => item.id == scriptId)
            if(s) {
                document.getElementById('scriptTitle').value = s.title
                document.getElementById('scriptCount').value = s.player_count
                document.getElementById('scriptPrice').value = s.price
                document.getElementById('scriptDuration').value = s.duration_minutes
                document.getElementById('scriptDifficulty').value = s.difficulty
                document.getElementById('scriptTags').value = s.tag_list || ''
                document.getElementById('scriptDesc').value = s.description || ''

                // --- 回显图片 ---
                if(s.cover_url && s.cover_url.trim() !== '') {
                    // 如果是相对路径，前端会自动解析
                    // 我们把旧的 url 也填进 base64 框里(作为标识)，或者后端判断逻辑里处理
                    // 这里为了简单，只做预览。用户不改图片，base64框就是空的。
                    coverBase64.value = s.cover_url
                    coverPreview.style.backgroundImage = `url(\${s.cover_url})`
                    coverPreview.innerHTML = ''
                }
            }
        } else {
            titleEl.innerText = "录入新剧本"
            idEl.value = ""
        }

        modal.style.display = 'flex'
        function temp(){
            modal.classList.add('show')
        }
        setTimeout(temp, 10)
    }

    //关闭模态框
    function closeManageScriptModal() {
        const modal = document.getElementById('manageScriptModal')
        if(!modal) return
        modal.classList.remove('show')
        setTimeout(() => modal.style.display = 'none', 300)
    }

    //提交保存
    async function submitManageScript() {
        const id = document.getElementById('editScriptId').value
        const action = id ? 'edit' : 'add'

        const payload = {
            action: action,
            id: id,
            title: document.getElementById('scriptTitle').value.trim(),
            player_count: parseInt(document.getElementById('scriptCount').value),
            price: parseFloat(document.getElementById('scriptPrice').value),
            duration_minutes: parseInt(document.getElementById('scriptDuration').value),
            difficulty: document.getElementById('scriptDifficulty').value,
            tag_list: document.getElementById('scriptTags').value.trim(),
            description: document.getElementById('scriptDesc').value.trim(),
            cover_url: document.getElementById('scriptCoverBase64').value
        }


        if(!payload.title || isNaN(payload.player_count) || isNaN(payload.price) || isNaN(payload.duration_minutes)) {
            showToast("请填写完整必填信息 (标题、人数、价格、时长)", false)
            return
        }

        if (payload.player_count < 1) {
            showToast("错误：游戏人数必须至少为 1 人", false)
            return
        }
        if (payload.price < 0) {
            showToast("错误：价格不能为负数", false)
            return
        }
        if (payload.duration_minutes <= 0) {
            showToast("错误：游戏时长必须大于 0 分钟", false)
            return
        }

        const tagPattern = /^([#＃][\u4e00-\u9fa5a-zA-Z0-9]+)(\s+[#＃][\u4e00-\u9fa5a-zA-Z0-9]+)*$/

        if (payload.tag_list && !tagPattern.test(payload.tag_list)) {
            showToast("标签格式错误！\n正确示例：#微恐 #情感 #古风\n(请确保使用空格分隔，且以#开头)", false)
            return
        }

        try {
            ShowCoveringLayer("正在保存...");

            const res = await request('AdminScript', payload)

            showToast("操作成功", true)
            closeManageScriptModal()

            // 刷新数据并重新渲染
            await getScriptData()
            ShowScriptLibrary()

        } catch(e) {
            HiddenCoveringLayer()
            showToast(e, false)
        }
    }

    //删除剧本
    async function deleteScript(id) {
        if(!confirm("确定要下架/删除该剧本吗？\n此操作不可恢复。")) return

        try {
            ShowCoveringLayer("正在删除...")
            let information={
                action: 'delete',
                id: id
            }
            await request('AdminScript',information)
            showToast("删除成功", true)
            // 刷新
            await getScriptData()
            ShowScriptLibrary()
        } catch(e) {
            HiddenCoveringLayer()
            showToast(e, false)
        }
    }

    // 当前选中的 Tab 和 筛选状态
    let ReportState = {
        currentTab: 'user_flow', // user_flow, store_finance, script_heat
        filterDate: 'MONTH',     // MONTH, ALL
        filterType: 'ALL'        // ALL, RECHARGE, PAYMENT, REFUND (仅对 user_flow 有效)
    }

    //显示财务页面框架
    function ShowFinancialReports() {
        top_nav.innerHTML = ''
        setMenuHighLight('财务与报表')
        ShowCoveringLayer("加载报表...")

        // 初始化页面结构
        SPAContent.innerHTML = `
            <div class="header-container">
                <h2 style="font-size:1.5rem; color:#333; font-weight:bold;">财务与报表 (Financial & Reports)</h2>
                <div class="AdminDashboard-header-actions">
                    <button class="AdminDashboard-menu-toggle" onclick="toggleMenu()">☰</button>
                </div>
            </div>

            <div class="AdminDashboard-main-content">
                <div style="display:flex; border-bottom:1px solid #ddd; margin-bottom:20px;">
                    <div class="report-tab active" id="tab_user_flow" onclick="switchReportTab('user_flow')">用户流水</div>
                    <div class="report-tab" id="tab_store_finance" onclick="switchReportTab('store_finance')">本店财务</div>
                    <div class="report-tab" id="tab_script_heat" onclick="switchReportTab('script_heat')">剧本热度</div>
                </div>

                <div style="display:flex; gap:15px; margin-bottom:20px; align-items:center; background:#f9f9f9; padding:12px; border-radius:12px;">
                    <div style="font-size:0.9rem; font-weight:bold; color:#555;">筛选条件:</div>

                    <select id="reportDateFilter" class="form-select" style="width:150px; padding:6px;" onchange="reloadReportData()">
                        <option value="MONTH">📅 本月数据</option>
                        <option value="ALL">🗓️ 全部历史</option>
                    </select>

                    <select id="reportTypeFilter" class="form-select" style="width:150px; padding:6px;" onchange="reloadReportData()">
                        <option value="ALL">💰 全部类型</option>
                        <option value="RECHARGE">📥 用户充值</option>
                        <option value="PAYMENT">📤 结算扣款</option>
                        <option value="REFUND">↩️ 跳车退款</option>
                    </select>

                    <button class="btn-confirm" style="margin-left:auto; padding:6px 20px; font-size:0.9rem; background:#3D4C6C;" onclick="exportReport()">
                        导出报表
                    </button>
                </div>

                <div id="ReportTableContainer" style="background:#fff; border-radius:16px; box-shadow:0 2px 8px rgba(0,0,0,0.05); overflow:hidden; min-height:300px;">
                    </div>
            </div>
        `

        // 注入 Tab 样式
        if (!document.getElementById('report-css-style')) {
            const style = document.createElement('style')
            style.id = 'report-css-style'
            style.innerHTML = `
                .report-tab {
                    padding: 12px 24px;
                    cursor: pointer;
                    font-weight: 600;
                    color: #888;
                    border-bottom: 3px solid transparent;
                    transition: all 0.2s;
                }
                .report-tab:hover { color: #3D77DD; background: #f0f7ff; }
                .report-tab.active {
                    color: #3D77DD;
                    border-bottom-color: #3D77DD;
                }
                .money-plus { color: #2E7D32; font-weight:bold; }
                .money-minus { color: #C62828; font-weight:bold; }
                .badge-gray { background:#eee; color:#666; padding:2px 8px; border-radius:4px; font-size:0.8rem; }
            `
            document.head.appendChild(style)
        }

        // 默认加载第一个 Tab
        switchReportTab('user_flow')
        HiddenCoveringLayer()
    }

    //Tab 切换逻辑
    function switchReportTab(tabName) {
        ReportState.currentTab = tabName

        // 更新 Tab 样式
        document.querySelectorAll('.report-tab').forEach(el => el.classList.remove('active'))
        document.getElementById('tab_' + tabName).classList.add('active')

        // 控制筛选器的显示/隐藏
        const typeFilter = document.getElementById('reportTypeFilter')
        const dateFilter = document.getElementById('reportDateFilter')

        if (tabName === 'user_flow') {
            typeFilter.style.display = 'block'
            dateFilter.style.display = 'block'
        } else if (tabName === 'store_finance') {
            typeFilter.style.display = 'none' // 本店财务默认只看 Payment
            dateFilter.style.display = 'block'
        } else if (tabName === 'script_heat') {
            typeFilter.style.display = 'none'
            dateFilter.style.display = 'none' // 热度榜强制看本月，简化逻辑
        }

        reloadReportData()
    }

    // 加载数据核心逻辑
    async function reloadReportData() {
        const container = document.getElementById('ReportTableContainer')
        container.innerHTML = '<div style="padding:40px; text-align:center; color:#999;">加载数据中...</div>'

        // 获取筛选值
        ReportState.filterDate = document.getElementById('reportDateFilter').value
        ReportState.filterType = document.getElementById('reportTypeFilter').value

        try {
            const res = await request('AdminFinance', {
                action: ReportState.currentTab,
                filter_date: ReportState.filterDate,
                filter_type: ReportState.filterType
            })

            if (!res.list || res.list.length === 0) {
                container.innerHTML = '<div style="padding:40px; text-align:center; color:#999;">暂无相关记录</div>'
                return;
            }

            // 根据不同 Tab 渲染不同表格
            if (ReportState.currentTab === 'user_flow') renderUserFlowTable(res.list)
            else if (ReportState.currentTab === 'store_finance') renderStoreFinanceTable(res.list)
            else if (ReportState.currentTab === 'script_heat') renderScriptHeatTable(res.list)

        } catch (e) {
            container.innerHTML = `<div style="padding:40px; text-align:center; color:red;">加载失败: \${e}</div>`
        }
    }

    // 格式日期的function
    function formatReportTime(timeVal) {
        if (!timeVal) return '-'

        // 情况1：如果是数字（时间戳），转成日期对象再拼接
        if (typeof timeVal === 'number') {
            const d = new Date(timeVal)
            const year = d.getFullYear()
            const month = String(d.getMonth() + 1).padStart(2, '0')
            const day = String(d.getDate()).padStart(2, '0')
            const hour = String(d.getHours()).padStart(2, '0')
            const minute = String(d.getMinutes()).padStart(2, '0')
            return `\${year}-\${month}-\${day} \${hour}:\${minute}`
        }

        // 情况2：如果是字符串，直接替换 T 即可
        if (typeof timeVal === 'string') {
            return timeVal.replace('T', ' ')
        }

        // 其他情况直接返回
        return timeVal;
    }

    // 用户流水表
    function renderUserFlowTable(list) {
        let html = `
            <div style="display:grid; grid-template-columns: 100px 160px 1fr 100px 120px 100px; padding:12px; background:#f1f5f9; font-weight:bold; color:#666;">
                <div>流水号</div>
                <div>时间</div>
                <div>用户</div>
                <div>类型</div>
                <div style="text-align:right;">变动金额</div>
                <div style="text-align:center;">状态</div>
            </div>
            <div style="max-height:600px; overflow-y:auto;">
        `
        list.forEach(item => {
            // 格式化金额颜色
            let moneyClass = item.amount >= 0 ? 'money-plus' : 'money-minus';
            let moneyStr = (item.amount >= 0 ? '+' : '') + parseFloat(item.amount).toFixed(2)

            let typeBadge = '';
            if(item.type === 'RECHARGE') typeBadge = '<span style="color:#2E7D32;">充值</span>'
            else if(item.type === 'PAYMENT') typeBadge = '<span style="color:#C62828;">扣款</span>'
            else if(item.type === 'REFUND') typeBadge = '<span style="color:#FF9800;">退款</span>'
            else typeBadge = item.type;

            let timeStr = formatReportTime(item.create_time)

            html += `
                <div style="display:grid; grid-template-columns: 100px 160px 1fr 100px 120px 100px; padding:12px; border-bottom:1px solid #eee; align-items:center; font-size:0.9rem;">
                    <div style="color:#999;">#\${item.id}</div>
                    <div>\${timeStr}</div>
                    <div style="font-weight:bold; color:#333;">\${item.username || '未知'}</div>
                    <div>\${typeBadge}</div>
                    <div class="\${moneyClass}" style="text-align:right;">¥ \${moneyStr}</div>
                    <div style="text-align:center;"><span class="badge-gray">已完成</span></div>
                </div>
            `;
        });
        html += '</div>';
        document.getElementById('ReportTableContainer').innerHTML = html
    }

    function renderStoreFinanceTable(list) {
        let html = `
            <div style="display:grid; grid-template-columns: 100px 160px 1fr 1fr 120px; padding:12px; background:#f1f5f9; font-weight:bold; color:#666;">
                <div>流水号</div>
                <div>入账时间</div>
                <div>来源 (剧本/房间)</div>
                <div>用户</div>
                <div style="text-align:right;">营收金额</div>
            </div>
            <div style="max-height:600px; overflow-y:auto;">
        `;

        list.forEach(item => {
            // 使用 formatReportTime 处理时间
            let timeStr = formatReportTime(item.create_time);

            html += `
                <div style="display:grid; grid-template-columns: 100px 160px 1fr 1fr 120px; padding:12px; border-bottom:1px solid #eee; align-items:center; font-size:0.9rem;">
                    <div style="color:#999;">#\${item.id}</div>
                    <div>\${timeStr}</div>
                    <div>
                        <span style="font-weight:bold; color:#3D77DD;">《\${item.script_title}》</span>
                    </div>
                    <div>\${item.username || '匿名'}</div>
                    <div class="money-plus" style="text-align:right;">+ ¥ \${item.revenue.toFixed(2)}</div>
                </div>
            `
        });
        html += '</div>';
        document.getElementById('ReportTableContainer').innerHTML = html;
    }

    //剧本热度表
    function renderScriptHeatTable(list) {
        let html = `
            <div style="display:grid; grid-template-columns: 60px 2fr 100px 120px 150px; padding:12px; background:#f1f5f9; font-weight:bold; color:#666;">
                <div>排名</div>
                <div>剧本信息</div>
                <div style="text-align:center;">平均评分</div>
                <div style="text-align:center;">本月开局</div>
                <div style="text-align:right;">本月收入</div>
            </div>
            <div style="max-height:600px; overflow-y:auto;">
        `

        list.forEach((item, index) => {
            // 前三名加重显示
            let rankStyle = index < 3 ? 'background:#FFC107; color:#fff; border-radius:50%; width:24px; height:24px; display:flex; align-items:center; justify-content:center;' : 'color:#999; padding-left:8px;';

            html += `
                <div style="display:grid; grid-template-columns: 60px 2fr 100px 120px 150px; padding:16px; border-bottom:1px solid #eee; align-items:center; font-size:0.95rem;">
                    <div><div style="\${rankStyle}">\${index + 1}</div></div>
                    <div style="font-weight:bold; font-size:1.1rem; color:#333;">《\${item.title}》</div>
                    <div style="text-align:center; font-weight:bold; color:#3D77DD;">\${item.avg_score} <span style="font-size:0.8rem;color:#ccc;">/5.0</span></div>
                    <div style="text-align:center;">\${item.play_count} 场</div>
                    <div style="text-align:right; font-weight:bold; color:#333;">¥ \${parseFloat(item.total_income).toFixed(2)}</div>
                </div>
            `
        });
        html += '</div>';
        document.getElementById('ReportTableContainer').innerHTML = html
    }

    //导出功能
    function exportReport() {
        //获取当前筛选状态
        const tab = ReportState.currentTab
        const dateFilter = ReportState.filterDate
        const typeFilter = ReportState.filterType

        //界面反馈
        showToast("正在请求下载...", true)

        //拼接 URL
        const baseUrl = "${pageContext.request.contextPath}/AdminFinance"
        const queryParams = `?action=export_report&tab=\${tab}&filter_date=\${dateFilter}&filter_type=\${typeFilter}`

        //下载
        window.location.href = baseUrl + queryParams
    }


    //我的行程
    async function ShowMySchedule() {
        clearWeb()
        setMenuHighLight('我的行程')
        ShowCoveringLayer("加载行程...")

        //页面
        SPAContent.innerHTML = `
            <div class="header-container">
                <h2 style="font-size:1.5rem; color:#333; font-weight:bold;">我的行程 (My Session)</h2>
                <div class="AdminDashboard-header-actions">
                    <button class="AdminDashboard-menu-toggle" onclick="toggleMenu()">☰</button>
                </div>
            </div>

            <div class="AdminDashboard-main-content">
                <div class="schedule-tabs">
                    <div class="schedule-tab active" id="tab_pending" onclick="switchSessionTab('pending')">待开始</div>
                    <div class="schedule-tab" id="tab_history" onclick="switchSessionTab('history')">历史战绩</div>
                </div>

                <div id="PendingContainer"></div>

                <div id="HistoryContainer" style="display:none;"></div>
            </div>
        `

        //加载数据
        try {
            let information={
                action: 'get_my_bookings'
            }
            const res = await request('Player',information)
            MySessionData = res.list || []

            //渲染两个列表
            renderPendingList()
            renderHistoryList()

            HiddenCoveringLayer()
        } catch (e) {
            HiddenCoveringLayer()
            showToast("加载失败: " + e, false)
            document.getElementById('PendingContainer').innerHTML = '<div style="padding:20px; color:red;">无法加载数据</div>'
        }
    }

    // 切换 Tab
    function switchSessionTab(tabName) {
        CurrentSessionTab = tabName;
        // 样式切换
        document.querySelectorAll('.schedule-tab').forEach(el => el.classList.remove('active'))
        document.getElementById('tab_' + tabName).classList.add('active')

        // 容器显隐
        if (tabName === 'pending') {
            document.getElementById('PendingContainer').style.display = 'block'
            document.getElementById('HistoryContainer').style.display = 'none'
        } else {
            document.getElementById('PendingContainer').style.display = 'none'
            document.getElementById('HistoryContainer').style.display = 'block'
        }
    }

    //“待开始”列表 (WAITING, LOCKED, PLAYING)
    function renderPendingList() {
        const container = document.getElementById('PendingContainer')
        const list = MySessionData.filter(item => ['WAITING', 'LOCKED', 'PLAYING'].includes(item.room_status))

        if (list.length === 0) {
            container.innerHTML = '<div style="text-align:center; padding:60px; color:#999;">暂无待开始的行程，快去组局大厅看看吧~</div>'
            return;
        }

        let html = '';
        list.forEach(item => {
            const timeStr = formatSessionTime(item.start_time, item.end_time);
            const coverSrc = item.cover_url ? (item.cover_url.startsWith('http') ? item.cover_url : `${pageContext.request.contextPath}/\${item.cover_url}`) : ''

            let statusHTML = ''
            let actionBtn = ''

            if (item.room_status === 'WAITING') {
                const pct = (item.current_num / item.max_num) * 100;
                statusHTML = `
                    <div style="background:#E0E0E0; border-radius:20px; height:30px; width:140px; position:relative; overflow:hidden; display:flex; align-items:center;">
                        <div style="background:#FFC107; height:100%; width: \${pct} %;"></div>
                        <div style="position:absolute; width:100%; text-align:center; color:#fff; font-weight:bold; text-shadow:0 1px 2px rgba(0,0,0,0.3); font-size:0.85rem;">
                            \${item.current_num}/\${item.max_num} 人
                        </div>
                    </div>
                    <span style="margin-left:10px; color:#666; font-size:0.85rem; font-weight:bold;">WAITING (拼车中)</span>
                `
                actionBtn = `
                    <button class="btn-action-outline btn-cancel-red" onclick="handleCancelBooking('\${item.booking_id}', '\${item.title}')">
                        取消预约 (跳车)
                    </button>
                    <div style="font-size:0.7rem; color:#666; margin-top:5px; text-align:center;">当前取消扣除 10 信誉分</div>
                `
            } else if (item.room_status === 'LOCKED') {
                statusHTML = `<span class="status-pill status-locked">LOCKED (待开局)</span>`
                actionBtn = `<div style="background:#eee; padding:8px 16px; border-radius:20px; color:#666; font-size:0.85rem;">已锁车，请准时到店</div>`
            } else if (item.room_status === 'PLAYING') {
                statusHTML = `<span class="status-pill status-finished" style="background:#E3F2FD; color:#1565C0;">PLAYING (游戏中)</span>`
                actionBtn = `<div style="color:#1565C0; font-size:0.85rem; font-weight:bold;">正在游戏，祝您体验愉快!</div>`
            }

            let tagsHTML = ''
            if (item.tag_list) item.tag_list.split(/[,，\s]+/).forEach(t => { if(t) tagsHTML += `<span class="session-tag">\${t}</span>`; })

            html += `
            <div class="session-card">
                <img src="\${coverSrc}" class="session-cover" onerror="this.style.backgroundColor='#6200EE';this.src='';">
                <div class="session-info">
                    <div>
                        <div class="session-title">《\${item.title}》</div>
                        <div style="margin-bottom:8px;">\${tagsHTML}</div>
                        <div class="session-meta">
                            <div><span class="session-icon">📅</span> \${timeStr}</div>
                            <div><span class="session-icon">💰</span> ¥ \${item.price}/人</div>

                            <div><span class="session-icon" style="width:auto;">主持人</span> : \${item.dm_name || '待指派'}</div>
                        </div>
                    </div>
                    <div class="session-status-row">
                        <div style="flex:1; display:flex; align-items:center;">\${statusHTML}</div>
                        <div style="display:flex; flex-direction:column; align-items:flex-end;">
                            \${actionBtn}
                        </div>
                    </div>
                </div>
            </div>`
        })
        container.innerHTML = html
    }

    //“历史战绩”列表 (FINISHED)
    function renderHistoryList() {
        const container = document.getElementById('HistoryContainer')
        const list = MySessionData.filter(item => item.room_status === 'FINISHED')

        if (list.length === 0) {
            container.innerHTML = '<div style="text-align:center; padding:60px; color:#999;">暂无历史战绩</div>'
            return;
        }

        let html = ''
        list.forEach(item => {
            const timeStr = formatSessionTime(item.start_time, item.end_time);
            const coverSrc = item.cover_url ? (item.cover_url.startsWith('http') ? item.cover_url : `${pageContext.request.contextPath}/\${item.cover_url}`) : '';

            let reviewBtn = ''
            if (item.is_reviewed > 0) {
                reviewBtn = `<button class="btn-action-outline btn-view-gray" onclick="viewMyReview('\${item.room_id}', '\${item.title}')">查看评价</button>`;
            } else {
                reviewBtn = `<button class="btn-action-outline btn-rate-blue" onclick="openReviewModal('\${item.room_id}', '\${item.title}', '\${item.dm_name||'DM'}')">去评价</button>`;
            }

            html += `
            <div class="session-card">
                <img src="\${coverSrc}" class="session-cover" onerror="this.style.backgroundColor='#6200EE';this.src='';">
                <div class="session-info">
                    <div>
                        <div class="session-title">《\${item.title}》</div>
                        <div class="session-meta">
                            <div><span class="session-icon">📅</span> 结束时间: \${safeDateFormat(item.end_time)}</div>

                            <div><span class="session-icon" style="width:auto;">主持人</span> : \${item.dm_name || '未知'}</div>
                        </div>
                    </div>
                    <div class="session-status-row">
                        <div style="flex:1;">
                            <span class="status-pill status-finished">FINISHED (已结算)</span>
                        </div>
                        <div>\${reviewBtn}</div>
                    </div>
                </div>
            </div>`
        })
        container.innerHTML = html
    }

    // 取消预约 (跳车)
    async function handleCancelBooking(bookingId, scriptTitle) {
        if (!confirm(`【严重警告】\n\n您确定要退出《\${scriptTitle}》的车队吗？\n\n⚠️ 跳车将扣除 10 信誉分！\n信誉分过低将无法加入热门车队。\n\n点击[确定]继续跳车，点击[取消]保留车位。`)) {
            return
        }

        try {
            ShowCoveringLayer("正在处理退款...")
            let information={
                action: 'cancel_booking',
                booking_id: bookingId
            }
            await request('Player',information)
            HiddenCoveringLayer()
            showToast("已取消预约，信誉分已扣除", true)
            // 刷新列表
            ShowMySchedule()
        } catch (e) {
            HiddenCoveringLayer();
            showToast("跳车失败: " + e, false)
        }
    }


    //评价弹窗 HTML
    function getReviewModalHTML() {
        return `
        <div class="modal-overlay" id="reviewModal" onclick="onOverlayClick(event)">
            <div class="modal-card" style="width: 450px;">
                <div class="modal-header">游戏评价 (Review)</div>
                <input type="hidden" id="reviewRoomId">
                <div style="margin-bottom:15px; font-size:0.9rem; color:#666;" id="reviewTargetText"></div>

                <div style="margin-bottom:15px;">
                    <label class="form-label">剧本体验</label>
                    <div class="rating-group" id="scriptStarGroup">
                        <span class="star-btn" onclick="setStar('script', 1)">★</span>
                        <span class="star-btn" onclick="setStar('script', 2)">★</span>
                        <span class="star-btn" onclick="setStar('script', 3)">★</span>
                        <span class="star-btn" onclick="setStar('script', 4)">★</span>
                        <span class="star-btn" onclick="setStar('script', 5)">★</span>
                        <span style="font-size:0.9rem; color:#FFC107; font-weight:bold;" id="scriptScoreText">0分</span>
                    </div>
                    <input type="hidden" id="scriptScoreVal" value="0">
                </div>

                <div style="margin-bottom:15px;">
                    <label class="form-label">DM 服务</label>
                    <div class="rating-group" id="dmStarGroup">
                        <span class="star-btn" onclick="setStar('dm', 1)">★</span>
                        <span class="star-btn" onclick="setStar('dm', 2)">★</span>
                        <span class="star-btn" onclick="setStar('dm', 3)">★</span>
                        <span class="star-btn" onclick="setStar('dm', 4)">★</span>
                        <span class="star-btn" onclick="setStar('dm', 5)">★</span>
                        <span style="font-size:0.9rem; color:#FFC107; font-weight:bold;" id="dmScoreText">0分</span>
                    </div>
                    <input type="hidden" id="dmScoreVal" value="0">
                </div>

                <div class="form-group">
                    <label class="form-label">详细评价</label>
                    <textarea id="reviewContent" class="form-input" rows="3" placeholder="剧情怎么样？DM带得好吗？..."></textarea>
                </div>

                <div class="modal-actions">
                    <button class="btn-cancel" onclick="closeReviewModal()">取消</button>
                    <button class="btn-confirm" onclick="submitReview()">提交评价</button>
                </div>
            </div>
        </div>`;
    }

    //评价弹窗
    function openReviewModal(roomId, title, dmName) {
        let modal = document.getElementById('reviewModal')
        if (!modal) {
            document.body.insertAdjacentHTML('beforeend', getReviewModalHTML())
            modal = document.getElementById('reviewModal')
        }

        document.getElementById('reviewRoomId').value = roomId
        document.getElementById('reviewTargetText').innerText = `评测对象：《\${title}》 | DM：\${dmName}`
        document.getElementById('reviewContent').value = ''
        setStar('script', 0);
        setStar('dm', 0);

        // 启用提交按钮（以防查看详情时被禁用了）
        document.querySelector('#reviewModal .btn-confirm').style.display = 'block'
        document.querySelector('#reviewModal .btn-cancel').innerText = '取消'
        document.querySelector('#reviewModal .modal-header').innerText = '游戏评价'
        document.getElementById('reviewContent').readOnly = false

        modal.style.display = 'flex'
        function temp(){
            modal.classList.add('show')
        }
        setTimeout(temp, 10)
    }

    //星级点击逻辑
    function setStar(type, score) {
        const group = document.getElementById(type + 'StarGroup')
        const input = document.getElementById(type + 'ScoreVal')
        const text = document.getElementById(type + 'ScoreText')
        const stars = group.querySelectorAll('.star-btn')

        input.value = score;
        text.innerText = score + "分"

        stars.forEach((star, index) => {
            if (index < score) star.classList.add('active')
            else star.classList.remove('active')
        });
    }

    //提交评价
    async function submitReview() {
        const roomId = document.getElementById('reviewRoomId').value
        const scriptScore = document.getElementById('scriptScoreVal').value
        const dmScore = document.getElementById('dmScoreVal').value
        const content = document.getElementById('reviewContent').value

        if (scriptScore == 0 || dmScore == 0) {
            showToast("请先完成打分", false)
            return
        }

        try {
            ShowCoveringLayer("提交中...")
            let information={
                action: 'submit_review',
                room_id: roomId,
                script_score: parseInt(scriptScore),
                dm_score: parseInt(dmScore),
                content: content
            }
            await request('Player',inforamtion)
            HiddenCoveringLayer()
            showToast("评价成功！感谢您的反馈", true)
            closeReviewModal()
            ShowMySchedule() // 刷新列表，按钮变“查看”
        } catch (e) {
            HiddenCoveringLayer()
            showToast(e, false)
        }
    }

    //查看我的评价,只读
    async function viewMyReview(roomId, title) {
        try {
            ShowCoveringLayer("加载评价...")
            let information={
                action: 'get_review',
                room_id: roomId
            }
            const res = await request('Player',information)
            HiddenCoveringLayer()

            if(res.data) {
                //设为只读
                let modal = document.getElementById('reviewModal');
                if (!modal) {
                    document.body.insertAdjacentHTML('beforeend', getReviewModalHTML())
                    modal = document.getElementById('reviewModal')
                }

                document.getElementById('reviewTargetText').innerText = `历史评价：《\${title}》`
                setStar('script', res.data.script_score)
                setStar('dm', res.data.dm_score)
                document.getElementById('reviewContent').value = res.data.content || '（未填写文字评论）'
                document.getElementById('reviewContent').readOnly = true

                // 隐藏提交按钮
                document.querySelector('#reviewModal .btn-confirm').style.display = 'none'
                document.querySelector('#reviewModal .btn-cancel').innerText = '关闭'
                document.querySelector('#reviewModal .modal-header').innerText = '我的评价详情'
                modal.style.display = 'flex'
                function temp(){
                    modal.classList.add('show')
                }
                setTimeout(temp, 10)
            }
        } catch(e) {
            HiddenCoveringLayer()
            showToast("获取失败", false)
        }
    }

    // 关闭评价的模态框
    function closeReviewModal() {
        const modal = document.getElementById('reviewModal');
        if (modal) {
            modal.classList.remove('show')
            function temp(){
                modal.style.display = 'none'
            }
            setTimeout(temp, 300)
        }
    }

    // 辅助：时间格式化 (显示为 "今日 15:00-19:00" 或 "01-12 15:00")
    function formatSessionTime(startStr, endStr) {
        const start = new Date(startStr)
        const end = new Date(endStr)
        const now = new Date()

        const isToday = (start.getDate() === now.getDate() && start.getMonth() === now.getMonth())
        const isTomorrow = (start.getDate() === now.getDate()+1 && start.getMonth() === now.getMonth())

        let datePart = ''
        if(isToday) datePart = '今日'
        else if(isTomorrow) datePart = '明日'
        else datePart = (start.getMonth()+1) + '月' + start.getDate() + '日'

        const timePart = String(start.getHours()).padStart(2,'0') + ':' + String(start.getMinutes()).padStart(2,'0') +
            '-' + String(end.getHours()).padStart(2,'0') + ':' + String(end.getMinutes()).padStart(2,'0')

        return datePart + ' ' + timePart
    }

    //  DM 工作台
    function renderWorkbench(data, selectedDateStr) {
        var upcoming = data.upcoming
        var list = data.today_list || []
        var now = new Date()

        // 解析选中日期
        var dateParts = selectedDateStr.split('-')
        var selectedYear = parseInt(dateParts[0])
        var selectedMonth = parseInt(dateParts[1])
        var selectedDay = parseInt(dateParts[2])
        var dateShowStr = selectedYear + '年' + selectedMonth + '月' + selectedDay + '日'

        var leftColHTML = '';

        //标题区
        leftColHTML += `
            <div style="margin-bottom: 24px; display:flex; align-items:center; justify-content:space-between;">
                <div>
                    <h2 style="font-size: 1.6rem; font-weight: 800; color: #1a1a1a; margin-bottom: 4px; letter-spacing: -0.5px;">DM工作台</h2>
                    <div style="color: #666; font-size: 0.95rem;">📅 当前查看: \${dateShowStr}</div>
                </div>
            </div>
        `

        //卡片 (最急单)
        if (upcoming) {
            // 时间处理
            var startTimeObj;
            if (typeof upcoming.start_time === 'number') startTimeObj = new Date(upcoming.start_time);
            else startTimeObj = new Date(upcoming.start_time.toString().replace(/-/g, "/").replace("T", " "));

            var diffMs = startTimeObj - now;
            var diffMins = Math.floor(diffMs / 60000);

            var timeBadge = '';
            if(upcoming.status === 'PLAYING') timeBadge = `<span style="background:#E8F5E9; color:#2E7D32; padding:4px 8px; border-radius:6px; font-size:0.85rem; font-weight:bold;">进行中</span>`;
            else if (diffMins > 0) timeBadge = `<span style="background:#FFF3E0; color:#E65100; padding:4px 8px; border-radius:6px; font-size:0.85rem; font-weight:bold;">还有 \${diffMins} 分钟</span>`;
            else timeBadge = `<span style="background:#FFEBEE; color:#C62828; padding:4px 8px; border-radius:6px; font-size:0.85rem; font-weight:bold;">已超时 \${Math.abs(diffMins)} 分钟</span>`;

            var showTime = String(startTimeObj.getHours()).padStart(2, '0') + ':' + String(startTimeObj.getMinutes()).padStart(2, '0');

            var heroBtn = '';
            if (upcoming.status === 'PLAYING') {
                heroBtn = `<button class="dm-start-btn" style="background:#FF5252; box-shadow: 0 4px 12px rgba(255, 82, 82, 0.3);" onclick="FinishGame('\${upcoming.room_id}')">结束游戏</button>`;
            } else if (upcoming.current_num >= upcoming.max_num || upcoming.status === 'LOCKED') {
                heroBtn = `<button class="dm-start-btn" onclick="StartGame('\${upcoming.room_id}')">开始游戏</button>`;
            } else {
                heroBtn = `<button class="dm-start-btn" style="background:#fff; color:#888; border:1px solid #ddd; box-shadow:none; cursor:default;">等待拼满</button>`;
            }

            leftColHTML += `
                <div class="dm-hero-card">
                    <div style="display:flex; justify-content:space-between; align-items:start;">
                        <div>
                            <div style="font-size:0.9rem; font-weight:bold; color:#B78900; margin-bottom:8px; text-transform:uppercase;">Urgent Mission</div>
                            <div style="font-size:1.5rem; font-weight:bold; color:#483C08; margin-bottom:4px;">《\${upcoming.title}》</div>
                            <div style="font-size:1rem; color:#6D5D22; margin-bottom:16px;">房间号 #\${upcoming.room_id} <span style="opacity:0.5">|</span> \${showTime}</div>
                            <div style="display:flex; gap:10px;">
                                \${timeBadge}
                                <span style="background:rgba(255,255,255,0.6); padding:4px 10px; border-radius:6px; font-size:0.85rem; font-weight:bold; color:#555;">
                                    \${upcoming.current_num} / \${upcoming.player_count} 人
                                </span>
                            </div>
                        </div>
                        <div style="align-self: flex-end;">
                             \${heroBtn}
                        </div>
                    </div>
                </div>
            `
        } else {
            leftColHTML += `
                <div class="dm-hero-card" style="background:#F5F5F5; box-shadow:none; border:1px dashed #ddd; text-align:center; padding:30px;">
                    <div style="font-size:2rem; margin-bottom:10px;">☕</div>
                    <div style="color:#999; font-weight:500;">当前无急需处理的开局场次</div>
                </div>
            `
        }

        //列表区域
        leftColHTML += `<div style="font-size:1.1rem; font-weight:bold; color:#333; margin-bottom:16px; margin-top:30px; display:flex; align-items:center; gap:8px;">
            <span style="display:inline-block; width:4px; height:16px; background:#333; border-radius:2px;"></span>
            排班列表 (Schedule List)
        </div>`

        if (list.length > 0) {
            var listHTML = list.map(function(item) {
                var start = safeTimeOnly(item.start_time);
                var end = safeTimeOnly(item.end_time);
                var actionBtn = '';
                var statusHTML = '';

                // 状态样式统一化
                if (item.status === 'FINISHED') {
                    statusHTML = `<span style="background:#eee; color:#999; padding:4px 10px; border-radius:20px; font-size:0.8rem; font-weight:bold;">已结束</span>`;
                    actionBtn = `<button class="room-action-btn" style="color:#ccc; border:none; background:none; cursor:default;">无需操作</button>`;
                }
                else if (item.status === 'PLAYING') {
                    statusHTML = `<span style="background:#E8F5E9; color:#2E7D32; padding:4px 10px; border-radius:20px; font-size:0.8rem; font-weight:bold;">● 游戏中</span>`;
                    actionBtn = `<button class="room-action-btn" style="background:#FFEBEE; color:#D32F2F; border:none;" onclick="FinishGame('\${item.id}')">结束</button>`;
                }
                else if (item.current_num >= item.max_num || item.status === 'LOCKED') {
                    statusHTML = `<span style="background:#FFF3E0; color:#E65100; padding:4px 10px; border-radius:20px; font-size:0.8rem; font-weight:bold;">待开局</span>`;
                    actionBtn = `<button class="room-action-btn btn-rate-blue" style="padding:6px 16px; font-size:0.85rem;" onclick="StartGame('\${item.id}')">开始</button>`;
                }
                else {
                    statusHTML = `<span style="background:#E3F2FD; color:#1565C0; padding:4px 10px; border-radius:20px; font-size:0.8rem; font-weight:bold;">拼车中 \${item.current_num}/\${item.max_num}</span>`;
                    actionBtn = `<button class="room-action-btn" onclick="showToast('房间 #\${item.id} 正在等待拼满...', true)">查看</button>`;
                }

                return `
                    <div class="dm-schedule-card-modern">
                        <div class="dm-indicator-bar"></div>

                        <div style="flex:1;">
                            <div style="font-size:1.15rem; font-weight:bold; color:#333; margin-bottom:4px;">《\${item.title}》</div>
                            <div style="display:flex; align-items:center; gap:10px;">
                                <div style="font-size:0.95rem; color:#666; font-family:var(--font-mono, monospace);">\${start} - \${end}</div>
                                <div style="height:12px; width:1px; background:#ddd;"></div>
                                \${statusHTML}
                            </div>
                        </div>

                        <div style="padding-left:16px;">
                            \${actionBtn}
                        </div>
                    </div>
                `
            }).join('')
            leftColHTML += listHTML;
        } else {
            leftColHTML += `
                <div style="text-align:center; padding:40px; background:#fff; border-radius:16px; border:1px dashed #e0e0e0; color:#999;">
                    <img src="${pageContext.request.contextPath}/resources/svg/Information_bad.svg" style="width:40px; opacity:0.2; margin-bottom:10px;">
                    <div>该日期暂无您的排班</div>
                </div>`
        }

        // 右侧构建
        var rightColHTML = '';
        var calendarContent = generateInteractiveCalendar(selectedDateStr)

        var introTitle = upcoming ? `《\${upcoming.title}》` : '暂无剧本'
        var introContent = upcoming ? (upcoming.description || "暂无详细描述...") : '请先选择一个待开始的场次查看简介。'
        // 剧本封面
        var coverImg = (upcoming && upcoming.cover_url) ?
            (upcoming.cover_url.startsWith('http') ? upcoming.cover_url : `${pageContext.request.contextPath}/\${upcoming.cover_url}`) : '';
        var coverDisplay = coverImg ? `<img src="\${coverImg}" style="width:100%; height:140px; object-fit:cover; border-radius:12px; margin-bottom:12px;">` : '';


        rightColHTML += `
            <div class="dm-calendar-box">
                <div style="font-weight:bold; font-size:1.1rem; margin-bottom:20px; color:#333;">我的日历 (Calendar)</div>
                \${calendarContent}
            </div>

            <div class="dm-shortcut-box">
                \${coverDisplay}
                <div style="font-weight:bold; font-size:1.1rem; margin-bottom:8px; color:#333;">
                    \${introTitle} <span style="font-size:0.8rem; color:#999; font-weight:normal;">背景提要</span>
                </div>
                <div style="font-size:0.9rem; color:#666; line-height:1.6; max-height:200px; overflow-y:auto; padding-right:5px; text-align:justify;">
                    \${introContent}
                </div>
            </div>
        `

        var pageHTML = `
            <div class="AdminDashboard-main-content">
                <div class="AdminDashboard-content-split">
                    <div>\${leftColHTML}</div>
                    <div>\${rightColHTML}</div>
                </div>
            </div>
        `
        SPAContent.innerHTML = pageHTML
    }

    //日历生成函数
    function generateInteractiveCalendar(selectedDateStr) {
        var now = new Date()
        var selected = new Date(selectedDateStr)

        var year = now.getFullYear()
        var month = now.getMonth()
        var today = now.getDate()
        var firstDay = new Date(year, month, 1).getDay()
        var daysInMonth = new Date(year, month + 1, 0).getDate()

        var html = '<table class="dm-cal-table" style="width:100%;">'
        html += '<thead class="dm-cal-header"><tr>'
        var weeks = ['日', '一', '二', '三', '四', '五', '六']
        for (var w = 0; w < weeks.length; w++) {
            html += '<th style="padding-bottom:12px; color:#999; font-size:0.8rem;">' + weeks[w] + '</th>'
        }
        html += '</tr></thead><tbody><tr>'

        for (var i = 0; i < firstDay; i++) {
            html += '<td></td>'
        }

        for (var d = 1; d <= daysInMonth; d++) {
            var cellDateStr = year + '-' + String(month + 1).padStart(2, '0') + '-' + String(d).padStart(2, '0')

            var cellClass = 'dm-cal-cell' // 基础样式

            // 判断是否是选中
            if (selectedDateStr === cellDateStr) {
                cellClass += ' dm-cal-active-day' // 蓝色方块
            }
            // 判断是否是今天 (且没被选中时显示小蓝点)
            else if (d === today) {
                cellClass += ' dm-cal-today-dot';
            }

            html += '<td onclick="switchDMDate(\'' + cellDateStr + '\')" style="text-align:center; cursor:pointer;">'
            html += '<div class="' + cellClass + '" style="margin:0 auto; display:flex; align-items:center; justify-content:center;">' + d + '</div>'
            html += '</td>'

            if ((firstDay + d) % 7 === 0) {
                html += '</tr><tr>'
            }
        }

        var remainingCells = (7 - (firstDay + daysInMonth) % 7) % 7
        if (remainingCells !== 0 && remainingCells !== 7) {
            for (var j = 0; j < remainingCells; j++) {
                html += '<td></td>'
            }
        }
        html += '</tr></tbody></table>'
        return html;
    }

    // 日历点击响应
    function switchDMDate(dateStr) {
        ShowDMDashboard(dateStr);
    }

    // 个人中心
    async function ShowUserProfile() {
        clearWeb()
        setMenuHighLight('个人中心')
        ShowCoveringLayer("加载个人信息...")

        try {
            // 并发请求
            const [profileRes, logsRes] = await Promise.all([
                request('Player', { action: 'get_profile_info' }),
                request('Player', { action: 'get_wallet_logs' })
            ])
            const user = profileRes.data
            const logs = logsRes.list || []

            //准备数据
            const avatarSrc = user.avatar_url ?
                (user.avatar_url.startsWith('http') ? user.avatar_url : `${pageContext.request.contextPath}/\${user.avatar_url}`) :
                ''

            let joinDate = '未知'
            if (user.created_at) {
                if (typeof user.created_at === 'string') {
                    // 如果是字符串，直接截取
                    joinDate = user.created_at.substring(0, 10);
                } else {
                    // 如果是数字(时间戳)或对象，转换成 YYYY-MM-DD
                    const d = new Date(user.created_at);
                    const y = d.getFullYear();
                    const m = (d.getMonth() + 1).toString().padStart(2, '0');
                    const day = d.getDate().toString().padStart(2, '0');
                    joinDate = y + '-' + m + '-' + day
                }
            }

            // 信誉分颜色逻辑
            let ringColor = '#4CAF50'; // 绿色
            if (user.reputation_score < 60) ringColor = '#FF5252'; // 红色
            else if (user.reputation_score < 80) ringColor = '#FFC107'; // 黄色
            const ringPercent = user.reputation_score + '%';

            SPAContent.innerHTML = `
            <div class="header-container">
                <h2 style="font-size:1.5rem; color:#333; font-weight:bold;">个人中心 (Profile & Wallet)</h2>
                <button class="AdminDashboard-menu-toggle" onclick="toggleMenu()">☰</button>
            </div>

            <div class="AdminDashboard-main-content" style="height: auto; overflow: visible;">

                <div class="profile-grid">
                    <div class="profile-card">
                        <img src="\${avatarSrc}" class="profile-avatar-large" onerror="this.style.backgroundColor='#ccc';this.src='';"
                             id="profileAvatarDisplay">
                        <div class="profile-name">\${user.username}</div>
                        <div class="profile-meta">
                            ID: #\${user.id} |
                            <span style="background:#E3F2FD; color:#1565C0; padding:2px 6px; border-radius:4px; font-size:0.75rem;">PLAYER</span>
                        </div>
                        <div class="profile-meta" style="margin-top:-10px;">
                            📅 注册时间: \${joinDate}
                        </div>
                        <button class="btn-action-outline btn-rate-blue" style="width:140px;"
                                onclick="openEditProfileModal('\${user.id}', '\${user.username}')">
                            ✏️ 编辑资料
                        </button>
                    </div>

                    <div style="display:grid; grid-template-rows: 1fr 1fr; gap:20px;">

                        <div class="profile-card" style="align-items:flex-start; text-align:left; padding-left:30px;">
                            <div style="color:#888; font-weight:bold;">我的钱包 (My Wallet)</div>
                            <div class="wallet-balance-huge">¥ \${user.balance}</div>

                            <div class="wallet-frozen">冻结中: ¥ \${user.frozen_balance}</div>
                            <button class="btn-confirm" style="width:100%; margin-top:auto;"
                                    onclick="openRechargeModal()">
                                💳 立即充值
                            </button>
                        </div>

                        <div class="profile-card" style="flex-direction:row; justify-content:space-around;">
                            <div style="text-align:left;">
                                <div style="font-size:1.1rem; font-weight:bold; margin-bottom:5px;">我的信誉</div>

                                <div style="color:#666; font-size:0.9rem; max-width:120px;">
                                    信誉分影响热门车队加入，跳车将扣分。
                                </div>

                            </div>
                            <div class="reputation-ring" style="--ring-color:\${ringColor}; --percent:\${ringPercent};">
                                <div class="reputation-value">\${user.reputation_score}</div>
                            </div>

                        </div>
                    </div>
                </div>

                <div style="background:#fff;
                     border-radius:20px; padding:20px; box-shadow:0 4px 12px rgba(0,0,0,0.03);">
                    <div style="font-size:1.1rem;
                         font-weight:bold; margin-bottom:15px; color:#333;">最近资金变动 (Recent Transactions)</div>
                    <div style="overflow-x:auto;">
                        <table class="log-table">
                            <thead>
                                <tr>
                                    <th>时间</th>
                                    <th>类型</th>
                                    <th>金额</th>
                                    <th>说明</th>
                                </tr>
                            </thead>
                            <tbody id="walletLogBody">
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            `

            // 流水列表
            const logBody = document.getElementById('walletLogBody')
            if (logs.length === 0)
            {
                logBody.innerHTML = '<tr><td colspan="4" style="text-align:center; padding:30px; color:#999;">暂无资金记录</td></tr>'
            } else {
                logBody.innerHTML = logs.map(log => {
                    let time = '-';
                    if (log.create_time) {
                        if (typeof log.create_time === 'string') {
                            time = log.create_time.replace('T', ' ');
                        } else {
                            // 如果是时间戳，手动格式化为 yyyy-MM-dd HH:mm
                            const d = new Date(log.create_time);
                            const y = d.getFullYear();
                            const m = (d.getMonth() + 1).toString().padStart(2, '0');
                            const day = d.getDate().toString().padStart(2, '0');
                            const h = d.getHours().toString().padStart(2, '0');
                            const min = d.getMinutes().toString().padStart(2, '0');
                            time = `\${y}-\${m}-\${day} \${h}:\${min}`;
                        }
                    }

                    let moneyStyle = log.amount >= 0 ?
                        'color:#2E7D32; font-weight:bold;' : 'color:#C62828; font-weight:bold;'
                    let amountStr = (log.amount >= 0 ? '+' : '') + parseFloat(log.amount).toFixed(2)
                    let typeText = log.type
                    if(typeText === 'RECHARGE') typeText = '充值'
                    else if(typeText === 'PAYMENT') typeText = '支付/冻结'
                    else if(typeText === 'REFUND') typeText = '退款'

                    return `
                        <tr>
                            <td>\${time}</td>
                            <td>\${typeText}</td>
                            <td style="\${moneyStyle}">\${amountStr}</td>
                            <td>\${log.description || '-'}</td>
                        </tr>
                    `
                }).join('')
            }
            HiddenCoveringLayer()
        } catch (e) {
            HiddenCoveringLayer()
            showToast("加载失败: " + e, false);
            SPAContent.innerHTML = `<div style="text-align:center; padding:50px; color:red;">加载失败，请重试</div>`
        }
    }

    //充值
    function getRechargeModalHTML() {
        return `
        <div class="modal-overlay" id="rechargeModal" onclick="onOverlayClick(event)">
            <div class="modal-card" style="width:360px;">
                <div class="modal-header">账户充值 (Recharge)</div>
                <div class="form-group">
                    <label class="form-label">充值金额 (¥)</label>
                    <input type="number" id="rechargeAmount" class="form-input" placeholder="请输入金额，如 100">
                </div>
                <div class="modal-actions">
                    <button class="btn-cancel" onclick="closeRechargeModal()">取消</button>
                    <button class="btn-confirm" onclick="submitRecharge()">确认支付</button>
                </div>
            </div>
        </div>`
    }

    // 打开充值的模态框
    function openRechargeModal() {
        if (!document.getElementById('rechargeModal')) {
            document.body.insertAdjacentHTML('beforeend', getRechargeModalHTML())
        }
        document.getElementById('rechargeAmount').value = ''
        const modal = document.getElementById('rechargeModal')
        modal.style.display = 'flex'
        function temp(){
            modal.classList.add('show')
        }
        setTimeout(temp, 10)
    }

    // 关闭模态框
    function closeRechargeModal() {
        const modal = document.getElementById('rechargeModal')
        if(modal) {
            modal.classList.remove('show')
            function temp(){
                modal.style.display='none'
            }
            setTimeout(temp , 300)
        }
    }

    // 提交
    async function submitRecharge() {
        const amount = document.getElementById('rechargeAmount').value
        if (!amount || amount <= 0) {
            showToast("请输入有效的金额", false)
            return
        }

        try {
            ShowCoveringLayer("充值处理中...")
            let information={
                action: 'recharge',
                amount: parseFloat(amount)
            }
            await request('Player',information)
            HiddenCoveringLayer()
            showToast("充值成功！", true)
            closeRechargeModal()
            ShowUserProfile() // 刷新页面
        } catch (e) {
            HiddenCoveringLayer()
            showToast("充值失败: " + e, false)
        }
    }

    //编辑资料功能
    function getEditProfileModalHTML() {
        return `
        <div class="modal-overlay" id="editProfileModal" onclick="onOverlayClick(event)">
            <div class="modal-card" style="width: 400px;">
                <div class="modal-header">编辑个人资料</div>

                <div style="display:flex; flex-direction:column; align-items:center; margin-bottom:20px;">
                    <div id="editAvatarPreview" style="width:80px; height:80px; border-radius:50%; background:#eee; background-size:cover; background-position:center; border:2px solid #ddd; margin-bottom:10px;"></div>
                    <button class="room-action-btn" onclick="document.getElementById('editAvatarInput').click()">更换头像</button>
                    <input type="file" id="editAvatarInput" accept="image/*" style="display:none;" onchange="handleEditAvatar(this)">
                    <input type="hidden" id="editAvatarBase64">
                </div>

                <div class="form-group">
                    <label class="form-label">用户名</label>
                    <input type="text" id="editUsername" class="form-input input-readonly" readonly title="用户名不可修改">
                </div>

                <div class="form-group">
                    <label class="form-label">新密码 (可选)</label>
                    <input type="password" id="editPassword" class="form-input" placeholder="不修改请留空">
                </div>

                <div class="modal-actions">
                    <button class="btn-cancel" onclick="closeEditProfileModal()">取消</button>
                    <button class="btn-confirm" onclick="submitEditProfile()">保存修改</button>
                </div>
            </div>
        </div>`
    }

    // 上传头像
    function handleEditAvatar(input) {
        if (input.files && input.files[0]) {
            const file = input.files[0]
            if(file.size > 2 * 1024 * 1024) {
                showToast("图片太大，请小于2MB", false)
                return
            }
            const reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById('editAvatarBase64').value = e.target.result
                document.getElementById('editAvatarPreview').style.backgroundImage = 'url(' + e.target.result + ')'
            }
            reader.readAsDataURL(file)
        }
    }

    // 打开编辑个人数据的模态框
    function openEditProfileModal(userId, username) {
        if (!document.getElementById('editProfileModal')) {
            document.body.insertAdjacentHTML('beforeend', getEditProfileModalHTML())
        }

        //初始化数据
        document.getElementById('editUsername').value = username
        document.getElementById('editPassword').value = ''
        document.getElementById('editAvatarBase64').value = ''

        //尝试获取当前头像并显示
        const currentAvatarSrc = document.getElementById('profileAvatarDisplay').src
        document.getElementById('editAvatarPreview').style.backgroundImage = 'url(' + currentAvatarSrc + ')'

        const modal = document.getElementById('editProfileModal')
        modal.style.display = 'flex'
        function temp(){
            modal.classList.add('show')
        }
        setTimeout(temp, 10)
    }

    // 关闭个人页面编辑
    function closeEditProfileModal() {
        const modal = document.getElementById('editProfileModal')
        if(modal) {
            modal.classList.remove('show')
            function temp(){
                modal.style.display='none'
            }
            setTimeout(temp, 300)
        }
    }

    // 提交
    async function submitEditProfile() {
        const password = document.getElementById('editPassword').value
        const avatarBase64 = document.getElementById('editAvatarBase64').value

        if (!password && !avatarBase64) {
            showToast("未做任何修改", false)
            return
        }

        try {
            ShowCoveringLayer("保存中...")
            let information={
                action: 'update_profile',
                password: password,
                avatar_url: avatarBase64
            }
            await request('Player',information)
            HiddenCoveringLayer()
            showToast("资料修改成功", true)
            closeEditProfileModal()
            ShowUserProfile()
        } catch (e) {
            HiddenCoveringLayer()
            showToast(e, false)
        }
    }

    const originalOverlayClick = window.onOverlayClick;

    //组局大厅详情弹窗
    function getLobbyDetailModalHTML() {
        return `
    <div class="modal-overlay" id="lobbyDetailModal" onclick="onOverlayClick(event)">
        <div class="modal-card" style="width: 800px; max-width: 95%;">
            <div class="modal-header" style="border-bottom:1px solid #eee; padding-bottom:10px; display:flex; justify-content:space-between; align-items:center;">
                <div>剧本详情：<span style="color:#3D77DD; font-weight:bold;" id="ldTitle"></span></div>
                <div style="font-size:0.8rem; color:#999;" id="ldRoomId"></div>
            </div>

            <div class="dm-read-modal-body">
                <div class="dm-read-sidebar">
                    <img id="ldCover" class="dm-read-cover" src="" onerror="this.style.backgroundColor='#eee';this.src='';">

                    <div style="text-align:left; width:100%;">
                        <div style="font-weight:bold; margin-bottom:4px; color:#333;">基础信息</div>
                        <div style="font-size:0.9rem; color:#666; line-height:1.6;" id="ldMeta"></div>

                        <div style="font-weight:bold; margin-top:12px; margin-bottom:4px; color:#333;">标签</div>
                        <div style="font-size:0.9rem; color:#666;" id="ldTags"></div>
                    </div>
                </div>

                <div class="dm-read-content-box">
                    <div style="font-weight:bold; margin-bottom:10px; color:#333;">📖 故事背景：</div>
                    <div id="ldDesc" style="white-space: pre-wrap; font-size:0.95rem; color:#444;"></div>
                </div>
            </div>

            <div class="modal-actions" style="justify-content: space-between; align-items: center; border-top: 1px solid #eee; padding-top: 15px; margin-top: 0;">
                <div style="font-size:0.85rem; color:#888;" id="ldFooterTip"></div>
                <div style="display:flex; gap:10px;">
                    <button class="btn-cancel" onclick="closeLobbyDetailModal()">关闭</button>
                    <div id="ldJoinBtnContainer"></div>
                </div>
            </div>
        </div>
    </div>`
    }

    //打开详情弹窗
    function openLobbyDetailModal(roomId) {
        let modal = document.getElementById('lobbyDetailModal')
        if (!modal) {
            document.body.insertAdjacentHTML('beforeend', getLobbyDetailModalHTML())
            modal = document.getElementById('lobbyDetailModal')
        }

        const room = LobbyDataList.find(r => r.room_id == roomId)
        if (!room) return;

        document.getElementById('ldTitle').innerText = `《\${room.title}》`
        document.getElementById('ldRoomId').innerText = `房间号 #\${room.room_id}`

        let coverSrc = ''
        if (room.cover_url) {
            coverSrc = room.cover_url.startsWith('http') ? room.cover_url : `${pageContext.request.contextPath}/\${room.cover_url}`
        }
        document.getElementById('ldCover').src = coverSrc

        document.getElementById('ldMeta').innerHTML = `
        难度: \${'⭐'.repeat(room.difficulty)}<br>
        时长: \${(room.duration_minutes/60).toFixed(1)} 小时<br>
        价格: <span style="color:#FF9800; font-weight:bold;">¥ \${room.price}/人</span><br>
        人数: \${room.current_num} / \${room.max_num}
    `;

        document.getElementById('ldTags').innerText = room.tag_list || '无标签'

        const rawDesc = room.description || room.DESCRIPTION
        const desc = rawDesc ? rawDesc : "（暂无详细故事背景描述）"
        document.getElementById('ldDesc').innerText = desc

        const btnContainer = document.getElementById('ldJoinBtnContainer')
        const userRole = `${sessionScope.role}`

        if (userRole === 'DM' || userRole === 'ADMIN') {
            btnContainer.innerHTML = ''
            document.getElementById('ldFooterTip').innerText = '当前为管理员模式，仅供查看'
        } else {
            if (room.is_joined === 1) {
                btnContainer.innerHTML = `<button class="btn-lobby-action btn-joined" style="width:auto; padding:8px 24px;" disabled>已在车上</button>`
                document.getElementById('ldFooterTip').innerText = '您已加入该房间'
            } else if (room.current_num >= room.max_num) {
                btnContainer.innerHTML = `<button class="btn-lobby-action btn-full" style="width:auto; padding:8px 24px;" disabled>已满员</button>`
                document.getElementById('ldFooterTip').innerText = '手慢了，如下次有空位请留意'
            } else {
                btnContainer.innerHTML = `<button class="btn-lobby-action btn-join" style="width:auto; padding:8px 24px;"
                onclick="handleJoinRoom('\${room.room_id}', '\${room.title}', \${room.price}); closeLobbyDetailModal();">
                立即加入 (¥ \${room.price})
             </button>`
                document.getElementById('ldFooterTip').innerText = `加入将预冻结 ¥\${room.price}`
            }
        }
        modal.style.display = 'flex'
        function temp(){
            modal.classList.add('show')
        }
        setTimeout(temp, 10)
    }

    //关闭详情弹窗
    function closeLobbyDetailModal() {
        const modal = document.getElementById('lobbyDetailModal');
        if (modal) {
            modal.classList.remove('show');
            function temp(){
                modal.style.display = 'none'
            }
            setTimeout(temp , 300);
        }
    }

    //加载资料库
    async function loadDMScriptMaterialsPage() {
        clearWeb()
        setMenuHighLight('剧本资料')
        ShowCoveringLayer("加载资料库...")

        if (!ScriptData || !ScriptData.list) {
            await getScriptData()
        }

        //页面
        SPAContent.innerHTML = `
            <div class="header-container">
                <h2 style="font-size:1.5rem; color:#333; font-weight:bold;">剧本资料库 (Script Materials)</h2>
                <div class="AdminDashboard-header-actions">
                    <div style="position:relative;">
                        <span style="position:absolute; left:12px; top:10px; color:#999;">🔍</span>
                        <input type="text" id="dmMatSearch" class="AdminDashboard-search-bar"
                               style="padding-left: 36px; width: 220px;"
                               placeholder="搜索剧本名称..." oninput="filterDMMaterials()" autocomplete="off">
                    </div>
                    <button class="AdminDashboard-menu-toggle" onclick="toggleMenu()">☰</button>
                </div>
            </div>

            <div class="dm-materials-container">
                <div class="dm-materials-header">
                    <p>点击下方卡片，查看剧本详情、主持流程及背景故事。</p>
                </div>

                <div id="dmMaterialsGrid" class="dm-materials-grid">
                    </div>
            </div>
        `

        renderDMMaterialsList(ScriptData.list);
        HiddenCoveringLayer();
    }

    //前端过滤
    function filterDMMaterials() {
        const keyword = document.getElementById('dmMatSearch').value.toLowerCase()
        if (!ScriptData || !ScriptData.list) return

        const filtered = ScriptData.list.filter(s =>
            s.title.toLowerCase().includes(keyword) ||
            (s.tag_list && s.tag_list.toLowerCase().includes(keyword))
        )
        renderDMMaterialsList(filtered);
    }

    //卡片列表
    function renderDMMaterialsList(list) {
        const container = document.getElementById('dmMaterialsGrid')

        if (!list || list.length === 0) {
            container.innerHTML = '<div style="grid-column:1/-1; text-align:center; color:#999; padding:40px;">未找到相关剧本</div>'
            return
        }

        let html = ''
        list.forEach(s => {
            // 处理封面
            let coverSrc = '';
            if (s.cover_url && s.cover_url.trim() !== '') {
                coverSrc = s.cover_url.startsWith('http') ? s.cover_url : `${pageContext.request.contextPath}/\${s.cover_url}`
            }
            // 封面HTML：如果有图显示图，没图显示灰色占位
            const coverHTML = coverSrc ?
                `<img src="\${coverSrc}" class="dm-mat-cover-img" alt="\${s.title}">` :
                `<div style="width:100%; height:100%; display:flex; align-items:center; justify-content:center; color:#999;">无封面</div>`;

            // 处理标签 (取前3个)
            let tagsHTML = ''
            if (s.tag_list) {
                const tags = s.tag_list.split(/[,，\s]+/);
                tags.slice(0, 3).forEach(t => {
                    if(t) tagsHTML += `<span class="dm-mat-tag">\${t}</span>`
                })
            }

            // 整个卡片绑定 onclick
            html += `
            <div class="dm-material-card" onclick="openDMMaterialModal('\${s.id}')" title="点击阅读详情">
                <div class="dm-mat-cover-box">
                    \${coverHTML}
                </div>
                <div class="dm-mat-content">
                    <div class="dm-mat-title">《\${s.title}》</div>
                    <div class="dm-mat-meta-tags" style="margin-bottom:10px;">
                        \${tagsHTML}
                    </div>
                    <div style="font-size:0.85rem; color:#888;">
                        ⏱️ \${(s.duration_minutes/60).toFixed(1)}h | 👥 \${s.player_count}人 | 🔥 \${s.difficulty}星
                    </div>
                </div>
                <div style="background:#f5f5f5; padding:8px; text-align:center; color:#3D77DD; font-size:0.8rem; font-weight:bold; border-top:1px solid #eee;">
                    📖 点击阅读手册
                </div>
            </div>
            `
        })
        container.innerHTML = html
    }

    // 打开阅读模态框
    function openDMMaterialModal(scriptId) {
        const s = ScriptData.list.find(item => item.id == scriptId);
        if (!s) return;

        let coverSrc = ''
        if (s.cover_url) {
            coverSrc = s.cover_url.startsWith('http') ? s.cover_url : `${pageContext.request.contextPath}/\${s.cover_url}`
        }

        const descriptionContent = s.description ? s.description : "（该剧本暂无详细资料或电子版手册内容，请查阅线下纸质资料。）"

        const modalHTML = `
        <div class="modal-overlay" id="dmReadModal" onclick="onOverlayClick(event)">
            <div class="modal-card" style="width: 800px; max-width: 95%;">
                <div class="modal-header" style="border-bottom:1px solid #eee; padding-bottom:10px;">
                    剧本资料：<span style="color:#3D77DD;">《\${s.title}》</span>
                </div>

                <div class="dm-read-modal-body">
                    <div class="dm-read-sidebar">
                        <img src="\${coverSrc}" class="dm-read-cover" onerror="this.style.backgroundColor='#eee';this.src='';">
                        <div style="text-align:left; width:100%;">
                            <div style="font-weight:bold; margin-bottom:4px;">基本参数</div>
                            <div style="font-size:0.9rem; color:#666;">
                                人数: \${s.player_count}人<br>
                                时长: \${(s.duration_minutes/60).toFixed(1)}h<br>
                                难度: \${s.difficulty} / 5
                            </div>
                            <div style="font-weight:bold; margin-top:12px; margin-bottom:4px;">标签</div>
                            <div style="font-size:0.9rem; color:#666;">
                                \${s.tag_list || '无'}
                            </div>
                        </div>
                    </div>

                    <div class="dm-read-content-box">
                        <div style="font-weight:bold; margin-bottom:10px; color:#333;">📜 内容简介 / DM手册：</div>
                        \${descriptionContent}
                    </div>
                </div>

                <div class="modal-actions">
                    <button class="btn-cancel" onclick="closeDMMaterialModal()">关闭 (Close)</button>
                </div>
            </div>
        </div>`

        const oldModal = document.getElementById('dmReadModal')
        if (oldModal) oldModal.remove();

        document.body.insertAdjacentHTML('beforeend', modalHTML)

        const modal = document.getElementById('dmReadModal')
        modal.style.display = 'flex'
        function temp(){
            modal.classList.add('show')
        }
        setTimeout(temp, 10)
    }

    // 关闭阅读模态框
    function closeDMMaterialModal() {
        const modal = document.getElementById('dmReadModal');
        if (modal) {
            modal.classList.remove('show')
            function temp(){
                modal.remove()
            }
            setTimeout(temp, 300)
        }
    }

    //进行初始化，第一次进入必须进行，用于获取菜单，以及接下来要干的事
    async function Initialize() {
        ShowCoveringLayer("Load")
        let source;
        try {
            await getScriptData() // 必须先获取剧本数据
            source = await request('Auth', { action: 'initialize' })

            let tempHTML = ``
            if(source.list){
                for (let i = 0; i < source.list.length; i++) {
                    tempHTML += source.list[i];
                }
            }
            sidebar_menu.innerHTML = tempHTML;
            if (source.username) {
                sidebar_username.innerHTML = `
                    <span style="font-size: 1.2rem; margin-right: 8px;"></span>
                    \${source.username}
                `;
                sidebar_username.style.pointerEvents = 'none';
            }
            // 执行后端返回的指令 (例如: ShowAdminDashboard())
            if(source.ExecuteImmediately) eval(source.ExecuteImmediately);

            HiddenCoveringLayer() // 记得关闭遮罩
        } catch (error) {
            showToast(error, false)
            setTimeout(() => { Initialize() }, 10000)
        }
    }

    window.addEventListener('resize', function() {
        const searchInput = document.getElementById('userSearchInput');
        // 768px 是你 CSS 中定义的断点
        if (window.innerWidth <= 768 && searchInput && searchInput.value !== '') {
            searchInput.value = ''; // 清空值
            // 触发一次过滤逻辑，还原列表显示
            if(typeof filterUserList === 'function') {
                filterUserList();
            }
        }
    });

    Initialize()

</script>
</html>