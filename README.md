# README

This Rails app is an implementation of a url shortener kike TinyURL

Short urls from base conversion

Think of the seven-bit short url as a hexadecimal number (0–9, a-z, A-Z) (For e.g. aKc3K4b) . Each short url can be mapped to a decimal integer by using base conversion and vice versa.

 - Endpoint for encode `POST`  `/v1/encode`
 - Endpoint for decode `GET`  `/v1/:code`

## Technologies



* Ruby 2.7.5

* Rails 6.1.4

* Postgres 14



## Development with Docker



Building api image:

```sh

docker-compose build

```



Setting the database up:

```sh

docker-compose run api rake db:create

docker-compose run api rake db:migrate

```



Running the app:

```sh

docker-compose up

```



Running the test:

```sh

docker-compose run api rails test

```

## Potential attack vectors on the ShortUrl like TinyURL


URL-shortening services provide attackers and spammers with phishing methods with the following options:

- Allow spammers to sidestep spam filters as domain names like TinyURL are automatically trusted.
- Prevent educated users from checking for suspect URLs by obfuscating the actual Website URL.
- Redirect users to phishing sites to capture sensitive personal information.
- Redirect users to malicious sites loaded and just waiting to download malware.
- Via shortened URLs  DDoS victims
- Using shortened URLs provides some protection for the attackers, as they cannot be reported for brand infringement.

### Referenced:
- https://www.techrepublic.com/article/url-shortening-yet-another-security-risk/
- https://www.sans.org/blog/the-secrets-in-url-shortening-services/
- https://portswigger.net/daily-swig/cybercriminals-use-reverse-tunneling-and-url-shorteners-to-launch-virtually-undetectable-phishing-campaigns


## Problems and Scale applications


### 1. Server and DB

a.) **Short urls from base conversion**

 We used a counter (A large number) and then converted it into a base62 7 character. As counters always get incremented so we can get a new value for every new request (Thus we don’t need to worry about getting same ShortURL for different long/original urls)

b.)**Scaling with SQL sharding and auto increment**

Sharding is a scale-out approach in which database tables are partitioned, and each partition is put on a separate RDBMS server. For SQL, this means each node has its own separate SQL RDBMS managing its own separate set of data partitions. This data separation allows the application to distribute queries across multiple servers simultaneously, creating parallelism and thus increasing the scale of that workload

Before an RDBMS can be sharded, several design decisions must be made. Each of these is critical to both the performance of the sharded array, as well as the flexibility of the implementation going forward. These design decisions include the following:

-   Sharding key must be chosen
-   Schema changes
-   Mapping between sharding key, shards (databases), and physical servers

We can use sharding key as auto-incrementing counter and divide them into ranges for example from 1 to 10M, server 2 ranges from 10M to 20M, and so on.

We can start the counter from  **100000000000**. So counter for each SQL database instance will be in range  **100000000000+1 to 100000000000+10M , 100000000000+10M to 100000000000+20M** and so on.

We can start with 100 database instances and as and when any instance reaches maximum limit (10M), we can stop saving objects there and spin up a new server instance. In case one instance is not available/or down or when we require high throughput for write we can spawn multiple new server instances.

**Where to keep which information about active database instances ?**

**Solution:** We  can use a distributed service  [Zookeeper](https://zookeeper.apache.org/)  to solve the various challenges of a distributed system like a race condition, deadlock, or particle failure of data. Zookeeper is basically a distributed coordination service that manages a large set of hosts. It keeps track of all the things such as the naming of the servers, active database servers, dead servers, configuration information (_Which server is managing which range of counters_)of all the hosts. It provides coordination and maintains the synchronization between the multiple servers.

### 2. Load Balancer

Load balancer as the name suggests, balances the load by distributing the requests across our servers. There are various kinds of load balancers, each type having its own logic on how to distribute the load, but for our use case lets keep this simple by assuming the load balancer redirects the requests depending on which server is free or available to process the request.

### 3. Cache

We can optimize this design further by adding a caching layer to our service. With the current design our servers have to talk to the database every time the user clicks on the short URL, in order to retrieve the short URL to long URL mapping. Database calls can be slow and expensive as compared to fetching the data from a cache which is essentially an in-memory storage. We can improve the response time of our APIs by caching frequently accessed short URLs so that when we get a request for a short URL our servers will first check to see if the data is available in cache, if yes it retrieves the data from cache, otherwise it fetches it from database.


### Referenced:
- https://medium.com/@sandeep4.verma/system-design-scalable-url-shortener-service-like-tinyurl-106f30f23a82
- https://www.geeksforgeeks.org/system-design-url-shortening-service/
- https://www.code-recipe.com/post/url-shortener

## TODO

- [ ] Make Authentication Feature
- [ ] Set Exprience For Short URL
- [ ] Test Builder
- [ ] Test Service

