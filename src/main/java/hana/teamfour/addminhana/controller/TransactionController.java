package hana.teamfour.addminhana.controller;

import hana.teamfour.addminhana.DTO.AccountSummaryDTO;
import hana.teamfour.addminhana.DTO.DepositDTO;
import hana.teamfour.addminhana.DTO.TransferDTO;
import hana.teamfour.addminhana.DTO.WithdrawDTO;
import hana.teamfour.addminhana.service.AccountService;
import hana.teamfour.addminhana.service.TransactionService;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.DecimalFormat;

@WebServlet({"/deposit", "/withdraw", "/transfer"})
public class TransactionController extends HttpServlet {
    TransactionService transactionService;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        transactionService = new TransactionService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();
        RequestDispatcher dispatcher;

        if (action.equals("/deposit")) {
            request.setAttribute("title", "입금");
            dispatcher = request.getRequestDispatcher("views/transfer.jsp");
            dispatcher.forward(request, response);
        }
        if (action.equals("/withdraw")) {
            request.setAttribute("title", "출금");
            dispatcher = request.getRequestDispatcher("views/transfer.jsp");
            dispatcher.forward(request, response);
        }
        if (action.equals("/transfer")) {
            request.setAttribute("title", "계좌이체");
            dispatcher = request.getRequestDispatcher("views/transfer.jsp");
            dispatcher.forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) {
        String action = request.getServletPath();
        RequestDispatcher dispatcher = null;
        response.setContentType("text/html;charset=utf-8");
        String isCheck = request.getParameter("isCheck");
        try {
            if (action.equals("/deposit")) {
                request.setAttribute("title", "입금");
                doDeposit(request, response);
            }
            if (action.equals("/withdraw")) {
                request.setAttribute("title", "출금");
                //1. 계좌 비밀번호 확인 처리 부분
                if (isCheck != null && isCheck.equals("check")) {
                    //1-1. doCheckAndForward로 던진다.
                    doCheckAndForward(request, response);
                } else {
                    doWithdraw(request, response);
                }
            }
            if (action.equals("/transfer")) {
                request.setAttribute("title", "계좌이체");
                if (isCheck != null && isCheck.equals("check")) {
                    //1-1. doCheckAndForward로 던진다.
                    doCheckAndForward(request, response);
                } else {
                    doTransfer(request, response);
                }
            }
            dispatcher = request.getRequestDispatcher("views/transfer.jsp");
            dispatcher.forward(request, response);
        } catch (ServletException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        } catch (IOException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
    }

    public void doTransfer(HttpServletRequest request, HttpServletResponse response) {
        String accId = request.getParameter("acc_id");
        String password = request.getParameter("acc_password");
        String counterpartId = request.getParameter("counterpart_id");
        String amount = request.getParameter("t_amount");
        String message = request.getParameter("message");
        TransferDTO transferDTO = TransferDTO.builder()
                .acc_id(Integer.parseInt(accId))
                .acc_password(Integer.parseInt(password))
                .t_counterpart_id(Integer.parseInt(counterpartId))
                .t_amount(Integer.parseInt(amount))
                .t_description(message)
                .build();
        TransferDTO responseTransferDTO = transactionService.doTransfer(transferDTO);
        if (responseTransferDTO.getAcc_id() == null) {
            request.setAttribute("alert_message", responseTransferDTO.getMessage());
        } else {//성공한 경우
            request.setAttribute("alert_message", responseTransferDTO.getMessage() +
                    "\n출금 계좌번호: " + responseTransferDTO.getAcc_id() +
                    "\n입금 계좌번호 : " + responseTransferDTO.getT_counterpart_id() +
                    "\n거래 금액 : " + responseTransferDTO.getT_amount());
        }
    }

    public void doDeposit(HttpServletRequest request, HttpServletResponse response) {
        String accId = request.getParameter("counterpart_id");
        String amount = request.getParameter("t_amount");
        String message = request.getParameter("message");
        DepositDTO depositDTO = DepositDTO.builder()
                .acc_id(Integer.parseInt(accId))
                .t_amount(Integer.parseInt(amount))
                .t_description(message)
                .build();
        String result = transactionService.doDeposit(depositDTO);
        request.setAttribute("alert_message", result);
    }

    public WithdrawDTO doAccountPwdCheck(WithdrawDTO withdrawDTO) {
        // TODO: 2023/06/29 (비밀번호 체크 < = DTO => 서비스에서(false이면  <= ENTITY => DAO : return boolean (성공 실패)
        return transactionService.verifyAccountPassword(withdrawDTO);
    }

    //비밀번호 체크 로직
    public HttpServletRequest doCheckAndForward(HttpServletRequest request, HttpServletResponse response) {
        String acc_id = null;
        String acc_password = null;
        if (request.getParameter("acc_id") != null) {
            acc_id = request.getParameter("acc_id");
        }
        if (request.getParameter("acc_password") != null) {
            acc_password = request.getParameter("acc_password");
        }
        //필요한 DTO를 만들고
        WithdrawDTO requestWithdrawDTO = WithdrawDTO.builder()
                .acc_id(Integer.valueOf(acc_id))
                .acc_password(acc_password)
                .build();
        //DTO로 service -> DAO 로 던진다 .
        WithdrawDTO result = doAccountPwdCheck(requestWithdrawDTO);
        request.setAttribute("acc_id", request.getParameter("acc_id"));
        request.setAttribute("t_amount", request.getParameter("t_amount"));
        request.setAttribute("message", request.getParameter("message"));
        if (result.getAcc_balance() != null) {
            AccountService accountService = new AccountService(Integer.parseInt(acc_id));
            AccountSummaryDTO accountSummaryDTO = new AccountSummaryDTO();
            accountSummaryDTO = accountService.getAccSummary("출금");
            if (accountSummaryDTO.getAcc_id() != -999) {
                //출금 체크후에 balance 반환해야함.
                DecimalFormat decimalFormat = new DecimalFormat("#,###.##");
                request.setAttribute("acc_pname", accountSummaryDTO.getAcc_pname());
                request.setAttribute("counterpart_id", request.getParameter("counterpart_id"));
                request.setAttribute("acc_p_category", accountSummaryDTO.getAcc_p_category());
                request.setAttribute("acc_balance", decimalFormat.format(result.getAcc_balance())); //int 형 반환 balance
                request.setAttribute("acc_password", request.getParameter("acc_password"));
                request.setAttribute("alert_message", "비밀번호가 정상입니다.\\n");
                request.setAttribute("ck", "1");
            } else {
                request.setAttribute("alert_message", "출금이 불가능한 계좌입니다. (일반 입출금 통장만 가능)\\n");
            }
        } else {
            request.setAttribute("alert_message", "없는 계좌이거나 잘못된 비밀번호 입니다.\\n");
        }
        return request;
    }


    public void doWithdraw(HttpServletRequest request, HttpServletResponse response) {
        //2. 출금 처리 부분
        int accId = Integer.parseInt(request.getParameter("acc_id"));
        String message = request.getParameter("message");
        String pwd = request.getParameter("acc_password");
        int amount = Integer.parseInt(request.getParameter("t_amount"));
        WithdrawDTO requestWithdrawDTO = WithdrawDTO.builder()
                .acc_id(accId)
                .acc_password(pwd)
                .t_description(message)
                .build();
        requestWithdrawDTO.setT_amount(amount);
        WithdrawDTO responseWithdrawDTO = transactionService.doWithdraw(requestWithdrawDTO);
        //왜 여기에서 getAcc_id 가 null 이야?
        if (responseWithdrawDTO.getAcc_id() == null) {
            request.setAttribute("alert_message", "출금에 실패하였습니다. 사유(비밀번호 다름)");
        } else if (responseWithdrawDTO.getAcc_id() != null) {
            String responseAccId = responseWithdrawDTO.getAcc_id().toString();
            String responseAmount = responseWithdrawDTO.getT_amount().toString();
            String responseBalance = responseWithdrawDTO.getAcc_balance().toString();
            String text = "계좌번호 : " + responseAccId + "\n출금액 : " + responseAmount +
                    "\\n잔액 : " + responseBalance;
            request.setAttribute("alert_message", responseWithdrawDTO.getMessage() + "\\n" + text);
        } else {
            request.setAttribute("alert_message", responseWithdrawDTO.getMessage() + "출금에 실패하였습니다.");
        }
    }

    @Override
    public void destroy() {
        super.destroy();
    }
}
