select *
from products;

-- Truy van phan loai cac san pham dua theo gia cua chung

select
	ProductID,
	ProductName,
	Price,
	case
		when Price < 50 then 'Low' 
		when Price between 50 and 200 then 'Medium'
		else 'High'
	end as PriceCategory
from products;