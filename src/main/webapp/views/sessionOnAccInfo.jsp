<%@ page import="java.util.ArrayList" %>
<%@ page import="hana.teamfour.addminhana.entity.AccountEntity" %>
<%@ page import="hana.teamfour.addminhana.entity.AssetEntity" %><%--
Created by IntelliJ IDEA.
User: jiyou
Date: 2023-06-17
Time: 오후 7:01
To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%
  request.setCharacterEncoding("UTF-8");
  String contextPath = request.getContextPath();

  // 계좌 정보
  ArrayList<AccountEntity> accountEntity = (ArrayList<AccountEntity>) request.getAttribute("accountEntity");

  // 계좌 type (예금/적금/대출)
  String productType = request.getAttribute("productType").toString();

  // 자산
  AssetEntity assetEntity = (AssetEntity) request.getAttribute("assetEntity");
  Integer asset = 0;

  // 계좌 자산 비율
  Integer[] accountRate;
  String[] assetCategory;

  if (productType.equals("대출")) {
    accountRate = (Integer[]) request.getAttribute("loanRate");
    assetCategory = new String[]{"신용", "담보"};
    if (assetEntity.getAss_loan() != null) asset = assetEntity.getAss_loan();
  }
  else if (productType.equals("예금")) {
    accountRate = (Integer[]) request.getAttribute("depositRate");
    assetCategory = new String[] {"보통", "정기"};
    if (assetEntity.getAss_deposit() != null) asset = assetEntity.getAss_deposit();
  }
  else {
    accountRate = (Integer[]) request.getAttribute("savingsRate");
    assetCategory = new String[] {"자유", "정기"};
    if (assetEntity.getAss_savings() != null) asset = assetEntity.getAss_savings();
  }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Title</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"
      integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous"/>
  <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/resources/css/nav.css">
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/resources/css/sessionOnAccInfo.css?ver=1">
  <script src="https://cdn.jsdelivr.net/npm/chart.js@2.8.0"></script>
</head>
<body>
<div class="wrap">
  <%@ include file="common/navbar.jsp" %>
  <main>
    <div class="container">
      <div class="row">
        <div class="col">
          <div class="statistics_situation card">
            <div class="card-body">
              <h1 class="card-title"><%-- 손님 이름 --%>님의 <%=productType%> 현황</h1>
              <div class="asset_info">
                <h3>자산 정보</h3>
                <p><span>총 <%=productType%>액</span> <span>₩ <%=asset%></span></p>
                <div class="statistics_graph">
                  <%-- 손님의 대출 자산 현황 그래프 --%>
                  <canvas id="asset_chart"></canvas>
                </div>
              </div>
              <div class="signedup_product">
                <h3>가입 상품</h3>
                <div>
                  <%-- 가입된 상품 리스트 --%>
                  <%
                    for (int i = 0; i < accountEntity.size(); i++) {
                  %>
                  <div>
                    <span><%=accountEntity.get(i).getAcc_pname()%></span>
                    <span>만기일 <%=accountEntity.get(i).getAcc_maturitydate()%></span>
                    <span>이자율 <%=accountEntity.get(i).getAcc_interestrate()%></span>
                    <span>잔고 <%=accountEntity.get(i).getAcc_balance()%></span>
                  </div>
                  <%
                    }
                  %>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="search_box">
            <input class="form-control" type="text" placeholder="Search for..." aria-label="Search for..."
                 aria-describedby="btnNavbarSearch"/>
          </div>
        </div>
        <div class="col">
          <div class="recommend_product card">
            <div class="card-body">
              <h1 class="card-title">추천 <%=productType%> 상품</h1>
              <h3>추천</h3>
              <div>
                <%-- 추천 대출 상품 리스트 --%>
              </div>
            </div>
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
    data = {
        datasets: [{
            backgroundColor: ['#BF5AD8','#9E37D1'],
            data: [<%=accountRate[0]%>, <%=accountRate[1]%>]
        }],
        // 라벨의 이름이 툴팁처럼 마우스가 근처에 오면 나타남
        labels: ['<%=assetCategory[0]%>', '<%=assetCategory[1]%>']
    };

    // 도넛형 차트
    var ctx2 = document.getElementById("asset_chart");
    var myDoughnutChart = new Chart(ctx2, {
        type: 'doughnut',
        data: data,
        options: {}
    });
</script>
</body>
</html>