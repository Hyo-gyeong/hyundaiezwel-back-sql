-- 테이블 생성
-- 기본키 제약조건
-- 1. 속성 설정 시 기본키 지정
CREATE TABLE PRODUCT (
    PRDNO VARCHAR2(10) PRIMARY KEY,
    PRDNAME VARCHAR2(30) NOT NULL,
    PRDPRICE NUMBER(8),
    PRDCOMPANY VARCHAR2(30)
);

-- 2. 기본키 따로 설정 : PRIMARY KEY (기본 필드 명)
CREATE TABLE PRODUCT (
    PRDNO VARCHAR2(10),
    PRDNAME VARCHAR2(30) NOT NULL,
    PRDPRICE NUMBER(8),
    PRDCOMPANY VARCHAR2(30),
    PRIMARY KEY(PRDNO)
);

-- 3. 제약 이름과 같이 설정 : 제약 변경이나 삭제 시 유용함
-- CONSTRAINT PK_테이블명_필드명 으로 지정하는게 일반적 (관리의 편리성)
CREATE TABLE PRODUCT (
    PRDNO VARCHAR2(10) CONSTRAINT PK_PRODUCT_PRDNO PRIMARY KEY,
    PRDNAME VARCHAR2(30) NOT NULL,
    PRDPRICE NUMBER(8),
    PRDCOMPANY VARCHAR2(30)
);

-- 4. 따로 설정 제약명 추가
CREATE TABLE PRODUCT2 (
    PRDNO VARCHAR2(10),
    PRDNAME VARCHAR2(30) NOT NULL,
    PRDPRICE NUMBER(8),
    PRDCOMPANY VARCHAR2(30),
    CONSTRAINT PK_PRODUCT_PRDNO PRIMARY KEY(PRDNO)
);

---------------------------------------------------
-- 출판사 테이블을 먼저 생성하고 도서 테이블 생성(외래키 참조필드)
-- 외래키 필드에 입력되는 값은 참조테이블의 기본키로서 값과 동일해야함
-- 외래키 필드의 도메인과 참조테이블의 기보키 도메인은 동일해야 함
-- 테이블 삭제시에는 생성과 반대로 참조하는 BOOK을 먼저 삭제하고 참조되는 PUBLISHER를 삭제

/* 출판사 테이블 생성(출판사 번호, 출판사명)
제약조건
- 기본키 not null
*/

CREATE TABLE PUBLISHER(
    PUBNO VARCHAR2(10) NOT NULL PRIMARY KEY,
    PUBNAME VARCHAR2(30) NOT NULL
);

/*
도서 테이블(도서번호, 도서명, 가격, 발행일, 출판사번호)
기본키
외래키
기본값 체크조건
*/
-- 외래키 필드는 참조테이블에서는 기본키여야 함
CREATE TABLE book(
    bookNO VARCHAR2(10) NOT NULL PRIMARY KEY,
    bookNAME VARCHAR2(30) NOT NULL,
    bookPRICE NUMBER(8) DEFAULT 10000 CHECK(bookPRICE > 1000),
    bookDATE DATE,
    pubNO VARCHAR2(10) NOT NULL,
    -- FK_(로컬 테이블명)_(참조 테이블명)으로 주로 생성
    CONSTRAINT FK_book_publisher FOREIGN KEY (pubNO) REFERENCES publisher(pubNo)
);

-- 학과 테이블
create table department (
	dptNo varchar2(10) not null primary key,
    dptName varchar2(30) not null,
    dptTel varchar2(13) not null
);

-- 학생 테이블
create table student (
	stdNo varchar2(10) not null primary key,
    stdName varchar2(30) not null,
    stdYear int default 4 check (stdYear>=1 and stdYear<=4),
    stdAddress varchar2(30),
    stdBirth date,
    dptNo varchaR2(10) not null,
    foreign key (dptNo) references department(dptNo)
);

-- 교수 테이블
create table professor (
	profNo varchar2(10) not null primary key,
    profName varchar2(30) not null,
    profPosition varchar2(30),
    profTel varchar2(13),
    dptNo varchar2(10) not null,
    foreign key (dptNo) references department(dptNo)
);

-- 과목 테이블
create table course (
	courseId varchar(10) not null primary key,
    courseName varchar(30) not null,
    courseCredit int,
    profNo varchar(10) not null,
    foreign key (profNo) references professor(profNo)
);

CREATE TABLE SCORES(
    STDNO VARCHAR2(10) NOT NULL,
    COURSEID VARCHAR2(10) NOT NULL,
    SCORE NUMBER(3),
    GRADE VARCHAR2(2),
    CONSTRAINT PK_SCORES_STDNO_COURSEID PRIMARY KEY(STDNO, COURSEID),
    CONSTRAINT FK_SCORES_STUDENT FOREIGN KEY(STDNO) REFERENCES STUDENT (STDNO),
    CONSTRAINT FK_SCORES_COURSE FOREIGN KEY(COURSEID) REFERENCES COURSE (COURSEID)
);


