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


sysbench standard install


    https://aws.amazon.com/blogs/database/running-sysbench-on-rds-mysql-rds-mariadb-and-amazon-aurora-mysql-via-ssl-tls/
(also see https://quip-amazon.com/LjSxAj88yq27 )

    $ git clone https://github.com/akopytov/sysbench

    $ cd sysbench
    $ ./autogen.sh
    $ ./configure
    $ make
    $ sudo make install
    $ sysbench --version
    sysbench 1.1.0-174f3aa

    export user=kylelf
    export password=XXX
    export host=kylelfams56-instance-1.cs63gefrggyf.us-east-1.rds.amazonaws.com
    export threads=8
    export db=sysbench

prepare

    sysbench oltp_read_write \
           --db-driver=mysql \
           --mysql-host=ams5l-2-10-0-instance-1.cs63gefrggyf.us-east-1.rds.amazonaws.com  \
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