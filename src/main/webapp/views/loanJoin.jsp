<%--
  Created by IntelliJ IDEA.
  User: 하나로H012
  Date: 2023-06-16
  Time: 오후 5:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="hana.teamfour.addminhana.entity.ProductEntity" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="hana.teamfour.addminhana.DTO.*" %>
<%
  request.setCharacterEncoding("UTF-8");
  String contextPath = request.getContextPath();
  ProductJoinDTO productJoinDTO = (ProductJoinDTO) request.getAttribute("productJoinDTO");
  ProductDTO productDTO = (ProductDTO) request.getAttribute("productDTO");


%>
<% Boolean isSuccess = (Boolean) request.getAttribute("isSuccess");
  System.out.println("isSuccess: " + isSuccess);
%>
<% if (isSuccess != null && isSuccess) { %>
<script>
    var alertMessage = "해당금융상품이 등록되었습니다";
    alert(alertMessage);
</script>
<% } else if (isSuccess != null && !isSuccess) {%>
<script>
    var alertMessage = "등록이 안되었습니다. 다시 시도해주세요";
    alert(alertMessage);
</script>
<% } else {%>
<script>
    var alertMessage = "다시 입력해주세요";
    alert(alertMessage);
</script>

<%}%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous"/>
  <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
  <link rel="stylesheet" href="<%=contextPath%>/resources/css/nav.css">
  <link rel="stylesheet" href="<%=contextPath%>/resources/css/loanJoin.css ">
  <link rel="stylesheet" href="<%=contextPath%>/resources/css/base.css ">
  <title>금융상품가입</title>
</head>
<body>
  <div class="wrap">
    <nav id="layoutSidenav_nav">
      <%@ include file="common/navbar.jsp" %>
    </nav>
    <main>
      <form action="loanjoin" method="POST">
        <div class="container">
          <div class="row justify-content-center">
            <div class="col-lg-7">
              <div class="card shadow-lg border-0 rounded-lg mt-5">
                <div class="card-header"><h3 class="text-center font-weight-light my-4">금융상품가입</h3></div>
                <div class="card-body">

                  <div class="form-floating mb-3">
                    <label>이름</label>
                    <input class="form-control" name="ACC_PASSWORD" value="남성희" type="text">
                  </div>
                  <div class="form-floating mb-3">
                    <label>비밀번호</label>
                    <input class="form-control" name="ACC_PASSWORD" value="${ACC_PASSWORD}" type="text">
                  </div>
                  <div class="form-floating mb-3">
                    <label>상품종류</label>
                    <input class="form-control" name="ACC_P_CATEGORY" value="" type="text">
                  </div>
                  <div class="form-floating mb-3">
                    <label>상품명</label>
                    <input class="form-control" name="ACC_P_NAME" value="" type="text">
                  </div>
                  <div class="form-floating mb-3">
                    <label>이자율</label>
                    <input class="form-control" name="ACC_INTERESTRATE" value="${ACC_INTERESTRATE}"
                           type="text">
                  </div>
                  <div class="form-floating mb-3">
                    <label>담보가액</label>
                    <input class="form-control" name="ACC_COLLATERALVALUE" value="${ACC_COLLATERALVALUE}"
                           type="text">
                  </div>
                  <div>
                    <label>
                      <%String P_Name = (String) request.getSession().getAttribute("P_Name"); %>
                      <%=P_Name%>
                    </label>
                  </div>


                  <div class="d-grid">
                    <button onclick="reloadPage()" type="submit" class="btn btn-primary btn-block" id="signButton">신규 손님
                      가입
                    </button>
                  </div>
                </div>
              </div>
            </div>
      </form>
    </main>
  </div>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"
          integrity="sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz"
          crossorigin="anonymous"></script>
  <script>
      function reloadPage() {
          location.reload();
      }
  </script>
</body>
</html>
