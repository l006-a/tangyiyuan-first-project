package Servlet.Universal;

import cn.hutool.core.io.IoUtil;
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

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@SuppressWarnings("all")
@WebServlet("/Lobby")
public class LobbyServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/json;charset=UTF-8");

        Map<String, Object> map = new HashMap<>();
        String info = "SUCCESS";

        try {
            //获取当前用户ID (用于判断是否已加入某房间)
            HttpSession session = req.getSession(false);
            Object currentUserId = (session != null) ? session.getAttribute("id") : 0;
            if(currentUserId == null) currentUserId = 0;

            String body = IoUtil.read(req.getReader());
            if (body.isEmpty()) body = "{}";
            JSONObject json = JSONUtil.parseObj(body);
            String action = json.getStr("action");

            if ("get_lobby_data".equals(action)) {
                // 核心查询逻辑：
                // 1. 关联 rooms 和 scripts 表
                // 2. 只查 WAITING 且 时间未过期的
                // 3. 子查询 is_joined：返回 1 表示当前用户在车上，0 表示不在
                String sql = "SELECT " +
                        "r.id AS room_id, r.start_time, r.current_num, r.max_num, " +
                        "s.title, s.cover_url, s.tag_list, s.difficulty, s.price, s.duration_minutes, " +
                        "s.description AS description, " +
                        "(SELECT COUNT(1) FROM bookings b WHERE b.room_id = r.id AND b.user_id = ?) AS is_joined " +
                        "FROM rooms r " +
                        "JOIN scripts s ON r.script_id = s.id " +
                        "WHERE r.status = 'WAITING' AND r.start_time >= NOW() " +
                        "ORDER BY r.start_time ASC";

                List<Entity> list = Db.use().query(sql, currentUserId);

                map.put("list", list);
            } else {
                info = "未知操作";
            }

        } catch (Exception e) {
            e.printStackTrace();
            info = "操作失败: " + e.getMessage();
        }

        map.put("info", info);
        resp.getWriter().write(JSONUtil.toJsonStr(map));
    }
}