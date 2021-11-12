#
# Set USER, PW, HOSTS(endpoints)
#

USER=XXX
PW=XXX
INSTANCE=postgres
PORT=3306


HOSTS="A B"

MYTEST=`date '+%s'`
MYTMP="/tmp/bc${MYTEST}.sql"

START=1
STOP=8

PORT=3306

INNER_SLEEP=0.5
SLEEP_AFTER_TEST=1800
SLEEP_BETWEEN_TESTS=7200

FORCE_CREATE=${1-0}
echo "FORCE_CREATE $FORCE_CREATE"

for HOST in $HOSTS; do
  for i in 1; do
     cat << EOF
     create database kyle;
     set autocommit=0;
     use kyle;
     CREATE TABLE locks ( id INT AUTO_INCREMENT PRIMARY KEY, val INT);
     insert into locks(val) values (1);
     select * from locks for update;
     select sleep($SLEEP_AFTER_TEST);
EOF
    done >  bctmp1.sql
    cmd="mysql -A -f  --host=$HOST  --user=$USER  --password=$PW --port=$PORT mysql < bctmp1.sql &"
    cat bctmp1.sql
    echo "starting  create"
    echo $cmd
    eval $cmd
    echo "end of create"
done


#for j in  4 8 16 32 64 128; do
for j in  400; do
#for j in  1; do
  STOP=$j
  for i in `seq $START $STOP`; do
    for HOST in $HOSTS; do
      echo "-------- i $i ------"
      echo "use kyle;" > bctmp.sql
      echo "set autocommit=0;" >> bctmp.sql
      echo "SET SESSION innodb_lock_wait_timeout = $SLEEP_AFTER_TEST ;" >> bctmp.sql
      echo " select * from locks for update;" >> bctmp.sql
      echo "exit" >> bctmp.sql
      echo " " >> bctmp.sql
      cmd="mysql -A  -f --tee=$MYTEST --host=$HOST  --user=$USER  --password=$PW --port=$PORT kyle   < bctmp.sql &"
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
