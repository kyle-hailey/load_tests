http://www.nocoug.org/download/2012-08/Jonathan_Lewis_Creating_Tests.pdf

     select i 
    from generate_series(1, 100) s(i);
 
     drop table dummy;
 
     create table dummy ( 
         id  int,
         zero_to_ten  int, 
         one_third  int, 
         zero_to_two   int,
         data VARCHAR(40)
     );
 
     insert into dummy (
            id, zero_to_ten, one_third, zero_to_two, data
    )
         select 
         i,
         mod(i,10),
         trunc((i)/3),
         mod(i,3),
         left(md5(random()::text), 40) 
          from generate_series(1, 1000000) s(i);

