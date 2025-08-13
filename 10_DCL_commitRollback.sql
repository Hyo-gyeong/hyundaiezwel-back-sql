-- commit/rollback

-- commit
-- 트렌젝션 처리가 정상적으로 종료되는 상광
-- 트렌젝션이 수행한 변경 내용을 데이터베이스에 반영하는 연산
-- 트렌젝션이 commit에 의해 완료되면 db는 완전 변경되어서 시스템 오류가 발생해도 취소되지 않음

-- rollback
-- 트렌젝션 처리가 비정상적으로 종료된 경우
-- 데이터베이스의 일관성이 깨졌을 때 트렌젝션이 진행한 변경작업을 취소하는 연산 - 이전 상태로 되돌림

-- 간단한 예제
insert into book values ('12345678', 'booktest', 'test', 33000, '2020-10-10', 5, '1'); -- 잘못 들어온 데이터
select * from book;

rollback;

select * from book; -- 잘못 들어온 데이터 사라짐

insert into book values ('12345678', 'booktest', 'test', 33000, '2020-10-10', 5, '1');

select * from book;

commit; -- commit 이전에 진행한 작업들의 취소는 불가능함

insert into book values ('123456789', 'booktest', 'test', 33000, '2020-10-10', 5, '1');

rollback; -- commit 이후까지 rollback

select * from book; -- commit 이전은 원상복구 안됨

delete from book where bookno = '12345678';
rollback;
select * from book;
