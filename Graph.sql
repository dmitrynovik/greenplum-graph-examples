DROP TABLE IF EXISTS city, 
	road, 
	pagerank_out,
    pagerank_out_summary,
    all_pairs_shorted_paths_out,
    all_pairs_shorted_paths_out_summary;
  

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
	(3, 4, 62.1),  -- Bahurst -> Orange
	(3, 6, 252),   -- Lithgow -> Dubbo
	(4, 5, 56.9),  -- Bathurst -> Orange
	(6, 7, 312)    -- Dubbo -> Singleton
;

-- compute all pairs shortest path (APSP) 
SELECT madlib.graph_apsp('city',             -- city table
               'id',                         -- city id column
               'road',                       -- road table
               'src=src, dest=dest',         -- comma delimited string of road arguments
               'all_pairs_shorted_paths_out' -- output table of APSP
                );              
				
SELECT 
		c1."name"  as from
		,c2."name"  as to
		,APSP.weight as distance
		,via."name"  as via
		--,*
	FROM all_pairs_shorted_paths_out APSP
	join city c1 on c1.id = src
	join city c2 on c2.id = dest
	join city via on via.id = parent
	where src != dest
	ORDER BY 1, 2;

/*
SELECT madlib.pagerank('city',     -- city table
               'id',                 -- city id column
               'road',               -- road table
               'src=src, dest=dest', -- Comma delimited string of road arguments
               'pagerank_out',       -- Output table of PageRank
                0.5);                -- Damping factor
				
SELECT * FROM pagerank_out ORDER BY pagerank DESC;
*/