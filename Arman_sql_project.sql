
/*
پروژه سیستم مدیریت کارمندان
آرمان داخته ورنکش
خرداد 1405
*/


--ساخت جدول دپارتمان ها

create sequence ad_dept_seq start with 101
increment by 1;


create table tbl_ad_departments(
dept_id  number  primary key,
dept_name  varchar2(30) not null,
dept_location  varchar2(20) default 'Tehran'
);

/

--پر کردن جدول دپارتمان


declare
v_id number;
begin
select ad_dept_seq.nextval into v_id from dual;
insert into tbl_ad_departments(
dept_id,dept_name,dept_location)
values(v_id,'Afagh Tejarat Negin','Mashhad');

commit;
end;

declare
v_id number;
begin
select ad_dept_seq.nextval into v_id from dual;
insert into tbl_ad_departments(
dept_id,dept_name,dept_location)
values(ad_dept_seq.nextval,'Pasargad Machine','Tehran');

commit;

end;
declare
v_id number;
begin
select ad_dept_seq.nextval into v_id from dual;

insert into tbl_ad_departments(
dept_id,dept_name,dept_location)
values(ad_dept_seq.nextval,'Modiran Khodro','Sary');

commit;

end;

declare
v_id number;
begin
select ad_dept_seq.nextval into v_id from dual;

insert into tbl_ad_departments(
dept_id,dept_name,dept_location)
values(ad_dept_seq.nextval,'Negin Ofogh Pars','Tehran');

commit;

end;
declare
v_id number;
begin
select ad_dept_seq.nextval into v_id from dual;

insert into tbl_ad_departments(
dept_id,dept_name,dept_location)
values(ad_dept_seq.nextval,'Caspian','Tehran');

commit;

end;



/

--افزودن دپارتمانprocedure

CREATE OR REPLACE PROCEDURE prc_ad_dept(
p_dept_name IN VARCHAR2,
p_dept_location IN VARCHAR2,
p_result OUT VARCHAR2
)
IS
v_dept_id NUMBER;
BEGIN
SELECT NVL(MAX(dept_id), 0) + 1 INTO 
v_dept_id FROM tbl_ad_departments;

INSERT INTO tbl_ad_departments (
dept_id, dept_name, dept_location)
 VALUES (v_dept_id, p_dept_name, p_dept_location);
 
 commit;
 
p_result := 'دپارتمان با شماره' || v_dept_id || 'با موفقیت افزوده شد.' ;

EXCEPTION
   when others then
 
  IF SQLCODE = -1400 THEN
         p_result := 'فیلد های اجباری را پر کنید.';
         
  ELSE  

         p_result := 'ﺧﻄﺎ: ' || SQLERRM;
  END IF;
END;     

/

--ساخت جدول مشاغل

create table tbl_ad_jobs(
job_id   varchar2(10) not null primary key,
job_title  varchar2(30),
min_salary  number  check(min_salary>0),
max_salary  number  check(max_salary>0)
);

/

--وارد کردن مشاغل

INSERT INTO tbl_ad_jobs (job_id,job_title,min_salary,max_salary)
values(11,'SYSTEM ADMIN',30000,70000);


INSERT INTO tbl_ad_jobs (job_id,job_title,min_salary,max_salary)
values(12,'SELLER',30000,85000);

INSERT INTO tbl_ad_jobs (job_id,job_title,min_salary,max_salary)
values(13,'BARNAME NEVIS',40000,90000);


INSERT INTO tbl_ad_jobs (job_id,job_title,min_salary,max_salary)
values(14,'HUMAN RESOURCES MANAGER',60000,110000);


INSERT INTO tbl_ad_jobs (job_id,job_title,min_salary,max_salary)
values(15,'FINANCE ACCOUNTANT',30000,90000);


INSERT INTO tbl_ad_jobs (job_id,job_title,min_salary,max_salary)
values(16,'POSHTIBAN',30000,75000);


INSERT INTO tbl_ad_jobs (job_id,job_title,min_salary,max_salary)
values(17,'MARKETING MANAGER',60000,100000);


INSERT INTO tbl_ad_jobs (job_id,job_title,min_salary,max_salary)
values(18,'MARKETING REPRESENTATIVE',35000,85000);


INSERT INTO tbl_ad_jobs (job_id,job_title,min_salary,max_salary)
values(19,'SALE MANAGER',60000,110000);

INSERT INTO tbl_ad_jobs (job_id,job_title,min_salary,max_salary)
values(20,'HUMAN RESOURCES REPRESENTATIVE',40000,850000);

/

--افزودن مشاغلPROCEDURE

CREATE OR REPLACE PROCEDURE prc_ad_job(
p_job_id IN VARCHAR2,
p_job_title IN VARCHAR2,
p_min_salary IN NUMBER,
p_max_salary  IN  NUMBER,
p_result     OUT  VARCHAR2
)
IS
BEGIN

INSERT INTO tbl_ad_jobs (
job_id, job_title, min_salary,max_salary)
 VALUES (p_job_id, p_job_title, p_min_salary,p_max_salary);
 
 commit;
 
p_result := 'شغل ' || p_job_id || 'با موفقیت افزوده شد.' ;

EXCEPTION
   when others then
 
  IF SQLCODE = -1400 THEN
         p_result := 'فیلد های اجباری را پر کنید.';
  ELSIF  SQLCODE = -2290 THEN
         p_result := 'حقوق نمی تواند منفی باشد.';
         
  ELSE  

         p_result := 'ﺧﻄﺎ: ' || SQLERRM;
  END IF;
END;     

/

--ساخت جدول کارمندان



create sequence ad_emp_seq start with 1001
increment by 1;

create table tbl_ad_employees(
emp_id  number primary key,
first_name   varchar2(20) not null,
last_name     varchar2(30) not null,
national_id   varchar2(10) unique check (regexp_like(national_id, '^[0-9]{10}$')),
phone         varchar2(11)  not null check (regexp_like(phone, '^[0-9]{11}$')),
email         varchar2(100) unique not null,
hire_date      date default sysdate,
salary        number check (salary>0),
dept_id       number references tbl_ad_departments(dept_id),
job_id        NUMBER references tbl_ad_jobs(job_id)
);

/

create index idx_emp_sal on tbl_ad_employees(salary);

/

--پر کردن جدول کارمندان

declare
v_emp_id number;
begin
select ad_emp_seq.nextval into v_emp_id from dual;

insert into tbl_ad_employees (emp_id,first_name,last_name,
national_id,phone,email,hire_date,salary,dept_id,job_id)
values(v_emp_id,'Arman','Dakhte','0024812765','09966007514',
'armandakhte@gmail.com',to_date('2026-02-15','yyyy-mm-dd'),35000,101 ,12);
commit;
end;

declare
v_emp_id number;
begin
select ad_emp_seq.nextval into v_emp_id from dual;
insert into tbl_ad_employees (emp_id,first_name,last_name,
national_id,phone,email,hire_date,salary,dept_id,job_id)
values(v_emp_id,'Sahar','Sabeti','0016985477','09124581257',
'saharsabeti@gmail.com',to_date('2024-02-02','yyyy-mm-dd'),50000,103,13);
commit;
end;

declare
v_emp_id number;
begin
select ad_emp_seq.nextval into v_emp_id from dual;
insert into tbl_ad_employees (emp_id,first_name,last_name,
national_id,phone,email,hire_date,salary,dept_id,job_id)
values(v_emp_id,'Seyyed Mohammad','Moosavi','4175895125','09366584751',
'seyyedmohammadmoosavi@gmail.com',to_date('2021-09-17','yyyy-mm-dd'),80000,105,14);
commit;
end;

declare
v_emp_id number;
begin
select ad_emp_seq.nextval into v_emp_id from dual;
insert into tbl_ad_employees (emp_id,first_name,last_name,
national_id,phone,email,hire_date,salary,dept_id,job_id)
values(v_emp_id,'Hamed','Mohseni','0035487951','09015874125',
'hamedmohseni@gmail.com',to_date('2023-08-20','yyyy-mm-dd'),48000,122,15);
commit;
end;

declare
v_emp_id number;
begin
select ad_emp_seq.nextval into v_emp_id from dual;
insert into tbl_ad_employees (emp_id,first_name,last_name,
national_id,phone,email,hire_date,salary,dept_id,job_id)
values(v_emp_id,'Marjan','Kamali','5143256879','09125874125',
'marjankamali@gmail.com',to_date('2022-04-22','yyyy-mm-dd'),52000,124,13);
commit;
end;

declare
v_emp_id number;
begin
select ad_emp_seq.nextval into v_emp_id from dual;
insert into tbl_ad_employees (emp_id,first_name,last_name,
national_id,phone,email,hire_date,salary,dept_id,job_id)
values(v_emp_id,'Ali','Mohebi','0015874589','09115879112',
'alimohebi@gmail.com',to_date('2025-04-16','yyyy-mm-dd'),38000,101,11);
commit;
end;


declare
v_emp_id number;
begin
select ad_emp_seq.nextval into v_emp_id from dual;
insert into tbl_ad_employees (emp_id,first_name,last_name,
national_id,phone,email,hire_date,salary,dept_id,job_id)
values(v_emp_id,'Setare','Solati','0025847751','09355884123',
'setaresolati@gmail.com',to_date('2021-08-08','yyyy-mm-dd'),75000,103,16);
commit;
end;


declare
v_emp_id number;
begin
select ad_emp_seq.nextval into v_emp_id from dual;
insert into tbl_ad_employees (emp_id,first_name,last_name,
national_id,phone,email,hire_date,salary,dept_id,job_id)
values(v_emp_id,'Maryam','Rezaee','2365879512','09165874410',
'maryamrezaee@gmail.com',to_date('2025-11-11','yyyy-mm-dd'),40000,105,18);
commit;
end;


declare
v_emp_id number;
begin
select ad_emp_seq.nextval into v_emp_id from dual;
insert into tbl_ad_employees (emp_id,first_name,last_name,
national_id,phone,email,hire_date,salary,dept_id,job_id)
values(v_emp_id,'Ali','Mahdavi','5289663241','09336658120',
'alimahdavi@gmail.com',to_date('2022-10-09','yyyy-mm-dd'),65000,122,16);
commit;
end;


declare
v_emp_id number;
begin
select ad_emp_seq.nextval into v_emp_id from dual;
insert into tbl_ad_employees (emp_id,first_name,last_name,
national_id,phone,email,hire_date,salary,dept_id,job_id)
values(v_emp_id,'Erfan','Mahdavi','0058954788','09233598552',
'erfanmahdavi@gmail.com',to_date('2019-01-26','yyyy-mm-dd'),100000,124,19);
commit;
end;


declare
v_emp_id number;
begin
select ad_emp_seq.nextval into v_emp_id from dual;
insert into tbl_ad_employees (emp_id,first_name,last_name,
national_id,phone,email,hire_date,salary,dept_id,job_id)
values(v_emp_id,'Mohammad','Alavi','0015875214','09228510269',
'mohammadalavi@gmail.com',to_date('2023-09-09','yyyy-mm-dd'),58000,101,16);
commit;
end;


declare
v_emp_id number;
begin
select ad_emp_seq.nextval into v_emp_id from dual;
insert into tbl_ad_employees (emp_id,first_name,last_name,
national_id,phone,email,hire_date,salary,dept_id,job_id)
values(v_emp_id,'Melika','Shaabani','5210897410','09350221475',
'melikashaabani@gmail.com',to_date('2020-07-20','yyyy-mm-dd'),90000,103,15);
commit;
end;


declare
v_emp_id number;
begin
select ad_emp_seq.nextval into v_emp_id from dual;
insert into tbl_ad_employees (emp_id,first_name,last_name,
national_id,phone,email,hire_date,salary,dept_id,job_id)
values(v_emp_id,'Mahsa','Kave','9652001859','09365487110',
'mahsakave@gmail.com',to_date('2024-01-19','yyyy-mm-dd'),52000,105,20);
commit;
end;


declare
v_emp_id number;
begin
select ad_emp_seq.nextval into v_emp_id from dual;
insert into tbl_ad_employees (emp_id,first_name,last_name,
national_id,phone,email,hire_date,salary,dept_id,job_id)
values(v_emp_id,'Fariba','Kamali','0042587963','09135587441',
'faribakamali@gmail.com',to_date('2022-05-01','yyyy-mm-dd'),60000,122,11);
commit;
end;


declare
v_emp_id number;
begin
select ad_emp_seq.nextval into v_emp_id from dual;
insert into tbl_ad_employees (emp_id,first_name,last_name,
national_id,phone,email,hire_date,salary,dept_id,job_id)
values(v_emp_id,'Hossein','Sadeghi','2587741023','09125823331',
'hosseinsadeghi@gmail.com',to_date('2021-02-01','yyyy-mm-dd'),77000,124,12);
commit;
end;


declare
v_emp_id number;
begin
select ad_emp_seq.nextval into v_emp_id from dual;
insert into tbl_ad_employees (emp_id,first_name,last_name,
national_id,phone,email,hire_date,salary,dept_id,job_id)
values(v_emp_id,'Peyman','Vahedi','0102511423','09115240311',
'peymanvahedi@gmail.com',to_date('2025-07-01','yyyy-mm-dd'),44000,101,20);
commit;
end;


declare
v_emp_id number;
begin
select ad_emp_seq.nextval into v_emp_id from dual;
insert into tbl_ad_employees (emp_id,first_name,last_name,
national_id,phone,email,hire_date,salary,dept_id,job_id)
values(v_emp_id,'Parya','Vahedi','0053665987','09132565887',
'paryavahedi@gmail.com',to_date('2021-07-09','yyyy-mm-dd'),68000,103,20);
commit;
end;


declare
v_emp_id number;
begin
select ad_emp_seq.nextval into v_emp_id from dual;
insert into tbl_ad_employees (emp_id,first_name,last_name,
national_id,phone,email,hire_date,salary,dept_id,job_id)
values(v_emp_id,'Solmaz','Cheraghi','0043568488','09115326875',
'solmazcheraghi@gmail.com',to_date('2023-10-19','yyyy-mm-dd'),70000,105,17);
commit;
end;


declare
v_emp_id number;
begin
select ad_emp_seq.nextval into v_emp_id from dual;
insert into tbl_ad_employees (emp_id,first_name,last_name,
national_id,phone,email,hire_date,salary,dept_id,job_id)
values(v_emp_id,'Saleh','Hardani','0012548799','09162580123',
'salehhardani@gmail.com',to_date('2023-10-20','yyyy-mm-dd'),72000,122,17);
commit;
end;


declare
v_emp_id number;
begin
select ad_emp_seq.nextval into v_emp_id from dual;
insert into tbl_ad_employees (emp_id,first_name,last_name,
national_id,phone,email,hire_date,salary,dept_id,job_id)
values(v_emp_id,'Masoome','Moslemi','0102587965','09127117587',
'masoomemoslemi@gmail.com',to_date('2022-04-01','yyyy-mm-dd'),68000,124,11);
commit;
end;


/

--استخدام کارمندانPROCEDURE

CREATE OR REPLACE PROCEDURE prc_ad_hire(
p_fname IN VARCHAR2,
p_lname IN VARCHAR2,
p_national_id IN VARCHAR2,
p_phone IN VARCHAR2,
p_email IN VARCHAR2,
p_salary IN NUMBER,
p_dept_id IN NUMBER,
p_job_id IN NUMBER,
p_result OUT VARCHAR2
)
IS
v_emp_id NUMBER;
BEGIN
SELECT NVL(MAX(emp_id), 0) + 1 INTO 
v_emp_id FROM tbl_ad_employees;
INSERT INTO tbl_ad_employees (
emp_id, first_name, last_name, national_id, 
phone,email, hire_date, salary, dept_id, job_id)
 VALUES (v_emp_id, p_fname, p_lname, 
p_national_id, p_phone,p_email, SYSDATE, p_salary, p_dept_id, p_job_id);

COMMIT;
p_result := 'کارمند با شماره' || v_emp_id || 'با موفقیت استخدام شد.' ;

exception  
  WHEN DUP_VAL_ON_INDEX THEN
    ROLLBACK;


    IF INSTR(SQLERRM, 'NATIONAL_ID') > 0 THEN
        p_result := 'این کد ملی قبلا وارد شده است.';

    ELSIF INSTR(SQLERRM, 'EMAIL') > 0 THEN
        p_result := 'این ایمیل قبلا وارد شده است.';

    ELSE
        p_result := 'مقدار تکراری';
    END IF;

   WHEN OTHERS THEN
     ROLLBACK;
     
     IF SQLCODE = -1400 THEN
         p_result := 'فیلد های اجباری را پر کنید.';

     ELSIF SQLCODE = -2291 THEN
         p_result := 'شغل یا دپارتمان وارد شده وجود ندارد.';

     ELSIF SQLCODE = -2290 THEN
         p_result := 'خطای CHECK';


ELSE
p_result := 'ﺧﻄﺎ: ' || SQLERRM;
END IF;
END;

/

--function محاسبه سنوات

create or replace function func_ad_sanavat(p_emp_id number)
return number
is
v_hire_date tbl_ad_employees.hire_date%type;
v_years number;
begin
select hire_date into v_hire_date 
from tbl_ad_employees
where emp_id=p_emp_id;

v_years :=round((sysdate - v_hire_date)/365, 1);
return v_years;
exception 
when no_data_found then
return 0;
end; 

/

--VIEW برای دیدن گزارش کارمندان

create or replace view vw_emp_report as
select
e.emp_id,e.first_name,e.last_name,d.dept_name,j.job_title,e.salary,e.hire_date,func_ad_sanavat(e.emp_id) as sanavat
from tbl_ad_employees e
left join tbl_ad_departments d on e.dept_id=d.dept_id
left join tbl_ad_jobs j on e.job_id=j.job_id;

/

--procedureگرفتن حقوق کارمندان با نام آنها
create or replace procedure prc_salary_report
is
begin
     for x in (
select first_name,last_name,salary
from tbl_ad_employees 
order by salary)
loop
   dbms_output.put_line(x.first_name||' '||x.last_name||' : '||x.salary);
end loop;
end;

/

--procedureافزایش حقوق کارمندان یک دپارتمان

create or replace procedure prc_ad_increase_deptsalary
(p_dept_id in number,
p_percent in number,
p_result out varchar2
)
is
v_count number;
begin
update tbl_ad_employees
set salary=salary*(1+p_percent/100)
where dept_id=p_dept_id;

v_count := SQL%ROWCOUNT;
commit;

p_result := 'حقوق'|| v_count|| 'نفر از کارمندان دپارتمان' ||p_dept_id || 'افزایش یافت.';
exception 
when others then 
rollback;
p_result:= 'خطا:'|| sqlerrm;
end; 

/

create or replace package pkg_ad_emp 
is
   procedure prc_ad_hire(
p_fname IN VARCHAR2,
p_lname IN VARCHAR2,
p_national_id IN VARCHAR2,
p_phone IN VARCHAR2,
p_email IN VARCHAR2,
p_salary IN NUMBER,
p_dept_id IN NUMBER,
p_job_id IN VARCHAR2,
p_result OUT VARCHAR2
);
procedure prc_salary_report;

function func_ad_sanavat(p_emp_id number)
return number;

procedure prc_ad_increase_deptsalary
(p_dept_id in number,
p_percent in number,
p_result out varchar2
);
end;
/

create or replace package body pkg_ad_emp 
is
PROCEDURE prc_ad_hire(
p_fname IN VARCHAR2,
p_lname IN VARCHAR2,
p_national_id IN VARCHAR2,
p_phone IN VARCHAR2,
p_email IN VARCHAR2,
p_salary IN NUMBER,
p_dept_id IN NUMBER,
p_job_id IN VARCHAR2,
p_result OUT VARCHAR2
)
IS
v_emp_id NUMBER;
BEGIN
SELECT NVL(MAX(emp_id), 0) + 1 INTO 
v_emp_id FROM tbl_ad_employees;
INSERT INTO tbl_ad_employees (
emp_id, first_name, last_name, national_id, 
phone,email, hire_date, salary, dept_id, job_id)
 VALUES (v_emp_id, p_fname, p_lname, 
p_national_id, p_phone,p_email, SYSDATE, p_salary, p_dept_id, p_job_id);

COMMIT;
p_result := 'کارمند با شماره' || v_emp_id || 'با موفقیت استخدام شد.' ;

exception  
  WHEN DUP_VAL_ON_INDEX THEN
    ROLLBACK;


    IF INSTR(SQLERRM, 'NATIONAL_ID') > 0 THEN
        p_result := 'این کد ملی قبلا وارد شده است.';

    ELSIF INSTR(SQLERRM, 'EMAIL') > 0 THEN
        p_result := 'این ایمیل قبلا وارد شده است.';

    ELSE
        p_result := 'مقدار تکراری';
    END IF;

   WHEN OTHERS THEN
     ROLLBACK;
     
     IF SQLCODE = -1400 THEN
         p_result := 'فیلد های اجباری را پر کنید.';

     ELSIF SQLCODE = -2291 THEN
         p_result := 'شغل یا دپارتمان وارد شده وجود ندارد.';

     ELSIF SQLCODE = -2290 THEN
         p_result := 'خطای CHECK';


ELSE
p_result := 'ﺧﻄﺎ: ' || SQLERRM;
END IF;
END;

 procedure prc_salary_report
is
begin
     for x in (
select first_name,last_name,salary
from tbl_ad_employees 
order by salary)
loop
   dbms_output.put_line(x.first_name||' '||x.last_name||' : '||x.salary);
end loop;
end;

function func_ad_sanavat(p_emp_id number)
return number
is
v_hire_date tbl_ad_employees.hire_date%type;
v_years number;
begin
select hire_date into v_hire_date 
from tbl_ad_employees
where emp_id=p_emp_id;

v_years :=round((sysdate - v_hire_date)/365, 1);
return v_years;
exception 
when no_data_found then
return 0;
end; 

procedure prc_ad_increase_deptsalary
(p_dept_id in number,
p_percent in number,
p_result out varchar2
)
is
v_count number;
begin
update tbl_ad_employees
set salary=salary*(1+p_percent/100)
where dept_id=p_dept_id;

v_count := SQL%ROWCOUNT;
commit;

p_result := 'حقوق'|| v_count|| 'نفر از کارمندان دپارتمان' ||p_dept_id || 'افزایش یافت.';
exception 
when others then 
rollback;
p_result:= 'خطا:'|| sqlerrm;
end; 
end;

/

--ساخت جدول تاریخچه

create sequence ad_audit_seq
start with 1
increment by 1;


create table tbl_ad_audit(
log_id        number  primary key,
table_name    varchar2(30),
action_type   varchar2(30),
record_id     varchar2(100),
old_value      CLOB,
new_value      CLOB,
change_date    timestamp default systimestamp,
changed_by     varchar2(50) default user
);

/

create or replace trigger trg_change_salary
after update of salary on tbl_ad_employees for each row
begin
  if :old.salary != :new.salary then
        insert into tbl_ad_audit(
           log_id,
            table_name,
            action_type,
           record_id,
           old_value,
           new_value,
           change_date,
           changed_by)
          values(
                 ad_audit_seq.nextval,
                 'tbl_ad_employees',
                  'change_salary',
                  :old.emp_id,
                  'salary:  ' || :old.salary,
                   'salary:  ' || :new.salary,
                   SYSTIMESTAMP,
                   USER);
   END IF;
END;

/

--توضیح ستون ها و جداول
COMMENT ON TABLE tbl_ad_employees IS 'جدول اطلاعات کارمندان';
COMMENT ON COLUMN tbl_ad_employees.emp_id IS 'شناسه یکتای کارمند';
COMMENT ON TABLE tbl_ad_departments IS 'جدول اطلاعات شرکت ها';
COMMENT ON COLUMN tbl_ad_departments.dept_id IS 'شناسه یکتای شرکت ها';
COMMENT ON TABLE tbl_ad_jobs IS 'جدول اطلاعات شغل ها';
COMMENT ON TABLE tbl_ad_audit IS 'جدول  تغییرات و تاریخچه';
COMMENT ON COLUMN tbl_ad_audit.record_id IS 'شناسه یکتای جدولی که تغییر روی آن صورت گرفته.';
COMMENT ON COLUMN tbl_ad_audit.action_type IS ' نوع تغییری که روی جدول صورت گرفته.';

/*
برای استفاده از کد زیر استفاده کنید:
select table_name,NULL AS column_name, comments 
from user_tab_comments
UNION ALL
select table_name,column_name,comments
from user_col_comments; 
*/
              
 /
commit;
/            
