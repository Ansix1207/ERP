## HOW TO CREATE TABLE & INSERT DUMMY DATA

!! TRIGGER는 사용하지 마세요.

!! ASSET~.sql 파일 중에 ASSET(NULL)_300.sql을 사용하세요. 자산 업데이트 버튼을 누르면 만들어진 테이블에 데이터만 처리해서 넣으면 됩니다. (자산 테이블은 만들어져있지만 연동(새로고침)을 처음 한번은 직접 눌러주고 나서 모든 데이터들이 들어가는 컨셉)

!! ASSET_300.sql 은 임의의 데이터(RANDOM 자산이 들어가있거나, 자산은 null 이고 RANDOM한 예금과 적금이 들어가있는)가 들어가있습니다. CUSTOMER와 연결하긴 했지만 RANDOM에 의해 생성된 숫자들입니다. 임시로 들어가있는 데이터들로 무언가를 하고 싶다면 이걸 사용하세요. 이전에 들어가있는 모든 데이터를 제거하고싶다면 TRUNCATE 구문을 사용하세요.


1. tablesql 폴더를 엽니다.
2. T_ASSET.sql 과 T_SPECIFIC.sql을 제외한 나머지를 이용해서 테이블을 만듭니다.
3. 2번에서 T_CUSTOMER.sql을 이용하여 테이블을 만들었다면 이제 2번에서 만들기를 제외했던 테이블을 만듭니다.
4. datasql 폴더를 엽니다.
5. HANDMADE_PRODUCT_50.sql 을 이용해 "상품" 데이터를 넣습니다.
6. ASSET~.sql과 SPECIFIC_300.sql 을 제외하고 나머지 sql을 실행합니다. (FK 제약조건 때문에 가장 나중에 삽입해야 합니다.)
7. 이제 ORACLE DB 상에서 SELECT * FROM [TABLE_NAME] 을 이용해서 각각의 데이터 삽입용 sql 뒤에 달려있던 숫자만큼 데이터가 잘 들어가있는지 확인합니다.
8. 이제 개발하면서 잘 연결되어서 만들어진 더미 데이터로 씹고 뜯고 맛을봅니다. 🥩👍🍖

#### 데이터에 대해 질문이 있거나 잘못된 부분이 있다면 슬랙  or 갠톡 해주세요 빠르게 답변드리겠습니다. -안식-
