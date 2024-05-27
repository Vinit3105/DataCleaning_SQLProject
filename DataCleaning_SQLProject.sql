--cleaning data in SQL queries

select *
from PortfolioProject..NashvilleHousing

----------------------------------------------------------------------------------------------------------------------------------

--standardize the saledate

select SaleDateConverted , convert (date,saledate)
from PortfolioProject..NashvilleHousing


update NashvilleHousing
set saledate=convert(date,SaleDate)


alter table nashvillehousing 
add SaleDateConverted Date;

update NashvilleHousing
set SaleDateConverted =convert (Date,SaleDate)

-------------------------------------------------------------------------------------------------------------------------------

--populate property address data 


select *
from PortfolioProject..NashvilleHousing
--where PropertyAddress is null
order by parcelid

select a.parcelid,a.propertyaddress,b.parcelid,b.propertyaddress , isnull(a.propertyaddress,b.propertyaddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
     on a.parcelid=b.parcelid
	 and a.uniqueid <> b.uniqueid
where a.propertyaddress is null 


update a
set propertyaddress = isnull(a.propertyaddress,b.propertyaddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
     on a.parcelid=b.parcelid
	 and a.uniqueid <> b.uniqueid
where a.propertyaddress is null 

-------------------------------------------------------------------------------------------------------------------------------

--breaking out address into individual columns (address,city,state)

select propertyaddress
from PortfolioProject..nashvillehousing


select 
substring (propertyaddress,1 ,charindex(',' , propertyaddress) -1) as address
,substring (propertyaddress ,charindex(',' , propertyaddress) +1, len(propertyaddress)) as address
from PortfolioProject..NashvilleHousing


alter table NashvilleHousing
add propertysplitaddress nvarchar(255);

update nashvillehousing 
set propertysplitaddress =substring (propertyaddress,1 ,charindex(',' , propertyaddress) -1) 


alter table Nashvillehousing
add propertysplitcity nvarchar(255);

update nashvillehousing 
set propertysplitcity = substring (propertyaddress ,charindex(',' , propertyaddress) +1, len(propertyaddress)) 


select *
from PortfolioProject..NashvilleHousing


select OwnerAddress
from PortfolioProject..NashvilleHousing

select 
parsename(replace(owneraddress,',','.'),3),
parsename(replace(owneraddress,',','.'),2),
parsename(replace(owneraddress,',','.'),1)
from PortfolioProject..NashvilleHousing


alter table Nashvillehousing
add ownersplitaddress nvarchar(255);

update nashvillehousing 
set ownersplitaddress= parsename(replace(owneraddress,',','.'),3)


alter table Nashvillehousing
add ownersplitcity nvarchar(255);

update nashvillehousing 
set ownersplitcity= parsename(replace(owneraddress,',','.'),2)

alter table Nashvillehousing
add ownersplitstate nvarchar(255);

update nashvillehousing 
set ownersplitstate= parsename(replace(owneraddress,',','.'),1)

-----------------------------------------------------------------------------------------------------------------------------------

--change Y and N to Yes and No in "Sold as Vacant" field


select distinct(soldasvacant), count(soldasvacant)
from PortfolioProject..NashvilleHousing
group by SoldAsVacant
order by 2


select soldasvacant
,case when SoldAsVacant='Y' then 'Yes'
      when SoldAsVacant='N' then 'No'
      else SoldAsVacant
      end
from PortfolioProject..NashvilleHousing


update NashvilleHousing
set SoldAsVacant=case when SoldAsVacant='Y' then 'Yes'
      when SoldAsVacant='N' then 'No'
      else SoldAsVacant
      end

-------------------------------------------------------------------------------------------------------------------------

--Remove Duplicates

with RowNumCTE as (
select *,
      ROW_NUMBER() over(
	  partition by parcelid,
	               propertyaddress,
				   saleprice,
				   saledate,
				   legalreference
				   order by 
				      uniqueid
					  )row_num

from PortfolioProject..NashvilleHousing
--order by ParcelId
)
select *
--delete
from RowNumCTE
where row_num >1
--order by PropertyAddress

-----------------------------------------------------------------------------------------------------------------------

--Delete Unused Columns

select *
from PortfolioProject..NashvilleHousing

alter table PortfolioProject..NashvilleHousing
drop column OwnerAddress,TaxDistrict,PropertyAddress

alter table PortfolioProject..NashvilleHousing
drop column Saledate