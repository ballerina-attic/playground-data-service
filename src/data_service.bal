import ballerina/config;
import ballerina/http;
import ballerina/h2;
import ballerina/sql;

endpoint http:Listener listener {
    port:9090
};

// Get database credentials via configuration API.
@final string USER_NAME =  config:getAsString("username");
@final string PASSWORD = config:getAsString("password");
@final string DB_HOST = config:getAsString("db_host");
@final string DB_NAME = "CUSTOMER_DB";

@http:ServiceConfig {
    basePath:"/"
}
service<http:Service> CustomerDataMgt bind listener {

  @http:ResourceConfig {
    methods:["GET"],
    path:"/customer"
  }
  customers(endpoint caller, http:Request req) {

    // Endpoints can connect to databases with SQL connectors
    endpoint h2:Client customerDB {
      path: DB_HOST,
      name: DB_NAME,
      username: USER_NAME,
      password: PASSWORD,
      poolOptions: { maximumPoolSize: 1 }
    };

    // Invokes 'select' action against the endpoint.
    // The 'table' primitive type represents a set of records.
    table dt = check customerDB -> 
        select("SELECT * FROM CUSTOMER", null);

    // Tables can be cast to JSON and XML
    json response = check <json>dt;

    http:Response res = new;
    res.setJsonPayload(untaint response);
    _ = caller->respond(res);
  }
}
