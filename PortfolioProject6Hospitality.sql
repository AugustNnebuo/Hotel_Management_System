--Portfolio Project 6: Creating and Querying a Hospitality mgt system
--Description: This SQL Project carried out involves the Creation and manpiulation of a Hotel Database containing 4 tables,
-- populating the tables, and querying the data in the tables to provide insights for the compay and help them make 
--informed decisions.

-- Create the database
CREATE DATABASE HospitalityHotelDb;
GO

-- Use the database
USE HospitalityHotelDb;
GO

-- Create the GuestMaster table
CREATE TABLE GuestMaster (
    GuestID NVARCHAR(10) PRIMARY KEY,
    GuestName NVARCHAR(100),
    RoomID NVARCHAR(10) ,
    CheckInDate DATE,
    CheckOutDate DATE,
    StateID INT
);
GO

-- Create the Room table
CREATE TABLE Room (
    RoomID NVARCHAR(10) PRIMARY KEY,
    RoomType NVARCHAR(50),
    Price DECIMAL(10, 2),
    Status NVARCHAR(50)
);
GO

-- Create the Booking table
CREATE TABLE Booking (
    BookingID NVARCHAR(10) PRIMARY KEY,
    GuestID NVARCHAR(10) ,
    RoomID NVARCHAR(10) ,
    CheckInDate DATE,
    CheckOutDate DATE,
    TotalAmount DECIMAL(10, 2)
);
GO

-- Create the Statemaster table
CREATE TABLE Statemaster (
    StateID INT PRIMARY KEY,
    StateName NVARCHAR(50)
);
GO

-- Insert data into the Statemaster table
INSERT INTO Statemaster (StateID, StateName)
VALUES 
(101, 'Lagos'),
(102, 'Abuja'),
(103, 'Kano'),
(104, 'Delta'),
(105, 'Ido'),
(106, 'Ibadan'),
(107, 'Enugu'),
(108, 'Kaduna'),
(109, 'Ogun'),
(110, 'Anambra');
GO

-- Insert data into the Room table
INSERT INTO Room (RoomID, RoomType, Price, Status)
VALUES
('R01', 'Single', 100, 'Booked'),
('R02', 'Double', 200, 'Booked'),
('R03', 'Suite', 500, 'Booked'),
('R04', 'Deluxe', 300, 'Booked'),
('R05', 'Single', 100, 'Booked'),
('R06', 'Double', 200, 'Booked'),
('R07', 'Suite', 500, 'Booked'),
('R08', 'Deluxe', 300, 'Booked'),
('R09', 'Single', 100, 'Booked'),
('R10', 'Suite', 500, 'Booked');
GO

-- Insert data into the GuestMaster table
INSERT INTO GuestMaster (GuestID, GuestName, RoomID, CheckInDate, CheckOutDate, StateID)
VALUES
('G01', 'John Doe', 'R01', '2024-08-01', '2024-08-05', 101),
('G02', 'Jane Smith', 'R02', '2024-08-02', '2024-08-07', 102),
('G03', 'Mike Johnson', 'R03', '2024-08-03', '2024-08-08', 103),
('G04', 'Sara Williams', 'R04', '2024-08-04', '2024-08-09', 104),
('G05', 'David Brown', 'R05', '2024-08-05', '2024-08-10', 105),
('G06', 'Emma Davis', 'R06', '2024-08-06', '2024-08-11', 106),
('G07', 'Frank Miller', 'R07', '2024-08-07', '2024-08-12', 107),
('G08', 'Grace Wilson', 'R08', '2024-08-08', '2024-08-13', 108),
('G09', 'Henry Moore', 'R09', '2024-08-09', '2024-08-14', 109),
('G10', 'Linda Taylor', 'R10', '2024-08-10', '2024-08-15', 110);
GO

-- Insert data into the Booking table
INSERT INTO Booking (BookingID, GuestID, RoomID, CheckInDate, CheckOutDate, TotalAmount)
VALUES
('B01', 'G01', 'R01', '2024-08-01', '2024-08-05', 400),
('B02', 'G02', 'R02', '2024-08-02', '2024-08-07', 1000),
('B03', 'G03', 'R03', '2024-08-03', '2024-08-08', 2500),
('B04', 'G04', 'R04', '2024-08-04', '2024-08-09', 1500),
('B05', 'G05', 'R05', '2024-08-05', '2024-08-10', 500),
('B06', 'G06', 'R06', '2024-08-06', '2024-08-11', 1000),
('B07', 'G07', 'R07', '2024-08-07', '2024-08-12', 2500),
('B08', 'G08', 'R08', '2024-08-08', '2024-08-13', 1500),
('B09', 'G09', 'R09', '2024-08-09', '2024-08-14', 500),
('B10', 'G10', 'R10', '2024-08-10', '2024-08-15', 2500);
GO



/*SQL Tasks:
1.	Fetch guests who stayed for the same number of days.
2.	Find the second most expensive booking and the guest associated with it.
3.	Get the maximum room price per room type and the guest name.
4.	Room type-wise count of guests sorted by count in descending order.
5.	Fetch only the first name from the GuestName and append the total amount spent.
6.	Fetch bookings with odd total amounts.
7.	Create a view to fetch bookings with a total amount greater than $1000.

*/

--Queries--1.	Fetch guests who stayed for the same number of days.
select * from GuestMaster
SELECT DISTINCT 
    g1.GuestID, 
    g1.GuestName,
    DATEDIFF(DAY, g1.CheckInDate, g1.CheckOutDate) AS StayDays
FROM 
    GuestMaster g1
	--this portion of this code tells me how many days each guest stayed.
JOIN 
    GuestMaster g2
ON 
    DATEDIFF(DAY, g1.CheckInDate, g1.CheckOutDate) = DATEDIFF(DAY, g2.CheckInDate, g2.CheckOutDate)
    AND g1.GuestID <> g2.GuestID
	-- Then i created a self join and joined the table Guestmaster to itself on the condition that the stay days are same but IDs different.
ORDER BY 
    StayDays, 
    g1.GuestID;
	-- then I ordered it for aesthetics

--2.	Find the second most expensive booking and the guest associated with it.

select * from [dbo].[Booking]

select G.GuestName, B.TotalAmount
from GuestMaster G
join Booking B on B.GuestID = G.GuestID
order by B.TotalAmount desc
Offset 1 row
fetch next 1 row only

--3.	Get the maximum room price per room type and the guest name.
select G.GuestName, R.RoomType, R.Price
from Room R
join GuestMaster G on R.RoomID =G.RoomID
join (select RoomID, max(Price) Max_Price
from Room 
group by RoomID) I
on R.RoomID = I.RoomID
and R.Price = I.Max_Price

--4.	Room type-wise count of guests sorted by count in descending order.
select R.RoomType,  count(G.GuestName)
from Room R
join GuestMaster G
 on R.RoomID =G.RoomID
group by R.RoomType
order by count(G.GuestName) desc

--5.	Fetch only the first name from the GuestName and append the total amount spent.

select CONCAT(left(G.GuestName, Charindex(' ',G.GuestName) -1 ), '_' , B.TotalAmount) GuestName_Age
From GuestMaster G
join Booking B on B.GuestID=G.GuestID


--6.	Fetch bookings with odd total amounts.
select * from Booking
where TotalAmount % 2 =1

--7.	Create a view to fetch bookings with a total amount greater than $1000.
create view vw_Expensivebokings as
select * from Booking
where TotalAmount> 1000

select * from vw_Expensivebokings