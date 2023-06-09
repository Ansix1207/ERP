package hana.teamfour.addminhana.service;

import hana.teamfour.addminhana.DAO.AccountDAO;
import hana.teamfour.addminhana.DAO.ProductDAO;
import hana.teamfour.addminhana.DTO.AccountDTO;
import hana.teamfour.addminhana.DTO.ProductDTO;
import hana.teamfour.addminhana.entity.AccountEntity;
import hana.teamfour.addminhana.entity.ProductEntity;

import java.sql.SQLException;

public class LoanJoinService {
    private ProductDAO productDAO;
    private AccountDAO accountDAO;

    public LoanJoinService() {
        this.productDAO = new ProductDAO();
        this.accountDAO = new AccountDAO();
    }

    public boolean insertLoanJoin(AccountDTO accountDTO) {
        // AccountEntity accountEntity = new AccountEntity(accountDTO);
        boolean isSuccess = false;
        try {
            isSuccess = accountDAO.insertAccount(accountDTO.toEntity(accountDTO));
            System.out.println("Service 결과: " + isSuccess);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return isSuccess;
    }

    private AccountEntity convertToAccountEntity(AccountDTO productJoinDTO, ProductDTO productDTO) {
        AccountEntity accountEntity = new AccountEntity();

        accountEntity.setAcc_id(productJoinDTO.getAcc_id());
        accountEntity.setAcc_cid(productJoinDTO.getAcc_cid());
        accountEntity.setAcc_date(productJoinDTO.getAcc_date());
        accountEntity.setAcc_balance(productJoinDTO.getAcc_balance());
        accountEntity.setAcc_password(productJoinDTO.getAcc_password());

        accountEntity.setAcc_pid(productDTO.getP_id());
        accountEntity.setAcc_p_category(productDTO.getP_category());
        accountEntity.setAcc_pname(productDTO.getP_name());
        accountEntity.setAcc_interestrate(productDTO.getP_interestrate());
        accountEntity.setAcc_collateralvalue(productJoinDTO.getAcc_collateralvalue());

        accountEntity.setAcc_interest_day(productJoinDTO.getAcc_interest_day());
        accountEntity.setAcc_contract_month(productDTO.getP_contract_month());
        accountEntity.setAcc_maturitydate(productJoinDTO.getAcc_maturitydate());
        accountEntity.setAcc_isactive(productJoinDTO.getAcc_isactive());

        System.out.println(accountEntity);
        return accountEntity;
    }

    public ProductDTO getProductDTO(Integer pid) {
        ProductEntity productEntity = productDAO.getProductByPId(pid);

        Integer p_id = productEntity.getP_id();
        String p_category = productEntity.getP_category();
        String p_name = productEntity.getP_name();
        String p_description = productEntity.getP_description();
        Double p_interestrate = productEntity.getP_interestrate();
        Double p_collateralrate = productEntity.getP_collateralrate();
        Integer p_contract_month = productEntity.getP_contract_month();
        ProductDTO productDTO = new ProductDTO(p_id, p_category, p_name, p_description, p_interestrate, p_collateralrate, p_contract_month);
        return productDTO;
    }
}
