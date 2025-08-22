// ==UserScript==
// @name         AI Studio→Claude Style（v2.6）
// @namespace    https://linux.do/u/unfair0/
// @version      2.6
// @description  Unfair0的Google ai studio仿Claude风格油猴插件
// @author       Unfair0
// @match        https://aistudio.google.com/*
// @grant        none
// @run-at       document-start
// ==/UserScript==

(function() {
    'use strict';

    // 图标名称映射表 - 无效图标 → 有效替代
    const ICON_REPLACEMENTS = {
        'incognito': 'visibility_off',
        'incognito_off': 'visibility_off',
        'temporary_chat': 'visibility_off',
        'private_mode': 'visibility_off',
        'guest_mode': 'person_off'
    };

    // 加载Material Icons字体
    function loadMaterialIcons() {
        const iconSources = [
            'https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200',
            'https://fonts.googleapis.com/icon?family=Material+Icons'
        ];

        iconSources.forEach((src, index) => {
            const linkId = `material-icons-${index}`;
            if (!document.querySelector(`#${linkId}`)) {
                const link = document.createElement('link');
                link.id = linkId;
                link.rel = 'stylesheet';
                link.href = src;
                link.crossOrigin = 'anonymous';
                document.head.appendChild(link);
            }
        });

        console.log('✅ Material Icons fonts loaded');
    }

    const claudeCSS = `
    /* ===== Claude Design System Variables ===== */
    :root {
        /* Color System */
        --claude-primary: #D97706;
        --claude-primary-hover: #B45309;
        --claude-primary-active: #92400E;
        --claude-primary-light: #FED7AA;
        --claude-primary-focus: rgba(217, 119, 6, 0.15);

        --claude-bg-primary: #FFFBF5;
        --claude-bg-secondary: #FEF7ED;
        --claude-bg-card: #FFFFFF;
        --claude-bg-nav: #fdf9f0;
        --claude-bg-divider: #F3E8DB;

        --claude-text-primary: #1F2937;
        --claude-text-secondary: #6B7280;
        --claude-text-muted: #9CA3AF;
        --claude-text-inverse: #FFFFFF;

        --claude-success: #059669;
        --claude-warning: #D97706;
        --claude-error: #DC2626;
        --claude-info: #2563EB;

        --claude-shadow: rgba(0, 0, 0, 0.08);
        --claude-shadow-hover: rgba(0, 0, 0, 0.12);
        --claude-hover-mask: rgba(0, 0, 0, 0.05);

        /* Typography */
        --claude-font-serif: 'Sitka Text', Georgia, 'Times New Roman', serif;
        --claude-font-sans: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
        --claude-font-code: 'Cascadia Code', Consolas, 'Courier New', monospace;

        /* Spacing */
        --claude-space-1: 4px;
        --claude-space-2: 8px;
        --claude-space-3: 12px;
        --claude-space-4: 16px;
        --claude-space-6: 24px;
        --claude-space-8: 32px;

        /* Radius */
        --claude-radius-sm: 6px;
        --claude-radius-md: 8px;
        --claude-radius-lg: 12px;
        --claude-radius-xl: 16px;

        /* Animation */
        --claude-duration-fast: 150ms;
        --claude-duration-normal: 300ms;
        --claude-ease: cubic-bezier(0.4, 0, 0.2, 1);
    }

    /* ===== 🎯 智能图标字体修复 ===== */

    /* Material Icons 基础样式 */
    .material-icons,
    .material-symbols-outlined:not(.broken-icon),
    .material-symbols-rounded,
    span.material-symbols-outlined.notranslate.ms-button-icon-symbol,
    span.material-symbols-outlined.notranslate.open-in-new[style*="Material"] {
        font-family: 'Material Symbols Outlined', 'Material Icons' !important;
        font-weight: normal !important;
        font-style: normal !important;
        font-size: 18px !important;
        line-height: 1 !important;
        letter-spacing: normal !important;
        text-transform: none !important;
        display: inline-block !important;
        white-space: nowrap !important;
        word-wrap: normal !important;
        direction: ltr !important;
        -webkit-font-feature-settings: 'liga' 1 !important;
        font-feature-settings: 'liga' 1 !important;
        -webkit-font-smoothing: antialiased !important;
        text-rendering: optimizeLegibility !important;
        vertical-align: middle !important;

        /* Material Symbols 变体设置 */
        font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24 !important;
    }

    /* 修复字体已是Material但显示为文字的元素 */
    .material-symbols-outlined.notranslate.ms-button-icon-symbol.ng-star-inserted[style*="Material Symbols Outlined"],
    span[class*="material-symbols-outlined"][style*="Material"] {
        font-family: 'Material Symbols Outlined', 'Material Icons' !important;
        -webkit-font-feature-settings: 'liga' 1 !important;
        font-feature-settings: 'liga' 1 !important;
        font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24 !important;
    }

    /* 特殊修复：右上角的 open_in_new 图标 */
    span.material-symbols-outlined.notranslate.open-in-new {
        font-family: 'Material Symbols Outlined' !important;
        -webkit-font-feature-settings: 'liga' 1 !important;
        font-feature-settings: 'liga' 1 !important;
    }

    /* 🛡️ 永久CSS修复：防止无效图标名显示为文字 */
    span.material-symbols-outlined.ms-button-icon-symbol[data-original-text="incognito"] {
        font-size: 0 !important;
    }

    span.material-symbols-outlined.ms-button-icon-symbol[data-original-text="incognito"]::before {
        content: "visibility_off" !important;
        font-family: "Material Symbols Outlined", "Material Icons" !important;
        font-size: 18px !important;
        font-weight: normal !important;
        display: inline-block !important;
        font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24 !important;
    }

    /* 加载动画图标 */
    .run-button.loading .material-symbols-outlined,
    .loading .material-symbols-outlined,
    [class*="loading"][class*="material"] {
        animation: claudeRotate 1s linear infinite !important;
    }

    @keyframes claudeRotate {
        from { transform: rotate(0deg); }
        to { transform: rotate(360deg); }
    }

    /* ===== Dark Theme Support ===== */
    .dark-theme {
        --claude-bg-primary: #1A1A1A;
        --claude-bg-secondary: #2A2A2A;
        --claude-bg-card: #333333;
        --claude-bg-nav: #222222;
        --claude-bg-divider: #404040;

        --claude-text-primary: #F5F5F5;
        --claude-text-secondary: #B8B8B8;
        --claude-text-muted: #888888;

        --claude-shadow: rgba(0, 0, 0, 0.3);
        --claude-shadow-hover: rgba(0, 0, 0, 0.4);
        --claude-hover-mask: rgba(255, 255, 255, 0.05);
    }

    /* ===== Global Base Styles ===== */
    body {
        background: var(--claude-bg-primary) !important;
        color: var(--claude-text-primary) !important;
        font-family: var(--claude-font-sans) !important;
        line-height: 1.6 !important;
        -webkit-font-smoothing: antialiased !important;
        text-rendering: optimizeLegibility !important;
    }

    /* ===== Main Container Styling ===== */
    .banner-and-app-container.v3-bg-enabled,
    .makersuite-layout,
    .layout-wrapper,
    .layout-main {
        background: var(--claude-bg-primary) !important;
    }

    section.chunk-editor-main.v3-bg-enabled {
        background: var(--claude-bg-primary) !important;
        border-radius: var(--claude-radius-xl) !important;
        box-shadow: 0 4px 20px var(--claude-shadow) !important;
        margin: var(--claude-space-6) !important;
        padding: var(--claude-space-8) !important;
        border: 1px solid var(--claude-bg-divider) !important;
    }

    .chat-container,
    .chat-view-container {
        background: transparent !important;
        border-radius: var(--claude-radius-lg) !important;
    }

    /* ===== 🎨 左侧边栏样式 ===== */

    /* 主侧边栏容器 */
    .sidenav,
    .side-nav,
    .navigation-panel,
    .nav-panel,
    nav[role="navigation"],
    .makersuite-sidenav,
    aside,
    .sidebar-container {
        background: var(--claude-bg-card) !important;
        border-right: 1px solid var(--claude-bg-divider) !important;
        box-shadow: 2px 0 8px var(--claude-shadow) !important;
    }

    /* 侧边栏内容区域 */
    .sidenav-content,
    .nav-content,
    .navigation-content {
        background: transparent !important;
        padding: var(--claude-space-4) var(--claude-space-3) !important;
    }

    /* 导航项容器 */
    .nav-item-wrapper,
    .nav-item-container {
        margin-bottom: var(--claude-space-1) !important;
    }

    /* 导航项基础样式 */
    .nav-item,
    a.nav-item,
    .nav-link,
    .sidebar-item {
        background: transparent !important;
        color: var(--claude-text-secondary) !important;
        border: none !important;
        border-radius: var(--claude-radius-md) !important;
        padding: var(--claude-space-3) var(--claude-space-4) !important;
        margin: var(--claude-space-1) 0 !important;
        font-family: var(--claude-font-sans) !important;
        font-size: 14px !important;
        font-weight: 500 !important;
        text-decoration: none !important;
        transition: all var(--claude-duration-fast) var(--claude-ease) !important;
        display: flex !important;
        align-items: center !important;
        gap: var(--claude-space-3) !important;
    }

    /* 导航项悬停效果 */
    .nav-item:hover,
    a.nav-item:hover,
    .nav-link:hover,
    .sidebar-item:hover {
        background: var(--claude-primary-focus) !important;
        color: var(--claude-primary) !important;
        transform: translateX(2px) !important;
        box-shadow: 0 2px 4px var(--claude-shadow) !important;
    }

    /* 激活/选中状态 */
    .nav-item.active,
    .nav-item.selected,
    .nav-item[aria-current="page"],
    a.nav-item.router-link-active,
    .nav-link.active,
    .sidebar-item.active {
        background: var(--claude-primary) !important;
        color: var(--claude-text-inverse) !important;
        font-weight: 600 !important;
        box-shadow: 0 2px 8px rgba(217, 119, 6, 0.3) !important;
    }

    .nav-item.active:hover,
    .nav-item.selected:hover,
    .nav-link.active:hover {
        background: var(--claude-primary-hover) !important;
        transform: translateX(3px) !important;
    }

    /* 导航图标 */
    .nav-item .material-symbols-outlined,
    .nav-item .material-icons,
    .nav-link .material-symbols-outlined,
    .sidebar-item .material-symbols-outlined {
        font-size: 20px !important;
        opacity: 0.8 !important;
    }

    .nav-item:hover .material-symbols-outlined,
    .nav-item.active .material-symbols-outlined,
    .nav-link:hover .material-symbols-outlined,
    .nav-link.active .material-symbols-outlined {
        opacity: 1 !important;
    }

    /* 侧边栏标题/分组 */
    .nav-section-title,
    .sidebar-section-title,
    .nav-group-title {
        color: var(--claude-text-muted) !important;
        font-size: 12px !important;
        font-weight: 600 !important;
        text-transform: uppercase !important;
        letter-spacing: 0.05em !important;
        margin: var(--claude-space-6) var(--claude-space-4) var(--claude-space-2) !important;
        padding: 0 !important;
    }

    /* 侧边栏分隔线 */
    .nav-divider,
    .sidebar-divider {
        border: none !important;
        height: 1px !important;
        background: var(--claude-bg-divider) !important;
        margin: var(--claude-space-4) var(--claude-space-3) !important;
    }

    /* ===== 🎨 顶部导航栏样式 - 由CSS变量控制 ===== */

    /* 主导航栏 */
    .header-container,
    .top-nav,
    .app-header,
    .makersuite-header,
    .main-header,
    ms-header-root {
        background: var(--claude-bg-nav) !important;
        background-image: none !important;
        border-bottom: 1px solid var(--claude-bg-divider) !important;
        box-shadow: 0 2px 8px var(--claude-shadow) !important;
        backdrop-filter: blur(12px) !important;
        -webkit-backdrop-filter: blur(12px) !important;
        z-index: 1000 !important;
        transition: background-color 0.3s ease !important;
    }

    /* 导航栏内容容器 */
    .header-content,
    .nav-toolbar,
    .header-inner {
        padding: var(--claude-space-3) var(--claude-space-6) !important;
        display: flex !important;
        align-items: center !important;
        justify-content: space-between !important;
    }

    /* 导航栏左侧（Logo区域） */
    .header-left,
    .nav-brand,
    .logo-container {
        display: flex !important;
        align-items: center !important;
        gap: var(--claude-space-4) !important;
    }

    /* 导航栏右侧（用户菜单等） */
    .header-right,
    .nav-actions,
    .user-menu-container {
        display: flex !important;
        align-items: center !important;
        gap: var(--claude-space-3) !important;
    }

    /* 导航栏按钮 */
    .header-button,
    .nav-button,
    .toolbar-button {
        background: transparent !important;
        border: 1px solid transparent !important;
        border-radius: var(--claude-radius-md) !important;
        padding: var(--claude-space-2) var(--claude-space-3) !important;
        color: var(--claude-text-secondary) !important;
        font-size: 14px !important;
        transition: all var(--claude-duration-fast) var(--claude-ease) !important;
    }

    .header-button:hover,
    .nav-button:hover,
    .toolbar-button:hover {
        background: var(--claude-hover-mask) !important;
        border-color: var(--claude-bg-divider) !important;
        color: var(--claude-primary) !important;
    }

    /* 用户头像/菜单 */
    .user-avatar,
    .profile-button,
    .account-button {
        width: 36px !important;
        height: 36px !important;
        border-radius: 50% !important;
        border: 2px solid var(--claude-bg-divider) !important;
        transition: all var(--claude-duration-fast) var(--claude-ease) !important;
    }

    .user-avatar:hover,
    .profile-button:hover,
    .account-button:hover {
        border-color: var(--claude-primary) !important;
        box-shadow: 0 0 0 3px var(--claude-primary-focus) !important;
    }

    /* ===== 🎨 面包屑导航 ===== */

    .breadcrumb,
    .breadcrumb-nav,
    .path-nav {
        background: var(--claude-bg-secondary) !important;
        border: 1px solid var(--claude-bg-divider) !important;
        border-radius: var(--claude-radius-md) !important;
        padding: var(--claude-space-2) var(--claude-space-4) !important;
        margin: var(--claude-space-3) 0 !important;
    }

    .breadcrumb-item,
    .breadcrumb-link {
        color: var(--claude-text-secondary) !important;
        text-decoration: none !important;
        font-size: 13px !important;
    }

    .breadcrumb-item:hover,
    .breadcrumb-link:hover {
        color: var(--claude-primary) !important;
    }

    .breadcrumb-item.active,
    .breadcrumb-item:last-child {
        color: var(--claude-text-primary) !important;
        font-weight: 500 !important;
    }

    .breadcrumb-separator {
        color: var(--claude-text-muted) !important;
        margin: 0 var(--claude-space-2) !important;
    }

    /* ===== Typography Enhancement ===== */
    .chat-container *:not(button):not([class*="material"]):not([class*="icon"]):not(mat-icon):not(.nav-item):not(.nav-item-wrapper),
    .promo-card *:not(button):not([class*="material"]):not([class*="icon"]):not(mat-icon),
    .zero-state *:not(button):not([class*="material"]):not([class*="icon"]):not(mat-icon),
    .input-placeholder *:not(button):not([class*="material"]):not([class*="icon"]):not(mat-icon) {
        font-family: var(--claude-font-serif) !important;
        letter-spacing: 0.01em !important;
        line-height: 1.7 !important;
    }

    .promo-card h1,
    .promo-card h2,
    .promo-card h3,
    .promo-card h4,
    .promo-card .mat-mdc-card-title,
    .promo-card .mat-mdc-card-content {
        font-family: var(--claude-font-serif) !important;
        font-weight: 500 !important;
        line-height: 1.5 !important;
    }

    button,
    .toolbar-container *,
    .header-container *,
    .settings-items-wrapper *,
    nav *:not(.nav-item):not(.nav-item-wrapper),
    [role="navigation"] *:not(.nav-item):not(.nav-item-wrapper),
    .mat-mdc-menu-panel *,
    input,
    select,
    textarea {
        font-family: var(--claude-font-sans) !important;
        letter-spacing: 0 !important;
    }

    code,
    pre,
    .code,
    [class*="code"],
    [class*="mono"] {
        font-family: var(--claude-font-code) !important;
        line-height: 1.5 !important;
    }

    /* ===== Button Styling ===== */
    button.ms-button-primary,
    .ms-button-large.ms-button-primary {
        background: var(--claude-primary) !important;
        color: var(--claude-text-inverse) !important;
        border: none !important;
        border-radius: var(--claude-radius-md) !important;
        padding: var(--claude-space-3) var(--claude-space-6) !important;
        font-weight: 500 !important;
        font-size: 14px !important;
        transition: all var(--claude-duration-fast) var(--claude-ease) !important;
        box-shadow: 0 2px 4px var(--claude-shadow) !important;
    }

    button.ms-button-primary:hover,
    .ms-button-large.ms-button-primary:hover {
        background: var(--claude-primary-hover) !important;
        transform: translateY(-1px) !important;
        box-shadow: 0 4px 8px var(--claude-shadow-hover) !important;
    }

    button.ms-button-primary:active,
    .ms-button-large.ms-button-primary:active {
        background: var(--claude-primary-active) !important;
        transform: translateY(0) !important;
    }

    button.ms-button-borderless,
    .ms-button-borderless {
        background: transparent !important;
        border: 1px solid var(--claude-bg-divider) !important;
        color: var(--claude-text-secondary) !important;
        border-radius: var(--claude-radius-md) !important;
        padding: var(--claude-space-2) var(--claude-space-4) !important;
        transition: all var(--claude-duration-fast) var(--claude-ease) !important;
    }

    button.ms-button-borderless:hover,
    .ms-button-borderless:hover {
        background: var(--claude-hover-mask) !important;
        border-color: var(--claude-primary) !important;
        color: var(--claude-primary) !important;
        transform: translateY(-1px) !important;
    }

    .ms-button-icon {
        border-radius: var(--claude-radius-sm) !important;
        width: 40px !important;
        height: 40px !important;
        display: flex !important;
        align-items: center !important;
        justify-content: center !important;
        min-width: 40px !important;
    }

    .run-button {
        background: var(--claude-primary) !important;
        color: var(--claude-text-inverse) !important;
        border: none !important;
        border-radius: var(--claude-radius-lg) !important;
        padding: var(--claude-space-4) var(--claude-space-8) !important;
        font-weight: 600 !important;
        font-size: 16px !important;
        min-height: 48px !important;
        box-shadow: 0 4px 12px var(--claude-shadow) !important;
    }

    .run-button:hover:not(.disabled) {
        background: var(--claude-primary-hover) !important;
        transform: translateY(-2px) !important;
        box-shadow: 0 8px 20px var(--claude-shadow-hover) !important;
    }

    .run-button.disabled {
        background: var(--claude-text-muted) !important;
        opacity: 0.5 !important;
        cursor: not-allowed !important;
    }

    /* ===== Card Styling ===== */
    .mat-mdc-card.promo-card {
        background: var(--claude-bg-card) !important;
        border: 1px solid var(--claude-bg-divider) !important;
        border-radius: var(--claude-radius-lg) !important;
        box-shadow: 0 2px 8px var(--claude-shadow) !important;
        transition: all var(--claude-duration-normal) var(--claude-ease) !important;
        padding: var(--claude-space-6) !important;
        margin: var(--claude-space-3) !important;
    }

    .mat-mdc-card.promo-card:hover {
        transform: translateY(-4px) !important;
        box-shadow: 0 8px 24px var(--claude-shadow-hover) !important;
        border-color: var(--claude-primary-light) !important;
    }

    /* ===== Toolbar ===== */
    .toolbar-container {
        background: var(--claude-bg-secondary) !important;
        border-radius: var(--claude-radius-md) !important;
        padding: var(--claude-space-3) var(--claude-space-4) !important;
        margin-bottom: var(--claude-space-4) !important;
        border: 1px solid var(--claude-bg-divider) !important;
    }

    /* ===== Input Areas ===== */
    .prompt-input-wrapper {
        border-radius: var(--claude-radius-lg) !important;
        border: 1px solid var(--claude-bg-divider) !important;
        background: var(--claude-bg-card) !important;
        box-shadow: 0 2px 8px var(--claude-shadow) !important;
        transition: all var(--claude-duration-fast) var(--claude-ease) !important;
    }

    .prompt-input-wrapper:focus-within {
        border-color: var(--claude-primary) !important;
        box-shadow: 0 0 0 3px var(--claude-primary-focus) !important;
    }

    /* ===== Side Panel ===== */
    .content-container.ng-tns-c3770797683-6 {
        background: var(--claude-bg-secondary) !important;
        border-left: 1px solid var(--claude-bg-divider) !important;
        border-radius: var(--claude-radius-lg) 0 0 var(--claude-radius-lg) !important;
    }

    .settings-items-wrapper {
        background: transparent !important;
    }

    .settings-item {
        border-radius: var(--claude-radius-sm) !important;
        margin-bottom: var(--claude-space-2) !important;
        padding: var(--claude-space-3) !important;
        transition: background-color var(--claude-duration-fast) var(--claude-ease) !important;
    }

    .settings-item:hover {
        background: var(--claude-hover-mask) !important;
    }

    /* ===== Menu & Dropdown ===== */
    .mat-mdc-menu-panel {
        background: var(--claude-bg-card) !important;
        border: 1px solid var(--claude-bg-divider) !important;
        border-radius: var(--claude-radius-md) !important;
        box-shadow: 0 8px 24px var(--claude-shadow-hover) !important;
        backdrop-filter: blur(12px) !important;
        -webkit-backdrop-filter: blur(12px) !important;
    }

    .mat-mdc-menu-item {
        color: var(--claude-text-primary) !important;
        transition: background-color var(--claude-duration-fast) var(--claude-ease) !important;
    }

    .mat-mdc-menu-item:hover {
        background: var(--claude-hover-mask) !important;
    }

    /* ===== 🎨 移动端适配 ===== */

    @media (max-width: 768px) {
        .sidenav,
        .sidebar-container {
            box-shadow: 4px 0 12px var(--claude-shadow) !important;
        }

        .nav-item,
        .nav-link,
        .sidebar-item {
            padding: var(--claude-space-4) var(--claude-space-3) !important;
            font-size: 15px !important;
        }

        .header-content,
        .nav-toolbar {
            padding: var(--claude-space-2) var(--claude-space-4) !important;
        }

        .header-button,
        .nav-button {
            padding: var(--claude-space-2) !important;
            min-width: 44px !important;
            min-height: 44px !important;
        }

        section.chunk-editor-main.v3-bg-enabled {
            margin: var(--claude-space-3) !important;
            padding: var(--claude-space-4) !important;
            border-radius: var(--claude-radius-md) !important;
        }

        .mat-mdc-card.promo-card {
            margin: var(--claude-space-2) !important;
            padding: var(--claude-space-4) !important;
        }

        .run-button {
            min-height: 44px !important;
            padding: var(--claude-space-3) var(--claude-space-6) !important;
            font-size: 15px !important;
        }
    }

    /* ===== 🎨 特殊状态样式 ===== */

    /* 侧边栏折叠状态 */
    .sidenav.collapsed .nav-item,
    .sidebar-container.collapsed .nav-item {
        justify-content: center !important;
        padding: var(--claude-space-3) !important;
    }

    .sidenav.collapsed .nav-item span:not(.material-symbols-outlined),
    .sidebar-container.collapsed .nav-item span:not(.material-symbols-outlined) {
        display: none !important;
    }

    /* 加载状态 */
    .nav-item.loading,
    .sidebar-item.loading {
        opacity: 0.6 !important;
        pointer-events: none !important;
    }

    .nav-item.loading .material-symbols-outlined {
        animation: claudeRotate 1s linear infinite !important;
    }

    /* 通知徽章 */
    .nav-item .badge,
    .sidebar-item .badge,
    .nav-item .notification-dot {
        background: var(--claude-error) !important;
        color: white !important;
        font-size: 11px !important;
        font-weight: 600 !important;
        border-radius: 10px !important;
        padding: 2px 6px !important;
        min-width: 18px !important;
        height: 18px !important;
        display: flex !important;
        align-items: center !important;
        justify-content: center !important;
        margin-left: auto !important;
    }

    /* ===== 🎨 动画增强 ===== */

    .nav-item,
    .nav-link,
    .sidebar-item,
    .header-button {
        position: relative !important;
        overflow: hidden !important;
    }

    .nav-item::before,
    .nav-link::before,
    .sidebar-item::before {
        content: '' !important;
        position: absolute !important;
        top: 0 !important;
        left: -100% !important;
        width: 100% !important;
        height: 100% !important;
        background: linear-gradient(90deg, transparent, rgba(255,255,255,0.1), transparent) !important;
        transition: left 0.5s ease !important;
    }

    .nav-item:hover::before,
    .nav-link:hover::before,
    .sidebar-item:hover::before {
        left: 100% !important;
    }

    /* ===== Loading States ===== */
    .loading-spinner {
        border: 2px solid var(--claude-bg-divider) !important;
        border-top: 2px solid var(--claude-primary) !important;
        border-radius: 50% !important;
        width: 20px !important;
        height: 20px !important;
        animation: claudeRotate 1s linear infinite !important;
    }

    /* ===== Accessibility Enhancements ===== */
    .nav-item:focus,
    .nav-link:focus,
    button:focus {
        outline: 2px solid var(--claude-primary) !important;
        outline-offset: 2px !important;
    }

    .nav-item:focus:not(:focus-visible),
    .nav-link:focus:not(:focus-visible),
    button:focus:not(:focus-visible) {
        outline: none !important;
    }

    /* ===== High Contrast Mode ===== */
    @media (prefers-contrast: high) {
        :root {
            --claude-primary: #B45309;
            --claude-bg-divider: #666666;
            --claude-text-secondary: #333333;
            --claude-bg-nav: #f0f0f0;
        }
    }

    /* ===== Reduced Motion ===== */
    @media (prefers-reduced-motion: reduce) {
        * {
            animation-duration: 0.01ms !important;
            animation-iteration-count: 1 !important;
            transition-duration: 0.01ms !important;
            scroll-behavior: auto !important;
        }
    }

    /* ===== Print Styles ===== */
    @media print {
        .sidenav,
        .sidebar-container,
        .header-container,
        .toolbar-container,
        .run-button {
            display: none !important;
        }

        body {
            background: white !important;
            color: black !important;
        }

        .chat-container,
        .mat-mdc-card {
            background: white !important;
            box-shadow: none !important;
            border: 1px solid #ddd !important;
        }
    }
    `;

    // 注入CSS样式
    function injectStyles() {
        if (!document.querySelector('#claude-style-css')) {
            const styleElement = document.createElement('style');
            styleElement.id = 'claude-style-css';
            styleElement.textContent = claudeCSS;
            document.head.appendChild(styleElement);
            console.log('✅ Claude styles injected');
        }
    }

    // 智能图标修复 - 替换无效图标名
    function smartIconFix() {
        const allMaterialIcons = document.querySelectorAll('span.material-symbols-outlined');
        let fixedCount = 0;

        allMaterialIcons.forEach(el => {
            const iconName = el.textContent?.trim();
            if (iconName && ICON_REPLACEMENTS[iconName]) {
                const replacement = ICON_REPLACEMENTS[iconName];
                el.setAttribute('data-original-text', iconName);
                el.textContent = replacement;
                el.style.setProperty('font-family', '"Material Symbols Outlined", "Material Icons"', 'important');
                el.style.setProperty('font-variation-settings', '"FILL" 0, "wght" 400, "GRAD" 0, "opsz" 24', 'important');
                fixedCount++;
                console.log(`🔄 智能图标修复: "${iconName}" → "${replacement}"`);
            }
        });

        if (fixedCount > 0) {
            console.log(`✨ 智能修复完成，共修复 ${fixedCount} 个图标`);
        }
    }

    // 保守字体修复 - 只修复确定能工作的图标元素
    function conservativeIconFix() {
        // 修复宽度过大的图标（显示为文字的）
        const suspiciousIcons = Array.from(document.querySelectorAll('.material-symbols-outlined, .material-icons'))
            .filter(el => {
                if (!el.textContent?.trim()) return false;
                const rect = el.getBoundingClientRect();
                const width = Math.round(rect.width);
                return width > 30; // 可能是文字而非图标
            });

        suspiciousIcons.forEach(el => {
            const computedFont = getComputedStyle(el).fontFamily;
            if (!computedFont.includes('Material')) {
                el.style.setProperty('font-family', '"Material Symbols Outlined", "Material Icons"', 'important');
                el.style.setProperty('font-variation-settings', '"FILL" 0, "wght" 400, "GRAD" 0, "opsz" 24', 'important');
                console.log('🔧 保守字体修复:', el.textContent?.trim());
            }
        });

        // 修复特定的Material图标元素
        const specificSelectors = [
            'span.material-symbols-outlined.notranslate.ms-button-icon-symbol',
            'span.material-symbols-outlined.notranslate.open-in-new',
            '.ms-button-icon .material-symbols-outlined'
        ];

        specificSelectors.forEach(selector => {
            document.querySelectorAll(selector).forEach(el => {
                if (el.textContent?.trim()) {
                    el.style.setProperty('font-family', '"Material Symbols Outlined", "Material Icons"', 'important');
                    el.style.setProperty('font-variation-settings', '"FILL" 0, "wght" 400, "GRAD" 0, "opsz" 24', 'important');
                }
            });
        });
    }

    // 增强界面 - 添加动态监听
    function enhanceInterface() {
        console.log('🎨 开始增强界面...');

        // 初始修复
        setTimeout(() => {
            smartIconFix();
            conservativeIconFix();
        }, 500);

        // 设置动态观察器
        const observer = new MutationObserver((mutations) => {
            let shouldFix = false;

            mutations.forEach(mutation => {
                if (mutation.type === 'childList' && mutation.addedNodes.length > 0) {
                    mutation.addedNodes.forEach(node => {
                        if (node.nodeType === 1) { // Element node
                            const hasMaterialIcons = node.querySelectorAll &&
                                node.querySelectorAll('.material-symbols-outlined, .material-icons').length > 0;
                            const isMaterialIcon = node.classList &&
                                (node.classList.contains('material-symbols-outlined') || node.classList.contains('material-icons'));

                            if (hasMaterialIcons || isMaterialIcon) {
                                shouldFix = true;
                            }
                        }
                    });
                }
            });

            if (shouldFix) {
                // 延迟执行，等待DOM稳定
                setTimeout(() => {
                    // 检查新增的图标元素
                    const newIcons = document.querySelectorAll('.material-symbols-outlined, .material-icons');
                    newIcons.forEach(el => {
                        const iconName = el.textContent?.trim();
                        if (iconName && !el.getAttribute('data-checked')) {
                            el.setAttribute('data-checked', 'true');

                            if (ICON_REPLACEMENTS[iconName]) {
                                const replacement = ICON_REPLACEMENTS[iconName];
                                el.setAttribute('data-original-text', iconName);
                                el.textContent = replacement;
                                el.style.fontFamily = '"Material Symbols Outlined", "Material Icons"';
                                el.style.fontVariationSettings = '"FILL" 0, "wght" 400, "GRAD" 0, "opsz" 24';
                                console.log(`🔄 动态修复图标: "${iconName}" → "${replacement}"`);
                            } else {
                                // 对于其他Material Icons元素进行字体修复
                                const computedFont = getComputedStyle(el).fontFamily;
                                if (!computedFont.includes('Material')) {
                                    el.style.setProperty('font-family', 'Material Symbols Outlined', 'important');
                                    el.style.setProperty('font-variation-settings', '"FILL" 0, "wght" 400, "GRAD" 0, "opsz" 24', 'important');
                                }
                            }
                        }
                    });
                }, 100);
            }
        });

        observer.observe(document.body, {
            childList: true,
            subtree: true
        });

        console.log('✨ Claude Style with Smart Icon Fix Applied!');
    }

    // 调试工具
    window.claudeDebug = {
        checkIconStatus: () => {
            const allIcons = document.querySelectorAll('[class*="material"], [class*="icon"]');
            console.log(`Found ${allIcons.length} icon-related elements:`);

            const working = [];
            const broken = [];
            const replaced = [];

            allIcons.forEach(icon => {
                const text = icon.textContent?.trim();
                const font = getComputedStyle(icon).fontFamily;
                const isMaterial = font.includes('Material');
                const originalText = icon.getAttribute('data-original-text');

                if (text && text.length > 0) {
                    const iconInfo = {
                        element: icon,
                        text,
                        font,
                        originalText,
                        width: Math.round(icon.getBoundingClientRect().width)
                    };

                    if (originalText) {
                        replaced.push(iconInfo);
                    } else if (isMaterial && iconInfo.width <= 30) {
                        working.push(iconInfo);
                    } else if (iconInfo.width > 30) {
                        broken.push(iconInfo);
                    }
                }
            });

            console.log(`✅ 正常图标 (${working.length}):`, working);
            console.log(`🔄 已替换图标 (${replaced.length}):`, replaced);
            console.log(`❌ 显示为文字 (${broken.length}):`, broken);

            return { working, broken, replaced };
        },

        fixSpecificIcon: (selector) => {
            const element = document.querySelector(selector);
            if (element) {
                element.style.setProperty('font-family', 'Material Symbols Outlined', 'important');
                element.style.setProperty('font-variation-settings', '"FILL" 0, "wght" 400, "GRAD" 0, "opsz" 24', 'important');
                console.log(`Attempted to fix: ${selector}`);
            }
        },

        testIconReplacement: (originalIcon, replacementIcon) => {
            console.log(`🧪 测试图标替换: "${originalIcon}" → "${replacementIcon}"`);

            const testContainer = document.createElement('div');
            testContainer.style.position = 'absolute';
            testContainer.style.left = '-9999px';

            // 测试原始图标
            const originalEl = document.createElement('span');
            originalEl.className = 'material-symbols-outlined';
            originalEl.textContent = originalIcon;
            originalEl.style.fontFamily = '"Material Symbols Outlined"';
            originalEl.style.fontSize = '18px';

            // 测试替换图标
            const replacementEl = document.createElement('span');
            replacementEl.className = 'material-symbols-outlined';
            replacementEl.textContent = replacementIcon;
            replacementEl.style.fontFamily = '"Material Symbols Outlined"';
            replacementEl.style.fontSize = '18px';

            testContainer.appendChild(originalEl);
            testContainer.appendChild(replacementEl);
            document.body.appendChild(testContainer);

            setTimeout(() => {
                const originalWidth = Math.round(originalEl.getBoundingClientRect().width);
                const replacementWidth = Math.round(replacementEl.getBoundingClientRect().width);

                console.log(`   📏 "${originalIcon}": ${originalWidth}px ${originalWidth > 30 ? '❌ (文字)' : '✅ (图标)'}`);
                console.log(`   📏 "${replacementIcon}": ${replacementWidth}px ${replacementWidth > 30 ? '❌ (文字)' : '✅ (图标)'}`);

                document.body.removeChild(testContainer);
            }, 100);
        },

        addIconReplacement: (originalIcon, replacementIcon) => {
            ICON_REPLACEMENTS[originalIcon] = replacementIcon;
            console.log(`✅ 添加图标映射: "${originalIcon}" → "${replacementIcon}"`);

            // 立即应用到现有元素
            const existingElements = Array.from(document.querySelectorAll('span.material-symbols-outlined'))
                .filter(el => el.textContent.trim() === originalIcon);

            existingElements.forEach(el => {
                el.setAttribute('data-original-text', originalIcon);
                el.textContent = replacementIcon;
                el.style.fontFamily = '"Material Symbols Outlined", "Material Icons"';
                el.style.fontVariationSettings = '"FILL" 0, "wght" 400, "GRAD" 0, "opsz" 24';
                console.log(`🔄 应用新映射到现有元素`);
            });
        },

        forceIconRefresh: () => {
            console.log('🔄 强制刷新所有图标...');
            smartIconFix();
            conservativeIconFix();
        },

        enableDarkMode: () => {
            document.documentElement.classList.add('dark-theme');
            console.log('🌙 暗色模式已启用');
        },

        disableDarkMode: () => {
            document.documentElement.classList.remove('dark-theme');
            console.log('☀️ 暗色模式已禁用');
        },

        getStyleStats: () => {
            const stats = {
                totalElements: document.querySelectorAll('*').length,
                styledElements: document.querySelectorAll('[style*="claude"]').length,
                materialIcons: document.querySelectorAll('.material-symbols-outlined, .material-icons').length,
                customButtons: document.querySelectorAll('.ms-button-primary, .ms-button-borderless').length,
                navbarColor: getComputedStyle(document.querySelector('.header-container, .top-nav, ms-header-root') || document.body).backgroundColor
            };

            console.log('📊 样式统计:', stats);
            return stats;
        }
    };

    // 主初始化
    function initClaudeStyle() {
        loadMaterialIcons();
        injectStyles();

        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', enhanceInterface);
        } else {
            enhanceInterface();
        }

        // 页面完全加载后再次应用修复
        window.addEventListener('load', () => {
            setTimeout(() => {
                smartIconFix();
                conservativeIconFix();
            }, 1000);
        });
    }

    initClaudeStyle();

    console.log(`
    🎨 AI Studio → Claude Style Complete (v2.6 - Dark Mode Fix)
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    ✅ 完整的Claude风格界面已应用
    🌙 导航栏暗黑模式已修复
    🎯 智能图标修复 - 自动替换无效图标名
    🔧 保守字体修复 - 只修复确定能工作的元素
    🛡️ 永久CSS保护 - 防止问题重现
    🎨 侧边栏和全导航栏样式优化
    📱 移动端响应式适配
    ♿ 无障碍访问增强
    🎭 暗色主题支持
    🖨️ 打印样式优化

    🎯 内置图标映射:
    • incognito → visibility_off (隐身模式)
    • incognito_off → visibility_off
    • temporary_chat → visibility_off
    • private_mode → visibility_off
    • guest_mode → person_off

    🛠️  调试命令:
    • claudeDebug.checkIconStatus() - 检查图标状态
    • claudeDebug.fixSpecificIcon(selector) - 修复特定元素
    • claudeDebug.testIconReplacement(original, replacement) - 测试图标
    • claudeDebug.addIconReplacement(original, replacement) - 添加映射
    • claudeDebug.forceIconRefresh() - 强制刷新图标
    • claudeDebug.enableDarkMode() / disableDarkMode() - 切换暗色模式
    • claudeDebug.getStyleStats() - 查看样式统计
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    `);

})();