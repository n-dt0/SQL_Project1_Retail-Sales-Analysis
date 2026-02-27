USE [SQL_Project1_RetailSales]
GO

/****** Object:  Table [dbo].[retail_sales_]    Script Date: 2026-02-12 10:05:16 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[retail_sales_](
	[transactions_id] [int] NOT NULL,
	[sale_date] [date] NOT NULL,
	[sale_time] [time](7) NULL,
	[customer_id] [int] NOT NULL,
	[gender] [nvarchar](50) NOT NULL,
	[age] [int] NULL,
	[category] [nvarchar](50) NOT NULL,
	[quantiy] [int] NULL,
	[price_per_unit] [float] NULL,
	[cogs] [float] NULL,
	[total_sale] [float] NULL
) ON [PRIMARY]
GO

