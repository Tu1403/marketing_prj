select 
	EngagementID,
	ContentID,
	CampaignID,
	ProductID,
	upper(replace(ContentType,'Socialmedia','Social Media')) as ContentType, --Thay thế "Socialmedia" bằng "Social Media" và sau đó chuyển đổi tất cả các giá trị ContentType thành chữ hoa
	left(ViewsClicksCombined, charindex('-', ViewsClicksCombined) -1) as Views, --Trích xuất phần Views từ cột ViewsClicksCombined bằng cách lấy chuỗi con trước ký tự '-'
	right(ViewsClicksCombined, len(ViewsClicksCombined) - charindex('-',ViewsClicksCombined))as Clicks,-- Trích xuất phần Clicks từ cột ViewsClicksCombined bằng cách lấy chuỗi con sau ký tự '-'
	Likes,
	format(convert(date, EngagementDate), 'dd.MM.yyyy') as EngagementDate -- Chuyển đổi và định dạng ngày tháng theo dạng dd.mm.yyyy

from engagement_data
where ContentType != 'Newsletter'; 
