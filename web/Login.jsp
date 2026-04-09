<%--
  Created by IntelliJ IDEA.
  User: 480900462
  Date: 2026/1/8
  Time: 14:36
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>登录</title>
    <style>

        .gx-root-final {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: #FFF5EA;
            z-index: 9999;
            pointer-events: none;
            overflow: hidden;
            font-family: 'Impact', sans-serif;
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
            justify-content: center;
        }

        .gx-stream-left {
            transform: rotate(-45deg);
        }

        .gx-stream-right {
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
        *{
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body{
            overflow: hidden;
        }
        section{
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background: linear-gradient(to bottom,#f1f4f9,#dff1ff);
        }
        section .color{
            position: absolute;
            filter: blur(150px);
        }
        section .color:nth-child(1){
            top: -350px;
            width: 600px;
            height: 600px;
            background: #ff359b;
        }
        section .color:nth-child(2){
            bottom: -150px;
            left: 100px;
            width: 500px;
            height: 500px;
            background: #fffd87;
        }
        section .color:nth-child(3){
            bottom: 50px;
            right: 100px;
            width: 500px;
            height: 500px;
            background: #00d2ff;
        }
        .box{
            position: relative;
        }
        .box .square{
            position: absolute;
            backdrop-filter: blur(5px);
            box-shadow: 0 25px 45px rgb(0,0,0,0.1);
            border: 1px solid rgb(255,255,255,0.5);
            border-right: 1px solid rgb(255,255,255,0.2);
            border-bottom: 1px solid rgb(255,255,255,0.2);
            background:rgb(255,255,255,0.1);
            border-radius: 10px;
            animation: animate 10s linear infinite;
            animation-delay: calc(-1s*var(--i));
        }
        /* 动画 */

        @keyframes animate{
            0%,100%{
                transform: translateY(-40px);
            }
            50%{
                transform: translate(40px);
            }
        }
        .box .square:nth-child(1){
            top: -50px;
            right: -60px;
            width: 100px;
            height: 100px;
        }
        .box .square:nth-child(2){
            top: 150px;
            left: -100px;
            width: 120px;
            height: 120px;
            z-index: 2;
        }
        .box .square:nth-child(3){
            bottom: 50px;
            right: -60px;
            width: 80px;
            height: 80px;
            z-index: 2;
        }
        .box .square:nth-child(4){
            bottom: -80px;
            left: 100px;
            width: 50px;
            height: 50px;
        }
        .box .square:nth-child(5){
            top: -90px;
            left: 140px;
            width: 60px;
            height: 60px;
        }
        .container{
            position: relative;
            width:400px;
            background:rgb(255,255,255,0.1);
            border-radius: 10px;
            display: flex;
            justify-content: center;
            align-items: center;
            backdrop-filter: blur(5px);
            box-shadow: 0 25px 45px rgb(0,0,0,0.1);
            border: 1px solid rgb(255,255,255,0.5);
            border-right: 1px solid rgb(255,255,255,0.2);
            border-bottom: 1px solid rgb(255,255,255,0.2);
            transition: height 0.5s ease-in-out;
            overflow: hidden;
        }

        .form{
            position: relative;
            height: 100%;
            width: 100%;
            padding: 40px;
        }

        .form h2{
            position: relative;
            color: #3D77DD;
            font-size: 24px;
            font-weight: 600;
            letter-spacing: 1px;
            margin-bottom: 40px;
        }
        .form h2::before{
            content: '';
            position: absolute;
            left: 0;
            bottom: -10px;
            width: 80px;
            height: 4px;
            background: #fff;
        }

        .form .inputBox{
            width: 100%;
            margin-top: 20px;
        }

        .form .inputBox input{
            width: 100%;
            background: rgb(255,255,255,0.2);
            border: none;
            outline: none;
            padding: 10px 20px;
            border-radius: 35px;
            border: 1px solid rgb(255,255,255,0.5);
            border-right: 1px solid rgb(255,255,255,0.2);
            border-bottom: 1px solid rgb(255,255,255,0.2);
            font-size: 16px;
            letter-spacing: 1px;
            color: #6A73E3;
            box-shadow: 0 5px 15px rgb(0,0,0,0.05);
        }

        .form .inputBox input::placeholder{
            color: #ffc1f1;
        }

        .form .inputBox input[type="submit"]{
            background: #fff;
            color: #666;
            max-width: 100px;
            cursor: pointer;
            margin-bottom: 20px;
            font-weight: 600;
        }

        .forget{
            margin-top: 5px;
            color: #787205;
        }

        .forget a{
            color: #20d200;
            font-weight: 600;
        }

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
        #toast-container.error .icon-error {
            display: block;
        }
        #toast-container.error .toast-icon-wrapper {
            background-color: var(--toast-error-bg);
        }
        .confirm-password-box {
            height: 0;
            opacity: 0;
            margin-top: 0;
            overflow: hidden;
            transition: all 0.5s ease-in-out;
        }

        .confirm-password-box.show {
            height: 58px;
            opacity: 1;
            margin-top: 20px;
        }

        .forget a{
            cursor: pointer;
        }
        .NextBtn{
            position: relative;
            transition: top 0.4s;
            top: 0;
        }
        .NextBtn:hover {
            top: -7px;
        }
        #loadingDiv{
            opacity: 0;
            pointer-events: none;
            transition: opacity .4s;
        }

    </style>
</head>
<body>

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

<section>
    <div class="color"></div>
    <div class="color"></div>
    <div class="color"></div>
    <div class="box">
        <div class="square" style="--i:0;"></div>
        <div class="square" style="--i:1;"></div>
        <div class="square" style="--i:2;"></div>
        <div class="square" style="--i:3;"></div>
        <div class="square" style="--i:4;"></div>
        <div class="container">
            <div class="form">
                <h2 class="formH2">登录</h2>
                <form>
                    <div class="inputBox" id="avatarBox" style="display:none; text-align: center; margin-bottom: 15px;">
                        <div style="width: 80px; height: 80px; border-radius: 50%; background: #eee; margin: 0 auto;
                    background-size: cover; background-position: center; border: 2px solid #fff; cursor: pointer;"
                             id="regAvatarPreview" onclick="document.getElementById('regAvatarInput').click()">
                            <span style="line-height: 80px; color: #999; font-size: 12px;">上传头像</span>
                        </div>
                        <input type="file" id="regAvatarInput" accept="image/*" style="display: none;" onchange="handleRegAvatar(this)">
                        <input type="hidden" id="regAvatarBase64">
                    </div>

                    <div class="inputBox">
                        <input type="text" placeholder="用户名" class="UserName">
                    </div>
                    <div class="inputBox">
                        <input type="password" placeholder="密码" class="Password">
                    </div>
                    <div class="inputBox confirm-password-box">
                        <input type="password" placeholder="确认密码" class="ConfirmPassword">
                    </div>
                    <div class="inputBox">
                        <input type="submit" value="登录" class="NextBtn">
                    </div>
                    <p class="forget">没有账号？<a onclick="PageChange()" class="PageChangeBtn">注册</a></p >
                </form>
            </div>
        </div>
    </div>
</section>
<div id="toast-container">
    <div class="toast-icon-wrapper">
        <img class="toast-svg-img icon-success" src="${pageContext.request.contextPath}/resources/svg/Information_good.svg" alt="Success Icon">
        <img class="toast-svg-img icon-error" src="${pageContext.request.contextPath}/resources/svg/Information_bad.svg" alt="Error Icon">
    </div>
    <span id="toast-message"></span>
</div>
</body>
<script>
    //这个绑定用户名输入框
    const UserName=document.querySelector('.UserName')
    //这个绑定密码输入框
    const Password=document.querySelector('.Password')
    //这个绑定确认密码输入框
    const ConfirmPassword=document.querySelector('.ConfirmPassword')
    //这个绑定的是登录按钮
    const NextBtn=document.querySelector('.nextBtn');
    //获取确认密码输入框的容器
    const confirmPasswordBox = document.querySelector('.confirm-password-box');
    //获取外层容器
    const container = document.querySelector('.container');
    //这个绑定的是通知的大div
    const toastContainer = document.getElementById('toast-container');
    //这个绑定的是通知的文字信息div
    const toastMessage = document.getElementById('toast-message');
    //这个绑定的是登录/注册的标题
    const formH2=document.querySelector('.formH2');
    //这个绑定的是下面的切换按钮的文字
    const forget=document.querySelector('.forget');
    //这个绑定的是遮盖层
    const CoveringLayer=document.querySelector('#loadingDiv')
    //这个是通知音
    const notificationSound=new Audio('${pageContext.request.contextPath}/resources/sound/notificationSound.ogg')


    //通知显示的计时器
    let toastTimeout;
    //这个来判断目前是登录还是注册
    let isLogIn=true

    //设置动画文字
    function setLoaderText(text) {
        const unitHtml = '<span class="gx-gap">' + text + '</span>';
        const countPerChunk = 160;
        let singleChunk = '';
        for (let i = 0; i < countPerChunk; i++) {
            singleChunk += unitHtml;
        }
        const finalContent = singleChunk + singleChunk;
        const elSW = document.getElementById('gx-text-sw');
        const elNW = document.getElementById('gx-text-nw');

        if (elSW) elSW.innerHTML = finalContent;
        if (elNW) elNW.innerHTML = finalContent;
    }

    //显示遮盖层（需要传入文字）
    function ShowCoveringLayer(text){
        setLoaderText(text);
        CoveringLayer.style.opacity = 1;
        CoveringLayer.style.pointerEvents = 'auto';
    }

    //隐藏遮盖层
    function HiddenCoveringLayer(){
        CoveringLayer.style.opacity = 0;
        CoveringLayer.style.pointerEvents = 'none';
    }

    //这是前后段通信的主要方法,传入url和数据（自动转json格式）,返回结果。如果超时会报错，到trycatch的catch里捕获
    function request(url,data=null){
        return new Promise((resolve,reject)=>{
            const xhr = new XMLHttpRequest();
            xhr.open('POST', `${pageContext.request.contextPath}/\${url}`);
            xhr.setRequestHeader('Content-type', 'application/json;charset=UTF-8');
            xhr.timeout=4000//设置，4秒连接不上，就有问题
            xhr.ontimeout = function() {//挺好，超时了
                reject("连接服务器超时")
            };
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4) {
                    if (xhr.status === 200){
                        let temp1=xhr.responseText
                        let r=JSON.parse(temp1);
                        if(r.info==='SUCCESS') resolve(r.list);
                        else if(r.info==='NOT_LOGGED_IN'){
                            window.location.href = "${pageContext.request.contextPath}/Login.jsp";
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
        if (toastTimeout) {
            clearTimeout(toastTimeout);
        }
        toastMessage.textContent = message;
        toastContainer.classList.remove('success', 'error');
        if (isSuccess) {
            toastContainer.classList.add('success');
        } else {
            toastContainer.classList.add('error');
        }
        notificationSound.currentTime = 0;//重置播放进度到开头 (防止上一次没播完，这次接着播)
        //ai的代码. 执行播放
        notificationSound.play().catch(function(error) {
            console.log("播放失败，可能是因为用户还没有与页面交互:", error);
        });

        // 使用 setTimeout 确保浏览器捕捉到状态变化以触发动画
        setTimeout(() => {
            toastContainer.classList.add('show');
        }, 10);

        toastTimeout = setTimeout(() => {
            toastContainer.classList.remove('show');
        }, 5000);
    }

    // 处理头像转 Base64 的函数,ai的
    function handleRegAvatar(input) {
        if (input.files && input.files[0]) {
            const file = input.files[0];
            if(file.size > 2 * 1024 * 1024) {
                showToast("图片太大，请小于2MB", false);
                return;
            }
            const reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById('regAvatarBase64').value = e.target.result;
                document.getElementById('regAvatarPreview').style.backgroundImage = 'url(' + e.target.result;
                document.getElementById('regAvatarPreview').innerHTML = ''; // 清除文字
            }
            reader.readAsDataURL(file);
        }
    }


    //点击登录/注册后的逻辑
    NextBtn.addEventListener('click', async (e) => {
        e.preventDefault()
        if (isLogIn) {
            //登录
            if (UserName.value.trim() === '' || Password.value.trim() === '') {
                showToast("用户名或密码没填", false)
                return
            }
            let information = {
                action: 'login',
                username: UserName.value,
                password: Password.value
            }
            try {
                await request('Auth', information)
                ShowCoveringLayer("Load")
                showToast('登录成功，正在跳转', true)
                setTimeout(function () {
                    window.location.href = "Index.jsp"
                }, 500)

            } catch (error) {
                showToast(error, false)
            }
        } else {
            //注册
            if (UserName.value.trim() === '' || Password.value.trim() === '' || ConfirmPassword.value.trim() === '') {
                showToast("用户名密码或者确认密码没填", false)
                return
            } else if (Password.value.trim() !== ConfirmPassword.value.trim()) {
                showToast("密码!=确认密码", false)
                return
            }
            let information = {
                action: 'register',
                username: UserName.value,
                password: Password.value,
                avatar_url: document.getElementById('regAvatarBase64').value
            }
            try {
                await request('Auth', information)
                PageChange()
                showToast('注册成功，请登录', true)
            } catch (error) {
                showToast(error, false)
            }
        }
    })



    function PageChange(){
        Password.value = ''
        ConfirmPassword.value = ''
        const avatarBox = document.getElementById('avatarBox');
        const currentHeight = container.offsetHeight;
        container.style.height = currentHeight + 'px';
        container.offsetHeight;
        const heightOffset = 58;

        if (isLogIn) {
            // === 切换到 注册 模式 ===
            confirmPasswordBox.classList.add('show');
            avatarBox.style.display = 'block'; // 显示头像
            isLogIn = false;
            formH2.innerHTML='注册'
            NextBtn.value='注册'
            forget.innerHTML='有账号了？<a onclick="PageChange()" class="PageChangeBtn">登录</a >'

            // 动态调整高度，多预留一些空间给头像
            container.style.height = (currentHeight + 150) + 'px';
        } else {
            // === 切换到 登录 模式 ===
            confirmPasswordBox.classList.remove('show');
            avatarBox.style.display = 'none'; // 隐藏头像
            isLogIn = true;
            formH2.innerHTML='登录'
            NextBtn.value='登录'
            forget.innerHTML='没有账号？<a onclick="PageChange()" class="PageChangeBtn">注册</a >'

            container.style.height = '400px'; // 恢复默认高度
        }
        setTimeout(() => {
            container.style.height = 'auto';
        }, 500);

    }

</script>
</html>
