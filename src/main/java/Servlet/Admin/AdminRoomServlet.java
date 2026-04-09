package Servlet.Admin;

import cn.hutool.core.date.DateField;
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
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@SuppressWarnings("all")
@WebServlet("/AdminRoom")
public class AdminRoomServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/json;charset=UTF-8");

        Map<String, Object> map = new HashMap<>();
        String info = "SUCCESS";

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("id") == null || !"ADMIN".equals(session.getAttribute("role"))) {
            resp.getWriter().write(JSONUtil.toJsonStr(Map.of("info", "无权操作")));
            return;
        }

        try {
            String body = IoUtil.read(req.getReader());
            if (body.isEmpty()) body = "{}";
            JSONObject json = JSONUtil.parseObj(body);
            String action = json.getStr("action");

            if ("create".equals(action)) {
                doCreate(json);
            }
            else if ("delete".equals(action)) {
                doDelete(json);
            }
            else if ("get_schedule".equals(action)) {
                doGetSchedule(json, map);
            }
            else if ("get_today_dashboard".equals(action)) {
                List<Entity> list = Db.use().query("SELECT * FROM rooms WHERE start_time >= CURDATE() AND start_time < CURDATE() + INTERVAL 1 DAY");
                map.put("list", list);
            }
            else if ("get_action_required".equals(action)) {
                String sql = "SELECT COUNT(*) FROM rooms WHERE dm_id IS NULL AND status IN ('WAITING', 'LOCKED') " +
                        "AND start_time >= NOW() AND start_time <= DATE_ADD(NOW(), INTERVAL 48 HOUR)";
                long count = Db.use().queryNumber(sql).longValue();
                map.put("count", count);
                map.put("list", Collections.emptyList());
            }
            else if ("assign_dm".equals(action)) {
                doAssignDM(json);
            }
            else if ("get_available_dms".equals(action)) {
                doGetAvailableDMs(json, map);
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

    // 创建房间
    private void doCreate(JSONObject json) throws Exception {
        String scriptIdStr = json.getStr("script_id");
        String startTimeStr = json.getStr("start_time");
        String dmIdStr = json.getStr("dm_id");

        if (scriptIdStr == null || startTimeStr == null) throw new Exception("参数不完整");

        if (dmIdStr == null || dmIdStr.trim().isEmpty() || "null".equals(dmIdStr)||"-- 请选择主持人 --".equals(dmIdStr)) {
            throw new Exception("创建失败：必须指派一名主持人 (DM)");
        }


        // 查询剧本信息
        Entity script = Db.use().queryOne("SELECT duration_minutes, player_count FROM scripts WHERE id = ?", scriptIdStr);
        if (script == null) throw new Exception("剧本不存在");

        DateTime startTime = DateUtil.parse(startTimeStr);
        DateTime now = DateUtil.date();

        // 时间校验
        if (startTime.isBefore(DateUtil.offsetHour(now, 6))) throw new Exception("开始时间必须在 6小时 之后");
        if (startTime.isAfter(DateUtil.endOfMonth(DateUtil.offsetMonth(now, 1)))) throw new Exception("只能安排本月或下个月的场次");

        DateTime endTime = DateUtil.offset(startTime, DateField.MINUTE, script.getInt("duration_minutes"));
        String conflictSql = "SELECT COUNT(*) FROM rooms WHERE dm_id = ? " +
                "AND status IN ('WAITING', 'LOCKED', 'PLAYING') " +
                "AND (start_time < ? AND end_time > ?)";

        int conflictCount = Db.use().queryNumber(conflictSql, dmIdStr, endTime, startTime).intValue();
        if (conflictCount > 0) {
            throw new Exception("冲突警告：该 DM 在此时间段已有其他排期，请选择其他人。");
        }
        Entity room = Entity.create("rooms")
                .set("script_id", scriptIdStr)
                .set("dm_id", dmIdStr) // 直接设置，因为上面已经校验过非空了
                .set("status", "WAITING")
                .set("current_num", 0)
                .set("max_num", script.getInt("player_count"))
                .set("start_time", startTime)
                .set("end_time", endTime);

        Db.use().insert(room);
    }

    //删除房间
    private void doDelete(JSONObject json) throws Exception {
        String roomId = json.getStr("id");
        if (roomId == null) throw new Exception("ID不能为空");

        int bookingCount = Db.use().queryNumber("SELECT count(1) FROM bookings WHERE room_id = ?", roomId).intValue();
        if (bookingCount > 0) throw new Exception("删除失败：已有玩家加入该房间！");

        Db.use().del("rooms", "id", roomId);
    }

    //获取排期表
    private void doGetSchedule(JSONObject json, Map<String, Object> map) throws Exception {
        String dateStr = json.getStr("date");
        if (dateStr == null || dateStr.isEmpty()) dateStr = DateUtil.today();

        String sql = "SELECT * FROM rooms WHERE start_time >= ? AND start_time < DATE_ADD(?, INTERVAL 1 DAY) ORDER BY start_time ASC";
        List<Entity> list = Db.use().query(sql, dateStr, dateStr);
        map.put("list", list);
    }

    //获取空闲 DM 列表
    private void doGetAvailableDMs(JSONObject json, Map<String, Object> map) throws Exception {
        DateTime startTime;
        DateTime endTime;

        if (json.containsKey("room_id") && !json.getStr("room_id").isEmpty()) {
            String roomId = json.getStr("room_id");
            Entity room = Db.use().queryOne("SELECT start_time, end_time FROM rooms WHERE id = ?", roomId);
            if (room == null) throw new Exception("房间不存在");
            startTime = DateTime.of(room.getDate("start_time"));
            endTime = DateTime.of(room.getDate("end_time"));
        }

        else if (json.containsKey("script_id") && json.containsKey("start_time")) {
            String scriptId = json.getStr("script_id");
            String startTimeStr = json.getStr("start_time");

            if (scriptId.isEmpty() || startTimeStr.isEmpty()) {
                map.put("list", Collections.emptyList()); // 参数不全，不返回名单
                return;
            }

            startTime = DateUtil.parse(startTimeStr);
            // 查剧本时长算出结束时间
            Integer duration = Db.use().queryNumber("SELECT duration_minutes FROM scripts WHERE id = ?", scriptId).intValue();
            endTime = DateUtil.offset(startTime, DateField.MINUTE, duration);
        } else {
            // 参数不足，无法计算闲忙
            map.put("list", Collections.emptyList());
            return;
        }

        // 核心查询逻辑：找出这段时间没空的 DM ID，然后排除他们
        // 注意：这里排除了 dm_id 为空的房间，因为那是没人负责的
        String sql = "SELECT id, username FROM users WHERE role = 'DM' AND id NOT IN (" +
                "SELECT dm_id FROM rooms WHERE dm_id IS NOT NULL " +
                "AND status IN ('WAITING', 'LOCKED', 'PLAYING') " +
                "AND (start_time < ? AND end_time > ?))"; // 时间重叠逻辑

        List<Entity> dms = Db.use().query(sql, endTime, startTime);
        map.put("list", dms);
    }

    //指派DM
    private void doAssignDM(JSONObject json) throws Exception {
        String roomId = json.getStr("room_id");
        String dmId = json.getStr("dm_id");
        if (dmId == null || dmId.isEmpty()) throw new Exception("请选择 DM");

        Db.use().update(Entity.create().set("dm_id", dmId), Entity.create("rooms").set("id", roomId));
    }
}