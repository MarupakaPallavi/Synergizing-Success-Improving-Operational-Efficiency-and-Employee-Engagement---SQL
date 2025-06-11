create database advsql1
use advsql1

select * from Business_Operations_Dataset

--Analysis Questions:
--● Employee Performance:

--● Which department had the highest average profit margin among its
--products?

select top 1 department, avg(profit_margin)as avg_profit_margin from Business_Operations_Dataset 
group by department order by avg(profit_margin) desc


--● Which employee in the IT department had the highest performance score,
--and what was their role

 SELECT * FROM Business_Operations_Dataset

 SELECT B.employee_id,B.department, B.employee_performance_score AS max_score, B.employee_name,B.employee_role
FROM Business_Operations_Dataset B
INNER JOIN (
    SELECT department,max(employee_performance_score) as max_score
    FROM Business_Operations_Dataset
    GROUP BY department,employee_role
) AS dept_max ON B.department = dept_max.department and  B.employee_performance_score = dept_max.max_score 
WHERE dept_max.DEPARTMENT =  'IT'AND employee_performance_score = '10'


--● Product Sales & Customer Satisfaction:

--● Identify the product with the highest revenue generated in the HR
--department.

 select department , category,product_name, max(revenue) as max_revenue from Business_Operations_Dataset
 group by  department, category,product_name 
 having department = 'HR'

--● What is the average customer feedback score for products in the
--Accessories category, and which product received the highest score?

SELECT * from Business_Operations_Dataset


select category, product_name, avg(customer_feedback_score) as customer_feedback_score, 
max(customer_feedback_score) as max_feedbackscore
from Business_Operations_Dataset
group by category, product_name 
having category = 'Accessories'

--● Supply Chain & Inventory Management:

--● Which supplier had the highest total inventory level across all
--departments?

SELECT * from Business_Operations_Dataset

select department , supplier_name, max(inventory_level)as max_inventory 
from Business_Operations_Dataset
group by department, supplier_name 
order by department desc

--● Which product in the Gadgets category had the lowest inventory level?
with lowest_inventory_level
as
(
select   department, category, product_name, min(inventory_level) as min_score,
dense_rank() OVER(order by min(inventory_level) asc) as Rownum
from Business_Operations_Dataset
group by department, category, product_name
having category = 'Gadgets'
)
select *  from lowest_inventory_level where rownum = 1

--● Employee Training & Sales:

--● How many employees in the Sales department have completed training
--programs, and what percentage does this represent of the total employees
--in that department?

SELECT  count(employee_id)
from Business_Operations_Dataset where department = 'Sales' 


with percent_employee_sales 
as 
( 
    SELECT count(employee_id) as no_of_training_completed 
from Business_Operations_Dataset where department = 'Sales' and training_program_completed = '1'
)

select no_of_training_completed, no_of_training_completed * 100.0/(SELECT count(employee_id) 
from Business_Operations_Dataset where department = 'Sales' )as percentage_of_training_completed
from percent_employee_sales;


--Product Sales Contribution:

--● What is the total number of units sold for all products in the Marketing
--department, and which product contributed the most to this total?


SELECT * from Business_Operations_Dataset
where department  = 'Marketing' and product_name  ='Phone'and category = 'Gadgets'


with contribution_for_units_sold
as
(
SELECT department, category , product_name ,sum(units_sold)as total_units_sold,
row_number() OVER(order by sum(units_sold) desc) as rownum
from Business_Operations_Dataset where department  = 'Marketing'
group by department ,category , product_name 
)

select *  from contribution_for_units_sold where rownum = 1

--Advanced SQL Questions


--● Write a query to rank employees in each department by their revenue
--generated using a window function.

SELECT * from Business_Operations_Dataset

SELECT
    Department 
    employee_id,
    employee_name,
	revenue,
    ROW_NUMBER() OVER (PARTITION BY Department ORDER BY revenue DESC) AS RowNum,
    RANK() OVER (PARTITION BY Department ORDER BY revenue DESC) AS RankNum,
    DENSE_RANK() OVER (PARTITION BY Department ORDER BY revenue DESC) AS DenseRankNum
FROM Business_Operations_Dataset;

--● Create a CTE to find the average salary of employees in each department
--and then select departments where the average salary is above $70,000.


WITH dept_avg_salary AS (
    select department,avg(salary)as average_salary
from Business_Operations_Dataset
group by department 
)

select department,average_salary  from dept_avg_salary where average_salary >  '70000'


--● Create a view that shows only the product name, revenue, and profit
--margin for products in the Accessories category.

create view accessories_revenue 
as
select category, product_name, revenue, profit_margin
from Business_Operations_Dataset
where category = 'Accessories'

select * from accessories_revenue

--● Write a query to create a non-clustered index on the employee_name
--column to improve query performance.

CREATE NONCLUSTERED INDEX IX_employee_name 
    ON Business_Operations_Dataset (employee_name)



--● Create a stored procedure that accepts a department name as a
--parameter and returns the total revenue generated by that department.



	
    create procedure department_REVENUE  
	       @department varchar(200)

	as
	begin
	select department, sum(revenue) as total_revenue  from Business_Operations_Dataset
	WHERE department = @department
	group by department 
	end 

	exec department_REVENUE @department = 'IT'


--● Write a trigger that logs changes to the revenue column in a separate table
--whenever an update occurs.

CREATE TABLE revenue_update 
(	
	SNO INT IDENTITY(1,1),
	TIMESTAMPS DATETIME  DEFAULT GETDATE(),
	LOGINNAME VARCHAR(50) DEFAULT SUSER_NAME(),
	dmlOPS  VARCHAR(50) ,
	department varchar(200),
	old_revenue VARCHAR(50) ,
	new_revenue VARCHAR(50)
	)

	----Create Update revenuelist
	Create trigger  revenueupdate
	on Business_Operations_Dataset 
	for Update 
	as 
	insert into revenue_update (dmlOPS,department ,
	old_revenue ,
	new_revenue  )
	select 'Update',i.department,d.revenue,
	i.revenue from Deleted d join  inserted i on i.department=d.department



	update Business_Operations_Dataset
	set revenue = '247750.390900'
	where employee_id = '15459'

	select * from revenue_update




--● Create a scalar UDF that calculates the profit from a given product's
--revenue and profit margin.



create function calcuval(@Revenue float, @ProfitMargin float)
 returns float
 as
 begin
      return @Revenue*@ProfitMargin
 end

 select  dbo.calcuval (revenue, profit_margin  ) as profit from Business_Operations_Dataset  where employee_id = '11362' 


--● Provide a query to create a clustered index on the company_id column.

CREATE CLUSTERED INDEX IX_company_id ON dbo.Business_Operations_Dataset (company_id);
GO