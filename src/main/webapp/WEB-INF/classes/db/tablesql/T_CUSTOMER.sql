DROP TABLE CUSTOMER;

CREATE TABLE CUSTOMER (
	c_id NUMBER NOT NULL,
	c_name VARCHAR(100) NOT NULL,
	c_rrn VARCHAR(255) NOT NULL,
	c_gender CHAR(1) NOT NULL,
	c_address VARCHAR(100) NOT NULL,
	c_mobile VARCHAR(20) NOT NULL,
	c_job VARCHAR(20) NOT NULL,
	c_description VARCHAR(300) DEFAULT '특이사항 존재시 입력' NULL,
	e_id NUMBER NULL,
	CONSTRAINT CK_CUSTOMER_C_GENDER CHECK (c_gender IN ('F', 'M')),
    CONSTRAINT CH_CUSTOMER_C_JOB CHECK(c_job IN('공무원','직장인','전문직','사업자','일반'))
);

ALTER TABLE CUSTOMER ADD CONSTRAINT PK_CUSTOMER PRIMARY KEY (
	c_id
);

select * from customer;