--CLEANING DATA IN SQL QUERIES.

SELECT *
FROM [Nashville Housing]



--STANDARDIZE DATE FORMAT.

SELECT SALEDATECONVERTED, CONVERT(DATE, SALEDATE)
FROM [Nashville Housing]

UPDATE [Nashville Housing]
SET SALEDATE = CONVERT(DATE, SALEDATE)

ALTER TABLE [Nashville Housing]
ADD SALEDATECONVERTED DATE;

UPDATE [Nashville Housing]
SET SALEDATECONVERTED = CONVERT(DATE, SALEDATE)




--POPULATE PROPERTY ADDRESS DATA

SELECT *
FROM [Nashville Housing]
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID


SELECT A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM [Nashville Housing] A
JOIN [Nashville Housing] B
	ON A.ParcelID = B.ParcelID
	AND A.[UniqueID ] <> B.[UniqueID ]

UPDATE A
SET PROPERTYADDRESS = ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM [Nashville Housing] A
JOIN [Nashville Housing] B
	ON A.ParcelID = B.ParcelID
	AND A.[UniqueID ] <> B.[UniqueID ]




--BREAKING OUT ADRESS INTO INDIVIDUAL COLUMNS (ADDRESS, CITY, STATE)

SELECT PropertyAddress
FROM [Nashville Housing]

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS ADDRESS,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS ADDRESS

FROM [Nashville Housing]


ALTER TABLE [Nashville Housing]
ADD STREETADDRESS NVARCHAR(255);

UPDATE [Nashville Housing]
SET STREETADDRESS = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE [Nashville Housing]
ADD CITY NVARCHAR(255);

UPDATE [Nashville Housing]
SET CITY = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

SELECT *
FROM [Nashville Housing]


SELECT OwnerAddress
FROM [Nashville Housing]

SELECT
PARSENAME(REPLACE(OWNERADDRESS, ',', '.'),3),
PARSENAME(REPLACE(OWNERADDRESS, ',', '.'),2),
PARSENAME(REPLACE(OWNERADDRESS, ',', '.'),1)
FROM [Nashville Housing]

ALTER TABLE [Nashville Housing]
ADD OWNERSTREETADDRESS NVARCHAR(255);

UPDATE [Nashville Housing]
SET OWNERSTREETADDRESS = PARSENAME(REPLACE(OWNERADDRESS, ',', '.'),3)

ALTER TABLE [Nashville Housing]
ADD OWNERCITY NVARCHAR(255);

UPDATE [Nashville Housing]
SET OWNERCITY = PARSENAME(REPLACE(OWNERADDRESS, ',', '.'),2)

ALTER TABLE [Nashville Housing]
ADD OWNERSTATE NVARCHAR(255);

UPDATE [Nashville Housing]
SET OWNERSTATE = PARSENAME(REPLACE(OWNERADDRESS, ',', '.'),1)

SELECT *
FROM [Nashville Housing]



--CHANGE Y AND N TO YES AND NO IN "SOLD AS VACANT" FIELD

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM [Nashville Housing]
GROUP BY SoldAsVacant
ORDER BY 2


SELECT SoldAsVacant
,CASE WHEN SOLDASVACANT = 'Y' THEN 'YES'
      WHEN SOLDASVACANT = 'N' THEN 'NO'
	  ELSE SoldAsVacant
	  END
FROM [Nashville Housing]

UPDATE [Nashville Housing]
SET SoldAsVacant = CASE WHEN SOLDASVACANT = 'Y' THEN 'YES'
      WHEN SOLDASVACANT = 'N' THEN 'NO'
	  ELSE SoldAsVacant
	  END



--REMOVE DUPLICATES
WITH ROWNUMCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY PARCELID,
				 PROPERTYADDRESS,
				 SALEPRICE,
				 SALEDATE,
				 LEGALREFERENCE
				 ORDER BY
				 UNIQUEID) ROW_NUM
FROM [Nashville Housing]
--ORDER BY PARCELID
)
SELECT *
FROM ROWNUMCTE
WHERE ROW_NUM > 1
--ORDER BY PropertyAddress


--DELETE UNUSED COLUMNS

SELECT *
FROM [Nashville Housing]

ALTER TABLE [Nashville Housing]
DROP COLUMN OWNERADDRESS, TAXDISTRICT, PROPERTYADDRESS
ALTER TABLE [Nashville Housing]
DROP COLUMN SALEDATE





