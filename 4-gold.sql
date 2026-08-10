-------DimDate

CREATE TABLE Gold.DimDate
(
    datekey    INT NOT NULL PRIMARY KEY,
    full_date  DATE NOT NULL,
    [year]     INT NOT NULL,
    [quarter]  INT NOT NULL,
    [month]    INT NOT NULL,
    month_name VARCHAR(20) NOT NULL,
    [day]      INT NOT NULL,
    day_name   VARCHAR(20) NOT NULL,
    is_weekend BIT NOT NULL
);

declare @start_date Date, @end_date Date, @current_date Date;

SELECT
    @start_date=MIN(trans_date_trans_time) ,
    @end_date=MAX(trans_date_trans_time)
FROM Silver.Transactions;

set @current_date=@start_date
select @start_date,@end_date,@current_date


while @current_date <= @end_date
begin
   insert into Gold.dimdate(
       datekey    ,
       full_date  ,
       [year]     ,
       [quarter]  ,
       [month]    ,
       month_name ,
       [day]      ,
       day_name   ,
       is_weekend 
   
   )
   values(
   cast(format(@current_date ,'yyyyMMdd') As int ),
   @current_date,
   Year(@current_date ),
   datepart(quarter,@current_date),
   month(@current_date),
   datename(month,@current_date),
   day(@current_date ),
   datename(weekday,@current_date ),
   case 
     when datepart(weekday,@current_date) in (1,7) then 1
	 else 0
   end
   );

   set @current_date =dateadd(day,1,@current_date)
end;

select * from gold.dimdate

------DimCustomers

select *
into gold.DimCustomers
from [silver].[Customers]

alter table gold.DimCustomers 
alter column [customer_id] int not null;

alter table gold.DimCustomers 
add constraint pk_DimCustomers 
primary key (customer_id);

-------DimMerchants

select *
into gold.DimMerchants
from [silver].[Merchants]

alter table gold.DimMerchants
alter column [merchant_id] int not null;

alter table gold.DimMerchants
add constraint pk_DimMerchants
primary key (merchant_id);

---FactTransactions

select
    [transaction_id],
    cast(FORMAT([trans_date_trans_time],'yyyyMMdd') As int) AS datekey,
    [customer_id],
    [merchant_id],
    [category],
    [amt],
    [tax_amt],
    [discount_amt],
    [currency],
    [payment_method],
    [channel],
    [entry_mode],
    [device_type],
    [transaction_status],
    [trans_num],
    [session_id],
    [unix_time],
    [is_fraud]
into gold.factTransactions
from [silver].[Transactions]


---Primary Key
ALTER TABLE Gold.FactTransactions
ALTER COLUMN transaction_id INT NOT NULL;

ALTER TABLE Gold.FactTransactions
ADD CONSTRAINT PK_FactTransactions
PRIMARY KEY (transaction_id);

---Foreign Key_Customer
ALTER TABLE Gold.FactTransactions
ADD CONSTRAINT FK_FactTransactions_Customers
FOREIGN KEY (customer_id)
REFERENCES Gold.DimCustomers(customer_id);

---Foreign Key_Merchant
ALTER TABLE Gold.FactTransactions
ADD CONSTRAINT FK_FactTransactions_Merchants
FOREIGN KEY (merchant_id)
REFERENCES Gold.DimMerchants(merchant_id);

---Foreign Key_Date
ALTER TABLE Gold.FactTransactions
ADD CONSTRAINT FK_FactTransactions_Date
FOREIGN KEY (datekey)
REFERENCES Gold.DimDate(datekey);

--- Validation
SELECT COUNT(*) AS DimCustomers
FROM Gold.DimCustomers;

SELECT COUNT(*) AS DimMerchants
FROM Gold.DimMerchants;

SELECT COUNT(*) AS DimDate
FROM Gold.DimDate;

SELECT COUNT(*) AS FactTransactions
FROM Gold.FactTransactions;

SELECT TOP (10) *
FROM Gold.DimDate;

SELECT TOP (10) *
FROM Gold.DimCustomers;

SELECT TOP (10) *
FROM Gold.DimMerchants;

SELECT TOP (10) *
FROM Gold.FactTransactions;

---indexes
create index IX_Fact_Datekey     on Gold.FactTransactions(datekey);
create index IX_Fact_Customer_Id on Gold.FactTransactions(customer_id);
create index IX_Fact_MerchantId  on Gold.FactTransactions(merchant_id);


