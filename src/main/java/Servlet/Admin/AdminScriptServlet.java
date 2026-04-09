package Servlet.Admin;

import cn.hutool.core.codec.Base64;
import cn.hutool.core.date.DateUtil;
import cn.hutool.core.io.FileUtil;
import cn.hutool.core.io.IoUtil;
import cn.hutool.core.util.IdUtil;
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
import java.util.HashMap;
import java.util.Map;

@SuppressWarnings("all")
@WebServlet("/AdminScript")
public class AdminScriptServlet extends HttpServlet {

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
            JSONObject json = JSONUtil.parseObj(IoUtil.read(req.getReader()));
            String action = json.getStr("action");
            String title = json.getStr("title");

            String coverUrl = null;
            String base64 = json.getStr("cover_url");

            if (base64 != null && base64.startsWith("data:image")) {
                // 使用绝对路径 + /upload/
                String path = ABSOLUTE_RESOURCE_PATH + "/upload/";

                if (!FileUtil.exist(path)) FileUtil.mkdir(path);
                String fileName = IdUtil.simpleUUID() + ".jpg";
                // 写入文件到源码目录
                FileUtil.writeBytes(Base64.decode(base64.substring(base64.indexOf(",") + 1)), new File(path + fileName));

                coverUrl = "resources/upload/" + fileName;
            } else {
                // 如果没有上传新图，原来的 url，保持原样
                coverUrl = base64;
            }

            //添加剧本
            if ("add".equals(action)) {
                int count = Db.use().queryNumber("SELECT count(1) FROM scripts WHERE title = ?", title).intValue();
                if (count > 0) {
                    throw new Exception("剧本《" + title + "》已存在，请勿重复录入！");
                }
                Entity script = Entity.create("scripts")
                        .set("title", json.getStr("title"))
                        .set("description", json.getStr("description"))
                        .set("cover_url", coverUrl)
                        .set("price", json.getBigDecimal("price"))
                        .set("difficulty", json.getInt("difficulty"))
                        .set("duration_minutes", json.getInt("duration_minutes"))
                        .set("player_count", json.getInt("player_count"))
                        .set("tag_list", json.getStr("tag_list"));
                Db.use().insert(script);
            }
            else {
                // 编辑或删除前，检查冲突
                String id = json.getStr("id");
                // 检查未来一个月内是否有该剧本的未完结场次
                String checkSql = "SELECT count(1) FROM rooms WHERE script_id = ? AND start_time >= NOW() AND start_time <= ? AND status IN ('WAITING', 'LOCKED', 'PLAYING')";
                int conflicts = Db.use().queryNumber(checkSql, id, DateUtil.endOfMonth(DateUtil.offsetMonth(DateUtil.date(), 1))).intValue();

                if (conflicts > 0) throw new Exception("未来一个月内有 " + conflicts + " 场该剧本的预约，无法编辑或删除");

                if ("edit".equals(action)) {
                    int count = Db.use().queryNumber("SELECT count(1) FROM scripts WHERE title = ? AND id != ?", title, id).intValue();
                    if (count > 0) {
                        throw new Exception("剧本名《" + title + "》与其他剧本冲突，请修改！");
                    }
                    Entity update = Entity.create("scripts")
                            .set("title", json.getStr("title"))
                            .set("description", json.getStr("description"))
                            .set("price", json.getBigDecimal("price"))
                            .set("difficulty", json.getInt("difficulty"))
                            .set("duration_minutes", json.getInt("duration_minutes"))
                            .set("player_count", json.getInt("player_count"))
                            .set("tag_list", json.getStr("tag_list"));

                    // 只有当有新图片或者确实有 url 时才更新封面字段
                    if(coverUrl != null) update.set("cover_url", coverUrl);

                    Db.use().update(update, Entity.create().set("id", id));
                }
                else if ("delete".equals(action)) {
                    Db.use().del("scripts", "id", id);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            info = "操作失败: " + e.getMessage();
        }

        map.put("info", info);
        resp.getWriter().write(JSONUtil.toJsonStr(map));
    }
}