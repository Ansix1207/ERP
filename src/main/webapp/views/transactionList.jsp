<%@ page import="java.util.List" %>
<%@ page import="hana.teamfour.addminhana.DTO.TransactionDTO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="hana.teamfour.addminhana.DTO.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: chaedongim
  Date: 2023/07/01
  Time: 4:56 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<%
  request.setCharacterEncoding("UTF-8");
  String contextPath = request.getContextPath();
  List<TransactionDTO> transactionList = new ArrayList<>();
  List<TransactionDTO> tempList = (List<TransactionDTO>) request.getAttribute("transactionList");
  if (tempList != null) {
    transactionList = tempList;
  }
  Integer transactionCount = (Integer) request.getAttribute("transactionCount");
  String _page = request.getParameter("page");
  String size = request.getParameter("size");
  String orderBy = request.getParameter("orderBy");
  String ordering = request.getParameter("ordering");
  String search = request.getParameter("search");
  String t_accid = request.getParameter("t_accid");
  if (_page == null) {
    _page = "1";
  }
  if (size == null) {
    size = "10";
  }
  if (orderBy == null) {
    orderBy = "c_id";
  }
  if (search == null) {
    search = "%";
  }
  if (ordering == null) {
    ordering = "asc";
  }
  // TODO:임시 에러 방지 코드
  if (t_accid == null) {
    t_accid = "1";
  }

  DecimalFormat decimalFormat = new DecimalFormat("#,###.##");

%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous"/>
  <link rel="stylesheet" href="<%=contextPath%>/resources/css/nav.css">
  <link rel="stylesheet" href="<%=contextPath%>/resources/css/base.css">
  <link rel="stylesheet" href="<%=contextPath%>/resources/css/transactionList.css">
  <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
  <title>Admin Hana - transactionList.jsp</title>
</head>
<body>
  <div class="wrap">
    <nav id="layoutSidenav_nav">
      <%@ include file="common/navbar.jsp" %>
    </nav>

    <main>
      <div class="card m-4">
        <div class="card-header">
          <svg height="20px" width="20px" class="svg-inline--fa fa-table me-1" aria-hidden="true" focusable="false"
               data-prefix="fas"
               data-icon="table" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" data-fa-i2svg="">
            <path fill="currentColor"
                  d="M64 256V160H224v96H64zm0 64H224v96H64V320zm224 96V320H448v96H288zM448 256H288V160H448v96zM64 32C28.7 32 0 60.7 0 96V416c0 35.3 28.7 64 64 64H448c35.3 0 64-28.7 64-64V96c0-35.3-28.7-64-64-64H64z"></path>
          </svg>
          계좌 거래 리스트
        </div>

        <div class="card-body">
          <div class="datatable-wrapper datatable-loading no-footer sortable searchable fixed-columns">
            <div class="datatable-top">
              <div class="datatable-dropdown"></div>
              <div class="datatable-search d-flex gap-4">
                <form class="searchForm">
                  <input class="datatable-input" name="searchInput" placeholder="Search..." type="search"
                         title="Search within table"
                         aria-controls="datatablesSimple">
                  <button type="submit">검색</button>
                </form>
                <form class="accountForm">
                  <input class="datatable-input" name="accountInput" placeholder="계좌번호를 입력하세요..." type="search"
                         title="Account within table"
                         aria-controls="datatablesSimple">
                  <button type="submit">계좌 조회</button>
                </form>
              </div>
            </div>
            <div class="datatable-container">
              <table id="datatablesSimple" class="datatable-table">
                <thead id="columnHead">

                </thead>
                <tbody>
                <%
                  for (int i = 0; i < transactionList.size(); i++) {
                %>
                <tr data-index="<%=i%>">
                  <td style="width: 2rem;"><%=transactionList.get(i).getT_id()%>
                  </td>
                  <td style="width: 2rem;"><%=transactionList.get(i).getT_type() == '+' ? "입금" : "출금"%>
                  </td>
                  <td style="width: 4rem;">₩ <%=decimalFormat.format(transactionList.get(i).getT_amount()) %>
                  </td>
                  <td style="width: 4rem;">₩ <%=decimalFormat.format(transactionList.get(i).getT_balance())%>
                  </td>
                  <td style="width: 2rem;"><%=transactionList.get(i).getT_accid()%>
                  </td>
                  <td style="width: 2rem;"><%=transactionList.get(i).getT_counterpart_id() == 0 ? "창구 입금" : transactionList.get(i).getT_counterpart_id()%>
                  </td>
                  <td style="width: 8rem;"><%=transactionList.get(i).getT_description()%>
                  </td>
                  <td style="width: 6rem;"><%=transactionList.get(i).getT_date()%>
                  </td>
                    <%
                  }
                %>
                </tbody>
              </table>
            </div>
            <div class="datatable-bottom">
              <div class="datatable-info">Showing <%=transactionList.size()%> Transaction of <%=transactionCount%>
                Transactions
              </div>
              <nav class="datatable-pagination">
                <ul class="datatable-pagination-list"></ul>
              </nav>
            </div>
          </div>
        </div>
      </div>

    </main>
  </div>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"
          integrity="sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz"
          crossorigin="anonymous"></script>
  <script>
      const t_accid = <%=t_accid%>;
      const page = <%=_page%>;
      const size = <%=size%>;
      const search = '<%=search %>';
      const orderBy = '<%=orderBy %>';
      const ordering = '<%=ordering %>';
      const transactionCount = <%=transactionCount%>;
  </script>
  <script src="<%=contextPath%>/resources/js/transactionList.js"></script>
</body>
</html>
