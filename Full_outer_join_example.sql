/*Assume you're given two tables containing data about Facebook Pages and their respective likes (as in "Like a Facebook Page").

Write a query to return the IDs of the Facebook pages that have zero likes. The output should be sorted in ascending order based on the page IDs

You can't count what's not there, so the strategy is to full outer join the tables, then list the page_id's that have null for liked_date */



SELECT pg.page_id 
FROM page_likes AS plike FULL OUTER JOIN pages as pg
  ON pg.page_id = plike.page_id
WHERE plike.liked_date IS NULL
GROUP BY pg.page_id, plike.page_id
ORDER BY page_id ASC;