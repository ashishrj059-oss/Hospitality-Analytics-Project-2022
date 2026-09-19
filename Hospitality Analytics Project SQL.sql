Create database Hospitality_Analytics;
Use Hospitality_Analytics;

-- Total Bookings
select
count(booking_id) as total_bookings
from fact_bookings;

-- Total Revenue
select
sum(revenue_realized) as total_revenue
from fact_bookings;

-- Total capacity
select 
sum(capacity) as total_capacity
from fact_aggregated_bookings;

-- Total Successful_bookings
select sum(successful_bookings) as 	Total_Successful_bookings
from fact_aggregated_bookings;

-- Total Cancelled Bookings
select
count(booking_id) as Total_Cancelled_bookings
from fact_bookings
where booking_status = "Cancelled";

-- Cancellation Rate %
select
round(count(case when booking_status = 'cancelled' then 1 
end) * 100/ count(booking_id),2) as Cancellation_rate_percentage
from fact_bookings;

-- Total No show Bookings
select
count(booking_id) as Total_No_show_bookings
from fact_bookings
where booking_status = "No show";

-- No show rate %
select
round(count(case when booking_status = 'No show' then
 1 end) * 100/ count(booking_id),2) as Noshow_rate_Percentage
from fact_bookings;

-- Total checked out bookings
select count(booking_id) as Total_checked_out
from fact_bookings
where booking_status = "checked out";	

-- Realisation %
select
round(count(case when booking_status ='checked_out' then
 1 end)* 100/ count(booking_id),2) as Realisation_Percentage
from fact_bookings;

-- Average Rating
select
round(Avg(ratings_given),2) as average_rating
from fact_bookings;

-- ADR (Average Daily Rate)
select
round(sum(revenue_realized) * 1.0/count(booking_id),2) as ADR
from fact_bookings;

-- No of days
select	
count(distinct check_in_date) as no_of_days
from fact_aggregated_bookings;

-- RevPAR
select
round((select sum(revenue_realized)
from fact_bookings)
/
(select sum(capacity)
from fact_aggregated_bookings),2) as RevPAR;

-- DBRN (Daily booked room nights)
select round(sum(successful_bookings)/count(distinct check_in_date),2) as DBRN
from fact_aggregated_bookings;

-- DURN (Daily Utilized Room Nights)
select round(count(*)/count(distinct check_in_date),2) as DURN
from fact_bookings
where booking_status = "checked out";

-- DSRN (Daily Sellable Room Nights)
select round(sum(capacity)/count(distinct check_in_date),2) as DSRN
from fact_aggregated_bookings;

-- Channel and category breakdown
select
booking_platform, 
count(booking_id) as Total_bookings,
round(count(booking_id)*100/(select count(*) from fact_bookings),2) as booking_percentage
from fact_bookings
group by booking_platform
order by total_bookings desc;

-- Booking % by room category
select
room_category,
count(booking_id) as total_bookings,
round(count(booking_id)*100/
(select count(*) from fact_bookings), 2) as booking_percetage
from fact_bookings
group by room_category
order by total_bookings desc;

-- Revenue WoW Change %
SELECT
    week_no,
    weekly_revenue,
    ROUND(
        (weekly_revenue - LAG(weekly_revenue) OVER (ORDER BY week_start))
        / LAG(weekly_revenue) OVER (ORDER BY week_start) * 100,
        2
    ) AS revenue_wow_change_percentage
FROM (
    SELECT
        d.`week no` AS week_no,
        MIN(d.date) AS week_start,
        SUM(fb.revenue_realized) AS weekly_revenue
    FROM fact_bookings fb
    JOIN dim_date d
        ON fb.check_in_date = d.date
    GROUP BY d.`week no`
) AS weekly_data
ORDER BY week_start;

-- Occupancy WoW Change %
SELECT
    week_no,
    occupancy_percentage,
    ROUND(
        (
            occupancy_percentage
            - LAG(occupancy_percentage) OVER (ORDER BY week_start)
        )
        / LAG(occupancy_percentage) OVER (ORDER BY week_start) * 100,
        2
    ) AS occupancy_wow_change_percentage
FROM (
    SELECT
        d.`week no` AS week_no,
        MIN(d.date) AS week_start,
        SUM(fab.successful_bookings) /
        SUM(fab.capacity) * 100 AS occupancy_percentage
    FROM fact_aggregated_bookings fab
    JOIN dim_date d
        ON fab.check_in_date = d.date
    GROUP BY d.`week no`
) AS weekly_occupancy
ORDER BY week_start;

 -- ADR WoW Change %
SELECT
    week_no,
    adr,
    ROUND(
        (adr - LAG(adr) OVER (ORDER BY week_start))
        / LAG(adr) OVER (ORDER BY week_start) * 100,
        2
    ) AS adr_wow_change_percentage
FROM (
    SELECT
        d.`week no` AS week_no,
        MIN(d.date) AS week_start,
        SUM(fb.revenue_realized) /
        SUM(fb.booking_status = 'Checked Out') AS adr
    FROM fact_bookings fb
    JOIN dim_date d
        ON fb.check_in_date = d.date
    GROUP BY d.`week no`
) AS weekly_adr
ORDER BY week_start;

-- RevPAR WoW Change %
SELECT
    week_no,
    weekly_revenue,
    weekly_capacity,
    revpar,
    ROUND(
        (revpar - LAG(revpar) OVER (ORDER BY week_start))
        / LAG(revpar) OVER (ORDER BY week_start) * 100,
        2
    ) AS revpar_wow_change_percentage
FROM (
    SELECT
        r.week_no,
        r.week_start,
        r.weekly_revenue,
        c.weekly_capacity,
        r.weekly_revenue / c.weekly_capacity AS revpar
    FROM (
        SELECT
            d.`week no` AS week_no,
            MIN(d.date) AS week_start,
            SUM(fb.revenue_realized) AS weekly_revenue
        FROM fact_bookings fb
        JOIN dim_date d
            ON fb.check_in_date = d.date
        GROUP BY d.`week no`
    ) r
    JOIN (
        SELECT
            d.`week no` AS week_no,
            SUM(fab.capacity) AS weekly_capacity
        FROM fact_aggregated_bookings fab
        JOIN dim_date d
            ON fab.check_in_date = d.date
        GROUP BY d.`week no`
    ) c
        ON r.week_no = c.week_no
) AS weekly_revpar
ORDER BY week_start;

-- DSRN WoW Change %
SELECT
    week_no,
    dsrn,
    ROUND(
        (dsrn - LAG(dsrn) OVER (ORDER BY week_start))
        / LAG(dsrn) OVER (ORDER BY week_start) * 100,
        2
    ) AS dsrn_wow_change_percentage
FROM (
    SELECT
        d.`week no` AS week_no,
        MIN(d.date) AS week_start,
        SUM(fab.capacity) /
        COUNT(DISTINCT fab.check_in_date) AS dsrn
    FROM fact_aggregated_bookings fab
    JOIN dim_date d
        ON fab.check_in_date = d.date
    GROUP BY d.`week no`
) AS weekly_dsrn
ORDER BY week_start;
