DROP TABLE EMPLOYEE;

CREATE TABLE EMPLOYEE (
	e_id NUMBER NOT NULL,
	e_password VARCHAR(255) NOT NULL,
	e_name VARCHAR(100) NOT NULL
);

COMMENT ON COLUMN EMPLOYEE.e_password IS '암호화';

ALTER TABLE EMPLOYEE ADD CONSTRAINT PK_EMPLOYEE PRIMARY KEY (
	e_id
);

insert into EMPLOYEE VALUES(1,'1234','PPT-MASTER 피성희');
insert into EMPLOYEE VALUES(2,'1234','GIT-MASTER 깃채동');
insert into EMPLOYEE VALUES(3,'1234','JSP-CHOBO 초채동');

select * from EMPLOYEE;
