create database hoteldb;
select * from hotels;

-- (A)  SEASONAL ANALYSIS

--  analyze booking patterns across different months/seasons over the ten year period 
-- step 1. calculate the total number of bookings for each month 

SELECT EXTRACT(MONTH FROM Date_of_Booking) AS Month,
COUNT(*) AS TotalBookings
FROM hotels
GROUP BY Month
ORDER BY Month;

-- step 1. calclate the total number of bookings for each month
SELECT
    EXTRACT(MONTH FROM Date_of_Booking) AS Month,
    CASE EXTRACT(MONTH FROM Date_of_Booking)
         WHEN 1 THEN 'January'
         WHEN 2 THEN 'February'
         WHEN 3 THEN 'March'
         WHEN 4 THEN 'April'
         WHEN 5 THEN 'May'
         WHEN 6 THEN 'June'
         WHEN 7 THEN 'July'
         WHEN 8 THEN 'August'
         WHEN 9 THEN 'September'
         WHEN 10 THEN 'October'
         WHEN 11 THEN 'November'
         WHEN 12 THEN 'December'
     END AS MonthName,
    COUNT(*) AS TotalBookings
 FROM hotels
 GROUP BY EXTRACT(MONTH FROM Date_of_Booking), MonthName
 ORDER BY EXTRACT(MONTH FROM Date_of_Booking)
 LIMIT 0, 5000;


-- total number of booking patterns across different seasons

SELECT
    CASE
        WHEN EXTRACT(MONTH FROM Date_of_Booking) IN (12, 1, 2) THEN 'Winter'
        WHEN EXTRACT(MONTH FROM Date_of_Booking) IN (3, 4, 5) THEN 'Spring'
        WHEN EXTRACT(MONTH FROM Date_of_Booking) IN (6, 7, 8) THEN 'Summer'
        WHEN EXTRACT(MONTH FROM Date_of_Booking) IN (9, 10, 11) THEN 'Fall'
    END AS Season,
    COUNT(*) AS TotalBookings
FROM hotels
GROUP BY Season
ORDER BY Season;
 

--  identify peak booking periods, low seasons, and recurring trends 
-- Step 1. calculate the monthly average number of bookings for each month across all years: 

SELECT EXTRACT(MONTH FROM Date_of_Booking) AS Month,
COUNT(*) / COUNT(DISTINCT EXTRACT(YEAR_MONTH FROM Date_of_Booking)) AS AverageBookings
FROM hotels
GROUP BY EXTRACT(MONTH FROM Date_of_Booking)
ORDER BY Month;

--  calculates the count of bookings for each month.
-- The outer query then uses MAX and AVG on the result of the subquery to find the peak and average bookings for each mont

SELECT
    Month,
    MAX(BookingCount) AS PeakBookings,
    AVG(BookingCount) AS AverageBookings
FROM (
    SELECT
        EXTRACT(MONTH FROM Date_of_Booking) AS Month,
        COUNT(*) AS BookingCount
    FROM hotels
    GROUP BY EXTRACT(MONTH FROM Date_of_Booking)
) AS MonthlyCounts
GROUP BY Month
ORDER BY Month;

-- month with lowest booking

SELECT
    EXTRACT(MONTH FROM Date_of_Booking) AS Month,
    COUNT(*) AS TotalBookings
FROM hotels
GROUP BY Month
ORDER BY TotalBookings
LIMIT 1;

-- determine if there are specific destinations or origin countries that drive seasonal variations
-- step 1.  Identify destinations with significant seasonal variations. write a query to show the total bookings for
--  each destination country for each month, allowing you to identify seasonal patterns.
  
  SELECT Destination_Country,
EXTRACT(MONTH FROM Date_of_Booking) AS Month,
COUNT(*) AS TotalBookings FROM hotels
GROUP BY Destination_Country, Month
ORDER BY Destination_Country, Month;

-- step 2.  write a query to show the total bookings for
--  each origin country for each month, allowing you to identify seasonal patterns.

SELECT Origin_Country,
EXTRACT(MONTH FROM Date_of_Booking) AS Month,
COUNT(*) AS TotalBookings
FROM hotels
GROUP BY Origin_Country, Month
ORDER BY Origin_Country, Month;

-- step 3 combine both origin and destination countries to see if there are specific country pairs that exhibit seasonal variations

SELECT Origin_Country, Destination_Country,
EXTRACT(MONTH FROM Date_of_Booking) AS Month,
COUNT(*) AS TotalBookings
FROM hotels
GROUP BY Origin_Country, Destination_Country, Month
ORDER BY Origin_Country, Destination_Country, Month;

-- (B) DEMOGRAPHIC ANALYSIS

-- explore the distribution of bookings by age group, gender,  and origin country/state

--  step 1. categorize age into groups and count bookings in each group

 SELECT
    CASE
        WHEN Age BETWEEN 18 AND 30 THEN '18-30'
        WHEN Age BETWEEN 31 AND 40 THEN '31-40'
        WHEN Age BETWEEN 41 AND 50 THEN '41-50'
        ELSE '50+'  -- Adjust age ranges as needed
    END AS AgeGroup,
COUNT(*) AS TotalBookings
FROM hotels
GROUP BY AgeGroup
ORDER BY AgeGroup;

-- step 2 count bookings for each gender
SELECT Gender,
    COUNT(*) AS TotalBookings
FROM hotels
GROUP BY Gender;

-- step 3.  bookings by each origin country
SELECT Origin_Country, State,
COUNT(*) AS TotalBookings
FROM hotels
GROUP BY Origin_Country, State
ORDER BY Origin_Country, State;

-- (C) PAYMENT METHODS AND BOOKING FEES ANALYSIS

-- analyze the distribution of payment methods used by customers
SELECT Payment_Mode,
COUNT(*) AS TotalBookings,
AVG(Booking_Price) AS AverageBookingPrice,
SUM(Booking_Price) AS TotalBookingAmount
FROM hotels
GROUP BY Payment_Mode
ORDER BY TotalBookings DESC;

-- correlate payment methods with booking fees and taxes to understand preferences and spending habits
SELECT Payment_Mode,
AVG(Booking_Price) AS AverageBookingPrice,
AVG(Discount) AS AverageDiscount,
AVG(GST) AS AverageGST,s
AVG(Profit_Margin) AS AverageProfitMargin
FROM hotels
GROUP BY Payment_Mode
ORDER BY AverageBookingPrice DESC;

-- (D) HOTEL RATINGS AND CUSTOMER SATISFACTION

-- examine the relationship between hotel ratings and booking frequency

-- step 1.   counts the number of bookings for each hotel rating

SELECT Hotel_Rating,
COUNT(*) AS BookingFrequency
FROM hotels
GROUP BY Hotel_Rating
ORDER BY Hotel_Rating;

--  step 2. average booking price and total booking amount for each hotel rating
SELECT Hotel_Rating, 
COUNT(*) AS BookingFrequency,
AVG(Booking_Price) AS AverageBookingPrice,
SUM(Booking_Price) AS TotalBookingAmount
FROM hotels
GROUP BY Hotel_Rating
ORDER BY Hotel_Rating;

-- investigate any correlation between hotel ratings and customer demographics or origin countries

-- step 1. Correlation between Hotel Ratings and Age Groups: average hotel ratings per age group
 SELECT AVG(Hotel_Rating) AS AverageHotelRating,
    CASE
        WHEN Age BETWEEN 18 AND 30 THEN '18-30'
        WHEN Age BETWEEN 31 AND 40 THEN '31-40'
        WHEN Age BETWEEN 41 AND 50 THEN '41-50'
        ELSE '50+'  -- Adjust age ranges as needed
    END AS AgeGroup
FROM hotels
GROUP BY AgeGroup
ORDER BY AgeGroup;

-- step 2. Correlation between Hotel Ratings and Gender: average hotel ratings per gender
SELECT AVG(Hotel_Rating) AS AverageHotelRating, Gender
FROM hotels
GROUP BY Gender
ORDER BY Gender;

-- step 3. Correlation between Hotel Ratings and Origin Countries/States: average hotel ratings per origin countries/states
SELECT AVG(Hotel_Rating) AS AverageHotelRating,
Origin_Country, State
FROM hotels
GROUP BY Origin_Country, State
ORDER BY Origin_Country, State;

-- (E) OCCUPANCY ANALYSIS

-- analyze the number of room occupants per booking and its correlation with room type, origin, and destination

-- step 1.Number of Room Occupants per Booking: Analyze the distribution of the number of occupants per booking.
SELECT Rooms,
COUNT(*) AS BookingCount
FROM hotels
GROUP BY Rooms
ORDER BY Rooms;

-- step 2. Correlation with Origin and Destination: Analyze the average number of occupants per booking for each combination of origin and destination.
SELECT Origin_Country, State AS Origin_State, Destination_Country, Destination_City AS Destination_State, AVG(Rooms) AS AverageOccupants
FROM hotels
GROUP BY Origin_Country, Origin_State, Destination_Country, Destination_State
ORDER BY Origin_Country, Origin_State, Destination_Country, Destination_State;

-- determine if there are any trends in the number of occupants based on the time of year or specific events

-- Trends Based on Time of Year: Analyze the average number of occupants per booking for each month.
SELECT EXTRACT(MONTH FROM Check_In_Date) AS Month,
AVG(Rooms) AS AverageOccupants
FROM hotels
GROUP BY Month
ORDER BY Month;
