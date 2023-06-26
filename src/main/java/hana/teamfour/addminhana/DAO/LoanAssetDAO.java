package hana.teamfour.addminhana.DAO;

import hana.teamfour.addminhana.entity.AssetEntity;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class LoanAssetDAO {
    private DataSource dataFactory;
    private Connection conn = null;
    private PreparedStatement ps = null;
    private ResultSet rs = null;

    public LoanAssetDAO() {
        try {
            Context ctx = new InitialContext();
            Context envContext = (Context) ctx.lookup("java:/comp/env");
            dataFactory = (DataSource) envContext.lookup("jdbc/oracle");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public AssetEntity getLoanAsset(Integer id) {
        AssetEntity assetEntity = new AssetEntity();

        try {
            conn = dataFactory.getConnection();

            String sql = "select ass_loan " +
                    "from asset " +
                    "WHERE C_ID = ?";

            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();

            System.out.println("LoanAssetDAO 로드 성공");

            while (rs.next()) {
                assetEntity.setAss_loan(rs.getInt(1));
            }

            conn.close();
            ps.close();
            rs.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return assetEntity;
    }
}
