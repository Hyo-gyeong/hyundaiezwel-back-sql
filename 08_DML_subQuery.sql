-- 서브쿼리
-- 하위 질의 / 부속 질의
-- 하나의 SQL문 안에 다른 SQL문이 중첩
-- 하위 질의 수행 후 반환 릴레이션에 대해 다른 질의 릴레이션을 포함
-- 다른 테이블에서 가져온 데이터로 현재 테이블에 있는 정보 찾거나 가공할 때 사용

-- 조인 vs 서브쿼리
-- 1. 조인 : 여러 데이터를 모두 합쳐서 연산
--         : book join publisher -> 18*3 => 54행 반환 후 조건에 맞는 튜플 검색
--         : 카티션 곱 연산 + select 연산
-- 2. 서브쿼리 : 필요한 데이터만 찾아서 제공
--            : 경우에 따라 조인보다 성능이 더 좋을 수도 있지만 대용량 데이터에서 서브쿼리 수행 성능이 나쁠 수도 있음

-- 구성 : 메인쿼리(서브쿼리) -> 서브쿼리 먼저 진행 후 메인쿼리 진행

-- 메시(client) 고객이 주문한 도서의 총 수량(booksale) -> booksale에는 clientno만 있음
select sum(bsqty)
from booksale 
where clientno =
    -- 서브쿼리 
    (select clientno from client where clientname='메시');
    
-- 서브쿼리 where절에서 사용할 경우
-- 서브쿼리 질의 결과값이 단일 행인 경우 : 단일행 서브쿼리 (= 연산자 사용해서 조건 확인)

-- 서브쿼리 질의 결과값이 다중행인 경우 : 다중 서브쿼리 (in, any, all, exists 연산자 사용)
-- in, not in (집합에 값이 있는지, 없는지)
-- exists, not exists (존재의 의미)
-- all (모두), any(최소 하나라도) : 한정의 의미

-- 고객 호날두의 주문수량 및 주문 날짜 조회
-- 1. client 테이블에서 '호날두'의 clientno를 찾아서
-- 2. booksale테이블에서 1.에서 찾은 clientno에 해당되는 주문의 주문일/주문 수량 조회
select bsdate, bsqty
from booksale
where clientno = (-- 단일행 서브쿼리
                  select clientno
                  from client
                  where clientname='호날두');
                
-- 고객 호날두가 주문한 총 주문 수량
select sum(bsqty) as "총주문수량"
from booksale
where clientno = (-- 단일행 서브쿼리
                  select clientno
                  from client
                  where clientname='호날두');

-- 가장 비싼 도서의 도서명과 가격 출력
select bookname 
from book
where bookprice = (-- 단일행 서브쿼리
                  select max(bookprice)
                  from book);
                  
-- 서점 도서의 평균가격을 초과하는 도서의 이름과 도서 가격 조회
select bookname, bookprice
from book
where bookprice > (
                    select avg(bookprice)
                    from book);

----------------------------------------------------------------
-- 도서를 구매한적이 있는 고객의 고객명과 지역을 조회
-- 서브쿼리에서 다중행이 반환되는 예제
SELECT CLIENTNAME, CLIENTADDRESS
FROM CLIENT
WHERE CLIENTNO = (
                    SELECT CLIENTNO
                    FROM BOOKSALE
                  ); -- ORA-01427: 단일 행 하위 질의에 2개 이상의 행이 리턴되었습니다.
                  
-- 비교연산자는 한개의 값만 비교할 수 있음
-- 주문한 고객의 고객번호는 여러값이 반환이 됨(여러행이 반환) -> 비교 연산자 사용 불가
/*SELECT CLIENTNAME, CLIENTADDRESS
FROM CLIENT
WHERE CLIENTNO = '3' OR CLIENTNO ='7' ...


SELECT CLIENTNAME, CLIENTADDRESS
FROM CLIENT
WHERE CLIENTNO IN ('3','7','2',...) */

-- 도서를 구매한적이 있는 고객의 고객명, 주소 조회
-- 1. BOOOKSALE의  고객정보(CLIENTNO)를 조회
-- 2. CLIENT테이블에서 조회된 CLIENTNO에 해당되는 고객 레코드만 추출한 후에 필요 컬럼 추출
-- in, any, all, exists 연산자 사용                 
select clientname, clientaddress
from client
where clientno in (
                  select clientno
                  from booksale
                  ); 
                  
-- 도서를 한번도 구매한적이 없는 고객의 번호와 고객명 조회
SELECT CLIENTNAME
FROM CLIENT
WHERE CLIENTNO NOT IN (
                    SELECT CLIENTNO
                    FROM BOOKSALE
                  );
                  
----------------------------------------------------------
-- 중첩 서브 쿼리
-- 도서명이 '안드로이드 프로그래밍'인 도서를 구매한 고객의 고객명 조회
-- 1. '안드로이드 프로그래밍'도서의 도서번호 확인
SELECT BOOKNO FROM BOOK WHERE BOOKNAME='안드로이드 프로그래밍';
-- 2. BOOKNO 1004번의 도서가 주문된적이 있다면 주문한 고객의 번호를 조회
SELECT CLIENTNO
FROM BOOKSALE
WHERE BOOKNO='1004';
-- 3. 고객번호가 7번 8번인 고객들의 고객명을 조회
SELECT CLIENTNAME
FROM CLIENT
WHERE CLIENTNO='7' OR CLIENTNO ='8';


SELECT CLIENTNAME
FROM CLIENT
WHERE CLIENTNO in (SELECT CLIENTNO
                   FROM BOOKSALE
                   WHERE BOOKNO=(SELECT BOOKNO 
                                 FROM BOOK 
                                 WHERE BOOKNAME='안드로이드 프로그래밍'));
                                 
-- 단일행 서브쿼리의 조건 연산으로 in 사용해도 무방함                                 
SELECT CLIENTNAME
FROM CLIENT
WHERE CLIENTNO in (SELECT CLIENTNO
                   FROM BOOKSALE
                   WHERE BOOKNO in (SELECT BOOKNO 
                                    FROM BOOK 
                                    WHERE BOOKNAME='안드로이드 프로그래밍'));                                 

-- 서브쿼리를 사용했더라도 서브쿼리의 결과는 조건값이므로 
-- WHERE절 뒤에 모든 필요한 질의어 추가 가능
SELECT CLIENTNAME
FROM CLIENT
WHERE CLIENTNO in (SELECT CLIENTNO
                   FROM BOOKSALE
                   WHERE BOOKNO in (SELECT BOOKNO 
                                    FROM BOOK 
                                    WHERE BOOKNAME='안드로이드 프로그래밍'))
ORDER BY CLIENTNAME; 

--------------------------------------------------------------------------------------
-- 다중행 서브쿼리 연산자 (EXISTS, NOT EXISTS)
-- EXISTS : 서브쿼리의 결과가 행을 반환하면 참이되는 연산자
--          참조무결성에 대한 조건검사가 병행되어야 함
--          상관서브쿼리연산이 가능 : 서브쿼리에서 메인쿼리의 컬럼을 사용가능
-- 도서를 구매한적이 있는 고객
SELECT CLIENTNO, CLIENTNAME
FROM CLIENT
WHERE NOT EXISTS (SELECT CLIENTNO
              FROM BOOKSALE
              WHERE CLIENT.CLIENTNO = BOOKSALE.CLIENTNO);

-- 도서를 한번도 주문한적이 없는 고객
-- 서브쿼리의 조건에 해당되는 행이 없으면 TRUE 반환

-- 위 예시는 IN, NOT IN 사용시와 같은 결과가 나옴

-- NULL값을 포함하고 있는 컬럼 :  IN VS EXISTS

-- CLIENT 테이블의 CLIENTHOBBY 컬럼은 NULL값을 포함
SELECT CLIENTHOBBY FROM CLIENT;

-- 서브쿼리의 SELECT된 컬럼의 값이 NULL 포함 여부에 따라 메인 쿼리의 결과가 달라질 수 있음

--EXISTS : 서브쿼리 결과에 NULL값 포함
SELECT CLIENTNO
FROM CLIENT
WHERE EXISTS (SELECT CLIENTHOBBY
              FROM CLIENT);
              
--서브쿼리 결과에 NULL값이 포함되지 않음  
--취미정보가 입력된(NULL아닌) 고객의 번호를 조회
SELECT CLIENTNO
FROM CLIENT
WHERE CLIENTHOBBY IN (SELECT CLIENTHOBBY
                      FROM CLIENT);
                      
-------------------------------------------------------------------------------
-- ALL/ANY
-- 관계연산자와 같이 사용
-- ALL : 서브쿼리의 결과 리스트가 조건검사대상이되는 컬럼의 값고 비교할때 리스트이 모든값이 비교 연산에 대해 참이되는 경우 참
-- 컬럼값이 10 > ALL(3,4,5,6) -> 참
-- ANY : 서브쿼리의 결과 리스트가 조건검사대상이되는 컬럼의 값과 비교할때 리스트이 어떤 한값이라도 비교 연산에 대해 참이되는 경우 참
-- 컬럼값이 10 > ALL(11,12,5,13) -> 참

-- 2번 고객이 주문한 도서의 최고 주문수량보다 더 많은 도서를 구입한 고객의 고객번호, 주문번호, 주문수량 추력
-- 서브쿼리에서 MAX 집계함수 사용
SELECT CLIENTNO, BSNO, BSQTY
FROM BOOKSALE
WHERE BSQTY >
            (SELECT MAX(BSQTY)
            FROM BOOKSALE
            WHERE CLIENTNO = '2');
            
-- 메인쿼리에서 ALL 연산자를 사용            
SELECT CLIENTNO, BSNO, BSQTY
FROM BOOKSALE
WHERE BSQTY > ALL(SELECT BSQTY
                    FROM BOOKSALE
                    WHERE CLIENTNO = '2');
-- 서브쿼리의 결과 리스트 중 최대값보다 큰 이라는 의미    

-- 2번고객의 주문 내역들과 비교할 때 한번이라도 더 많은 주문을 한 적이 있는 고객(2번 고객이 3번 주문한 주문수량들 중 어떤 수량이어도 더 많이 주문한 고객의 고객번호
-- 주문수량을 조회
-- 2번고객의 최소 주문수량보다 많이 주문했던 고객의 주문정보

-- 2번고객을 포함한 모든 고객에 대해 2번 고객이 주문한 수량중 최소주문수량보다 많이 주문한 주문정보
SELECT CLIENTNO, BSNO, BSQTY
FROM BOOKSALE
WHERE BSQTY > ANY(SELECT BSQTY
                    FROM BOOKSALE
                    WHERE CLIENTNO = '2');
                    
SELECT CLIENTNO, BSNO, BSQTY
FROM BOOKSALE
WHERE BSQTY > (SELECT MIN(BSQTY)
                    FROM BOOKSALE
                    WHERE CLIENTNO = '2');

-- 2번 고객이 주문한 최소 주문수량보다 많이 주문한 고객의 주문정보(2번고객은 제외)
SELECT CLIENTNO, BSNO, BSQTY
FROM BOOKSALE
WHERE BSQTY > ANY(SELECT BSQTY
                    FROM BOOKSALE
                    WHERE CLIENTNO = '2')
      AND CLIENTNO !=2 ;                


-----------------------------------------------------------------------------------
-- 스칼라 서브쿼리 EX
-- SELECT 절에서 사용
-- 서브쿼리의 결과로 단일열의 스칼라값으로 반환
-- SELECT나 UPDATE에서 사용
-- 고객별로 총 주문 수량
-- 고객번호, 고객이름, 총주문수량

-- BOOKSALE 테이블로 GROUP BY 고객이름 조회 불가
SELECT CLIENTNO, SUM(BSQTY) AS "총주문수량"
FROM BOOKSALE
GROUP BY CLIENTNO
ORDER BY CLIENTNO ;

-- 스칼라 서브쿼리 사용 
-- 상관서브쿼리
SELECT CLIENTNO AS 고객번호, 
       (SELECT CLIENTNAME -- WHERE절에서 비교되는 CLIENTNO가 GROUP기준이므로 반환되는 CLIENTNAME은 그룹별로 반환됨
        FROM CLIENT
        WHERE CLIENT.CLIENTNO = BOOKSALE.CLIENTNO) AS 고객명,
       SUM(BSQTY) AS "총주문수량"
FROM BOOKSALE
GROUP BY CLIENTNO
ORDER BY CLIENTNO ;

/* DBMS VIEW 객체 제공
 한개의 릴레이션에 모든 정보가 저장되지는 않음
 필요한 정보를 얻기위해 조인, SUBQUERY등을 진행하게 됨
 - 많은 연산 수행이 동반됨
 - 한번 연산 해 놓은 결과를 다시 동일한 데이터를 사용하려고 할 때 빠른 연산을 위해 연산의 순서를 기록해 놓은 것
 - 물리적 의미는 위와 같지만 사용할 때는 릴레이션처럼 사용 가능
 - 개발 중에 뷰가 필요한 경우 뷰를 생성하면 
    - 관리 문제나 트랜잭션등의 성능 문제가 발생할 수 있음
    - 가상의 뷰, 인라인 뷰를 사용
*/ 

-- 인라인 뷰 : 반환되는 데이터는 다중행, 다중열이어도 상관없음

-- 도서가격이 25000원 이상인 도서 중 판매된 도서에 대해 도서별로 도서명, 도서가격, 총판매수량, 총판매액 조회

SELECT BOOKNAME, BOOKPRICE, COUNT(*) AS 판매건수, SUM(BSQTY) AS 총판매수량, SUM(BOOKPRICE*BSQTY) AS 총판매액
FROM BOOKSALE BS,
     (SELECT BOOKNO, BOOKNAME, BOOKPRICE -- *로 해도 결과는 같음
      FROM BOOK
      WHERE BOOKPRICE > 25000) BOOK
WHERE BOOK.BOOKNO = BS.BOOKNO
GROUP BY BOOK.BOOKNO, BOOK.BOOKNAME, BOOKPRICE
                  







