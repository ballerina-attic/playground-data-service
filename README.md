# Ballerina Playground - Data Service  
 
 
 ## <a name="what-you-build"></a> What you’ll build 
 
 In this example you will use Ballerina to exposes data as an API. 
  
 ## <a name="pre-req"></a> Prerequisites
 - JDK 1.8 or later
 - [Ballerina Distribution](https://github.com/ballerina-lang/ballerina/blob/master/docs/quick-tour.md)
 - A Text Editor or an IDE 
 
 ## <a name="developing-service"></a> Developing the service 
 
 **This is a Ballerina playground example. You can try it at  [ballerina.io](https://ballerina.io).**


 
 ### <a name="invoking"></a> Invoking the service

GET all Customers 

``` 

curl http://localhost:9090/customer

```


ToDo:

// Get database credentials via configuration API.
const string user_name =? config:getAsString("username");
const string password =? config:getAsString("password");
const string DB_NAME="CUSTOMER_DB";