# Sales Analysis Report
[Click here to view the dashboard](https://public.tableau.com/app/profile/sahnoon.t.m/viz/super_store_analysis_17477283254530/Dashboard1)

Objective :-
Analyse the data set to find the different region and based on their sales and profit, 
and also address the reason for the losses and suggest improvement

Data set - https://www.kaggle.com/datasets/vivek468/superstore-dataset-final

## STAGE-1

-- User Excel for data cleaning(removed empty rows ,formatted corrected data type)
-- Prepared EDA using pivot table
-- Understand the basic idea about the data set

## STAGE - 2



* Total Sales         = 2296919.70
* Total Profit        = 286409.85
* Total Quantity Sold = 37871
* Total Loss          = -156119.80
* Total Customer      = 793
* Profit Margin       = 12.47
* Total state         = 43
* Total cities        = 531
* Avg Shipping Time   = 3-4 days
* Avg discount        = .16
* shipping mode       = 4 type


-- Geogrphical KPI

* Top Region by sales

"West"	   725457.93
"East"	   678499.99
"Central"	501239.88
"South"	   391721.90

* Top Region by profit

"West"	   108418.79
"East"	   91534.90
"South"	   46749.71
"Central"	39706.45

* Top 5 state by sales

"California"	457687.68
"New York"	   310876.20
"Texas"	      170187.98
"Washington"	138641.29
"Pennsylvania"	116512.02

* Bad 5 state by sales

"Abilene"	   1.39
"Elyria"	      1.82
"Jupiter"	   2.06
"Pensacola"	   2.21
"Ormond Beach"	2.81

* Top 5 state by profit

"California"	76381.60
"New York"	74038.64
"Washington"	33402.70
"Michigan"	24463.15
"Virginia"	18598.00

-- Category and Product KPI

* Total Products     = 1862
* Total Category     = 3
* Total Sub categroy = 17
* Product with profit= 1803
* Product with loss  = 777

* Best selling category 

"Technology"	   145455.66
"Office Supplies"	122490.88
"Furniture"	       18463.31


* West has high profit and sales, and 2/5 high sales cities and state are from west.
people from west most buy Technology and office supplies and both category has high profit 
as well as sales.and most people are from cunsumer and less home office , people prefer standard 
shipping mode often, avg discount is .11 


* Central has lowest profit and 3rd lowest sales. 2/5 high loss state are from central and 60 out of 180 cities producting 
loss here. poeple in central doesnt purchanse technology much but prefer furniture and office suppies more which course loss
10 out of 17 prodcut doesnt produce profit in central, most people are from cunsumer and less home office,  people prefer Second class 
shipping mode often, avg discount is 0.24


* East Region performs better than Central, with only 3 loss-making sub-categoriesand strong profits from 
Technology and Office Supplies. The only concern is Furniture – especially Tables, which creates heavy losses.Most
people are cunsumer and less home office, poeple prefer standard class shipping mode , with avg dicount .15


* The South region performs slightly better than Central, but not as efficiently 
as East or West. The Technology category (Phones, Accessories) remains a key 
profit center. However, Furniture – especially Tables – continues to create 
substantial losses, and Machines also show red flags despite high sales. with hight consumer and standard
calss as fav shipping mode with .15 avg dicount 


* Products like Machines and Tables often show high sales but negative profit
* Tables, Bookcases, and sometimes Appliances are loss-making in almost all regions
* Phones, Copiers, and Accessories are usually profitable and show strong demand across most regions
* Technology and Office Supplies are the most stable profit generators
* Furniture has the most inconsistent performance, often being loss-making.


* High profit and sales are from technology, sales are much greater 
than office supplies for furniture, but the profit ratio is too low
for the furniture. here we see less discount producing high profit

* in furniture here bookcases and tables are cousing more loss but both it have high discount
* high discount is cousing more loss  Above .30 discount produce loss best margin is .10 which has good profit range


## STAGE 3

* Discount has a negative correlation with profit.Discounts show almost no relationship with Sales
* shipping duration has nothing to do with sales or profit, it remain independent correlation with other metrics
* sales and profit has medium corrilation

* performing t test for the region and category

* After doing the t test in south vs east i found out The average profit of East and South regions is not statistically different. There's no strong reason to believe that East is underperforming compared to South. We might treat them equally in terms of profitability planning

* There is a statistically significant difference in average profit between Technology and Furniture. so we can confirm the diffrenet is indeed 

* performing anova testing for the segment with profit and sales

* Result showing there is no statistically significant difference in the average profit and sales among the three segments.
* we do not have enough evidence to say that profit or sales differ significantly between different shipping modes

* performing AB test for discount vs sales

* Bases on the test we see Discounts do not have a clear effect on sales in this dataset.
* we do NOT have strong enough evidence to confidently say that the average profit margins differ significantly across segments
* Although the Home Office segment shows a slightly higher average profit margin (14.3%), the ANOVA test does not provide statistically significant evidence (p = 0.054) to confirm that profit margins differ across customer segments

* After reducing all discounts to a flat 10%, the total profit increased by approximately 98% and the total loss decreased by about 92%, showing a significant improvement in overall profitability

* sales and profit are increasing over year

## STAGE 4  

* Designed a professional Tableau dashboard to visualize:
--  Sales & profit trends over time
--  Regional performance across states
--  Sub-category insights
--  Customer segmentation
--  Discount vs Profit impact using scatter plots
--  Interactive filtering for top/low performing products


