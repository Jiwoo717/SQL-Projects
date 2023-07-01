-- This query retrieves sales data for some snack items. Although in reality I used it for something else. The "snack" replacement was to obfuscate the query for public viewing. This query aims to retrieve the vendor, region, type of snack, and various sales metrics.
-- Problem statement: We need to look at the Sales of Snack items by the Region of Sale. Will help us determine which regiion is struggling.
SELECT 
  	A.SnackItem AS [Snack Name],
  	B.FK_ItemId AS [Id],
  	MONTH(B.BusinessDate) AS [Month],
  	YEAR(B.BusinessDate) AS [Year],
  
    -- Mapping Vendor IDs to their respective locations
  	CASE B.VendorId
  		WHEN 2 THEN 'Riverside'
  		WHEN 3 THEN 'Corona'
  		WHEN 5 THEN 'Torrance'
		WHEN 6 THEN 'Santa Monica'
  		ELSE 'Unknown'
  	END AS [Vendor Name],
  
    -- Categorizing vendors into regions
  	CASE
  		WHEN B.VendorId IN (2, 3) THEN 'Inland'
  		WHEN B.VendorId IN (5, 6) THEN 'Coast'
  		ELSE 'Unknown'
  	END AS [Region],
  
    -- Categorizing snack items based on their type
  	CASE
  		WHEN A.Type LIKE '%Chip%' THEN 'Chips'
		WHEN A.Type LIKE '%Candy%' THEN 'Candy'
  		ELSE 'False'
  	END AS [Type],
  
    -- Calculating the average monthly sales per vendor
  	SUM(B.ItemCount) / (DATEDIFF(month, MIN(B.BusinessDate), MAX(B.BusinessDate)) + 1) / COUNT(DISTINCT B.VendorId) AS [Monthly AVG],
  
    -- Calculating the total quantity, gross sales, and order count
  	SUM(B.ItemCount) AS [QTY],
  	SUM(B.Amount) AS [Gross Sales],
  	SUM(B.Orders) AS [Order Count],
  
    -- Calculating the Rate of Sale (ROS)
  	SUM(B.ItemCount) / SUM(B.Orders) * 100 AS [ROS]

FROM dbo.ItemSales B
	LEFT JOIN dbo.ItemByLocation A 
	ON B.FK_Id = A.FK_Id AND B.FK_ItemId = A.FK_ItemId

WHERE B.BusinessDate BETWEEN '2021-01-01' AND '2021-12-30'

GROUP BY A.Type, B.FK_ItemId, MONTH(B.BusinessDate), YEAR(B.BusinessDate), B.VendorId

ORDER BY YEAR(B.BusinessDate), MONTH(B.BusinessDate), B.VendorId;