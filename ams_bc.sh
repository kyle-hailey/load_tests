
USER=kylelf
INSTANCE=postgres
PW=Vigil20!
PORT=3306
HOSTS="host1 host2 host3"


MYTEST=`date '+%s'`
MYTMP="/tmp/bc${MYTEST}.sql"

START=1
PORT=3306

INNER_SLEEP=0.5
SLEEP_AFTER_TEST=1000
SLEEP_BETWEEN_TESTS=7200

FORCE_CREATE=${1-0}
echo "FORCE_CREATE $FORCE_CREATE"

for HOST in $HOSTS; do
  for i in 1; do
     cat << EOF
     -- create database kyle;
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
 --  insert into seed(val) select val from seed;  /*  65536 */
 --  insert into seed(val) select val from seed;  /*  131072 */
 --  insert into seed(val) select val from seed;  /*  262144 */
 --  insert into seed(val) select val from seed;  /*  524288 */
 --  insert into seed(val) select val from seed;  /*  1048576 */
 --  insert into seed(val) select val from seed;  /*  2000000 */
 --  insert into seed(val) select val from seed;  /*  4000000 */
    select count(*) from seed a;
EOF
    done >  bctmp.sql
    if [  $FORCE_CREATE -eq 1 ]; then
       cmd="mysql -A -f  --host=$HOST  --user=$USER  --password=$PW --port=$PORT mysql < bctmp.sql &"
    else
       cmd="mysql -A  --host=$HOST  --user=$USER  --password=$PW --port=$PORT mysql < bctmp.sql &"
    fi
    cat bctmp.sql
    echo "starting  create"
    echo $cmd
    eval $cmd
    wait
    echo "end of create"
done
 



for j in  4 8 16 32 64 128; do
  STOP=$j
  for i in `seq $START $STOP`; do
    for HOST in $HOSTS; do
      echo "-------- i $i ------"
      echo "use kyle;" > bctmp.sql
      echo "create table IF NOT EXISTS kyle.seed$i as select * from kyle.seed;" >> bctmp.sql
  #   echo "insert into kyle.seed$i  select * from kyle.seed$i;" >> bctmp.sql
      echo " insert into seed(val) values (1);"  >> bctmp.sql
      echo "select 'cnt',  $i, count(*) from seed$i a  ; " >> bctmp.sql
      echo "insert into seed(val) values (1);"  >> bctmp.sql
      echo "select 'cnt_join_2' , $i , count(*) from seed$i a, seed$1 b  where a.id=b.id ; " >> bctmp.sql
      echo "insert into seed(val) values (1);"  >> bctmp.sql
      echo "select 'cnb_join_3', $i , count(*) from seed$i a, seed b, seed$i c  where a.id=b.id and a.id=c.id ; " >> bctmp.sql
      echo "insert into seed(val) values (1);"  >> bctmp.sql
      echo "select 'cnb_join_4', $i , count(*) from seed$i a, seed b, seed$i c, seed$i d   where a.id=b.id and a.id=c.id and d.id=c.id; " >> bctmp.sql
      echo "insert into seed(val) values (1);"  >> bctmp.sql
      echo "select 'cnb_join_5', $i , count(*) from seed$i a, seed b, seed$i c, seed$i d , seed$i e  where a.id=b.id and a.id=c.id and d.id=c.id and d.id=e.id; " >> bctmp.sql
      echo "exit" >> bctmp.sql
      echo " " >> bctmp.sql
      cmd="mysql -A  --tee=$MYTEST --host=$HOST  --user=$USER  --password=$PW --port=$PORT kyle   < bctmp.sql &"
      echo "Loop $j $i : $cmd"
      #cat bctmp.sql
      echo $cmd
      eval $cmd
      echo "sleeping $INNER_SLEEP inner"
      sleep $INNER_SLEEP
    done
  done
  cat bctmp.sql
  echo "sleeping  $SLEEP_AFTER_TEST ........................... "
  sleep $SLEEP_AFTER_TEST
  cmd="ps -ef | grep mysql | grep  $MYTEST | grep -v grep | awk '{print \$2}' | xargs kill -9"
  echo $cmd
  eval $cmd
  echo "sleeping $SLEEP_BETWEEN_TESTS ........................... "
  sleep $SLEEP_BETWEEN_TESTS
done

