--Create database Foodservice--
Create database FoodserviceDB
Use FoodserviceDB

--Alter statement to add primary key--
Alter Table Ratings Add  RatingsID int IDENTITY(1,1) PRIMARY KEY

--Alter statement to add primary key--
Alter Table Restaurant_Cuisines Add  Restaurant_CuisinesID int IDENTITY(1,1) PRIMARY KEY

select * from Ratings
select * from Consumers
select * from Restaurant_Cuisines
select * from Restaurants

--Alter statement to  ADD FOREIGN KEY--
ALTER TABLE Ratings
ADD FOREIGN KEY (Consumer_ID) REFERENCES Consumers (Consumer_ID);

--Alter statement to  ADD FOREIGN KEY--
ALTER TABLE Ratings
ADD FOREIGN KEY (Restaurant_ID) REFERENCES Restaurants (Restaurant_ID);

--Alter statement to  ADD FOREIGN KEY--
ALTER TABLE Restaurant_Cuisines
ADD FOREIGN KEY (Restaurant_ID) REFERENCES Restaurants (Restaurant_ID);


--CREATE VIEW AllmyTables--
CREATE VIEW AllmyTables (Restaurant_Name, Price, Area, Cuisine, Overall_Rating, Food_Rating,  Service_rating, Age)
As
SELECT R.Name,R.Price, R.Area, RC.Cuisine, RT.Overall_Rating,
       RT.Food_Rating,RT.Service_rating, C.AGe
FROM Restaurants R
JOIN Restaurant_Cuisines RC ON R.Restaurant_ID = RC.Restaurant_ID
JOIN Ratings RT ON R.Restaurant_ID = RT.Restaurant_ID
JOIN Consumers C ON RT.Consumer_ID = C.Consumer_ID;

select * from AllmyTables

--Question 1--
SELECT Restaurant_Name
FROM AllmyTables
WHERE Price = 'Medium' and Area = 'Open' and Cuisine = 'Mexican';

--Question 2--
Select Count(*) from AllmyTables
where Overall_Rating = 1 and Cuisine = 'Mexican'

Select Count(*) from AllmyTables
where Overall_Rating = 1 and Cuisine = 'Italian'

--Question 3--
Select Avg(Age) from AllmyTables
where Service_rating = 0

--Question 4--

select rt.Name, r.food_rating from ratings r
join restaurants rt on rt.Restaurant_ID = r.Restaurant_ID
join consumers c on c.consumer_id = r.Consumer_ID
where c.Age= ( select min(Age) from consumers)
order by r.Food_Rating Desc

--Question 5--
CREATE PROCEDURE ServiceRaingUpdate 
as
BEGIN
UPDATE R
SET R.Service_rating = 2
from Ratings R Inner Join Restaurants RC on R.Restaurant_id = RC.restaurant_id
where RC.Parking in ('Public', 'yes')
END

Exec ServiceRaingUpdate

--Question 6--

--Nested queries-EXISTS--

SELECT *
FROM Consumers Cu
WHERE Cu.Occupation = 'Student' and Cu.Budget = 'low'
AND EXISTS (
    SELECT 1
    FROM Ratings R
    WHERE R.Consumer_id = Cu.Consumer_id
)



--GROUP BY, HAVING, and ORDER BY--
SELECT Name, COUNT(*) AS Total_Ratings
FROM Ratings
JOIN Restaurants ON Ratings.Restaurant_id = Restaurants.Restaurant_id
GROUP BY Name
HAVING COUNT(*) >= 10
ORDER BY Total_Ratings DESC;

--Nested queries-In--
SELECT Children, COUNT(*) AS Consumer_Count
FROM Consumers
WHERE Consumer_id IN (
    SELECT DISTINCT Consumer_id
    FROM Ratings
)
GROUP BY Children;

