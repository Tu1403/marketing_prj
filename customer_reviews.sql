select *
from customer_reviews


select 
	ReviewID,
	ReviewDate,
	CustomerID,
	ProductID,
	Rating,
	--thay thế khoảng cách đôi bằng khoảng cách đơn để đảm bảo văn bản dễ đọc hơn và được chuẩn hóa
	REPLACE(ReviewText,' ',' ') as ReviewText 
	--ReviewText
from customer_reviews