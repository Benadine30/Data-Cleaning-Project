select * 
from NashvilleHousing

---Standardize Date Format(yyyy-mm-dd)

select SaleDateConverted, CONVERT(Date,SaleDate)
from NashvilleHousing

Update NashvilleHousing
set SaleDate = CONVERT(Date, SaleDate)

Alter table NashvilleHousing
add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted = CONVERT(Date, SaleDate)


---populate property address data.

select *
from NashvilleHousing
--where PropertyAddress is null
Order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
JOIN NashvilleHousing b
     on a.ParcelID = b.ParcelID
     and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


Update a
 Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
JOIN NashvilleHousing b
     on a.ParcelID = b.ParcelID
     and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


---Splitting address into individual column (Address, city and state)

select propertyaddress
from NashvilleHousing
--where PropertyAddress is null
Order by ParcelID

select
SUBSTRING (propertyaddress, 1, CHARINDEX(',', propertyaddress) -1 ) as Address
from NashvilleHousing

select
SUBSTRING (propertyaddress, 1, CHARINDEX(',', propertyaddress) -1 ) as Address
, SUBSTRING (propertyaddress, CHARINDEX(',', propertyaddress) +1, LEN(PropertyAddress)) as Address
from NashvilleHousing

Alter table NashvilleHousing
add PropertySplitAddress NVARCHAR (255);

Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1,CHARINDEX(',', propertyaddress) -1 ) 

Alter table NashvilleHousing
add PropertySplitCity NVARCHAR (255);

Update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', propertyaddress) +1, LEN(PropertyAddress))


---Splitting Ownersaddress column

select
PARSENAME(REPLACE (Owneraddress, ',','.'),3)
,PARSENAME(REPLACE (Owneraddress, ',','.'),2)
,PARSENAME(REPLACE (Owneraddress, ',','.'),1)
from NashvilleHousing
    
	      ------OR------
SELECT 
     REVERSE(PARSENAME(REPLACE(REVERSE(Owneraddress), ',', '.'), 1)) AS [Street]
   , REVERSE(PARSENAME(REPLACE(REVERSE(Owneraddress), ',', '.'), 2)) AS [City]
   , REVERSE(PARSENAME(REPLACE(REVERSE(Owneraddress), ',', '.'), 3)) AS [State]
FROM NashvilleHousing;


Alter table NashvilleHousing
add OwnerSplitAddress NVARCHAR (255);

Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(REPLACE(Owneraddress, ',','.'),3)

Alter table NashvilleHousing
add OwnerSplitCity NVARCHAR (255);

Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(REPLACE(Owneraddress, ',','.'),2)

Alter table NashvilleHousing
add OwnerSplitState NVARCHAR (255);

Update NashvilleHousing
Set OwnerSplitState = PARSENAME(REPLACE(Owneraddress, ',','.'),1)


---Change Y and N to Yes and No in"sold as vacant" field

select Distinct(SoldAsVacant), count(SoldAsVacant)
From NashvilleHousing
group by SoldAsVacant
order by SoldAsVacant

select SoldAsVacant
, CASE when SoldAsVacant = 'N' then 'No' 
       when SoldAsVacant = 'Y' then 'Yes'
	   else SoldAsVacant
	   end
from NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant=CASE when SoldAsVacant = 'N' then 'No' 
       when SoldAsVacant = 'Y' then 'Yes'
	   else SoldAsVacant
	   end


---To Delete Unused Column
Alter Table NashvilleHousing
Drop column TaxDistrict