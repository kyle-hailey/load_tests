# edit HOST to point to your mysql endpoint
# edit USER and PW to be your database user and password
# edit STOP to be the maximum # of connections, i.e. max DB Load in AAS
# test lasts about 15-40 minute depending on # of user
#
# test will create a database "kyle" and seed table "seed" if it doesn't exits
# test will then create a seed table for each user i.e. seed1, seed2 etc
# test will then join seedN with seedN 
# initial run will spend most of its time creating seed1 - seedN
# subsequent runs will spend most of their time just running the join seedN to seedN 
# 
 
USER=XXX
PW=XXXX
HOST=XXX
START=1
STOP=10
 
PORT=3306
 
INNER_SLEEP=0.5
 
 
  for i in 1; do
     cat << EOF
     create database kyle;
     use kyle;
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
     insert into seed(val) select val from seed;  /*  2000000 */
     insert into seed(val) select val from seed;  /*  4000000 */
    select count(*) from seed a;
EOF
    done >  bctmp.sql
    cmd="mysql -A  --host=$HOST  --user=$USER  --password=$PW --port=$PORT mysql < bctmp.sql &"
    cat bctmp.sql
    echo "starting  create"
    echo $cmd
    eval $cmd
    wait
    echo "end of create"
 
 
for i in `seq $START $STOP`; do
 
    echo "-------- i $i ------"
    echo "use kyle;" > bctmp.sql
    echo "create table IF NOT EXISTS kyle.seed$i as select * from kyle.seed;" >> bctmp.sql
#   echo "insert into kyle.seed$i  select * from kyle.seed$i;" >> bctmp.sql
    echo "select 'cnt',  $i, count(*) from seed$i a  ; " >> bctmp.sql
    echo "select 'cnt_join' , $i , count(*) from seed$i a, seed$1 b  where a.id=b.id ; " >> bctmp.sql
#   echo "select count(*) from seed$i a, seed$1 b, seed$i c  where a.id=b.id and a.id=c.id; " >> bctmp.sql
 
    cmd="mysql -A --host=$HOST  --user=$USER  --password=$PW --port=$PORT kyle  < bctmp.sql &"
    echo "Loop $j $i : $cmd"
    cat bctmp.sql
    eval $cmd
    echo "sleeping $INNER_SLEEP inner"
    sleep $INNER_SLEEP
done
 
wait
