package Servlet.Admin;

import cn.hutool.core.date.DateUtil;
import cn.hutool.core.io.IoUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.db.Db;
import cn.hutool.db.Entity;
import cn.hutool.json.JSONObject;
import cn.hutool.json.JSONUtil;
import cn.hutool.poi.excel.ExcelUtil;
import cn.hutool.poi.excel.ExcelWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@SuppressWarnings("all")
@WebServlet("/AdminFinance")
public class AdminFinanceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("export_report".equals(action)) {
            doExportReport(req, resp);//下载报表
        } else {
            resp.getWriter().write("未知的Get请求");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/json;charset=UTF-8");

        Map<String, Object> map = new HashMap<>();
        String info = "SUCCESS";

        try {
            String body = IoUtil.read(req.getReader());
            if (body.isEmpty()) body = "{}";
            JSONObject json = JSONUtil.parseObj(body);
            String action = json.getStr("action");

            if ("user_flow".equals(action)) {//用户流水
                map.put("list", getUserFlowData(json.getStr("filter_date"), json.getStr("filter_type")));
            } else if ("store_finance".equals(action)) {//店铺营收
                map.put("list", getStoreFinanceData(json.getStr("filter_date")));
            } else if ("script_heat".equals(action)) {//剧本热度榜
                map.put("list", getScriptHeatData(json.getStr("filter_date")));
            } else if ("get_cash_inflows_today".equals(action)) { // 获取今日现金流入 (仅充值)
                String sql = "SELECT IFNULL(SUM(amount), 0) as total_recharge FROM wallet_logs WHERE type='RECHARGE' AND DATE(create_time) = CURDATE()";
                map.put("list", Db.use().query(sql));
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

    //用户流水查询
    private List<Entity> getUserFlowData(String filterDate, String filterType) throws Exception {
        String sql = "SELECT w.id, w.create_time, IFNULL(u.username, '已删除用户') as username, w.type, w.amount, w.description " +
                "FROM wallet_logs w LEFT JOIN users u ON w.user_id = u.id WHERE 1=1 ";

        if ("MONTH".equals(filterDate)) {
            sql += " AND DATE_FORMAT(w.create_time, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m') ";
        }

        if (StrUtil.isNotBlank(filterType) && !"ALL".equals(filterType)) {
            sql += " AND w.type = ? ";
            sql += " ORDER BY w.create_time DESC";
            return Db.use().query(sql, filterType);
        } else {
            sql += " ORDER BY w.create_time DESC";
            return Db.use().query(sql);
        }
    }

    //本店财务查询
    private List<Entity> getStoreFinanceData(String filterDate) throws Exception {
        // 这里的逻辑：查找所有 "PAYMENT" (扣款/收入) 类型的流水，并关联房间和剧本信息
        String sql = "SELECT w.id, w.create_time, IFNULL(s.title, '已删除剧本') as script_title, " +
                "IFNULL(u.username, '已删除用户') as username, ABS(w.amount) as revenue " +
                "FROM wallet_logs w " +
                "LEFT JOIN users u ON w.user_id = u.id " +
                "LEFT JOIN rooms r ON w.related_id = r.id " +
                "LEFT JOIN scripts s ON r.script_id = s.id " +
                "WHERE w.type = 'PAYMENT' ";

        if ("MONTH".equals(filterDate)) {
            sql += " AND DATE_FORMAT(w.create_time, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m') ";
        }
        sql += " ORDER BY w.create_time DESC";
        return Db.use().query(sql);
    }

    //剧本热度查询
    private List<Entity> getScriptHeatData(String filterDate) throws Exception {
        // 统计剧本的开局次数和总收入
        String sql = "SELECT s.title, s.avg_score, " +
                "COUNT(r.id) as play_count, " +
                "IFNULL(SUM(b.frozen_amount), 0) as total_income " + // 统计 booking 里的钱
                "FROM scripts s " +
                "LEFT JOIN rooms r ON s.id = r.script_id AND r.status = 'FINISHED' ";

        if ("MONTH".equals(filterDate)) {
            sql += " AND DATE_FORMAT(r.end_time, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m') ";
        }

        // 继续连接 bookings 算钱 (只有加入并结算的才算钱)
        sql += "LEFT JOIN bookings b ON r.id = b.room_id AND b.status = 'SETTLED' " +
                "GROUP BY s.id, s.title, s.avg_score " +
                "ORDER BY play_count DESC, total_income DESC " +
                "LIMIT 20"; // 取前20

        return Db.use().query(sql);
    }


    //导出 Excel
    private void doExportReport(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String tab = req.getParameter("tab");
        String filterDate = req.getParameter("filter_date");
        String filterType = req.getParameter("filter_type");

        try (ExcelWriter writer = ExcelUtil.getWriter(true)) { // true 表示 xlsx
            List<Entity> list;
            String fileName = "Report.xlsx";

            // 根据不同的 Tab 获取数据并设置表头
            if ("user_flow".equals(tab)) {
                fileName = "用户流水报表.xlsx";
                list = getUserFlowData(filterDate, filterType);

                // 设置表头别名 (将数据库字段映射为中文)
                writer.addHeaderAlias("id", "流水号");
                writer.addHeaderAlias("create_time", "时间");
                writer.addHeaderAlias("username", "用户");
                writer.addHeaderAlias("type", "类型");
                writer.addHeaderAlias("amount", "变动金额");
                writer.addHeaderAlias("description", "说明");

                // 只输出这些列
                writer.setOnlyAlias(true);

            } else if ("store_finance".equals(tab)) {
                fileName = "本店财务报表.xlsx";
                list = getStoreFinanceData(filterDate);

                writer.addHeaderAlias("id", "流水号");
                writer.addHeaderAlias("create_time", "入账时间");
                writer.addHeaderAlias("script_title", "剧本名称");
                writer.addHeaderAlias("username", "付款用户");
                writer.addHeaderAlias("revenue", "营收金额");
                writer.setOnlyAlias(true);

            } else if ("script_heat".equals(tab)) {
                fileName = "剧本热度报表.xlsx";
                list = getScriptHeatData(filterDate);

                writer.addHeaderAlias("title", "剧本名称");
                writer.addHeaderAlias("avg_score", "评分");
                writer.addHeaderAlias("play_count", "开局场次");
                writer.addHeaderAlias("total_income", "总营收");
                writer.setOnlyAlias(true);

            } else {
                resp.getWriter().write("Unknown Tab");
                return;
            }

            // 写入数据
            writer.write(list, true);

            // 设置 Response 响应头，触发下载
            resp.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;charset=utf-8");
            String encodedFileName = URLEncoder.encode(fileName, StandardCharsets.UTF_8);
            resp.setHeader("Content-Disposition", "attachment;filename=" + encodedFileName);

            // 输出流 flush
            ServletOutputStream out = resp.getOutputStream();
            writer.flush(out);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Export Error: " + e.getMessage());
        }
    }
}