use kyle;
drop table seed;
CREATE TABLE seed ( id INT AUTO_INCREMENT PRIMARY KEY, val INT);
 insert into seed(val) values (1);
insert into seed(val) select val from seed;  /*  2 */
insert into seed(val) select val from seed;  /*  4 */
insert into seed(val) select val from seed;  /*  8 */
insert into seed(val) select val from seed;  /*  16 */
insert into seed(val) select val from seed;  /*  32 */
insert into seed(val) select val from seed;  /*  64 */
insert into seed(val) select val from seed;  /*  128 */
insert into seed(val) select val from seed;  /*  256 */
insert into seed(val) select val from seed;  /*  512 */
insert into seed(val) select val from seed;  /*  1024 */
insert into seed(val) select val from seed;  /*  2048 */
insert into seed(val) select val from seed;  /*  4096 */
insert into seed(val) select val from seed;  /*  8192 */
insert into seed(val) select val from seed;  /*  16384 */
insert into seed(val) select val from seed;  /*  32768 */
insert into seed(val) select val from seed;  /*  65536 */
insert into seed(val) select val from seed;  /*  131072 */
insert into seed(val) select val from seed;  /*  262144 */
insert into seed(val) select val from seed;  /*  524288 */
insert into seed(val) select val from seed;  /*  1048576 */
 select count(*) from seed;

 drop table dummy;
 create table dummy ( 
    id  int,
    clus int,
    val int,
    data VARCHAR(40)
 );
 
 insert into dummy (
    id, clus , val, data
)
 select 
 id,
 truncate(id/169,0),  -- 169 is a weird value but the above data geration seems 
                      -- to skip some # in the id , otherwise this should be 100
 mod(id,10000), 
 CONV(FLOOR(RAND() * 99999999999999), 10, 36) 
from seed
;

select count(*) from dummy where clus = 1;
select count(*) from dummy where val =1;
\

create table big as select * from dummy;
insert into big select * from big;
