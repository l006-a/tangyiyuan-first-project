package Servlet.Universal;

import cn.hutool.db.Db;
import cn.hutool.db.Entity;
import cn.hutool.core.io.IoUtil;
import cn.hutool.json.JSONObject;
import cn.hutool.json.JSONUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@SuppressWarnings("all")
@WebServlet("/UniversalData")
public class UniversalDataServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/json;charset=UTF-8");

        Map<String, Object> map = new HashMap<>();

        try {
            // 读取 action
            String body = IoUtil.read(req.getReader());
            // 防止空body报错，给个空JSON
            if(body.isEmpty()) body = "{}";

            JSONObject json = JSONUtil.parseObj(body);
            String action = json.getStr("action");

            HttpSession session = req.getSession(false);
            if (session == null || session.getAttribute("id") == null) {
                map.put("info", "NOT_LOGGED_IN");
                resp.getWriter().write(JSONUtil.toJsonStr(map));
                return;
            }

            if ("get_script_list".equals(action)) {
                List<Entity> list = Db.use().query("SELECT * FROM scripts");
                map.put("list", list);
            }
            else if ("get_popular_scripts".equals(action)) {
                //(取前3名)
                List<Entity> list = Db.use().query("SELECT * FROM scripts ORDER BY avg_score DESC LIMIT 3");
                map.put("list", list);
            }
            else if ("get_dm_list".equals(action)) {
                List<Entity> list = Db.use().query("SELECT id, username FROM users WHERE role = 'DM'");
                map.put("list", list);
            }
            else if ("get_ongoing_games_count".equals(action)) {
                List<Entity> list = Db.use().query("SELECT * FROM rooms WHERE start_time <= NOW() AND end_time >= NOW()");
                map.put("list", list);
            }
            else {
                map.put("info", "无效的请求");
            }

            if(!map.containsKey("info")) map.put("info", "SUCCESS");

        } catch (Exception e) {
            e.printStackTrace();
            map.put("info", "服务器错误: " + e.getMessage());
        }

        resp.getWriter().write(JSONUtil.toJsonStr(map));
    }
}