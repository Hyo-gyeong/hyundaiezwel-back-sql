-- select를 통한 테이블 데이터 복사
-- create table .... as select
-- create table 새테이블명 as select 복사할 열 from 원본테이블명 where 조건

-- 테이블 복사 : 기본키는 복사안됨(제약조건은 따로 추가)
create table newbook as
select * from book where bookdate>= '2019-01-01';

select * from newbook;

-- 제약조건은 복사되지 않으므로 수정 작업 필요
alter table newbook add constraint pk_newbook_bookno primary key(bookno);

-- newbook 데이터 삭제
delete from newbook; -- 모든 데이터 삭제

select * from newbook;

-- 빈테이블에 데이터 저장 - 다른테이블의 select를 통해서 저장
-- 데이터를 저장할 테이블과 select되는 테이블의 구조가 같을 경우
-- book 테이블과 newbook 테이블이 동일한 구조
insert into newbook select * from book;

select * from newbook;

-- 테이블 생성
-- book 테이블의 bookno, bookname 두 속성만 새로 구성하는 테이블의 구조와 데이터로 사용
create table newbook2 as
select bookno, bookname from book;

select * from newbook2;

delete from newbook2;

-- newbook2테이블에 book테이블의 bookno, bookname을 복사해서 저장하시오
select * from newbook2; -- 비었는지 확인

insert into newbook2(bookno, bookname)
select bookno, bookname from book;

select * from newbook2;

select bookno, bookname, pubno
from book;