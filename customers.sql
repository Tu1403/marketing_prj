select *
from customers

select *
from geography

--ket noi hai bang customers va geography

select
		c.CustomerID,
		c.CustomerName,
		c.Email,
		c.Gender,
		c.Age,
		g.Country,
		g.City
from customers as c
left join geography g
on
	c.GeographyID = g.GeographyID;