package Servlet.Universal;

import cn.hutool.core.codec.Base64;
import cn.hutool.core.io.FileUtil;
import cn.hutool.core.io.IoUtil;
import cn.hutool.core.util.IdUtil;
import cn.hutool.crypto.digest.DigestUtil;
import cn.hutool.db.Db;
import cn.hutool.json.JSONObject;
import cn.hutool.json.JSONUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

@SuppressWarnings("all")
@WebServlet("/Auth")
public class AuthServlet extends HttpServlet {

    private static final String ABSOLUTE_RESOURCE_PATH = "C:\\Users\\480900462\\IdeaProjects\\JAVA_WEB_Work\\src\\main\\resources";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/json;charset=UTF-8");

        String info = "SUCCESS";
        Map<String, Object> map = new HashMap<>();

        try {
            String body = IoUtil.read(req.getReader());
            JSONObject json = JSONUtil.parseObj(body);
            String action = json.getStr("action");

            if ("login".equals(action)) {
                doLogin(req, json, map);
            }
            else if ("register".equals(action)) {
                doRegister(req, json, map);
            }
            else if ("initialize".equals(action)) {
                doInitialize(req, json, map);
            }
            else if ("logout".equals(action)) {
                req.getSession().invalidate();
                map.put("info", "SUCCESS");
            }
            else {
                map.put("info", "未知操作");
            }

        } catch (Exception e) {
            e.printStackTrace();
            map.put("info", "操作失败: " + e.getMessage());
        }

        resp.getWriter().write(JSONUtil.toJsonStr(map));
    }

    //登录
    private void doLogin(HttpServletRequest req, JSONObject json, Map<String, Object> map) throws Exception {
        String username = json.getStr("username");
        String password = json.getStr("password");

        // 使用 MD5 加密密码比对
        String md5Password = DigestUtil.md5Hex(password);

        // 查数据库
        var user = Db.use().queryOne("SELECT * FROM users WHERE username = ? AND password = ?", username, md5Password);

        if (user != null) {
            // 登录成功
            HttpSession session = req.getSession();
            session.setAttribute("id", user.get("id"));
            session.setAttribute("username", user.get("username"));
            session.setAttribute("role", user.get("role"));
            session.setAttribute("avatar_url", user.get("avatar_url"));
            map.put("info", "SUCCESS");
        } else {
            throw new Exception("用户名或密码错误");
        }
    }

    private void doRegister(HttpServletRequest req, JSONObject json, Map<String, Object> map) throws Exception {
        String username = json.getStr("username");
        String password = json.getStr("password");

        // 检查重名
        int count = Db.use().queryNumber("SELECT count(1) FROM users WHERE username = ?", username).intValue();
        if (count > 0) throw new Exception("用户名已存在");

        // 处理头像上传
        String newAvatarUrl = null;
        String base64Data = json.getStr("avatar_url");

        if (base64Data != null && base64Data.startsWith("data:image")) {
            // 使用绝对路径 + /upload/
            String uploadPath = ABSOLUTE_RESOURCE_PATH + "/upload/";

            if (!FileUtil.exist(uploadPath)) {
                FileUtil.mkdir(uploadPath);
            }

            String fileName = IdUtil.simpleUUID() + ".jpg";
            String pureBase64 = base64Data.substring(base64Data.indexOf(",") + 1);

            // 写入文件
            File destFile = new File(uploadPath + fileName);
            FileUtil.writeBytes(Base64.decode(pureBase64), destFile);

            // 数据库存相对路径
            newAvatarUrl = "resources/upload/" + fileName;
        }

        // 插入用户 (默认角色 PLAYER)
        Db.use().execute("INSERT INTO users (username, password, role, avatar_url, reputation_score, balance) VALUES (?, ?, ?, ?, ?, ?)",
                username, DigestUtil.md5Hex(password), "PLAYER", newAvatarUrl, 100, 0);

        map.put("info", "SUCCESS");
    }

    //初始化
    private void doInitialize(HttpServletRequest req, JSONObject json, Map<String, Object> map) throws Exception {
        HttpSession session = req.getSession(false);
        ArrayList<String> menuList = new ArrayList<>();
        String executeImmediately = "";

        // 尝试自动开启数据库定时任务
        try { Db.use().execute("SET GLOBAL event_scheduler = ON"); } catch (Exception ignored) {}

        if (session == null || session.getAttribute("id") == null) {
            map.put("info", "NOT_LOGGED_IN");
            return;
        }

        // 菜单
        String role = (String) session.getAttribute("role");
        String username = (String) session.getAttribute("username");

        if ("ADMIN".equals(role)) {
            menuList.add("<li class=\"active\" onclick=\"ShowAdminDashboard()\">仪表盘</li>");
            menuList.add("<li onclick=\"ShowSchedulePage()\">场次调度</li>");
            menuList.add("<li onclick=\"ShowScriptLibrary()\">剧本库</li>");
            menuList.add("<li onclick=\"ShowUserManagement()\">用户管理</li>");
            menuList.add("<li onclick=\"ShowFinancialReports()\">财务与报表</li>");
            executeImmediately = "ShowAdminDashboard()";
        } else if ("USER".equals(role) || "PLAYER".equals(role)) {
            menuList.add("<li class=\"active\" onclick=\"ShowOrganizingHall()\">组局大厅</li>");
            menuList.add("<li class=\"active\" onclick=\"ShowMySchedule()\">我的行程</li>");
            menuList.add("<li onclick=\"ShowUserProfile()\">个人中心</li>");
            executeImmediately = "ShowOrganizingHall()";
        } else if ("DM".equals(role)) {
            // DM 登录
            menuList.add("<li class=\"active\" onclick=\"ShowDMDashboard()\">DM工作台</li>");
            menuList.add("<li onclick=\"loadDMScriptMaterialsPage()\">剧本资料</li>");
            executeImmediately = "ShowDMDashboard()";
    }

        map.put("username", username);
        map.put("list", menuList);
        map.put("ExecuteImmediately", executeImmediately);
        map.put("info", "SUCCESS");
    }
}