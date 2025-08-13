-- 조인
-- 여러개의 테이블을 결합하여 조건에 맞는 행 검색
-- ex. 홍길동 학생의 소속과명
-- 조인 종류
-- 1. inner join/outer join
-- 1) inner join : 두 테이블에 공통되는 열이 있을 때
-- 2) outer join : 두 텡이블에 공통되는 열이 없을 때도 표현

-- 고객 / 주문 테이블
-- 상품을 주문한 고객을 조회 : inner join
-- 상품을 주문한 고객과 주문하지 않은 고객도 주문내역고 같이 조회 : outer join

-- 형식
/* 
select 열리스트
from 테이블명 1
    inner join 테이블명 2
    on 조인조건(기본키 = 외래키); 
*/
/* 
select 열리스트
from 테이블명 1,테이블명 2
where 조인조건(기본키 = 외래키); 
*/
/* 
select 테이블명.속성명, 테이블명.속성명
from 테이블명 1,테이블명 2
where 조인조건(기본키 = 외래키); 
*/

-- 주문한 적이 있는 고객의 번호 이름
-- 고객테이블에서 고객 번호와 이름이 있지만 주문여부는 확인 불가능
-- 주문테이블에서는 주문여부 확인이 가능하지만 고객번호외 고객이름은 확인 불가능

-- 주문한 적이 있는 고객의 모든 정보
-- 가장 많이 사용되는 방법
select client.clientno, client.clientname 
from client
    inner join booksale
    on client.clientno = booksale.clientno;

select client.clientno, client.clientname 
from client, booksale -- 결합하고자 하는 테이블 나열
where client.clientno = booksale.clientno;

-- 결과는 clientno를 제외하고는 테이블명 포함시키지 않아도 동일함
-- 오라클 서버 입장에서는 속성의 소속을 명확히 하게되므로 성능이 향상됨
select client.clientno, client.clientname, booksale.bsqty
from client, booksale
where client.clientno = booksale.clientno;

-- 테이블에 별칭 사용
select C.clientno, C.clientname, B.bsqty
from client C, booksale B
where C.clientno = B.clientno;

-- 주문한 적이 있는 고객의 모든 정보 - join(inner join)의 약어
select client.clientno, client.clientname 
from client
    join booksale
    on client.clientno = booksale.clientno;
    
-- 주문한 적이 있는 고객의 모든 정보
-- 중복을 제거해서 조회
-- 고객번호를 기준으로 정렬
select unique C.clientno, C.clientname 
from client C
    inner join booksale BS
    on C.clientno = BS.clientno
order by c.clientno;

-- 소장 도서에 대한 도서명과 출판사명
select b.bookname, p.pubname
from book b
    inner join publisher p
    on b.pubno = p.pubno;
    
------------------------------------------------------------------
-- 주문된 도서의 도서번호화 고객번호
select bookno, clientno
from booksale;

-- 주문(booksale)된 도서의 도서명(book)과 고객명(client)을 확인
-- 3개 테이블 조인 진행 : select ~ from ~ inner join ~ on ~ inner join ~ on
select c.clientname, b.bookname
from booksale bs
    inner join client c on bs.clientno = c.clientno
    inner join book b on b.bookno = bs.bookno;

-- 도서를 주문한 고객의 고개 정보, 주문정보, 도서정보
select c.clientname, b.bookname, bs.bsdate, bs.bsqty
from booksale bs
    inner join client c on bs.clientno = c.clientno
    inner join book b on b.bookno = bs.bookno;
    
-- 고객별로 총 주문 수량 계산
-- 주문 수량 기준 내림차순 정렬
select clientno, sum(bsqty) as 총주문수량
from booksale
group by clientno
order by 총주문수량 desc; -- 가장 마지막에 실행됨
    
-- 고객별로 총 주문 수량 계산
-- 주문 수량 기준 내림차순 정렬
-- 고객명을 표현할 것

-- 고객별로 그룹 생성 시 동일한 이름의 서로 다른 고객이 있을 수 있으므로 고객명이 필요하다고 해서 고객 이름만으로 그룹을 진행하면 안됨
select c.clientno, c.clientname, sum(bsqty) as 총주문수량
from booksale bs
    inner join client c on c.clientno = bs.clientno
group by c.clientno, c.clientname -- 동명이인 고려
order by 총주문수량 desc;

-- group by 다음에 없는 열 이름이 select절에 올 수 없음

-- 쿼리를 통한 연산 진행 - 가공필드 생성 가능
-- 주문된 도서의 주문일, 고객명, 도서명, 도서가격, 주문수량, 주문액(계산 가능: 주문수량 * 단가)을 조회
select c.clientname, b.bookname, bs.bsdate, bs.bsqty,
        bs.bsqty*b.bookprice as "주문액"
from booksale bs
    inner join client c on c.clientno = bs.clientno
    inner join book b on b.bookno = bs.bookno;
    
-- 조인된 결과를 활용한 가공필드 생성
select c.clientname, b.bookname, bs.bsdate, bs.bsqty,
        bs.bsqty*b.bookprice as "주문액"
from booksale bs
    inner join client c on c.clientno = bs.clientno
    inner join book b on b.bookno = bs.bookno
/* where 주문액 >= 100000 --별칭 사용 불가능, select보다 먼저 실행됨
    FROM → ON → JOIN → WHERE → GROUP BY → HAVING → SELECT → ORDER BY */
where bs.bsqty*b.bookprice >= 100000
order by 주문액 desc; -- 별칭 사용 가능

-- 2018년 부터 현재까지 판매된 도서의 주문일, 고객명, 도서명, 도서가격, 주문수량, 주문액 계산해서 조회
select c.clientname, b.bookname, bs.bsdate, bs.bsqty,
        bs.bsqty*b.bookprice as "주문액"
from booksale bs
    inner join client c on c.clientno = bs.clientno
    inner join book b on b.bookno = bs.bookno
where bs.bsdate >= '2018-01-01'
order by bs.bsdate;

-- ======================================================
-- client 테이블과 booksale 테이블 활용 outer join 예시
-- 왼쪽(left)기준
select *
from client c
    left outer join booksale bs
    on c.clientno = bs.clientno
order by c.clientno;
-- 조회 결과 clientno_1컬럼에 null이라고 표현되는 튜플은 주문한적이 없는 고객에 대한 정보를 주문정보 없이 표현

-- 오른쪽(right)기준 : 테이블의 의미적으로 inner join과 동일한 결과
-- 서점의 고객 중 주문하지 않은 고객은 존재 가능 단, 주문한 고객 중 서점의 회원이 아닌 고객은 없음
select *
from client c
    right outer join booksale bs
    on c.clientno = bs.clientno
order by c.clientno;

select *
from client c
    full outer join booksale bs
    on c.clientno = bs.clientno
order by c.clientno;

-- 오라클 outer 조인
-- (+)연산자로 조인시킬 값이 없는 조인측에 위치
-- 고객의 주문정보 확인하되 주문이 없는 고객의 정보 확인
select *
from client c, booksale bs
where c.clientno = bs.clientno(+)
order by c.clientno;

select *
from client c, booksale bs
where c.clientno(+) = bs.clientno
order by c.clientno;

/*
select *
from client c, booksale bs
where c.clientno(+) = bs.clientno(+) -- ORA-01468: outer-join된 테이블은 1개만 지정할 수 있습니다
order by c.clientno;
*/

