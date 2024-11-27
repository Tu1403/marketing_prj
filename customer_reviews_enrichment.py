import pandas as pd
import pyodbc
import nltk
from nltk.sentiment.vader import SentimentIntensityAnalyzer

# Tải xuống từ điển VADER để phân tích sentiment
nltk.download('vader_lexicon')

# Định nghĩa một hàm để lấy dữ liệu từ cơ sở dữ liệu SQL bằng truy vấn SQL
def fetch_data_from_sql():
    # Xác định chuỗi kết nối với các tham số cho kết nối cơ sở dữ liệu
    conn_str = (
        "Driver={SQL Server};"
        "Server=TuNguyen14\\SQLEXPRESS;"
        "Database=Marketing;"
        "Trusted_Connection=yes;"
    )
    # Thiết lập kết nối đến cơ sở dữ liệu
    conn = pyodbc.connect(conn_str)

    # Xác định truy vấn SQL để lấy dữ liệu đánh giá của khách hàng
    query = "SELECT ReviewID, CustomerID, ProductID, ReviewDate, Rating, ReviewText FROM customer_reviews"

    # Thực hiện truy vấn và lấy dữ liệu vào DataFrame
    df=pd.read_sql(query, conn)

    # Đóng kết nối để giải phóng tài nguyên
    conn.close()

    # Trả về dữ liệu đã lấy dưới dạng DataFrame
    return df

# Lấy dữ liệu đánh giá của khách hàng từ cơ sở dữ liệu SQL
customer_reviews_df = fetch_data_from_sql()  

# Khởi tạo trình phân tích cường độ sentiment VADER để phân tích sentiment của dữ liệu văn bản
sia = SentimentIntensityAnalyzer()

# Xác định hàm để tính sentiment bằng VADER
def calculate_sentiment(review):
    # Lấy sentiment cho văn bản đánh giá
    sentiment = sia.polarity_scores(review)
    # Trả về compound, là điểm chuẩn hóa giữa -1 (most negative) và 1 (most possitive)
    return sentiment['compound']

def categorize_sentiment(score, rating):
    # Xếp hạng để xác định loại sentiment_categorize
    if score >0.05:
        if rating >=4:
            return 'Positive'
        elif rating == 3:
            return 'Mixed Positive'
        else: 
            return 'Mixed Negative'
    elif score < -0.05:
        if rating <=2:
            return 'Negative'
        elif rating == 3:
            return 'Mixed Negative'
        else:
            return 'Mixed Positive'
    else:
        if rating >=4:
            return 'Positive'
        elif rating <=2:
            return 'Negative'
        else:
            return 'Neutral'

def sentiment_bucket(score):
    if score >=0.5:
        return '0.5 to 1.0'
    elif 0.0 <= score < 0.5:
        return '0.0 to 0.49'
    elif -0.5 <= score <0.0:
        return '-0.49 to 0.0'
    else:
        return '-1.0 to 0.5'

# Tính Sentiment cho từng reviews
customer_reviews_df['SentimentScore']=customer_reviews_df['ReviewText'].apply(calculate_sentiment)

# Phân loại
customer_reviews_df['SentimentCategory']=customer_reviews_df.apply(lambda row: categorize_sentiment(row['SentimentScore'],row['Rating']), axis = 1)

customer_reviews_df['SentimentBucket'] = customer_reviews_df['SentimentScore'].apply(sentiment_bucket)
 
# Hiển thị một vài hàng đầu của DataFrame với sentiment scores, categories, buckets
print(customer_reviews_df.head())

#Lưu DataFrame vào một tệp csv mới
customer_reviews_df.to_csv('fact_customer_reviews_with_sentiment.csv', index = False)