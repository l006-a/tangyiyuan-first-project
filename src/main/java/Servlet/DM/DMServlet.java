package Servlet.DM;

import cn.hutool.core.date.DateTime;
import cn.hutool.core.date.DateUtil;
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
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@SuppressWarnings("all")
@WebServlet("/DM")
public class DMServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/json;charset=UTF-8");

        Map<String, Object> map = new HashMap<>();
        String info = "SUCCESS";

        HttpSession session = req.getSession(false);
        // 鉴权：必须是 DM
        if (session == null || session.getAttribute("id") == null || !"DM".equals(session.getAttribute("role"))) {
            resp.getWriter().write(JSONUtil.toJsonStr(Map.of("info", "权限不足")));
            return;
        }
        Object dmId = session.getAttribute("id");

        try {
            String body = IoUtil.read(req.getReader());
            if(body.isEmpty()) body="{}";
            JSONObject json = JSONUtil.parseObj(body);
            String action = json.getStr("action");

            //获取工作台数据
            if ("get_my_schedule".equals(action)) {
                // 获取分派给我的所有未结束场次
                String sql = "SELECT r.*, s.title, s.cover_url FROM rooms r " +
                        "JOIN scripts s ON r.script_id = s.id " +
                        "WHERE r.dm_id = ? AND r.status != 'FINISHED' " +
                        "ORDER BY r.start_time ASC";
                map.put("list", Db.use().query(sql, dmId));
            }
            else if ("start_game".equals(action)) {
                doStartGame(dmId, json);
            }
            else if ("finish_game".equals(action)) {
                doFinishGame(dmId, json);
            }else if ("get_dashboard_data".equals(action)) {
                doGetDashboardData(dmId, json, map);
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

    private void doGetDashboardData(Object dmId, JSONObject json, Map<String, Object> map) throws Exception {
        //获取即将开始的场次
        String sql = "SELECT r.id AS room_id, r.start_time, r.current_num, r.max_num, r.status, " +
                "s.title, s.cover_url, s.description, s.tag_list, s.difficulty, s.duration_minutes, s.player_count " +
                "FROM rooms r " +
                "JOIN scripts s ON r.script_id = s.id " +
                "WHERE r.dm_id = ? AND r.status IN ('WAITING', 'LOCKED', 'PLAYING') " +
                "ORDER BY r.start_time ASC LIMIT 1";

        Entity upcoming = Db.use().queryOne(sql, dmId);
        map.put("upcoming", upcoming);

        //获取排班列表
        String targetDateStr = json.getStr("target_date");
        String queryDateStart;
        String queryDateEnd;

        
        String listSql = "SELECT r.id, r.start_time, r.end_time, r.status, r.current_num, r.max_num, s.title " +
                "FROM rooms r JOIN scripts s ON r.script_id = s.id " +
                "WHERE r.dm_id = ? AND r.start_time >= ? AND r.start_time < ? " +
                "ORDER BY r.start_time ASC";

        List<Entity> list = Db.use().query(listSql, dmId, queryDateStart, queryDateEnd);
        map.put("today_list", list);
    }

    //开始游戏
    private void doStartGame(Object dmId, JSONObject json) throws Exception {
        String roomId = json.getStr("room_id");

        //先查询房间信息，校验时间
        Entity room = Db.use().queryOne("SELECT start_time, status FROM rooms WHERE id = ? AND dm_id = ?", roomId, dmId);

        if (room == null) {
            throw new Exception("你不是该房间的 DM 或房间不存在");
        }

        // 时间校验：最多提前30分钟开始
        DateTime startTime = DateUtil.parse(room.getStr("start_time"));
        DateTime allowedTime = DateUtil.offsetMinute(startTime, -30); // 允许的最早时间 = 计划开始时间 - 30分钟

        if (DateUtil.date().isBefore(allowedTime)) {
            // 格式化一下时间
            throw new Exception("未到开局时间，最早仅可提前30分钟（即 " + DateUtil.format(allowedTime, "HH:mm") + " 后）开始");
        }

        // 允许 WAITING 或 LOCKED 状态转变为 PLAYING
        int rows = Db.use().execute("UPDATE rooms SET status = 'PLAYING' WHERE id = ? AND status IN ('WAITING', 'LOCKED')", roomId);
        if(rows == 0) throw new Exception("开始失败：房间状态不正确（可能已开始或已结束）");
    }

    //结束游戏
    private void doFinishGame(Object dmId, JSONObject json) throws Exception {
        String roomId = json.getStr("room_id");

        // 事务：结算流程
        Db.use().tx(tx -> {
            //校验并锁定房间
            Entity room = tx.queryOne("SELECT * FROM rooms WHERE id = ? AND dm_id = ?", roomId, dmId);
            if (room == null || !"PLAYING".equals(room.getStr("status"))) throw new Exception("无法结束游戏（可能未开始或已结束）");

            // 防止 DM 误触：比如 14:00 的局，13:30 刚开，13:31 就误触点结束
            DateTime startTime = DateUtil.parse(room.getStr("start_time"));
            if (DateUtil.date().isBefore(startTime)) {
                throw new Exception("当前时间过早，无法结束游戏（需到达计划开始时间 " + DateUtil.format(startTime, "HH:mm") + " 后方可结算）");
            }

            String scriptTitle = tx.queryOne("SELECT title FROM scripts WHERE id = ?", room.get("script_id")).getStr("title");

            //更新房间状态
            tx.execute("UPDATE rooms SET status = 'FINISHED' WHERE id = ?", roomId);

            //结算 Booking：将冻结资金彻底扣除，并确认营收
            List<Entity> bookings = tx.query("SELECT * FROM bookings WHERE room_id = ?", roomId);
            for (Entity booking : bookings) {
                BigDecimal frozenAmount = booking.getBigDecimal("frozen_amount");
                Object userId = booking.get("user_id");

                // 将用户的 frozen_balance 真正扣除（物理扣款）
                tx.execute("UPDATE users SET frozen_balance = frozen_balance - ? WHERE id = ?",
                        frozenAmount, userId);

                // 更新 booking 状态
                tx.execute("UPDATE bookings SET status = 'SETTLED' WHERE id = ?", booking.get("id"));

                //写入 PAYMENT 日志 (确认营收)
                tx.insert(Entity.create("wallet_logs")
                        .set("user_id", userId)
                        .set("type", "PAYMENT")
                        .set("amount", frozenAmount.negate()) // 确认为消费，记为负数
                        .set("related_id", roomId)
                        .set("description", "剧本核销: " + scriptTitle));
            }
        });
    }
}
