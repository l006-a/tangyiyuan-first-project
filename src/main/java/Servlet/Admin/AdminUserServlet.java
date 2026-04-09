package Servlet.Admin;

import cn.hutool.core.codec.Base64;
import cn.hutool.core.io.FileUtil;
import cn.hutool.core.io.IoUtil;
import cn.hutool.core.util.IdUtil;
import cn.hutool.crypto.digest.DigestUtil;
import cn.hutool.db.Db;
import cn.hutool.db.Entity;
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
import java.util.List;
import java.util.Map;

@SuppressWarnings("all")
@WebServlet("/AdminUser")
public class AdminUserServlet extends HttpServlet {

    // 只有保存到这里，你的 Tomcat 虚拟路径映射才能找到它，且不会被 Rebuild 清空
    private static final String ABSOLUTE_RESOURCE_PATH = "C:\\Users\\480900462\\IdeaProjects\\JAVA_WEB_Work\\src\\main\\resources";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/json;charset=UTF-8");

        Map<String, Object> map = new HashMap<>();
        String info = "SUCCESS";

        HttpSession session = req.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            resp.getWriter().write(JSONUtil.toJsonStr(Map.of("info", "无权操作")));
            return;
        }

        try {
            String body = IoUtil.read(req.getReader());
            if(body.isEmpty()) body="{}";
            JSONObject json = JSONUtil.parseObj(body);
            String action = json.getStr("action");

            if ("list".equals(action)) {
                doList(json, map);
            }
            else if ("add".equals(action)) {
                doAdd(req, json);
            }
            else if ("edit".equals(action)) {
                doEdit(req, json);
            }
            else if ("delete".equals(action)) {
                doDelete(json);
            }
            else if ("get_reputation_alerts".equals(action)) {
                doGetAlerts(map);
            }
            else {
                info = "未知操作";
            }

        } catch (Exception e) {
            e.printStackTrace();
            info = "操作失败: " + e.getMessage();
        }
        map.put("info", info);
        resp.getWriter().write(JSONUtil.toJsonStr(map));
    }

    //查询用户列表
    private void doList(JSONObject json, Map<String, Object> map) throws Exception {
        String search = json.getStr("search");
        String roleFilter = json.getStr("role");
        StringBuilder sql = new StringBuilder("SELECT id, username, role, balance, frozen_balance, reputation_score, avatar_url, created_at FROM users WHERE role != 'ADMIN'");
        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND username LIKE ?");
            params.add("%" + search.trim() + "%");
        }
        if (roleFilter != null && !roleFilter.equals("ALL")) {
            sql.append(" AND role = ?");
            params.add(roleFilter);
        }
        sql.append(" ORDER BY created_at DESC");

        map.put("list", Db.use().query(sql.toString(), params.toArray()));
    }

    //新增用户
    private void doAdd(HttpServletRequest req, JSONObject json) throws Exception {
        String username = json.getStr("username");

        // 调用修改后的 handleImage
        String avatarUrl = handleImage(req, json.getStr("avatar_url"));

        int count = Db.use().queryNumber("SELECT count(1) FROM users WHERE username = ?", username).intValue();
        if (count > 0) throw new Exception("用户名已存在");
        BigDecimal balance = json.getBigDecimal("balance") != null ? json.getBigDecimal("balance") : BigDecimal.ZERO;
        if (balance.compareTo(BigDecimal.ZERO) < 0) {
            throw new Exception("初始余额不能为负数");
        }

        Entity user = Entity.create("users")
                .set("username", username)
                .set("password", DigestUtil.md5Hex(json.getStr("password")))
                .set("role", json.getStr("role"))
                .set("avatar_url", avatarUrl)
                .set("reputation_score", 100)
                .set("balance",balance);

        Db.use().insert(user);
    }

    //编辑用户
    private void doEdit(HttpServletRequest req, JSONObject json) throws Exception {
        String id = json.getStr("id");
        if(id == null) throw new Exception("ID为空");

        Entity update = Entity.create("users");

        // 调用修改后的 handleImage
        String newAvatar = handleImage(req, json.getStr("avatar_url"));
        if(newAvatar != null) update.set("avatar_url", newAvatar);

        String pwd = json.getStr("password");
        if(pwd != null && !pwd.isEmpty()) update.set("password", DigestUtil.md5Hex(pwd));

        if ("PLAYER".equals(json.getStr("role"))) {
            if(json.get("balance") != null) {
                BigDecimal balance = json.getBigDecimal("balance");
                if (balance.compareTo(BigDecimal.ZERO) < 0) {
                    throw new Exception("余额不能设置为负数");
                }
                update.set("balance", balance);
            }
            if(json.get("reputation_score") != null) update.set("reputation_score", json.getInt("reputation_score"));
        }

        Db.use().update(update, Entity.create().set("id", id));
    }

    //删除用户
    private void doDelete(JSONObject json) throws Exception {
        String id = json.getStr("id");
        Entity user = Db.use().queryOne("SELECT balance, frozen_balance FROM users WHERE id = ?", id);

        if (user != null) {
            BigDecimal total = user.getBigDecimal("balance").add(user.getBigDecimal("frozen_balance"));
            if (total.compareTo(BigDecimal.ZERO) > 0) throw new Exception("该用户仍有余额，无法删除");
        }

        int active = Db.use().queryNumber("SELECT count(1) FROM bookings b JOIN rooms r ON b.room_id = r.id WHERE b.user_id = ? AND r.status IN ('WAITING', 'LOCKED', 'PLAYING')", id).intValue();
        if (active > 0) throw new Exception("该用户有正在进行的拼车或游戏");

        Db.use().del("users", "id", id);
    }

    //获取信誉预警
    private void doGetAlerts(Map<String, Object> map) throws Exception {
        List<Map<String, String>> alerts = new ArrayList<>();

        Long critical = Db.use().queryNumber("SELECT COUNT(*) FROM users WHERE reputation_score < 60").longValue();
        if (critical > 0) alerts.add(Map.of("msg", "极低信誉分警告 (" + critical + "人)", "level", "critical"));

        Long warning = Db.use().queryNumber("SELECT COUNT(*) FROM users WHERE reputation_score >= 60 AND reputation_score <= 80").longValue();
        if (warning > 0) alerts.add(Map.of("msg", "信誉分下降预警 (" + warning + "人)", "level", "normal"));

        map.put("list", alerts);
    }

    //通用图片处理
    private String handleImage(HttpServletRequest req, String base64Data) {
        if (base64Data != null && base64Data.startsWith("data:image")) {

            String path = ABSOLUTE_RESOURCE_PATH + "/upload/";


            if (!FileUtil.exist(path)) FileUtil.mkdir(path);
            String fileName = IdUtil.simpleUUID() + ".jpg";

            //写入文件
            FileUtil.writeBytes(Base64.decode(base64Data.substring(base64Data.indexOf(",") + 1)), new File(path + fileName));

            //返回相对路径给数据库
            return "resources/upload/" + fileName;
        }
        return base64Data;
    }
}