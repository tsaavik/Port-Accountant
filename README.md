#Port-Accountant

Easily find out what servers are attempting to connect to your service (port).

Its as easy as

```./paccount.sh 80```

     The following 3 hosts have connected to port 80 of www.hellspark.com since Fri Oct 30 13:46
         crawl-66-249-65-124.googlebot.com(66.249.65.124)
         msnbot-157-55-39-12.search.msn.com(157.55.39.12)
         s420.pingdom.com(72.46.130.42)

The program will continue to run updating the list above until canceled...
You can also specifiy an optional destination host if your server is multihomed
```./paccount.sh 80 1.2.3.4```
