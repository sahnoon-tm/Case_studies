# Project: NYC Taxi Fare Estimation App

[Click here to view the dashboard](https://public.tableau.com/app/profile/sahnoon.t.m/viz/NYCtaxianalysis/Dashboard1)


## Background
- The New York City Taxi and Limousine Commission (TLC) regulates taxi and for-hire vehicles.
- Automatidata, a data consulting firm, is tasked with developing a taxi fare estimation app for TLC riders.

## Objectives
- Analyze historical ride fare data to identify pricing trends.
- Develop a predictive model to estimate taxi fares based on trip details.
- Provide insights to help TLC optimize fare structures.
- Identify potential factors influencing fare variations (e.g., peak hours, distance, weather).
- Enhance customer experience by offering upfront fare estimates.
- Support business strategy by improving pricing transparency and competitiveness.

## Data Descriptions

Unnamed: 0 – Index or unique trip identifier.
VendorID – ID of the taxi service provider.

1= Creative Mobile Technologies, LLC; 
2= VeriFone Inc.

tpep_pickup_datetime – Date and time when the trip started.
tpep_dropoff_datetime – Date and time when the trip ended.
passenger_count – Number of passengers in the taxi.
trip_distance – Distance of the trip in miles.
RatecodeID – Rate type used for the fare calculation.

1= Standard rate - This is the normal fare used for most rides within NYC. It's based on time and distance. Example: A regular trip from Manhattan to Brooklyn.
2=JFK - A flat fare for trips between JFK Airport and Manhattan. The rate is fixed no matter the distance.
3=Newark  - A specific rate used for trips to/from Newark Airport (in New Jersey). May include tolls or negotiated rates.
4=Nassau or Westchester - Trips going outside NYC to areas like Nassau County or Westchester County (suburbs). Different pricing rules may apply.
5=Negotiated fare - A fare agreed upon between the driver and the passenger before the trip starts. It’s not based on the meter. Often used for long trips.
6=Group ride - Fare for a shared taxi ride, where multiple passengers are going in the same direction. They pay a lower individual fare. Example: Shared ride from JFK to different parts of Manhattan.

store_and_fwd_flag – Whether the trip data was stored and forwarded later ('Y' or 'N').

Y= store and forward trip ( might less accurate)
N= not a store and forward trip ( accurate )

PULocationID – Pickup location zone ID.
DOLocationID – Dropoff location zone ID.
payment_type – Payment method used (e.g., cash, credit card).

1= Credit card 
2= Cash 
3= No charge - Could be a promotional trip, employee ride, or error
4= Dispute  -  passenger or company raised a complaint. These are usually unpaid or under review.
5= Unknown 
6= Voided trip - cancelled trip

fare_amount – Base fare for the trip.
extra – Additional charges (e.g., peak hour surcharge).
mta_tax – NYC Metropolitan Transportation Authority tax.
tip_amount – Tip given to the driver.
tolls_amount – Tolls paid during the trip.
improvement_surcharge – Surcharge for transportation improvement.
total_amount – Final amount charged for the trip.


# Area to focus

## STAGE 1

-- Perform Indepth KPI analysis using SQL (postgre with pgadmin)

-- Total revenue = 370256.72
-- Average fare_amount = 13
-- Total Tip amount = 41670.37
-- Average Tip amount = 1.90
-- Total tip = 14642 times
-- Total rides = 22699
-- Total passengers = 37279
-- Average passenger = 2
-- Total distance coverd = 66129.13
-- Average distance coverd = 3 miles
-- Most common pickup zones = "Upper East Side South"	890
-- Most common dropoff zones = "Midtown Center"	858
-- most comman payment_type = Credit card
-- most profitable zone = "JFK Airport"	29257.82
-- Average drip duration = 17 min

## Hour wise variations

-- Peak Travel Hours (6–8 PM)
-- Highest number of rides and passengers (2400+)
-- Avg fare is moderate (~$13.2)
-- Increase driver availability (shift planning)

-- High Fare Hours (5 AM)
-- Fare is highest: $19.50, but rides are very low (235)

-- Morning Rush (7–10 AM)
-- Ride volume rises steadily from 857 to 1112
-- Total passengers also high
-- Fare is relatively low (~$12.3)

-- Low Demand at Night (12–5 AM)
-- Rides & passengers drop significantly
-- Avg fare remains moderate (~$13)
-- Reduce active fleet to save costs


## day wise variations

-- Friday (3,413 rides) is the busiest day, followed closely by Thursday and Wednesday.
-- Suggests high weekday demand, likely due to commuting and work-related travel.

-- Saturday (5,766 passengers) and Friday (5,571) had the most passengers.
-- Indicates people often travel in groups or for on weekends.

-- Monday ($13.43) has the highest average fare, slightly higher than Thursday and Sunday.
-- Saturday ($12.35) has the lowest average fare, but highest total passengers.

## month wise 

Top 3 Revenue Months:
May – $33,828.92
March – $33,086.21
October – $33,066.13
-- These months could reflect spring and fall tourist seasons or favorable weather, increasing taxi demand.

Top Rides: March (2049), May (2013), April (2019), October (2027)
--meaning steady demand and more active drivers.

Lowest Revenue + Rides
July & August have Lowest total revenue (~$26k–$27k) and Fewer rides (~1697–1724)

Most months have ~3,000 passengers
Slightly lower in July–August (~2,900) and February (~2,900)


## Zone wise variations

-- Airport Trips = High Revenue
-- JFK and Newark have the highest average fares, with JFK having 532 rides — very high volume + high fare.
-- Prioritize availability in these zones.

-- “Outside of NYC” = Exceptionally High Fare
-- $96 average fare, even though average distance is low (2.1 miles) — likely includes toll zones, flat rates, or negotiated fares

-- Short Trips = Low Revenue
-- While these zones don’t bring much revenue, drivers may avoid them if fares are too low, hurting service quality in those areas 
-- Some distances are near zero (e.g., 0.01 miles) — possible GPS errors or very short rides.


-- Airports Generate the Highest Revenue, JFK ($29k) and LaGuardia ($27k) are far ahead of other zones.
-- Zones like Midtown Center, Times Square/Theatre District, Penn Station, Union Square are high-revenue areas might due to Tourist density and busniess office 
-- Zones like Upper East Side South, Murray Hill, and Clinton East show strong revenue too , maybe turism and office business

-- Credit Card rides make up the majority of tips. On average, passengers tip ₹2.73 per ride using cards.
-- Cash, No Charge, and Disputed payments do not generate tips in the dataset.
-- when doing other payment tip might not mention so it might inacurate
-- Most of the total tip revenue (₹41,670.37) comes from credit card payments.

-- "Woodhaven"	12.880000114440918 and "South Ozone Park"	11.699999809265137 is high paying tip 
-- 29 zone doesnt provide tip and 11 zone providing less than 1 dollar tip

## STAGE 2

-- histogram shows that the majority of trips are very short distances (clustered on the left side, near 0.0 to 5.0 miles)
-- The frequency drops sharply as the distance increases, with very few trips exceeding 10-20 miles.
-- VeriFone Inc is gettting more tip than , Creative Mobile Technologies
-- performed a/b testing and findout customers who pay in credit card tend to pay a larger fare amount

-- performed corrilation matrax and found out
*  Check correlation matrix
* Higher fares are associated with higher tips (common in ride-hailing data)
* Longer trips may lead to slightly higher tips.

# created new featured such as ride happend time like morning or night and profit per ride
-- long ride genereate more profit which mean the longer the ride more profit
-- profit ratio is almost same for day, time doesnt effect much 
-- Short trips peak in the morning, Medium trips rise in the afternoon
-- Short trips drop slightly at night , Medium trips spike in the evening
-- unexpected picture is long trips surge at night,may be airport travel
-- among the few loss most happening at night and evenig 
-- short travel cousing loss

-- Chi-Square Test shows statistically significant relationship between payment method and tipping behavior

## Suggestions
Increase fleet availability during  (6-8) hours to meet demand and reduce wait time
Reduce active fleet during 12-5 hours to save operational costs.
Prioritize sending drivers to JFK and LaGuardia locations to maximize income per ride.
change the short trip fare amount, adjust pricing, add minimum fare limits, or limit short ride acceptance at night
Encourage digital payments through in-car signage or app settings.