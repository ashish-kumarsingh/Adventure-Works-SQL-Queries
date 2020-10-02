use AdventureWorks2017;

select * from Sales.SalesOrderHeader;
select * from Sales.SalesTerritory;


/*1.	What are the sales, product costs, profit, 
number of orders & quantity ordered for internet sales by product category and ranked by sales?*/

select DENSE_RANK() OVER  (order by sum (Sales.SalesOrderHeader.TotalDue) desc) as Ranking, 
Production.ProductCategory.Name as ProductCategory,
sum(Sales.SalesOrderHeader.TotalDue) as Sales, 
sum(Production.Product.StandardCost) as Product_Cost, 
sum(Production.Product.ListPrice - Production.Product.StandardCost) as Profit,
count(Sales.SalesOrderHeader.SalesOrderID) as NumberOfOrders,
sum(Sales.SalesOrderDetail.OrderQty) as OrderQuantity
from Sales.SalesOrderHeader
join Sales.SalesOrderDetail on Sales.SalesOrderHeader.SalesOrderID = Sales.SalesOrderDetail.SalesOrderID
join Sales.SpecialOfferProduct on Sales.SalesOrderDetail.SpecialOfferID = Sales.SpecialOfferProduct.SpecialOfferID
join Production.Product on Production.Product.ProductID = Sales.SpecialOfferProduct.ProductID
join Production.ProductSubcategory on Production.Product.ProductSubcategoryID = Production.ProductSubcategory.ProductSubcategoryID
join Production.ProductCategory on Production.ProductCategory.ProductCategoryID = Production.ProductSubcategory.ProductCategoryID
where OnlineOrderFlag=1
group by Production.ProductCategory.Name
order by Sales DESC;

/*(4 rows affected)*/

/*2.	What are the sales, product costs, profit, number of orders 
& quantity ordered for reseller sales by product category and ranked by sales?*/

select DENSE_RANK() OVER  (order by sum (Sales.SalesOrderHeader.TotalDue) desc) as Ranking,
Production.ProductCategory.Name as ProductCategory,
sum(Sales.SalesOrderHeader.TotalDue) as Sales, 
sum(Production.Product.StandardCost) as Product_Cost, 
sum(Production.Product.ListPrice - Production.Product.StandardCost) as Profit,
count(Sales.SalesOrderHeader.SalesOrderID) as NumberOfOrders,
sum(Sales.SalesOrderDetail.OrderQty) as OrderQuantity
from Sales.SalesOrderHeader
join Sales.SalesOrderDetail on Sales.SalesOrderHeader.SalesOrderID = Sales.SalesOrderDetail.SalesOrderID
join Sales.SpecialOfferProduct on Sales.SalesOrderDetail.SpecialOfferID = Sales.SpecialOfferProduct.SpecialOfferID
join Production.Product on Production.Product.ProductID = Sales.SpecialOfferProduct.ProductID
join Production.ProductSubcategory on Production.Product.ProductSubcategoryID = Production.ProductSubcategory.ProductSubcategoryID
join Production.ProductCategory on Production.ProductCategory.ProductCategoryID = Production.ProductSubcategory.ProductCategoryID
where OnlineOrderFlag=0
group by Production.ProductCategory.Name
order by Sales DESC;


/*3.	What are the sales, product costs, profit, number of orders & quantity ordered for 
both internet & reseller sales by product category and ranked by sales?*/

select DENSE_RANK() OVER  (order by sum (Sales.SalesOrderHeader.TotalDue) desc) as Ranking,
Production.ProductCategory.Name as ProductCategory,
sum(Sales.SalesOrderHeader.TotalDue) as Sales, 
sum(Production.Product.StandardCost) as Product_Cost, 
sum(Production.Product.ListPrice - Production.Product.StandardCost) as Profit,
count(Sales.SalesOrderHeader.SalesOrderID) as NumberOfOrders,
sum(Sales.SalesOrderDetail.OrderQty) as OrderQuantity
from Sales.SalesOrderHeader
join Sales.SalesOrderDetail on Sales.SalesOrderHeader.SalesOrderID = Sales.SalesOrderDetail.SalesOrderID
join Sales.SpecialOfferProduct on Sales.SalesOrderDetail.SpecialOfferID = Sales.SpecialOfferProduct.SpecialOfferID
join Production.Product on Production.Product.ProductID = Sales.SpecialOfferProduct.ProductID
join Production.ProductSubcategory on Production.Product.ProductSubcategoryID = Production.ProductSubcategory.ProductSubcategoryID
join Production.ProductCategory on Production.ProductCategory.ProductCategoryID = Production.ProductSubcategory.ProductCategoryID
group by Production.ProductCategory.Name
order by Sales DESC;


/*4.	What are the sales, product costs, profit, number of orders & quantity ordered for product category 
Accessories broken-down by Product Hierarchy (Category, Subcategory, Model & Product) for both internet & reseller sales?*/

select distinct pc.Name as Product_Category, ps.Name as Product_Subcategory,
pm.Name as Product_Model,pd.Name as Product_Name, 
sum(sh.TotalDue) as Sales ,
sum(Pd.StandardCost) as ProductCost, 
sum(pd.ListPrice - pd.StandardCost) as Profit,
count(sh.SalesOrderID) as NumberOfOrders,
sum(so.OrderQty) as OrderQuantity
from sales.SalesOrderDetail so
join Production.Product pd on so.ProductID = pd.ProductID
join Production.ProductSubcategory ps on pd.ProductSubcategoryID = ps.ProductSubcategoryID
join Production.ProductCategory pc on ps.ProductCategoryID=pc.ProductCategoryID
join Sales.SalesOrderHeader sh on so.SalesOrderID=sh.SalesOrderID
join Production.ProductModel pm	on pm.ProductModelID = pd.ProductModelID
group by pc.Name,pd.ListPrice,so.UnitPrice,ps.name,pm.name,pd.name
order by sales desc;

/*757 rows affected*/


/*5.	What are the sales, product costs, profit, number of orders & 
quantity ordered for both internet & reseller sales by country and ranked by sales?*/

select DENSE_RANK() OVER  (order by sum (so.TotalDue) desc) as Ranking,
st.CountryRegionCode, 
sum(so.TotalDue) as Sales,
sum(pd.StandardCost) as Product_Cost,
sum(Pd.ListPrice - Pd.StandardCost) as Profit,
count(so.SalesOrderID) as Number_of_Orders,
sum(sc.OrderQty) as Order_Quantity
from sales.SalesOrderDetail sc
join Production.Product pd on sc.ProductID=pd.ProductID
join Production.ProductSubcategory ps on pd.ProductSubcategoryID=ps.ProductSubcategoryID
join Production.ProductCategory pc on ps.ProductCategoryID=pc.ProductCategoryID
join Sales.SalesOrderHeader so on sc.SalesOrderID=so.SalesOrderID
join Sales.SalesTerritory st on st.TerritoryID=so.TerritoryID
group by st.CountryRegionCode
order by sales desc;

/*6 rows affected*/

/*6.What are the sales, product costs, profit, number of orders & quantity ordered for 
France by city and ranked by sales for both internet & reseller sales?*/

select DENSE_RANK() OVER  (order by sum (so.TotalDue) desc) as Ranking,
pe.City as France_Cities, 
sum(so.TotalDue) as Sales,
sum(pd.StandardCost) as Product_Cost,
sum(Pd.ListPrice - Pd.StandardCost) as Profit,
count(so.SalesOrderID) as Number_of_Orders,
sum(sc.OrderQty) as Order_Quantity
from sales.SalesOrderDetail sc
join Production.Product pd on sc.ProductID=pd.ProductID
join Production.ProductSubcategory ps on pd.ProductSubcategoryID=ps.ProductSubcategoryID
join Production.ProductCategory pc on ps.ProductCategoryID=pc.ProductCategoryID
join Sales.SalesOrderHeader so on sc.SalesOrderID=so.SalesOrderID
join Sales.SalesTerritory st on st.TerritoryID=so.TerritoryID
join Person.StateProvince sp on sp.CountryRegionCode=st.CountryRegionCode
join Person.Address pe on pe.StateProvinceID=sp.StateProvinceID
where st.Name='France'
group by pe.City
order by sales desc;

/*(35 rows affected)*/

/*7.	What are the top ten resellers by reseller hierarchy (business type, reseller name) ranked by sales?*/

select top 10 st.BusinessEntityID as Business_Type, st.name as Reseller_Name, 
sum(sh.TotalDue) as Sales 
from Sales.Store st
join Sales.SalesOrderHeader sh on st.SalesPersonID=sh.SalesPersonID
join Sales.SalesOrderDetail sc on sh.SalesOrderID=sc.SalesOrderID
join Production.Product pd on sc.ProductID=pd.ProductID
group by st.Name,st.BusinessEntityID
order by Sales;	



/*(10 rows affected)*/

/*8.	What are the top ten (internet) customers ranked by sales?*/

select top 10 DENSE_RANK() OVER  (order by sum (TotalDue) desc) as Ranking,
Concat_ws(' ' ,pe.FirstName,pe.LastName) as Customers_Name,
sum(totaldue) as Total_Sales
from Sales.SalesOrderHeader as sh
inner join Sales.CreditCard as cc on sh.CreditCardID = cc.CreditCardID
inner join Sales.PersonCreditCard as pc on pc.CreditCardID = cc.CreditCardID
inner join Person.Person as pe on pe.BusinessEntityID = pc.BusinessEntityID
where sh.OnlineOrderFlag = 1
group by pe.firstname,pe.lastname
order by Total_Sales desc;

/*(10 rows affected)*/

/*9.What are the sales, product costs, profit, number of orders & quantity ordered by Customer Occupation?*/

select pd.Occupation,
sum((so.OrderQty)*((so.UnitPrice)-(so.unitprice*so.UnitPriceDiscount))) as 'Sales',
sum(pp.StandardCost) as 'Product Cost',
sum(((pp.ListPrice)-((so.UnitPrice)-(so.unitprice*so.UnitPriceDiscount)))*(so.OrderQty)) as 'Profit',
sum(so.OrderQty) as 'Ordered Quantity',
count(so.OrderQty) as 'No of Orders'
from Sales.vPersonDemographics pd
join Person.Person p on p.BusinessEntityID=pd.BusinessEntityID
join Sales.PersonCreditCard pc on pc.BusinessEntityID=pd.BusinessEntityID
join Sales.CreditCard cc on cc.CreditCardID=pc.CreditCardID
join sales.SalesOrderHeader sh on sh.CreditCardID=cc.CreditCardID
join sales.SalesOrderDetail so on so.SalesOrderID=sh.SalesOrderID
join Production.Product pp on so.ProductID=pp.ProductID
where Occupation is not null
group by pd.Occupation
order by pd.Occupation desc;

/*(5 rows affected)*/


/*10.	What are the ranked sales of the sales people (employees)?*/

select DENSE_RANK() OVER  (order by sum (so.TotalDue) desc) as Ranking,
concat_ws(' ',p.firstname,p.lastname) as 'Employee Name', 
sum(so.totaldue) as 'Sales'
from Sales.SalesOrderHeader as so 
join Person.person as p on so.SalesPersonID=p.BusinessEntityID
group by p.lastname,p.firstname
order by'sales' desc;



/*(17 rows affected)*/

/*11.	What are the sales, discount amounts (promotion discounts), profit and promotion % of sales for Reseller Sales 
by Promotion Hierarchy (Category, Type & Name)  sorted descending by sales.?*/

select spo.Category as Promotion_Category,spo.type,spo.description as Promotion_Name,
sum((so.OrderQty)*((so.UnitPrice)-(so.unitprice*so.UnitPriceDiscount))) as Sales,
sum(((pp.ListPrice)-((so.UnitPrice)-(so.unitprice*so.UnitPriceDiscount)))*(so.OrderQty)) as Profit,
sum((so.UnitPrice*spo.DiscountPct)*(so.OrderQty)) as Discounted_amount,
100*sum((so.UnitPrice*spo.DiscountPct)*(so.OrderQty))/sum((so.OrderQty)*((so.UnitPrice)-(so.unitprice*so.UnitPriceDiscount))) as '% of Sales'
from Sales.SalesOrderDetail so
join sales.SpecialOfferProduct sp on so.SpecialOfferID=sp.SpecialOfferID
join sales.SalesOrderHeader sh on so.SalesOrderID=sh.SalesOrderID
join Sales.SpecialOffer spo on spo.SpecialOfferID=sp.SpecialOfferID
join Production.Product pp on pp.ProductID=sp.ProductID
where sh.OnlineOrderFlag=0
group by spo.Category,spo.type,spo.description
order by sales desc;

/*(12 rows affected)*/


/*12.	What are the sales, product costs, profit, number of orders & quantity ordered by Sales Territory Hierarchy 
(Group, Country, region) and ranked by sales for both internet & reseller sales?*/

select DENSE_RANK() OVER  (order by sum (TotalDue) desc) as Ranking,
st.CountryRegionCode,st.Name,st.[Group] as 'Group', 
sum(sh.TotalDue) as Sales,
sum(pp.StandardCost) as Product_Cost,
sum(pp.ListPrice - Pp.StandardCost) as Profit,
count(sh.SalesOrderID) as Number_Of_Orders,
sum(so.OrderQty) as Order_Quantity
from Sales.SalesOrderDetail so
join sales.SalesOrderHeader sh on so.SalesOrderID=sh.SalesOrderID
join Sales.SalesTerritory st on st.TerritoryID=sh.TerritoryID
join Production.Product pp on pp.ProductID=so.ProductID
group by st.CountryRegionCode,st.Name,pp.StandardCost,st.[Group]
order by sales desc;

/*920 rows affected)*/


/*13.	What are the sales by year by sales channels (internet, reseller & total)?*/

select sum(TotalDue) as Total_Sales, 
year(Orderdate) as Years, OnlineOrderFlag as Sales_Channel
from Sales.SalesOrderHeader
where OnlineOrderFlag='1'
group by year(Orderdate),OnlineOrderFlag
order by years;

/*(4 rows affected)*/


/*14.	What are the total sales by month (& year)?*/
select sum(TotalDue) as Total_Sales,
month(Orderdate) as Months, year(Orderdate) as Years
from Sales.SalesOrderHeader
group by month(Orderdate),year(Orderdate)
order by years,months;


/*(38 rows affected)*/



