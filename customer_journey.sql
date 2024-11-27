--select *
--from customer_journey

with DuplicateRecords as(
	select	
		JourneyID,
		CustomerID,
		ProductID,
		VisitDate,
		Stage,
		Action,
		Duration,
		-- Sử dụng ROW_NUMBER() để gán một số hàng duy nhất cho mỗi bản ghi trong phân vùng được xác định bên dưới
		row_number() over(
		-- PARTITION BY nhóm các hàng dựa trên các cột được chỉ định phải là duy nhất
		partition by CustomerID, ProductID, VisitDate, Stage, Action
		-- ORDER BY xác định cách sắp xếp các hàng trong mỗi phân vùng (thường theo một mã định danh duy nhất như JourneyID)
		order by JourneyID
		) as row_num
	from customer_journey
)
select *
from DuplicateRecords
order by JourneyID

-- Truy vấn bên ngoài chọn dữ liệu đã được làm sạch và chuẩn hóa cuối cùng
select
	JourneyID,
	CustomerID,
	ProductID,
	VisitDate,
	Stage,
	Action,
	coalesce(Duration, avg_duration) as Duration -- Thay thế thời lượng bị thiếu bằng thời lượng trung bình cho ngày tương ứng

from
(
	-- Truy vấn phụ để xử lý và làm sạch dữ liệu
	select
	JourneyID,
	CustomerID,
	ProductID,
	VisitDate,
	UPPER(Stage) as Stage,
	Action,
	Duration,
	avg(Duration) over(partition by VisitDate) as avg_duration, -- Tính toán thời lượng trung bình cho mỗi ngày, chỉ sử dụng các giá trị số
	row_number() over (
		partition by CustomerID, ProductID, VisitDate, upper(Stage), Action -- Nhóm theo các cột này để xác định các bản ghi trùng lặp
		order by JourneyID -- Đặt hàng theo JourneyID để giữ lại lần xuất hiện đầu tiên của mỗi bản sao
		) as row_num
	from customer_journey
) as subquery
where row_num = 1; -- Chỉ giữ lại lần xuất hiện đầu tiên của mỗi nhóm trùng lặp được xác định trong truy vấn phụ