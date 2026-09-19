/* Which hotel generated the highest revenue?*/
select h.property_name,sum(f.revenue_realized) as Revenue
from fact_bookings f
join dim_hotels h on h.property_id = f.property_id
group by property_name
order by revenue desc;

/* Which hotel has the highest number of bookings?*/
select h.property_name, count(booking_id) as Total_bookings
from fact_bookings f
join dim_hotels h on f.property_id = h.property_id
group by property_name
order by total_bookings desc
limit 1;

/* Which city generates the highest revenue?*/
select h.city, sum(f.revenue_realized) as Revenue
from fact_bookings f
join dim_hotels h on h.property_id = f.property_id
group by city
order by revenue desc
limit 1;

/* Which room class generates the most revenue?*/
select r.room_class,sum(f.revenue_realized) as Revenue
from fact_bookings f
join dim_rooms r on r.room_id = f.room_category
group by r.room_class
order by revenue desc
limit 1;

/* Do hotels receive more bookings on weekdays or weekends?*/
select d.day_type, count(f.booking_id) as Total_bookings, sum(revenue_realized) as Revenue
from fact_bookings f
join dim_date d on f.check_in_date = STR_TO_DATE(d.date,'%d-%b-%y')
group by day_type;

/* Which month generated the highest revenue?*/
select d.`mmm yy`, sum(f.revenue_realized) as Revenue, count(f.booking_id) as Total_bookings
from fact_bookings f
join dim_date d on f.check_in_date = str_to_date(d.date,'%d-%b-%y')
group by d.`mmm yy`
order by revenue desc
limit 1;

/* You can find which hotel has the most cancellations?*/
select h.property_name, count(*) as cancelled_bookings
from fact_bookings f
join dim_hotels h on h.property_id = f.property_id
where f.booking_status = "Cancelled"
group by h.property_name
order by cancelled_bookings desc
limit 1;




