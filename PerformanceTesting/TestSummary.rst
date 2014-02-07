Test Summary
============

This file contains a list of all the tests within the test suite, and what particular things they are trying to test.  The main divisions are the following:

| 01.     processing/memory speed
| 01b-e.  disk speed
| 01f     index write speed
| 01g-h   index read speed
| 02-03.  SORT
| 04.     JOIN
| 05.     Grouped aggregation
| 06.     Hash dedup
| 07.     Keyed join
| 08.     Index read inside a child query
| 09.     Global index read
| 10.     Simple child queries

ToDo:
* PARSE
* LOOP
* PARALLEL PROJECT
* PREFETCH PROJECT
* GROUPED concat
* Child queries - trivial, and more complex.


01 Very basic row operations
++++++++++++++++++++++++++++

01a - Raw record creation
-------------------------

These tests create lots of records, and test how different sources work

| 01aa. raw create/destroy row speed
| 01ab. unordered combine of rows from multiple sources [ how well does the multi threaded concat work ]
| 01ac. ordered combine of rows from multiple sources [ concat is unthreaded ]
| 01ad - single input, duplicate the output n-ways (outputs overlap)
| 01ae - single input, split the output n-ways (no overlap between outputs)
| 01ag..al - 2,4,8,12,16,32 way unordered append - tests scaling of the multi threaded concat.

01b - Raw disk write speed
--------------------------

| 01ba - write 32b row to a disk file, uncompressed
| 01bb - write 32b row to a disk file, compressed
| 01bc - write 82b (with spaces) to a disk file, uncompressed
| 01bd - write 82b (with spaces) to a disk file, compressed
| 01be - write csv to a disk file, uncompressed
| 01bf - write xml to a disk file, uncompressed

01c - Raw disk read speed
-------------------------

| 01ca - read 32b row to a disk file, uncompressed
| 01cb - read 32b row to a disk file, compressed
| 01cc - read 82b (with spaces) to a disk file, uncompressed
| 01cd - read 82b (with spaces) to a disk file, compressed
| 01ce - read csv to a disk file, uncompressed
| 01cf - read xml to a disk file, uncompressed

01d - Parallel disk write speed
-------------------------------

| 01da - parallel write to disk (rows distributed among outputs)
| 01db - delete the files generated in parallel

01e - Disk aggregation (like 01c, but with little row creation overhead)
------------------------------------------------------------------------

| 01ea - sum 32b row to a disk file, uncompressed
| 01eb - sum 32b row to a disk file, compressed
| 01ec - sum 82b (with spaces) to a disk file, uncompressed
| 01ed - sum 82b (with spaces) to a disk file, compressed
| 01ee - sum csv to a disk file, uncompressed
| 01ef - sum xml to a disk file, uncompressed

01f - Index creation
--------------------

| 01fa - create an index, records already in order
| 01fb - create an index, records out of order
| 01fc - create an index, single node


TBD:01g - Raw index reading speed
---------------------------------

| 01ga - Read a contiguous block
| 01gb - Read multiple contiguous block distributed across the nodes
| 01gc - Stepped read, performing a 256-way merge.

TBD:01h - Limits on index reads.
--------------------------------

| 01ha - simple limit from single node
| 01hb - simple limit from single node, records on many
| 01hc - limit accumulated from multiple nodes
 
02 Sorting
++++++++++

02a - Disk sorting
------------------

| 02aa - sort rows from disk locally
| 02ab - sort rows from disk globally

02b - Sorting created records (no disk hit)
-------------------------------------------

| 02ba - sort rows locally
| 02bb - sort rows globally
| 02bc - A very big group sort.
| 02bd - Sort local with duplicates (only 1M unique keys)
| 02be - Sort local with duplicates (only 4K unique keys)
| 02bf - Sort global with duplicates (only 1M unique keys)
| 02bg - Sort global with duplicates (only 4K unique keys)
| 02bh - Sort global with duplicates (a skewed distribution)

02c - Multiple sorts in parallel
--------------------------------
| 02ca - 4 Parallel local sorts (same total records)
| 02cb - 16 Parallel local sorts (same total records)
| 02cc - 4 Parallel global sorts (same total records)
| 02cd - 16 Parallel global sorts (same total records)
| 02ce - local sort 4x total records
| 02cf - local sort 16x total records
| 02cg - global sort 4x total records
| 02ch - global sort 16x total records
| 02ci - 16 Parallel local sorts (16x total records)
| 02cj - 16 Parallel global sorts (16x total records)

03 Distribution
+++++++++++++++

03a - Distribution from disk
----------------------------
| 03aa - Distribute from disk file

03b - Distribution
------------------
| 03ba - Distribute created rows
| 03bb - Distribute all rows to the same node - no effect.
| 03bc - Distribute all rows to the next node.
| 03bc - Distribute all rows to node self+CLUSTERSIZE/2.

03c - Parallel Distribution
---------------------------
| 03ca - Distribute 4 datasets in parallel (same total records)
| 03cb - Distribute 16 datasets in parallel (same total records)

03d - Merge Distribution
---------------------------
| 03da - Local sort followed by a merge distribute

04 Joins
++++++++

| 04aa - Simple join between two datasets, 1 match per row.
| 04ab - Simple join between two datasets, 1 match per row. unsorted output
| 04ac - Simple join between two datasets, 1 match per row. parallel join
| 04ae - Simple join between two datasets, 1 match per row. hash join
| 04af - Simple join between two datasets, 1 match per row. smart join
| 04ba - Simple join between two datasets, 4 matches per row.
| 04bb - Simple join between two datasets, 4 matches per row. unsorted output
| 04bc - Simple join between two datasets, 4 matches per row. parallel join
| 04ca - Simple join between two datasets, 64 matches per row.
| 04cb - Simple join between two datasets, 64 matches per row. unsorted output
| 04cc - Simple join between two datasets, 64 matches per row. parallel join
| 04cd - Simple join between two datasets, 64 matches per row. lookup join
| 04ce - Simple join between two datasets, 64 matches per row. hash join
| 04cf - Simple join between two datasets, 64 matches per row. smart join
| 04da - Simple join between two datasets, 4K matches per row.
| 04db - Simple join between two datasets, 4K matches per row. unsorted output
| 04dc - Simple join between two datasets, 4K matches per row. parallel join
| 04dd - Simple join between two datasets, 4K matches per row. lookup join
| 04ea - Simple local join between two datasets, 1 match per row.
| 04eb - Simple local join between two datasets, 1 match per row. unsorted output
| 04ec - Simple local join between two datasets, 1 match per row. parallel join
| 04ee - Simple local hash join between two datasets, 1 match per row.
| 04ef - Simple local smart join between two datasets, 1 match per row.

05 Grouped aggregation
++++++++++++++++++++++

| 05aa - Summarise into 64 groups, sort->group->aggregate
| 05ab - Summarise into 1M groups, sort->group->aggregate
| 05ac - Summarise into groups of 1 item, sort->group->aggregate
| 05ba - Summarise into 64 groups, hash aggregate
| 05bb - Summarise into 1M groups, hash aggregate
| 05bc - Summarise into groups of 1 item, hash aggregate
| 05ca - Summarise into 64 groups, distribute->sort->group->aggregate
| 05cb - Summarise into 1M groups, distribute->sort->group->aggregate
| 05cc - Summarise into groups of 1 item, distribute->sort->group->aggregate

06 Hash dedup
+++++++++++++

| 06aa - Many Dedup into 64 groups, local sort->dedup->merge distribute->dedup
| 06ab - Many Dedup into 1M groups, local sort->dedup->merge distribute->dedup
| 06ac - Many Dedup, but no duplicates removed, local sort->dedup->merge distribute->dedup
| 06ba - Dedup into 64 groups, hash dedup
| 06bb - Dedup into 1M groups, hash dedup
| 06bc - Dedup no duplicates removed, hash dedup
| 06ca - Dedup into 64 groups, distribute->sort->dedup
| 06cb - Dedup into 1M groups, distribute->sort->dedup
| 06cc - Dedup but no duplicates removed, distribute->sort->dedup

07 Keyed join
+++++++++++++

07a/b - Simple keyed join
-------------------------

| 07aa - Simple keyed join, records in order
| 07ba - Simple keyed join, records out of order, smaller number
| 07bb - Simple keyed join, records out of order, medium number
| 07bc - Simple keyed join, records out of order, large number

07c - Keyed join with limit (not hit)
-------------------------------------

| 07ca - keyed join, out of order, match(1),limit(1)
| 07cb - keyed join, out of order, match(1),limit(256)
| 07cc - keyed join, in order, match(256),limit(256)

07d - Keyed join with limit,skip (hit)
--------------------------------------

| 07ca - keyed join, out of order, match(>1),limit(1)
| 07cb - keyed join, out of order, match(>1),limit(1), wild component(0)
| 07cc - keyed join, in order, match(255/256),limit(255)

07e - Keyed join with limit,skip,count (hit)
--------------------------------------------

| 07ea - keyed join, out of order, match(>1),limit(1)
| 07eb - keyed join, out of order, match(>1),limit(1), wild component(0)
| 07ec - keyed join, in order, match(255/256),limit(255)

07f - Keyed join with limit,transform (hit)
-------------------------------------------

| 07fa - keyed join, out of order, match(>1),limit(1)
| 07fb - keyed join, out of order, match(>1),limit(1), wild component(0)
| 07fc - keyed join, in order, match(255/256),limit(255)

08 Index read in child
++++++++++++++++++++++

| 08aa - child index read - 1 match - seeks in order
| 08ab - child index read - 1 match - seeks out of order
| 08ba - child index read, prefetch project - 1 match - seeks in order
| 08bb - child index read, prefetch project - 1 match - seeks out of order
| 08ca - child stepped index read - 1 match - seeks in order
| 08cb - child stepped index read - 1 match - seeks out of order
| 08cc - child stepped index read - 1 match - seeks out of order, wild first component
| 08cd - child stepped index read - multiple matches - seeks out of order
| 08da - child stepped index read - multiple matches - seeks in order

09 Global Index read
++++++++++++++++++++

| 09aa - index read 132000 entries from 2 blocks
| 09ab - stepped index read 132000 entries from 2 blocks

10 Child queryies
+++++++++++++++++

| 10aa - count a single inline row - code inline
| 10ab - count a single inline row - generate subquery
| 10ac - dedup a set of generated child rows
| 10ad - sort a set of generated child rows
| 10ae - project a global inline dataset
| 10af - project and lookup in a global dictionary