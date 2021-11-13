MySQL

     sudo yum install mysql
     # not sure if the following are necessary
     sudo yum update -y
    sudo yum install mysql-server mysql-devel -y
    sudo yum groupinstall development -y


Postgres

    sudo yum install postgresql
    # Amazon Linux 1
    sudo yum install postgresql93-contrib
    # Amzon linux 2
    sudo yum install postgresql-contrib.x86_64

Oracle

      oracle-instantclient18.3-basic-18.3.0.0.0-1.x86_64.rpm 
      oracle-instantclient18.3-sqlplus-18.3.0.0.0-1.x86_64.rpm
      sudo rpm -ivh oracle-instantclient18.3-basic-18.3.0.0.0-1.x86_64.rpm
      sudo rpm -ivh oracle-instantclient18.3-sqlplus-18.3.0.0.0-1.x86_64.rpm
      .bashrc
                 export LD_LIBRARY_PATH=/usr/lib/oracle/18.3/client64/lib/
                 alias sqlplus=/usr/lib/oracle/18.3/client64/bin/sqlplus
                 set -o vi




AWS CLI

1.  install AWS CLI

https://docs.aws.amazon.com/cli/latest/userguide/awscli-install-linux.html#awscli-install-linux-pip

    curl -O https://bootstrap.pypa.io/get-pip.py
    python get-pip.py --user

2.  install AWS CLI

https://docs.aws.amazon.com/cli/latest/userguide/installing.html

    pip install awscli --upgrade --user

3.  configure

    aws configure\

    For “aws configure” you will need

    * *AWS Access Key ID*:
    * *AWS Secret Access Key*:

     Which you can get by going to the AWS console, going to IAM and creating access key.

*Running Example*

Once “aws” is configured you can run the CLI like

    aws \
     pi get-resource-metrics \
     --region us-east-1 \
     --service-type RDS \
     --identifier db-YTDU5J5V66X7CXSCVDFD2V3SZM \
     --metric-queries "{\"Metric\": \"db.load.avg\"}" \
     --start-time `expr \`date +%s\` - 60480000 ` \
     --end-time `date +%s` \
     --period-in-seconds 86400

Jmeter

    wget https://s3.amazonaws.com/kylelfpi/apache_jmeter.gz
    wget https://s3.amazonaws.com/kylelfpi/postgresql-9.4-jdbc4.jar
    wget https://s3.amazonaws.com/kylelfpi/ojdbc6.jar
    wget https://s3.amazonaws.com/kylelfpi/mysql-connector-java-5.1.40-bin.jar


Java 8

    sudo yum install java-1.8.0
    sudo cp *jar /usr/share/java/
    alternatives --config java
    # sudo rm /usr/bin/java
    # sudo ln /usr/bin/java8 /usr/bin/java



PG Bench

    sudo yum install postgresql95-contrib
    yum list | grep postgres
    *postgres*ql-contrib.x86_64
    sudo yum install postgresql95-contrib.x86_64

Sysbench

*to be validated ...*

    wget https://s3.amazonaws.com/kylelfpi/sysbench-0.5.tar.gz
    wget https://s3.amazonaws.com/kylelfpi/libtool-2.4.tar.gz
    gzip -d *gz
    tar xvf libtool-2.4.tar
    tar xvf sysbench-0.5.tar
    export LD_LIBRARY_PATH=/home/ec2-user/libtool-2.4/mysql-connector-c-6.0.2-linux-glibc2.3-x86-64bit/lib
    cd sysbench-0.5
    ./sysbench

sysbench yum install

Followed directions from https://severalnines.com/blog/how-benchmark-postgresql-performance-using-sysbench
and got it working


     curl \
        -s https://packagecloud.io/install/repositories/akopytov/sysbench/script.rpm.sh | \
     sudo bash
     sudo yum -y install sysbench



sysbench standard install


    https://aws.amazon.com/blogs/database/running-sysbench-on-rds-mysql-rds-mariadb-and-amazon-aurora-mysql-via-ssl-tls/


    $ git clone https://github.com/akopytov/sysbench

    $ cd sysbench
    $ ./autogen.sh
    $ ./configure
    $ make
    $ sudo make install
    $ sysbench --version
    sysbench 1.1.0-174f3aa

 


Option build by hand
 

     # pre-requisite
     yum groupinstall "Development Tools"

     # then\
     sudo yum -y install bzr 
     bzr branch lp:sysbench 
     wget ftp://ftp.gnu.org/gnu/libtool/libtool-2.4.tar.gz (https://w.amazon.com/index.php?title=Ftp:ftp://ftp.gnu.org/gnu/libtool/libtool-2.4.tar.gz&action=edit&redlink=1)
     tar xvfz libtool-2.4.tar.gz 
     cd libtool-2.4 
     ./configure 
     make 
     sudo make install 
     sudo yum -y install automake 

     # the following command didn't work for me, but didn't seem to matter?
     sudo yum install mysql-bench 

     wget --no-check-certificate https://dev.mysql.com/get/Downloads/Connector-C/mysql-connector-c-6.0.2-linux-glibc2.3-x86-64bit.tar.gz
     tar xvfz mysql-connector-c-6.0.2-linux-glibc2.3-x86-64bit.tar.gz 
 
     cd sysbench
     libtoolize --force  --copy 
     ./autogen.sh
     ./configure \
      --with-mysql-includes=/home/ec2-user/mysql-connector-c-6.0.2-linux-glibc2.3-x86-64bit/include \
      --with-mysql-libs=/home/ec2-user/mysql-connector-c-6.0.2-linux-glibc2.3-x86-64bit/lib
     export LD_LIBRARY_PATH=/home/ec2-user/mysql-connector-c-6.0.2-linux-glibc2.3-x86-64bit/lib 
     make && sudo make install


Running tests

     CREATE DATABASE sbtest;

setup

    export user=kylelf
    export password=XXX
    export host=$HOST  
    export threads=8
    export db=sysbench

load data - one time operation
prepare

    sysbench oltp_read_write \
           --db-driver=mysql \
           --mysql-host=$HOST  \
           --mysql-db=sysbench \
           --mysql-user=kylelf \
           --mysql-password=Vigil20! \
           --tables=8 \
           --table-size=200000 \
           --threads=8 prepare

run

    sysbench oltp_read_write \
           --db-driver=mysql \
           --mysql-host=$host  \
           --mysql-db=$db \
           --mysql-user=$user \
           --mysql-password=$password \
           --tables=8 \
           --table-size=200000 \
           --threads=8 prepare

Initialize variables

     # set these first 3 values:
     export user=kylelf
     export password=XXX
     export host=$HOSTc

     export test=/home/ec2-user/sysbench-0.5/tests/db/oltp.lua
     export threads=100
     export db=sysbench
     export LD_LIBRARY_PATH=/home/ec2-user/libtool-2.4/mysql-connector-c-6.0.2-linux-glibc2.3-x86-64bit/lib

 

 create one large table

     # create one larger table
     ./sysbench \
       --test=$test \
       --mysql-db=sysbench \
       --mysql-user=$user \
       --mysql-password=$password \
       --db-driver=mysql \
       --mysql-host=$host \
       --mysql-port=3306 \
       --oltp-table-size=10000000 \
       prepare
       

alternatively  create lots of tables


     # create 250 tables

     ./sysbench \
       --test=$test \
       --mysql-db=sysbench \
       --mysql-user=$user \
       --mysql-password=$password \
       --db-driver=mysql \
       --mysql-host=$host \
       --mysql-port=3306 \
       --oltp-tables-count=250 \
       --oltp-table-size=25000 \
       --max-requests=0 \
       --report-interval=10 \
       --oltp_simple_ranges=0 \
       --oltp-distinct-ranges=0 \
       --oltp-sum-ranges=0 \
       --oltp-order-ranges=0 \
       --oltp-point-selects=0 \
       --rand-type=uniform \
       --max-time=1000 \
       --num-threads=$threads \
       prepare

           

Run test on one large table

      # run test with one large table
      ./sysbench \
                --test=$test \
                --db-driver=mysql \
                --oltp-table-size=10000000 \
                --mysql-host=$host \
                --mysql-db=sysbench \
                --mysql-user=$user \
                --mysql-password=$password \
                --max-time=0 \
                --max-requests=0 \
                 --db-ps-mode=auto \
                --num-threads=10 run; 
                

Ramping up load

     # ramp up load with one large table
     # and more and more users
     for each in 1 4 8 16 32 64; do 
     ./sysbench \
                --test=$test \
                --db-driver=mysql \
                --mysql-host=$host \
                --oltp-table-size=10000000 \
                --mysql-db=sysbench \
                --mysql-user=$user \
                --mysql-password=$password \
                --max-time=240 \
                --max-requests=0 \
                --oltp-read-only \
                --oltp-skip-trx  \
                --oltp-nontrx-mode=select \
                --num-threads=$each run; 
          sleep 10; 
       done
  

alternatively run tests on many tables

     ./sysbench \
        --test=$test \
        --oltp-tables-count=250 \
        --oltp-table-size=25000 \
        --max-requests=0 \
        --report-interval=10 \
        --oltp_simple_ranges=0 \
        --oltp-distinct-ranges=0 \
        --oltp-sum-ranges=0 \
        --oltp-order-ranges=0 \
        --oltp-point-selects=0 \
        --rand-type=uniform \
        --max-time=1000 \
        --num-threads=$threads \
        --mysql-user=$user \
        --mysql-password=$password \
        --db-driver=mysql \
        --mysql-host=$host \
        --mysql-port=3306 \
        --mysql-db=$db \
        run

Running tests on multiple machines at once

create data on multiple hosts


     for i in "$host"; do
        echo "host=$i"
        echo "db=$db"
        export host=$i
        cmd="sysbench \
           --test=$test \
           --db-driver=mysql \
           --oltp-tables-count=250 \
           --oltp-table-size=25000 \
           --mysql-host=$host \
           --mysql-user=$user \
           --mysql-password=$password \
           --num-threads=$threads \
           --mysql-db=$db \
           prepare  &"
         echo $cmd
         eval $cmd
     done

run load on multiple hosts

     for i in "$host" ; do
     export host=$i
     echo "HOST=$host"
     export threads=10
     ./sysbench \
         --test=$test \
         --oltp-tables-count=250 \
         --oltp-table-size=25000 \
         --max-requests=0 \
         --report-interval=10 \
         --oltp_simple_ranges=0 \
         --oltp-distinct-ranges=0 \
         --oltp-sum-ranges=0 \
         --oltp-order-ranges=0 \
         --oltp-point-selects=0 \
         --rand-type=uniform \
         --max-time=1000 \
         --num-threads=$threads \
         --mysql-user=$user \
         --mysql-password=$password \
         --db-driver=mysql \
         --mysql-host=$host \
         --mysql-port=3306 \
         --mysql-db=$db \
    run &
     done

TPCC

Sysbench TPCC test scripts are also available here (https://github.com/Percona-Lab/sysbench-tpcc).

    git clone https://github.com/Percona-Lab/sysbench-tpcc.git 

    ### prepare data and tables
    sysbench ./tpcc.lua \
        --mysql-host= <> \
        --mysql-user=root \
        --mysql-password=<> \
        --mysql-db=<> \
        --time=300 \
        --threads=64 --report-interval=1 \
        --tables=10 --scale=100 \
        --db-driver=mysql \
        prepare

    ### prepare for Innodb
    sysbench ./tpcc.lua \
        --mysql-host= <> \
        --mysql-user=root \
        --mysql-password=<> \
        --mysql-db=<> \
        --time=3000 --threads=64 \
        --report-interval=1 \
        --tables=10 --scale=100 \
        --use_fk=0 --mysql_storage_engine=innodb \
        --mysql_table_options='COLLATE latin1_bin' \
        --trx_level=RC \
        --db-driver=mysql \
        prepare

    ### Run benchmark
    sysbench ./tpcc.lua \
        --mysql-host= <> \
        --mysql-user=root \
        --mysql-password=<> \
        --mysql-db=<> \
        --time=300 --threads=64 \
        --report-interval=1 \
        --tables=10 --scale=100 \
        --db-driver=mysql \
        run

    ### Cleanup
    sysbench ./tpcc.lua \
        --mysql-host= <> \
        --mysql-user=root \
        --mysql-password=<> \
        --mysql-db=<> \
        --time=300 \
        --threads=64 \
        --report-interval=1 \
        --tables=10 --scale=100 \
        --db-driver=mysql \
        cleanup
    

