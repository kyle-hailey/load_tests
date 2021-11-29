# Set USER, PW, HOSTS(endpoints)
#

USER=XXXX
PW=XXXXX
PORT=3306

HOSTS="
XXX
"

MYTEST=`date '+%s'`
MYTMP="/tmp/bc${MYTEST}.sql"

START=1
STOP=8

PORT=3306

INNER_SLEEP=0.5
SLEEP_AFTER_TEST=1800
SLEEP_BETWEEN_TESTS=5400

FORCE_CREATE=${1-0}
echo "FORCE_CREATE $FORCE_CREATE"

for HOST in $HOSTS; do
  for i in 1; do
     cat << EOF
        create database kyle;
        use kyle;
        DELIMITER \$\$
        DROP PROCEDURE IF EXISTS mem\$\$
        CREATE PROCEDURE mem_tmp(loops INT, SIZE INT)
        BEGIN
        DECLARE counter int;
        DROP TEMPORARY TABLE IF EXISTS mem_temp1;
        CREATE TEMPORARY TABLE mem_temp1( id bigint, val varchar(32000)) ENGINE=memory;
        set counter=1;
        WHILE counter <= loops DO
          SET counter = counter + 1;
          insert into mem_temp1(ID,VAL) values (counter, lpad('a',size,'a'));
        END WHILE;
        -- insert into mem select count(*), 'count' from mem_temp;
        END\$\$
        DELIMITER ;
EOF
    done >  memtmp.sql
    cmd="mysql -A -f  --host=$HOST  --user=$USER  --password=$PW --port=$PORT mysql < memtmp.sql &"
    cat memtmp.sql
    echo "starting  create"
    echo $cmd
    eval $cmd
    echo "end of create"
done



#for j in  4 8 16 32 64 128; do
#for j in  400; do
#for j in  16 32 64 128; do
#for j in  4 7  11 17 27 42 64 98 150 240 ; do
for j in   7  11 17 27 42 64 98 150 240 ; do
  STOP=$j
  for i in `seq $START $STOP`; do
    for HOST in $HOSTS; do
      echo "-------- i $i ------"
      echo "use kyle;" > memtmp.sql
      echo "set autocommit=0;" >> memtmp.sql
      echo ""set tmp_table_size=5077721600; >> memtmp.sql
      echo "set max_heap_table_size=5077721600;" >> memtmp.sql
      echo "call mem_tmp(10000,100000);" >> memtmp.sql
      cmd="mysql -A  -f --tee=$MYTEST --host=$HOST  --user=$USER  --password=$PW --port=$PORT kyle   < memtmp.sql &"
      echo "Loop $j $i : $cmd"
      #cat memtmp.sql
      echo $cmd
      eval $cmd
      echo "sleeping $INNER_SLEEP inner"
      sleep $INNER_SLEEP
    done
  done
  cat memtmp.sql
  echo "sleeping  $SLEEP_AFTER_TEST ........................... "
  sleep $SLEEP_AFTER_TEST
  cmd="ps -ef | grep mysql | grep  $MYTEST | grep -v grep | awk '{print \$2}' | xargs kill -9"
  echo $cmd
  eval $cmd
  echo "sleeping $SLEEP_BETWEEN_TESTS ........................... "
  sleep $SLEEP_BETWEEN_TESTS
done
