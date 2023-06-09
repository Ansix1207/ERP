package hana.teamfour.addminhana.DAO;

import hana.teamfour.addminhana.entity.ProductEntity;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class LoanProductDAO {
    private DataSource dataFactory;
    private Connection conn;
    private PreparedStatement pstmt;


    public LoanProductDAO() {
        try {
            Context ctx = new InitialContext();
            Context envContext = (Context) ctx.lookup("java:/comp/env");
            dataFactory = (DataSource) envContext.lookup("jdbc/oracle");
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    public ArrayList<ProductEntity> getLoanProductList(int page) {
        ArrayList<ProductEntity> productEntityList = new ArrayList<>();
        try (Connection conn = dataFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement("select p_name, p_description, p_interestrate, p_category " +
                     "FROM (SELECT rownum AS num, p.*" +
                     "FROM (SELECT * FROM admin_hana.product) p)" +
                     "WHERE num BETWEEN ? AND ?")) {
            pstmt.setInt(1, 1 + (page - 1) * 5);
            pstmt.setInt(2, page * 5);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ProductEntity productEntity = new ProductEntity();
                    productEntity.setP_name(rs.getString(1));
                    productEntity.setP_description(rs.getString(2));
                    productEntity.setP_interestrate(rs.getDouble(3));
                    productEntity.setP_category(rs.getString(4));
                    productEntityList.add(productEntity);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return productEntityList;
    }

    public ArrayList<ProductEntity> getSearchLoanProductList(String query, int page) {
        ArrayList<ProductEntity> productEntityList = new ArrayList<>();
        try (Connection conn = dataFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement("SELECT p_id, p_name, p_description, p_interestrate , p_category " +
                     "FROM (SELECT rownum AS num, p.* " +
                     "FROM (SELECT * FROM admin_hana.product " +
                     "WHERE p_description LIKE ? or p_name LIKE ? ) p) " +
                     "WHERE num BETWEEN ? AND ?")) {
            pstmt.setString(1, "%" + query + "%");
            pstmt.setString(2, "%" + query + "%");
            pstmt.setInt(3, 1 + (page - 1) * 5);
            pstmt.setInt(4, page * 5);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ProductEntity productEntity = new ProductEntity();
                    productEntity.setP_id(rs.getInt("p_id"));
                    productEntity.setP_name(rs.getString("p_name"));
                    productEntity.setP_description(rs.getString("p_description"));
                    productEntity.setP_interestrate(rs.getDouble("p_interestrate"));
                    productEntity.setP_category(rs.getString("p_category"));
                    productEntityList.add(productEntity);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return productEntityList;
    }

    
    public int getProductCount(String query) {
        int count = 0;
        try (Connection conn = dataFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(
                     "SELECT count(*) " +
                             "FROM admin_hana.product " +
                             "WHERE p_description LIKE ? OR p_name LIKE ?")) {

            pstmt.setString(1, "%" + query + "%");
            pstmt.setString(2, "%" + query + "%");

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    public Map<String, Integer> getAccountCountByCategory() {
        Map<String, Integer> accountCountMap = new HashMap<>();
        try (Connection conn = dataFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(
                     "SELECT P_CATEGORY, COUNT(*) " + "FROM product " +
                             "GROUP BY P_CATEGORY")) {
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    String category = rs.getString("P_CATEGORY");
                    int count = rs.getInt(2);
                    accountCountMap.put(category, count);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return accountCountMap;
    }
}
