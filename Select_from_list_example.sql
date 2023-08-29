/* Given a table of candidates and their skills, you're tasked with finding the candidates best suited for an open Data Science job. You want to find candidates who are proficient in Python, Tableau, and PostgreSQL.

Write a query to list the candidates who possess all of the required skills for the job. Sort the output by candidate ID in ascending order.

Strategy is to list the skills grouped by candidate that are in the list of the 3 skills required, then to count those skills and return the id's that have a count of 3. The assumptions are that there are no duplicate entries. */

SELECT candidate_id 
FROM candidates
WHERE skill IN ('Python','Tableau','PostgreSQL')
GROUP BY candidate_id
HAVING count(skill) = 3
ORDER BY candidate_id ASC;