--CTE to count tickets sold before joining

WITH tickets_sold AS (
    SELECT
        flight_id,
        fare_conditions,
        COUNT(*) AS tickets_sold
    FROM ticket_flights
    GROUP BY flight_id, fare_conditions
),

-- CTE to count the number of seats available before joining

seat_count AS (
    SELECT
        aircraft_code,
		fare_conditions,
        COUNT(*) AS available_seats
    FROM seats
    GROUP BY aircraft_code, fare_conditions
),

--CTE for average ticket cost

tickets AS (
	SELECT
		flight_id, 
		fare_conditions,
		ROUND(AVG(amount),2) AS ticket_average_cost
	FROM ticket_flights
	GROUP BY flight_id, fare_conditions
)

-- Select statement 

SELECT 
    f.flight_id, 
    f.aircraft_code, 
    ts.fare_conditions, 
    ts.tickets_sold,
    sc.available_seats,
	ROUND((ts.tickets_sold::decimal / sc.available_seats) * 100, 2) || '%' AS tickets_sold_percentage,
	(f.scheduled_arrival - f.scheduled_departure) AS Flight_duration,
	t.ticket_average_cost,
	f.departure_airport,
	f.arrival_airport
	
	
FROM flights f

-- Join statements

JOIN tickets_sold ts ON f.flight_id = ts.flight_id
JOIN seat_count sc ON f.aircraft_code = sc.aircraft_code
	AND ts.fare_conditions = sc.fare_conditions
JOIN tickets t ON f.flight_id = t.flight_id
	AND ts.fare_conditions = t.fare_conditions
 


ORDER BY f.flight_id, ts.fare_conditions;