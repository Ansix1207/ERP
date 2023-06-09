<%@ page import="hana.teamfour.addminhana.DTO.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="hana.teamfour.addminhana.entity.ProductEntity" %>
<%@ page import="java.lang.reflect.Array" %><%-- Created by IntelliJ IDEA. User: chaedongim Date: 2023/06/19 Time: 9:26 AM To change this template use File |
Settings | File Templates. --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
  request.setCharacterEncoding("UTF-8");
  String contextPath = request.getContextPath();
  Boolean hasUpdatedDescription = (Boolean) request.getAttribute("hasUpdatedDescription");

  // 손님 정보
  CustomerSummaryDTO customerSummaryDTO = (CustomerSummaryDTO) request.getAttribute("customerSummaryDTO");
  Integer ageRange = ((int) customerSummaryDTO.getC_age() / 10) * 10;
  String gender = customerSummaryDTO.getC_gender() == 'M' ? "남성" : "여성";
  String job = customerSummaryDTO.getC_job();
  // 계좌 정보
  ArrayList<AccountDTO> depositAccountList = (ArrayList<AccountDTO>) request.getAttribute("depositAccountList");
  ArrayList<AccountDTO> savingsAccountList = (ArrayList<AccountDTO>) request.getAttribute("savingsAccountList");
  ArrayList<AccountDTO> loanAccountList = (ArrayList<AccountDTO>) request.getAttribute("loanAccountList");
  String category = "전체 자산 현황";
  AssetDTO depositDTO = (AssetDTO) request.getAttribute("depositDTO");
  AssetDTO savingsDTO = (AssetDTO) request.getAttribute("savingsDTO");
  AssetDTO loanDTO = (AssetDTO) request.getAttribute("loanDTO");
  // 자산 정보
  Integer asset = 0;
  Integer deposit = 0;
  Integer savings = 0;
  Integer loan = 0;
  String[] assetCategory = new String[]{"보통예금", "정기예금", "자유적금", "정기적금", "신용대출", "담보대출"};
  String balance = "잔액";
  int[] accountBalance = new int[6];
  int idx = 0;
  if (depositAccountList != null && depositDTO != null) {
    Integer[] tempBalance = depositDTO.getBalance_sum();
    accountBalance[0] = tempBalance[0];
    accountBalance[1] = tempBalance[1];
    deposit = depositDTO.getAss_deposit();
    asset += deposit;
  }
  if (savingsAccountList != null && savingsDTO != null) {
    Integer[] tempBalance = savingsDTO.getBalance_sum();
    accountBalance[2] = tempBalance[0];
    accountBalance[3] = tempBalance[1];
    savings = savingsDTO.getAss_savings();
    asset += savings;
  }
  if (loanAccountList != null && loanDTO != null) {
    Integer[] tempBalance = loanDTO.getBalance_sum();
    accountBalance[4] = tempBalance[0];
    accountBalance[5] = tempBalance[1];
    loan = loanDTO.getAss_loan();
    asset += loan;
  }
  request.setAttribute("asset", asset);
  request.setAttribute("deposit", deposit);
  request.setAttribute("savings", savings);
  request.setAttribute("loan", loan);

  ArrayList<ProductEntity> depositRecByAge = (ArrayList<ProductEntity>) request.getAttribute("depositRecByAge");
  ArrayList<ProductEntity> depositRecByGender = (ArrayList<ProductEntity>) request.getAttribute("depositRecByGender");
  ArrayList<ProductEntity> depositRecByJob = (ArrayList<ProductEntity>) request.getAttribute("depositRecByJob");

  ArrayList<ProductEntity> savingsRecByAge = (ArrayList<ProductEntity>) request.getAttribute("savingsRecByAge");
  ArrayList<ProductEntity> savingsRecByGender = (ArrayList<ProductEntity>) request.getAttribute("savingsRecByGender");
  ArrayList<ProductEntity> savingsRecByJob = (ArrayList<ProductEntity>) request.getAttribute("savingsRecByJob");

  ArrayList<ProductEntity> loanRecByAge = (ArrayList<ProductEntity>) request.getAttribute("loanRecByAge");
  ArrayList<ProductEntity> loanRecByGender = (ArrayList<ProductEntity>) request.getAttribute("loanRecByGender");
  ArrayList<ProductEntity> loanRecByJob = (ArrayList<ProductEntity>) request.getAttribute("loanRecByJob");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
        rel="stylesheet"
        integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM"
        crossorigin="anonymous"/>
  <link rel="stylesheet" href="<%=contextPath%>/resources/css/base.css">
  <link rel="stylesheet" href="<%=contextPath%>/resources/css/nav.css"/>
  <link rel="stylesheet" href="<%=contextPath%>/resources/css/profile.css"/>
  <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
  <title>Admin Hana - profile</title>
</head>
<body>
  <div class="wrap">
    <nav id="layoutSidenav_nav">
      <%@ include file="common/navbar.jsp" %>
    </nav>

    <jsp:include page="common/toastSuccess.jsp" flush="false">
      <jsp:param name="title" value="업데이트 성공"/>
      <jsp:param name="subtitle" value="Success"/>
      <jsp:param name="description" value="업데이트에 성공했습니다. "/>
    </jsp:include>

    <jsp:include page="common/toastFail.jsp" flush="false">
      <jsp:param name="title" value="업데이트 실패"/>
      <jsp:param name="subtitle" value="Fail"/>
      <jsp:param name="description" value="업데이트에 실패했습니다. "/>
    </jsp:include>

    <main>
      <div class="d-grid grid-cols-12 gap-4 w-100">
        <div class="col-span-8 column">
          <div class="card profileSummary">
            <div class="card-body">
              <h5 class="card-title">프로필</h5>
              <h6 class="card-subtitle mb-2">
                <span class="summaryCustomerName">${customerSummaryDTO.c_name} 손님</span>
                <span>만 ${customerSummaryDTO.c_age}세 / ${customerSummaryDTO.c_gender} / ${customerSummaryDTO.c_job}</span>
              </h6>
              <p class="card-text">${customerSummaryDTO.c_rrn}</p>
            </div>
          </div>

          <div class="col-span-1 h-full">
            <div class="card statisticsSituation h-full">
              <div class="card-body assetCardContainer gap-4">
                <div class="mb-4 assetInfo">
                  <h5 class="card-title mt-3 mb-2">자산 현황</h5>
                  <div class="d-flex justify-content-between align-items-center">
                    <p>
                      <span>자산 총액</span>
                      <span class="card-text">₩ 
                        <fmt:formatNumber type="number" maxFractionDigits="3" value="${asset}"/></span>
                    </p>
                    <form action="profile" method="post">
                      <button type="submit" class="btn btn-outline-secondary">새로고침</button>
                      <input type="hidden" name="action" value="asset-update">
                    </form>
                  </div>

                  <div class="statisticsChart">
                    <%-- 손님의 대출 자산 현황 그래프 --%>
                    <canvas class="assetChart" id="assetChart"></canvas>
                  </div>
                </div>
                <div class="signedupProduct">
                  <%-- 가입된 상품 리스트 --%>
                  <c:if test="${not empty depositAccountList}">
                    <p>
                      <span style="font-size:1.25rem;margin-right: 2rem;">예금 상품</span>
                      <span class="card-text">₩
                          <fmt:formatNumber type="number" maxFractionDigits="3" value="${deposit}"/>
                        </span>
                    </p>
                    <ul class="signedupProductList">
                      <%
                        for (AccountDTO account : depositAccountList) {
                      %>
                      <li>
                        <div class="productName">
                          <a class="accountLink"
                             href="<%=contextPath%>/transactionList?t_accid=<%=account.getAcc_id()%>&page=1&size=10">
                            <%=account.getAcc_pname()%>
                            <span class=" fs-10"> [계좌번호 : <%=account.getAcc_id()%>]
                          </span>
                          </a>
                        </div>
                        <span>만기일 <%=account.getAcc_str_maturitydate()%></span>
                        <span>이자율 <%=account.getAcc_interestrate()%>%</span>
                        <span><%=balance%> <%=account.getAcc_str_balance()%>원</span>
                      </li>
                      <%
                        }
                      %>
                    </ul>
                  </c:if>
                  <c:if test="${not empty savingsAccountList}">
                    <p>
                      <span style="font-size:1.25rem;margin-right: 2rem;">적금 상품</span>
                      <span class="card-text">₩
                        <fmt:formatNumber type="number" maxFractionDigits="3" value="${savings}"/>
                      </span>
                    </p>
                    <ul class="signedupProductList">
                      <%
                        for (AccountDTO account : savingsAccountList) {
                      %>
                      <li>
                        <div class="productName">
                          <a class="accountLink"
                             href="<%=contextPath%>/transactionList?t_accid=<%=account.getAcc_id()%>&page=1&size=10">
                            <%=account.getAcc_pname()%>
                            <span class=" fs-10"> [계좌번호 : <%=account.getAcc_id()%>]</span>
                          </a>
                        </div>
                        <span>만기일 <%=account.getAcc_str_maturitydate()%></span>
                        <span>이자율 <%=account.getAcc_interestrate()%>%</span>
                        <span><%=balance%> <%=account.getAcc_str_balance()%>원</span>
                      </li>
                      <%
                        }
                      %>
                    </ul>
                  </c:if>
                  <c:if test="${not empty loanAccountList}">
                    <p>
                      <span style="font-size:1.25rem;margin-right: 2rem;">대출 상품</span>
                      <span class="card-text">₩
                          <fmt:formatNumber type="number" maxFractionDigits="3" value="${loan}"/>
                        </span>
                    </p>
                    <ul class="signedupProductList">
                      <%
                        for (AccountDTO account : loanAccountList) {
                      %>
                      <li>
                        <div class="productName">
                          <a class="accountLink"
                             href="<%=contextPath%>/transactionList?t_accid=<%=account.getAcc_id()%>&page=1&size=10">
                            <%=account.getAcc_pname()%>
                            <span class=" fs-10"> [계좌번호 : <%=account.getAcc_id()%>]
                          </span>
                          </a>
                        </div>
                        <span>만기일 <%=account.getAcc_str_maturitydate()%></span>
                        <span>이자율 <%=account.getAcc_interestrate()%>%</span>
                        <span><%=balance%> <%=account.getAcc_str_balance()%>원</span>
                      </li>
                      <%
                        }
                      %>
                    </ul>
                  </c:if>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="col-span-4 column">
          <div class="card recommendationProducts">
            <div class="card-body">
              <h5 class="card-title mb-4">신규 추천 상품</h5>
              <div class="d-flex align-items-center">
                <h6 class="card-subtitle w-16 recommendationSubtitle ">예금 </h6>

                <a href="<%=contextPath%>/customer/depositInfo">
                  <button type="button" class="btn btn-sm btn-outline-secondary">전체보기 ></button>
                </a>
              </div>
              <div>
                <ul class="card-text  mb-4">
                  <%
                    for (int i = 0; i < 1; i++) {
                  %>
                  <li class="productItem">
                    <div class="d-flex flex-column">
                      <span class="productName">
                        <%=depositRecByAge.get(i).getP_name()%></span>
                      <span>이자율 <%=depositRecByAge.get(i).getP_interestrate()%>%</span>
                    </div>
                    <button onclick='location.href="loanjoin?pid=<%=depositRecByAge.get(i).getP_id()%>"' type="button"
                            class="btn btn-secondary rounded-pill joinBtn">가입
                    </button>
                  </li>
                  <%
                    }
                  %>
                  <%
                    for (int i = 0; i < 1; i++) {
                  %>
                  <li class="productItem">
                    <div class="d-flex flex-column">
                      <span class="productName"><%=depositRecByGender.get(i).getP_name()%></span>
                      <span>이자율 <%=depositRecByGender.get(i).getP_interestrate()%>%</span>
                    </div>
                    <button onclick='location.href="loanjoin?pid=<%=depositRecByGender.get(i).getP_id()%>"'
                            type="button"
                            class="btn btn-secondary rounded-pill joinBtn">가입
                    </button>
                  </li>
                  <%
                    }
                  %>
                  <%
                    for (int i = 0; i < 1; i++) {
                  %>
                  <li class="productItem">
                    <div class="d-flex flex-column">
                      <span class="productName"><%=depositRecByJob.get(i).getP_name()%></span>
                      <span>이자율 <%=depositRecByJob.get(i).getP_interestrate()%>%</span>
                    </div>
                    <button onclick='location.href="loanjoin?pid=<%=depositRecByJob.get(i).getP_id()%>"'
                            type="button"
                            class="btn btn-secondary rounded-pill joinBtn">가입
                    </button>
                  </li>
                  <%
                    }
                  %>
                </ul>
              </div>

              <div class="d-flex align-items-center">
                <h6 class="card-subtitle w-16 recommendationSubtitle ">적금 </h6>
                <a href="<%=contextPath%>/customer/savingsInfo">
                  <button type="button" class="btn btn-sm btn-outline-secondary">전체보기 ></button>
                </a>
              </div>
              <div>
                <ul class="card-text  mb-4">
                  <%
                    for (int i = 0; i < 1; i++) {
                  %>
                  <li class="productItem">
                    <div class="d-flex flex-column">
                      <span class="productName"><%=savingsRecByAge.get(i).getP_name()%></span>
                      <span>이자율 <%=savingsRecByAge.get(i).getP_interestrate()%>%</span>
                    </div>
                    <button onclick='location.href="loanjoin?pid=<%=savingsRecByAge.get(i).getP_id()%>"'
                            type="button"
                            class="btn btn-secondary rounded-pill joinBtn">가입
                    </button>
                  </li>
                  <%
                    }
                  %>
                  <%
                    for (int i = 0; i < 1; i++) {
                  %>
                  <li class="productItem">
                    <div class="d-flex flex-column">
                      <span class="productName"><%=savingsRecByGender.get(i).getP_name()%></span>
                      <span>이자율 <%=savingsRecByGender.get(i).getP_interestrate()%>%</span>
                    </div>
                    <button onclick='location.href="loanjoin?pid=<%=savingsRecByGender.get(i).getP_id()%>"'
                            type="button"
                            class="btn btn-secondary rounded-pill joinBtn">가입
                    </button>
                  </li>
                  <%
                    }
                  %>
                  <%
                    for (int i = 0; i < 1; i++) {
                  %>
                  <li class="productItem">
                    <div class="d-flex flex-column">
                      <span class="productName"><%=savingsRecByJob.get(i).getP_name()%></span>
                      <span>이자율 <%=savingsRecByJob.get(i).getP_interestrate()%>%</span>
                    </div>
                    <button onclick='location.href="loanjoin?pid=<%=savingsRecByJob.get(i).getP_id()%>"'
                            type="button"
                            class="btn btn-secondary rounded-pill joinBtn">가입
                    </button>
                  </li>
                  <%
                    }
                  %>
                </ul>
              </div>

              <div class="d-flex align-items-center">
                <h6 class="card-subtitle w-16 recommendationSubtitle ">대출 </h6>
                <a href="<%=contextPath%>/customer/loanInfo">
                  <button type="button" class="btn btn-sm btn-outline-secondary">전체보기 ></button>
                </a>
              </div>
              <div>
                <ul class="card-text  mb-4">
                  <%
                    for (int i = 0; i < 1; i++) {
                  %>
                  <li class="productItem">
                    <div class="d-flex flex-column">
                      <span class="productName"><%=loanRecByAge.get(i).getP_name()%></span>
                      <span>이자율 <%=loanRecByAge.get(i).getP_interestrate()%>%</span>
                    </div>
                    <button onclick='location.href="loanjoin?pid=<%=loanRecByAge.get(i).getP_id()%>"'
                            type="button"
                            class="btn btn-secondary rounded-pill joinBtn">가입
                    </button>
                  </li>
                  <%
                    }
                  %>
                  <%
                    for (int i = 0; i < 1; i++) {
                  %>
                  <li class="productItem">
                    <div class="d-flex flex-column">
                      <span class="productName"><%=loanRecByGender.get(i).getP_name()%></span>
                      <span>이자율 <%=loanRecByGender.get(i).getP_interestrate()%>%</span>
                    </div>
                    <button onclick='location.href="loanjoin?pid=<%=loanRecByGender.get(i).getP_id()%>"'
                            type="button"
                            class="btn btn-secondary rounded-pill joinBtn">가입
                    </button>
                  </li>
                  <%
                    }
                  %>
                  <%
                    for (int i = 0; i < 1; i++) {
                  %>
                  <li class="productItem">
                    <div class="d-flex flex-column">
                      <span class="productName"><%=loanRecByJob.get(i).getP_name()%></span>
                      <span>이자율 <%=loanRecByJob.get(i).getP_interestrate()%>%</span>
                    </div>
                    <button onclick='location.href="loanjoin?pid=<%=loanRecByJob.get(i).getP_id()%>"'
                            type="button"
                            class="btn btn-secondary rounded-pill joinBtn">가입
                    </button>
                  </li>
                  <%
                    }
                  %>
                </ul>
              </div>

            </div>
          </div>

          <div class="card customerDescriptionContainer">
            <div class="card-body">
              <h5 class="card-title">특이사항</h5>
              <p class="card-text customerDescriptions">
              <form class="descriptionForm" name="descriptionForm" method="post" action="profile"
                    accept-charset="utf-8">
              <textarea name="descriptionText" class="descriptionTextarea"
              <%--                        cols="35" rows="10"--%>
                        maxlength="300">${customerSummaryDTO.c_description}</textarea>
                <input type="hidden" name="action" value="description">
                <div class="d-grid mt-4">
                  <button class="btn btn-primary" style="background-color: #0d6efd" type="submit">수정</button>
                </div>
              </form>
              </p>
            </div>
          </div>
        </div>
      </div>
    </main>
  </div>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"
          integrity="sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz"
          crossorigin="anonymous"
  ></script>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <script>
      const hasUpdated = <%=hasUpdatedDescription%>;
      const $descriptionForm = document.querySelector('.descriptionForm')
      const $toastSuccess = document.getElementById('toastSuccess')
      const $toastFailure = document.getElementById('toastFail')

      document.addEventListener("DOMContentLoaded", () => {
          if (hasUpdated == null) {
              return;
          } else if (hasUpdated) {
              triggerToast($toastSuccess);
          } else {
              triggerToast($toastFailure);
          }
      })

      const triggerToast = ($target) => {
          const toast = new bootstrap.Toast($target);
          toast.show();
      }

      window.onkeydown = function (event) {
          const kcode = event.key;
          if (kcode == "refresh") {
              history.replaceState({}, null, location.pathname);
          }
      }

      // 자산이 없을 때 빈 도넛 차트를 그리기 위한 플러그인
      const plugin = {
          id: 'emptyDoughnut',
          afterDraw(chart, args, options) {
              const {datasets} = chart.data;
              const {color, width, radiusDecrease} = options;
              let hasData = false;
              for (let i = 0; i < datasets.length; i += 1) {
                  const dataset = datasets[i];
                  for (let j = 0; j < dataset.data.length; j += 1) {
                      hasData |= (dataset.data[j] != 0);
                  }
              }
              if (!hasData) {
                  const {chartArea: {left, top, right, bottom}, ctx} = chart;
                  const centerX = (left + right) / 2;
                  const centerY = (top + bottom) / 2;
                  const r = Math.min(right - left, bottom - top) / 2;
                  ctx.beginPath();
                  ctx.lineWidth = width || 2;
                  ctx.strokeStyle = color || '#BF5AD8';
                  ctx.arc(centerX, centerY, (r - radiusDecrease || 0), 0, 2 * Math.PI);
                  ctx.stroke();
              }
          }
      };
      const dataArr = [];
      dataArr.push(<%=accountBalance[0]%>);
      dataArr.push(<%=accountBalance[1]%>);
      dataArr.push(<%=accountBalance[2]%>);
      dataArr.push(<%=accountBalance[3]%>);
      dataArr.push(<%=accountBalance[4]%>);
      dataArr.push(<%=accountBalance[5]%>);
      const labelsArr = [];
      labelsArr.push('<%=assetCategory[0]%>')
      labelsArr.push('<%=assetCategory[1]%>')
      labelsArr.push('<%=assetCategory[2]%>')
      labelsArr.push('<%=assetCategory[3]%>')
      labelsArr.push('<%=assetCategory[4]%>')
      labelsArr.push('<%=assetCategory[5]%>')
      data1 = {
          datasets: [{
              data: dataArr
          }
          ],
          // 라벨의 이름이 툴팁처럼 마우스가 근처에 오면 나타남
          labels: labelsArr,
      }
      // 도넛형 차트
      var ctx1 = document.getElementById("assetChart");
      var myDoughnutChart = new Chart(ctx1, {
          type: 'doughnut',
          data: data1,
          options: {
              responsive: false,
              plugins: {
                  legend: {
                      position: 'right',
                      labels: {
                          font: {
                              size: 10
                          }
                      },
                  },
                  emptyDoughnut: {
                      color: '#BF5AD8',
                      width: 1,
                      radiusDecrease: 20
                  }
              }
          },
          plugins: [plugin]
      });
  </script>
</body>
</html>
