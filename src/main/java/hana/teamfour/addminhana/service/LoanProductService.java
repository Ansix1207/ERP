package hana.teamfour.addminhana.service;

import hana.teamfour.addminhana.DAO.LoanProductDAO;
import hana.teamfour.addminhana.entity.ProductEntity;

import java.util.ArrayList;

public class LoanProductService {
    private final LoanProductDAO loanProductDao;

    public LoanProductService(LoanProductDAO loanProductDao) {
        this.loanProductDao = loanProductDao;
    }

    public ArrayList<ProductEntity> getLoanProductList(String query, int page) {
        return loanProductDao.getLoanProductList(query, page);
    }

    public ArrayList<ProductEntity> getLoanProductList(String field, String query, int page) {
        return loanProductDao.getLoanProductList(query, page);
    }

    public ArrayList<ProductEntity> getSearchLoanProductList(String field, String query, int page) {
        ArrayList<ProductEntity> productEntityList = new ArrayList<>();
        return loanProductDao.getSearchLoanProductList(query, page);
    }
}
