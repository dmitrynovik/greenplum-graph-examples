DROP TABLE IF EXISTS city, 
	road, 
	pagerank_out,
    pagerank_out_summary,
    all_pairs_shorted_paths_out,
    all_pairs_shorted_paths_out_summary,
	avg_path_length_out,
	avg_path_length_out_summary
	;
  

CREATE TABLE city(id INTEGER primary KEY, name VARCHAR(31) not null); 

CREATE TABLE road(src INTEGER, dest INTEGER, weight FLOAT8);
		 
INSERT INTO city VALUES
	(0, 'Sydney'),
	(1, 'Katoomba'),
	(2, 'Windsor'),
	(3, 'Lithgow'),
	(4, 'Bathurst'),
	(5, 'Orange'),
	(6, 'Dubbo'),
	(7, 'Singleton')
;

INSERT INTO road VALUES
	(0, 1, 102),   -- SYD -> Katoomba
	(0, 2, 59.8),  -- SYD -> Windsor
	(0, 7, 208),   -- SYD -> Singleton
	(1, 3, 40.7),  -- Katoomba -> Lithgow
	(2, 3, 85.4),  -- Windsor -> Lithgow
	(3, 4, 62.1),  -- Lithgow -> Bathurst
	(3, 6, 252),   -- Lithgow -> Dubbo
	(4, 5, 56.9),  -- Bathurst -> Orange
	(7, 6, 312)    -- Singleton -> Dubbo
;

-- Compute all pairs shortest path (APSP) 
SELECT madlib.graph_apsp('city',             -- city table
               'id',                         -- city id column
               'road',                       -- road table
               'src=src, dest=dest',         -- comma delimited string of road arguments
               'all_pairs_shorted_paths_out' -- output table of APSP
                );              
				
SELECT 
		c1."name"  AS from
		,c2."name"  AS to
		,APSP.weight AS distance
		,via."name"  AS via
		--,*
	FROM all_pairs_shorted_paths_out APSP
	JOIN city c1 ON c1.id = src
	JOIN city c2 ON c2.id = dest
	JOIN city via ON via.id = parent
	WHERE src != dest
	ORDER BY 1, 2;

/*
-- AVG length:
SELECT madlib.graph_avg_path_length('all_pairs_shorted_paths_out', 'avg_path_length_out');
SELECT * FROM avg_path_length_out;
*/

/*
-- Pagerank:
SELECT madlib.pagerank('city',     -- city table
               'id',                 -- city id column
               'road',               -- road table
               'src=src, dest=dest', -- Comma delimited string of road arguments
               'pagerank_out',       -- Output table of PageRank
                0.5);                -- Damping factor
				
SELECT * FROM pagerank_out ORDER BY pagerank DESC;
*/