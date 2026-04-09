package Servlet.Player;

import cn.hutool.core.codec.Base64;
import cn.hutool.core.date.DateUtil;
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
import java.util.HashMap;
import java.util.Map;

@SuppressWarnings("all")
@WebServlet("/Player")
public class PlayerServlet extends HttpServlet {

    private static final String ABSOLUTE_RESOURCE_PATH = "C:\\Users\\480900462\\IdeaProjects\\JAVA_WEB_Work\\src\\main\\resources";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/json;charset=UTF-8");

        Map<String, Object> map = new HashMap<>();
        String info = "SUCCESS";

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("id") == null || !"PLAYER".equals(session.getAttribute("role"))) {
            resp.getWriter().write(JSONUtil.toJsonStr(Map.of("info", "请先登录玩家账号")));
            return;
        }

        Object userId = session.getAttribute("id");

        try {
            String body = IoUtil.read(req.getReader());
            if(body.isEmpty()) body="{}";
            JSONObject json = JSONUtil.parseObj(body);
            String action = json.getStr("action");

            if ("join_room".equals(action)) {
                doJoinRoom(userId, json);
            }
            else if ("cancel_booking".equals(action)) {
                doCancelBooking(userId, json);
            }
            else if ("get_my_bookings".equals(action)) {
                doGetMyBookings(userId, map);
            }
            else if ("recharge".equals(action)) {
                doRecharge(userId, json);
            }
            else if ("submit_review".equals(action)) {
                doSubmitReview(userId, json);
            }
            else if ("get_review".equals(action)) {
                doGetReview(userId, json, map);
            }
            else if ("get_wallet_logs".equals(action)) {
                // 获取最近 20 条流水
                map.put("list", Db.use().query("SELECT * FROM wallet_logs WHERE user_id = ? ORDER BY create_time DESC LIMIT 20", userId));
            }
            else if ("get_profile_info".equals(action)) {
                doGetProfileInfo(userId, map);
            }
            else if ("update_profile".equals(action)) {
                doUpdateProfile(req, userId, json);
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


    // 查询除了密码以外的个人信息
    private void doGetProfileInfo(Object userId, Map<String, Object> map) throws Exception {

        Entity user = Db.use().queryOne("SELECT id, username, role, balance, frozen_balance, reputation_score, avatar_url, created_at FROM users WHERE id = ?", userId);
        if (user == null) throw new Exception("用户数据不存在");
        map.put("data", user);
    }

    //更新个人数据
    private void doUpdateProfile(HttpServletRequest req, Object userId, JSONObject json) throws Exception {
        Entity update = Entity.create("users");
        boolean needUpdate = false;

        //处理密码修改
        String newPwd = json.getStr("password");
        if (newPwd != null && !newPwd.trim().isEmpty()) {
            update.set("password", DigestUtil.md5Hex(newPwd.trim()));
            needUpdate = true;
        }

        //处理头像上传
        String base64Data = json.getStr("avatar_url");
        if (base64Data != null && base64Data.startsWith("data:image")) {
            // 定义路径
            String path = ABSOLUTE_RESOURCE_PATH + "/upload/";
            if (!FileUtil.exist(path)) FileUtil.mkdir(path);

            String fileName = IdUtil.simpleUUID() + ".jpg";
            // 写入磁盘
            FileUtil.writeBytes(Base64.decode(base64Data.substring(base64Data.indexOf(",") + 1)), new File(path + fileName));

            // 存入数据库的相对路径
            String relativePath = "resources/upload/" + fileName;
            update.set("avatar_url", relativePath);
            needUpdate = true;

            req.getSession().setAttribute("avatar_url", relativePath);
        }

        if (needUpdate) {
            Db.use().update(update, Entity.create().set("id", userId));
        }
    }


    private void doGetMyBookings(Object userId, Map<String, Object> map) throws Exception {
        String sql = "SELECT b.id AS booking_id, b.room_id, r.status AS room_status, r.start_time, r.end_time, r.current_num, r.max_num, " +
                "s.id AS script_id, s.title, s.cover_url, s.tag_list, s.price, u.username AS dm_name, " +
                "(SELECT COUNT(1) FROM reviews rev WHERE rev.room_id = r.id AND rev.user_id = b.user_id) AS is_reviewed " +
                "FROM bookings b JOIN rooms r ON b.room_id = r.id JOIN scripts s ON r.script_id = s.id " +
                "LEFT JOIN users u ON r.dm_id = u.id WHERE b.user_id = ? ORDER BY r.start_time DESC";
        map.put("list", Db.use().query(sql, userId));
    }

    private void doJoinRoom(Object userId, JSONObject json) throws Exception {
        String roomId = json.getStr("room_id");

        // 开启数据库事务
        Db.use().tx(transaction -> {
            //检查用户状态 (信誉分、余额)
            Entity user = transaction.queryOne("SELECT balance, reputation_score FROM users WHERE id = ?", userId);
            if (user.getInt("reputation_score") < 60) throw new Exception("信誉分过低 (<60)，禁止上车");

            //检查房间状态 (是否满员、是否锁定)
            // 使用 FOR UPDATE 锁行，防止并发超卖
            Entity room = transaction.queryOne("SELECT * FROM rooms WHERE id = ? FOR UPDATE", roomId);
            if (room == null) {
                throw new Exception("房间不存在或已被删除 (Room ID: " + roomId + ")");
            }
            if (!"WAITING".equals(room.getStr("status"))) throw new Exception("房间已锁定或已结束");

            if (room.getInt("current_num") >= room.getInt("max_num")) throw new Exception("房间已满员");

            // 防止重复加入 (虽然bookings表有唯一索引，但这里预判一下更友好)
            int exist = transaction.queryNumber("SELECT count(1) FROM bookings WHERE user_id = ? AND room_id = ?", userId, roomId).intValue();
            if(exist > 0) throw new Exception("您已在车上，请勿重复加入");

            //检查余额
            // 必须 select price, title 两个字段，下面的日志才能取到标题
            Entity script = transaction.queryOne("SELECT price, title FROM scripts WHERE id = ?", room.getStr("script_id"));

            BigDecimal price = script.getBigDecimal("price");
            if (user.getBigDecimal("balance").compareTo(price) < 0) throw new Exception("余额不足，请先充值");

            //执行操作：
            //扣减余额，增加冻结资金
            transaction.execute("UPDATE users SET balance = balance - ?, frozen_balance = frozen_balance + ? WHERE id = ?", price, price, userId);
            //房间人数 + 1
            transaction.execute("UPDATE rooms SET current_num = current_num + 1 WHERE id = ?", roomId);

            //创建 Booking 记录
            transaction.insert(Entity.create("bookings")
                    .set("user_id", userId)
                    .set("room_id", roomId)
                    .set("frozen_amount", price)
                    .set("status", "JOINED")
                    .set("join_time", DateUtil.now()));

            //记录流水 (修改：类型改为 FREEZE，不计入营收)
            transaction.insert(Entity.create("wallet_logs")
                    .set("user_id", userId)
                    .set("type", "FREEZE") // 原来是 PAYMENT
                    .set("amount", price.negate()) // 记录为负数，表示冻结了一笔钱
                    .set("related_id", roomId)
                    .set("description", "预授权冻结: " + script.getStr("title")));
        });
    }

    private void doCancelBooking(Object userId, JSONObject json) throws Exception {
        String roomId = json.getStr("room_id");

        // 开启事务，确保资金、订单、房间人数要么全成功，要么全失败
        Db.use().tx(tx -> {
            //检查订单是否存在 (且状态必须是 BOOKED)
            Entity booking = tx.queryOne("SELECT * FROM bookings WHERE room_id = ? AND user_id = ? AND status = 'BOOKED'", roomId, userId);
            if (booking == null) throw new Exception("未找到您的有效拼车记录");

            //检查房间状态
            Entity room = tx.queryOne("SELECT * FROM rooms WHERE id = ?", roomId);
            // 如果游戏已经开始 (PLAYING) 或 结束 (FINISHED)，通常不允许直接跳车，或者需要联系 DM
            if ("PLAYING".equals(room.getStr("status")) || "FINISHED".equals(room.getStr("status"))) {
                throw new Exception("游戏已开始，无法自助取消，请联系店员");
            }

            BigDecimal frozenAmount = booking.getBigDecimal("frozen_amount");

            //资金回退
            // 并不是真正的“退款(REFUND)”，而是“解冻(UNFREEZE)”
            tx.execute("UPDATE users SET balance = balance + ?, frozen_balance = frozen_balance - ? WHERE id = ?",
                    frozenAmount, frozenAmount, userId);

            // 惩罚机制：扣除信誉分 (防止恶意跳车)
            // 只要跳车就扣 10 分，信誉分过低可能影响下次组局
            tx.execute("UPDATE users SET credit_score = credit_score - 10 WHERE id = ?", userId);

            // 删除订单
            // 物理删除 booking 记录，这样该位置可以被其他人再次预订
            tx.execute("DELETE FROM bookings WHERE id = ?", booking.get("id"));

            // 更新房间当前人数
            tx.execute("UPDATE rooms SET current_players = current_players - 1 WHERE id = ?", roomId);

            // 记录资金流水
            // 修改前：type = 'REFUND' (会被财务报表误读)
            // 修改后：type = 'UNFREEZE' (财务报表直接忽略，不影响营收统计)
            tx.insert(Entity.create("wallet_logs")
                    .set("user_id", userId)
                    .set("type", "UNFREEZE")
                    .set("amount", frozenAmount)    // 正数，表示资金回流到余额
                    .set("related_id", roomId)
                    .set("description", "取消拼车：资金解冻 (扣除10信誉分)"));
        });
    }

    //提交评价
    private void doSubmitReview(Object userId, JSONObject json) throws Exception {
        String roomId = json.getStr("room_id");
        int scriptScore = json.getInt("script_score");
        int dmScore = json.getInt("dm_score");
        String content = json.getStr("content");
        if (scriptScore < 1 || scriptScore > 5 || dmScore < 1 || dmScore > 5) throw new Exception("评分必须在 1-5 之间");
        Entity booking = Db.use().queryOne("SELECT * FROM bookings WHERE room_id = ? AND user_id = ?", roomId, userId);
        if (booking == null) throw new Exception("未找到您的参与记录");
        Entity room = Db.use().queryOne("SELECT script_id, dm_id, status FROM rooms WHERE id = ?", roomId);
        if (!"FINISHED".equals(room.getStr("status"))) throw new Exception("游戏尚未结束，无法评价");
        int count = Db.use().queryNumber("SELECT count(1) FROM reviews WHERE room_id = ? AND user_id = ?", roomId, userId).intValue();
        if (count > 0) throw new Exception("您已经评价过该场次");
        Db.use().insert(Entity.create("reviews").set("user_id", userId).set("room_id", roomId).set("script_id", room.get("script_id")).set("dm_id", room.get("dm_id")).set("script_score", scriptScore).set("dm_score", dmScore).set("content", content).set("create_time", DateUtil.now()));
    }

    //获取评价
    private void doGetReview(Object userId, JSONObject json, Map<String, Object> map) throws Exception {
        String roomId = json.getStr("room_id");
        Entity review = Db.use().queryOne("SELECT * FROM reviews WHERE room_id = ? AND user_id = ?", roomId, userId);
        if(review != null) map.put("data", review);
    }

    private void doRecharge(Object userId, JSONObject json) throws Exception {
        BigDecimal amount = json.getBigDecimal("amount");
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) throw new Exception("金额无效");
        Db.use().tx(tx -> {
            tx.execute("UPDATE users SET balance = balance + ? WHERE id = ?", amount, userId);
            tx.insert(Entity.create("wallet_logs").set("user_id", userId).set("type", "RECHARGE").set("amount", amount).set("description", "用户充值"));
        });
    }
}