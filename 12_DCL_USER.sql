-- 계정에 할당된 QUOTA 확인
SELECT * FROM USER_TS_QUOTAS; -- 할당량 MAX_BYTES 값이 -1이면 무제한

-- 계정 조회
-- SELECT * FROM DBA_USERS; -- DBA권한 없으므로 ERROR! : ORA-00942: 테이블 또는 뷰가 존재하지 않습니다
SELECT * FROM ALL_USERS; -- DBA보다 낮은 모든 사용자 권한으롲 조회만 가능
SELECT * FROM USER_USERS; -- 현재 계정에 대한 정보 조회

-- ALL_XXX : DBA권한보다 낮으면서 자신에게 부여된 권한으로 조회할 수 있는 객체 확인
SELECT * FROM ALL_TABLES;

-- USER_XXX : 자신이 생성한 모든 객체에 대한 정보
SELECT * FROM USER_TABLES;

-- 관리자가 아닌 경우 계정, 객체 정보 확인
SELECT * FROM ALL_USERS;
SELECT * FROM USER_TABLES; -- 현재 계정 DB 
SELECT * FROM TAB; -- 현재 계정 DB 

-- 현재 계정에 부여된 권한 조회
SELECT * FROM USER_ROLE_PRIVS;
