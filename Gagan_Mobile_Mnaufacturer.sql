--SQL Advance Case Study

select  * from DIM_MANUFACTURER
select * from DIM_MODEL
select * from DIM_CUSTOMER
select  * from DIM_LOCATION
select  * from DIM_DATE
select  * from FACT_TRANSACTIONS




--Q1--BEGIN 

		
		select lo.country,lo.state,year(tr.date)year
		,sum(tr.quantity)cnt from fact_transactions tr
		join dim_location lo on lo.idlocation = tr.idlocation
		where year(tr.date)>='2005'
		group by lo.country,lo.state,year(tr.date)
	


--Q1--END

--Q2--BEGIN
	
	
	select ma.idmanufacturer,ma.manufacturer_name,lo.state,sum(tr.quantity)qty 
	from dim_manufacturer ma
	join dim_model mo on ma.idmanufacturer = mo.idmanufacturer
	join fact_transactions tr on tr.idmodel = mo.idmodel
	join dim_location lo on lo.idlocation = tr.idlocation
	where ma.manufacturer_name='samsung' and lo.country = 'us'
	group by ma.idmanufacturer,ma.manufacturer_name,lo.state
	
	


--Q2--END

--Q3--BEGIN  

select lo.country,tr.idmodel,lo.state,lo.zipcode,count(*)no_tran from dim_location lo
join fact_transactions tr on lo.idlocation = tr.idlocation
group by lo.country,tr.idmodel,lo.state,lo.zipcode
order by 3 asc
	






--Q3--END

--Q4--BEGIN
			select top 1 *  from DIM_Model mo
			join dim_manufacturer ma on ma.idmanufacturer = mo.idmanufacturer
			order by 3 asc
--Q4--END

--Q5--BEGIN

select ma.manufacturer_name,tr.idmodel,sum(tr.quantity)quantity,avg(tr.totalprice)avg from fact_transactions tr
join dim_model mo on mo.idmodel = tr.idmodel
join dim_manufacturer ma on ma.idmanufacturer = mo.idmanufacturer
group by ma.manufacturer_name,tr.idmodel
order by 4 desc,3 desc



--Q5--END

--Q6--BEGIN


select cu.customer_name,year(tr.date)year,avg(tr.totalprice)avg from fact_Transactions tr
left join dim_customer cu on cu.idcustomer = tr.idcustomer
group by cu.customer_name,year(date)
having year(tr.date)='2009' and avg(tr.totalprice)>=500




--Q6--END
	
--Q7--BEGIN  

select * from (select  top 5 idmodel from fact_transactions
	where year(date)=2008
	group by idmodel,year(date)
	order by sum(quantity)desc) as top2008
intersect	
select * from (select  top 5 idmodel from fact_transactions
	where year(date)=2009
	group by idmodel,year(date)
	order by sum(quantity) desc) as top2009
intersect	
select * from (select  top 5 idmodel from fact_transactions
	where year(date)=2010
	group by idmodel,year(date)
	order by sum(quantity) desc) as top2010



--Q7--END	
--Q8--BEGIN


select * from (select ma.manufacturer_name,mo.idmanufacturer,sum(tr.totalprice)sales,year(date)year from fact_transactions tr
	join dim_model mo on mo.idmodel = tr.idmodel
	join dim_manufacturer ma on ma.idmanufacturer =  mo.idmanufacturer
	where year(date)=2009
	group by mo.idmanufacturer,ma.manufacturer_name,year(date)
	order by 3 desc
	offset  1 rows
	fetch next 1 rows only) as top2_2009
union
select * from (select ma.manufacturer_name,mo.idmanufacturer,sum(tr.totalprice)sales,year(date)year from fact_transactions tr
	join dim_model mo on mo.idmodel = tr.idmodel
	join dim_manufacturer ma on ma.idmanufacturer = mo.idmanufacturer
	where year(date)=2010
	group by ma.manufacturer_name,mo.idmanufacturer,year(date)
	order by 3 desc
	offset  1 rows
	fetch next 1 rows only) as top2_2010


--Q8--END
--Q9--BEGIN
	



select * from (select ma.manufacturer_name from fact_transactions tr
	join dim_model mo on mo.idmodel = tr.idmodel
	join dim_manufacturer ma on  ma.idmanufacturer = mo.idmanufacturer
	where year(date) in (2010)
	group by ma.manufacturer_name , year(date)) as m2
except
select * from (select ma.manufacturer_name from fact_transactions tr
	join dim_model mo on mo.idmodel = tr.idmodel
	join dim_manufacturer ma on  ma.idmanufacturer = mo.idmanufacturer

	where year(date) in (2009)
	group by ma.manufacturer_name , year(date)) as m1







--Q9--END

--Q10--BEGIN
	
select *,lag(avg,1) over(partition by idcustomer order by year) from (
	select idcustomer,year(date)year,avg(totalprice)avg,sum(quantity)qty_ from fact_transactions
	where IDCustomer in (select top 10 idcustomer from fact_transactions
	group by idcustomer
	order by sum(quantity) desc)
	group by idcustomer,year(date)) as asd








--Q10--END
	