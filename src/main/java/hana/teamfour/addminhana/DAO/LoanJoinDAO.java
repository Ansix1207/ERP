package hana.teamfour.addminhana.DAO;

import hana.teamfour.addminhana.entity.AccountEntity;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class LoanJoinDAO {
    private DataSource dataFactory;

    public LoanJoinDAO() {
        try {
            Context ctx = new InitialContext();
            Context envContext = (Context) ctx.lookup("java:/comp/env");
            dataFactory = (DataSource) envContext.lookup("jdbc/oracle");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean insertAccount(AccountEntity accountEntity) {
        boolean result = false;

        String sql = "INSERT INTO ACCOUNT VALUES(account_seq.nextval,101," +
                "?,?,?," +
                "select P_ID from product where p_name = ?," +
                "select P_CATEGORY from product where p_name = ?," +
                "select P_NAME from product where p_name = ?," +
                "select P_INTERESTRATE from product where p_name = ?," +
                "?," +
                "1," +
                "36," +
                "?,'Y')";
//        String sql = "INSERT INTO ACCOUNT VALUES(account_seq.nextval,?)";
//        select P_CONTRACT_MONTH from product where p_name = ?

        System.out.println("sql = " + sql);
        try (Connection connection = getDataFactoryConnection()) {
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setInt(1, accountEntity.getAcc_id());
//                PreparedStatement의 첫 번째 파라미터 위치에 accountEntity의 acc_id 값을 설정한다는 의미입니다.
                statement.setInt(2, accountEntity.getAcc_cid());
                statement.setTimestamp(3, accountEntity.getAcc_date());
                statement.setInt(4, accountEntity.getAcc_balance());
                statement.setString(5, accountEntity.getAcc_password());
                statement.setString(6, accountEntity.getAcc_pname());
                statement.setString(7, accountEntity.getAcc_pname());
                statement.setString(8, accountEntity.getAcc_pname());
                statement.setString(9, accountEntity.getAcc_pname());
                statement.setInt(10, accountEntity.getAcc_collateralvalue());
//                statement.setInt(11, accountEntity.getAcc_interest_day());
                statement.setString(11, accountEntity.getAcc_pname());
                statement.setTimestamp(12, accountEntity.getAcc_maturitydate());

                statement.executeUpdate(); // 데이터를 삽입?
                result = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            result = false;
        }
        System.out.println("pass" + new AccountEntity());
        return result;
    }

    private Connection getDataFactoryConnection() throws SQLException {
        if (dataFactory == null) {
            throw new SQLException("DataFactory is null");
        }
        return dataFactory.getConnection();
    }
}
