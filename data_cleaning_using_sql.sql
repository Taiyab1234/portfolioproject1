/*
Cleaning Data in SQL query
*/


select*
from PortfolioProject1.dbo.NashvilleHousing


---------------------------------------------------------------------------------------------------------

-- standardize data fromat 
select saledateconverted,CONVERT(date,saledate)
from PortfolioProject1.dbo.NashvilleHousing

update NashvilleHousing
SET saledate = CONVERT(date,saledate)

alter table NashvilleHousing
add saledateconverted date;

update NashvilleHousing
SET saledateconverted = CONVERT(date,saledate)

---------------------------------------------------------------------------------------------------------

-- Populate Property address data

select * 
from PortfolioProject1.dbo.NashvilleHousing
--where propertyaddress is null
order by parcelid

select a.Parcelid,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress) 
from PortfolioProject1.dbo.NashvilleHousing a
join PortfolioProject1.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
	where a.propertyaddress is null

update a 
SET propertyaddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject1.dbo.NashvilleHousing a
join PortfolioProject1.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
	where a.propertyaddress is null

---------------------------------------------------------------------------------------------------------

-- Breaking Out address into individual columns (address,city,states)

select  propertyaddress
from PortfolioProject1.dbo.NashvilleHousing
--where propertyaddress is null
--order by parcelid

select 
SUBSTRING (propertyaddress,1,CHARINDEX(',',propertyaddress) -1 ) as Address
,SUBSTRING (propertyaddress,CHARINDEX(',',propertyaddress) +1 , len(propertyaddress)) as Address
from PortfolioProject1.dbo.NashvilleHousing

alter table NashvilleHousing
add PropertySplitAddress nvarchar(255);

update NashvilleHousing
SET PropertySplitAddress = SUBSTRING (propertyaddress,1,CHARINDEX(',',propertyaddress) -1 )

alter table NashvilleHousing
add PropertySplitCity nvarchar(255);

update NashvilleHousing
SET PropertySplitAddress = SUBSTRING (propertyaddress,CHARINDEX(',',propertyaddress) +1 , len(propertyaddress))

select*
from PortfolioProject1.dbo.NashvilleHousing



select owneraddress
from PortfolioProject1.dbo.NashvilleHousing

select 
parsename(replace(owneraddress,',','.'),3)
,parsename(replace(owneraddress,',','.'),2)
,parsename(replace(owneraddress,',','.'),1)
from PortfolioProject1.dbo.NashvilleHousing

alter table NashvilleHousing
add OwnerSplitAddress nvarchar(255);

update NashvilleHousing
SET OwnerSplitAddress = parsename(replace(owneraddress,',','.'),3)

alter table NashvilleHousing
add OwnerSplitCity nvarchar(255);

update NashvilleHousing
SET OwnerSplitCity = parsename(replace(owneraddress,',','.'),2)

alter table NashvilleHousing
add OwnerSplitState nvarchar(255);

update NashvilleHousing
SET OwnerSplitState = parsename(replace(owneraddress,',','.'),1)


select*
from PortfolioProject1.dbo.NashvilleHousing


---------------------------------------------------------------------------------------------------------

--Change Y and N to yes and No "sold as vacant" Fields

select distinct (soldasvacant),COUNT(soldasvacant)
from PortfolioProject1.dbo.NashvilleHousing
group by soldasvacant
order by 2


select soldasvacant
, case when soldasvacant = 'Y' THEN 'Yes'
       when soldasvacant = 'N' THEN 'No'
	   else soldasvacant
	   end
from PortfolioProject1.dbo.NashvilleHousing

update NashvilleHousing
set soldasvacant = case when soldasvacant = 'Y' THEN 'Yes'
       when soldasvacant = 'N' THEN 'No'
	   else soldasvacant
	   end

---------------------------------------------------------------------------------------------------------

--Remove duplicates
with RowNumCTE AS(
select*,
   row_number() over (
   partition by ParcelID,
                propertyaddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY 
				     UniqueID
					 ) row_num
from PortfolioProject1.dbo.NashvilleHousing 
--order by parcelid
)
select *
--DELETE
from RowNumCTE
where row_num>1
order by propertyaddress

select*
from PortfolioProject1.dbo.NashvilleHousing

---------------------------------------------------------------------------------------------------------

--Delete Unused columns

select*
from PortfolioProject1.dbo.NashvilleHousing

alter table PortfolioProject1.dbo.NashvilleHousing
drop column owneraddress, taxdistrict,propertyaddress

alter table PortfolioProject1.dbo.NashvilleHousing
drop column SaleDate